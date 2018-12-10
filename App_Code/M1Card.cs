using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.InteropServices;
using System.Collections;

/// <summary>
///M1Card 的摘要说明
/// </summary>
public class M1Card
{
	public M1Card()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}

    public void SerialPort() {

    }
    Guid guidHID = Guid.Empty;

    //获得GUID
    [DllImport("hid.dll")]
    public static extern void HidD_GetHidGuid(ref Guid HidGuid);
    //过滤设备，获取需要的设备
    [DllImport("setupapi.dll", SetLastError = true)]
    public static extern IntPtr SetupDiGetClassDevs(ref Guid ClassGuid, uint Enumerator, IntPtr HwndParent, DIGCF Flags);
    IntPtr hDevInfo;
    //获取设备，true获取到
    [DllImport("setupapi.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern Boolean SetupDiEnumDeviceInterfaces(IntPtr hDevInfo, IntPtr devInfo, ref Guid interfaceClassGuid, UInt32 memberIndex, ref SP_DEVICE_INTERFACE_DATA deviceInterfaceData);
    public struct SP_DEVICE_INTERFACE_DATA
    {
        public int cbSize;
        public Guid interfaceClassGuid;
        public int flags;
        public int reserved;
    }
    // 获取接口的详细信息 必须调用两次 第1次返回长度 第2次获取数据
    [DllImport("setupapi.dll", SetLastError = true, CharSet = CharSet.Auto)]
    private static extern bool SetupDiGetDeviceInterfaceDetail(IntPtr deviceInfoSet, ref SP_DEVICE_INTERFACE_DATA deviceInterfaceData, IntPtr deviceInterfaceDetailData,
        int deviceInterfaceDetailDataSize, ref int requiredSize, SP_DEVINFO_DATA deviceInfoData);
    [StructLayout(LayoutKind.Sequential)]
    public class SP_DEVINFO_DATA
    {
        public int cbSize = Marshal.SizeOf(typeof(SP_DEVINFO_DATA));
        public Guid classGuid = Guid.Empty; // temp
        public int devInst = 0; // dumy
        public int reserved = 0;
    }
    [StructLayout(LayoutKind.Sequential, Pack = 2)]
    internal struct SP_DEVICE_INTERFACE_DETAIL_DATA
    {
        internal int cbSize;
        internal short devicePath;
    }
    public enum DIGCF
    {
        DIGCF_DEFAULT = 0x1,
        DIGCF_PRESENT = 0x2,
        DIGCF_ALLCLASSES = 0x4,
        DIGCF_PROFILE = 0x8,
        DIGCF_DEVICEINTERFACE = 0x10
    }

     [DllImport("kernel32.dll", SetLastError = true)]
        private static extern int CreateFile(
            string lpFileName,                            // file name
            uint dwDesiredAccess,                        // access mode
            uint dwShareMode,                            // share mode
            uint lpSecurityAttributes,                    // SD
            uint dwCreationDisposition,                    // how to create
            uint dwFlagsAndAttributes,                    // file attributes
            uint hTemplateFile                            // handle to template file
            );
        //读取设备文件
        [DllImport("Kernel32.dll", SetLastError = true)]
        private static extern bool ReadFile
            (
                IntPtr hFile,
                byte[] lpBuffer,
                uint nNumberOfBytesToRead,
                ref uint lpNumberOfBytesRead,
                IntPtr lpOverlapped
            );
        //释放设备
        [DllImport("hid.dll")]
        static public extern bool HidD_FreePreparsedData(ref IntPtr PreparsedData);
        //关闭访问设备句柄，结束进程的时候把这个加上保险点
        [DllImport("kernel32.dll")]
        static public extern int CloseHandle(int hObject);

        int HidHandle = -1;
        public const uint GENERIC_READ = 0x80000000;
        public const uint GENERIC_WRITE = 0x40000000;
        public const uint FILE_SHARE_READ = 0x00000001;
        public const uint FILE_SHARE_WRITE = 0x00000002;
        public const int OPEN_EXISTING = 3;
        public void UsBMethod(int index)
        {
            HidD_GetHidGuid(ref guidHID);
            hDevInfo = SetupDiGetClassDevs(ref guidHID, 0, IntPtr.Zero, DIGCF.DIGCF_PRESENT | DIGCF.DIGCF_DEVICEINTERFACE);
            int bufferSize = 0;
            ArrayList HIDUSBAddress = new ArrayList();
            string devicePathName = "";
            while (true)
            {
                //获取设备，true获取到
                SP_DEVICE_INTERFACE_DATA DeviceInterfaceData = new SP_DEVICE_INTERFACE_DATA();
                DeviceInterfaceData.cbSize = Marshal.SizeOf(DeviceInterfaceData);
                bool result = false;
                for (int i = 0; i < 3; i++)
                {
                    result = SetupDiEnumDeviceInterfaces(hDevInfo, IntPtr.Zero, ref guidHID, (UInt32)index, ref DeviceInterfaceData);
                }
                //第一次调用出错，但可以返回正确的Size
                SP_DEVINFO_DATA strtInterfaceData = new SP_DEVINFO_DATA();
                result = SetupDiGetDeviceInterfaceDetail(hDevInfo, ref DeviceInterfaceData, IntPtr.Zero, 0, ref bufferSize, strtInterfaceData);
                //第二次调用传递返回值，调用即可成功
                IntPtr detailDataBuffer = Marshal.AllocHGlobal(bufferSize);
                SP_DEVICE_INTERFACE_DETAIL_DATA detailData = new SP_DEVICE_INTERFACE_DETAIL_DATA();
                detailData.cbSize = Marshal.SizeOf(typeof(SP_DEVICE_INTERFACE_DETAIL_DATA));
                Marshal.StructureToPtr(detailData, detailDataBuffer, false);
                result = SetupDiGetDeviceInterfaceDetail(hDevInfo, ref DeviceInterfaceData, detailDataBuffer, bufferSize, ref bufferSize, strtInterfaceData);
                if (result == false)
                {
                    break;
                }
                //获取设备路径访
                IntPtr pdevicePathName = (IntPtr)((int)detailDataBuffer + 4);
                devicePathName = Marshal.PtrToStringAuto(pdevicePathName);
                HIDUSBAddress.Add(devicePathName);
                index++;
                break;
            }
            //连接设备文件
            int aa = CT_CreateFile(devicePathName);
            bool bb = USBDataRead(HidHandle);
        }
        //建立和设备的连接
        public int CT_CreateFile(string DeviceName)
        {
            HidHandle = CreateFile(
                DeviceName,
                GENERIC_READ,// | GENERIC_WRITE,//读写，或者一起
                FILE_SHARE_READ,// | FILE_SHARE_WRITE,//共享读写，或者一起
                0,
                OPEN_EXISTING,
                0,
                0);
            if (HidHandle == -1)
            {
                return 0;
            }
            else
            {
                return 1;
            }
        }
        //根据CreateFile拿到的设备handle访问文件，并返回数据
        public bool USBDataRead(int handle)
        {
            while (true)
            {
                uint read = 0;
                //注意字节的长度，我这里写的是8位，其实可以通过API获取具体的长度，这样安全点，
                //具体方法我知道，但是没有写，过几天整理完代码，一起给出来
                Byte[] m_rd_data = new Byte[8];
                bool isread = ReadFile((IntPtr)handle, m_rd_data, (uint)8, ref read, IntPtr.Zero);
                //这里已经是拿到的数据了
                Byte[] m_rd_dataout = new Byte[read];
                Array.Copy(m_rd_data, m_rd_dataout, read);
            }
        }
    


}