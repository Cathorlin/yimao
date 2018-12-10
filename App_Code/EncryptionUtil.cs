using System;
using System.IO;
using System.Text;
using System.Security;
using System.Data;
using System.Security.Cryptography;
using Base;

namespace Custom
{
/**//**//**//// <summary>
/// 加密，解密功能函数
/// </summary> 
public class EncryptionUtil
{
    public EncryptionUtil()
    {
    //
    // TODO: Add constructor logic here
    //

    }

static private Byte[] m_Key = new Byte[8];
static private Byte[] m_IV = new Byte[8];

//为了安全，直接将key写死在文件中，你也可以用一个属性来实现 
public string key = "wtlqlwyc";

//默认密钥向量    
private static byte[] Keys = { 0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF };
/// <summary>    
/// DES加密字符串    
/// </summary>    
/// <param name="encryptString">待加密的字符串</param>    
/// <param name="encryptKey">加密密钥,要求为8位</param>    
/// <returns>加密成功返回加密后的字符串，失败返回源串</returns>    
  public  string EncryptData(string encryptKey, string encryptString)
{

   //return DES.DESEncrypt(encryptString, encryptKey);

   try
   {
       if (encryptKey.Length < 8)
       {
           int li_length = encryptKey.Length;
           for (int i = 0; i < 8 - li_length; i++)
           {
               encryptKey = encryptKey + "-";
           }


       }

       byte[] rgbKey = Encoding.UTF8.GetBytes(encryptKey.Substring(0, 8));
       byte[] rgbIV = Keys;
       byte[] inputByteArray = Encoding.UTF8.GetBytes(encryptString);
       DESCryptoServiceProvider dCSP = new DESCryptoServiceProvider();
       MemoryStream mStream = new MemoryStream();
       CryptoStream cStream = new CryptoStream(mStream, dCSP.CreateEncryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
       cStream.Write(inputByteArray, 0, inputByteArray.Length);
       cStream.FlushFinalBlock();
       return Convert.ToBase64String(mStream.ToArray());

   }
   catch
   {
       return encryptString;
   }
}


/// <summary>    
/// DES解密字符串    
/// </summary>    
/// <param name="decryptString">待解密的字符串</param>    
/// <param name="decryptKey">解密密钥,要求为8位,和加密密钥相同</param>    
/// <returns>解密成功返回解密后的字符串，失败返源串</returns>    
  public  string DecryptData(string decryptKey, string decryptString)
{

    //return DES.DESDecrypt(decryptString, decryptKey);
    try
    {
        if (decryptKey.Length < 8)
        {
            int li_length = decryptKey.Length;
            for (int i = 0; i < 8 - li_length; i++)
            {
                decryptKey = decryptKey + "-";
            }


        }
        byte[] rgbKey = Encoding.UTF8.GetBytes(decryptKey);
        byte[] rgbIV = Keys;
        byte[] inputByteArray = Convert.FromBase64String(decryptString);
        DESCryptoServiceProvider DCSP = new DESCryptoServiceProvider();
        MemoryStream mStream = new MemoryStream();
        CryptoStream cStream = new CryptoStream(mStream, DCSP.CreateDecryptor(rgbKey, rgbIV), CryptoStreamMode.Write);
        cStream.Write(inputByteArray, 0, inputByteArray.Length);
        cStream.FlushFinalBlock();
        return Encoding.UTF8.GetString(mStream.ToArray());
    }
    catch (Exception ex)
    {
        return decryptString;
    }
}
















/**/
/**//**/////////////////////////// 
    /*
//加密函数 
public string EncryptData(String strKey, String strData)
{
string strResult; //Return Result
  
//1. 字符大小不能超过 90Kb. 否则, 缓存容易溢出（看第3点） 
if (strData.Length > 92160)
{
strResult="Error. Data String too large. Keep within 90Kb.";
return strResult;
}

//2. 生成key 
if (!InitKey(strKey))
{
strResult="Error. Fail to generate key for encryption";
return strResult;
}

//3. 准备处理的字符串
//字符串的前5个字节用来存储数据的长度
//用这个简单的方法来记住数据的初始大小，没有用太复杂的方法 
strData = String.Format("{0,5:00000}"+strData, strData.Length);


//4. 加密数据 
byte[] rbData = new byte[strData.Length];
ASCIIEncoding aEnc = new ASCIIEncoding();
aEnc.GetBytes(strData, 0, strData.Length, rbData, 0);



//加密功能实现的主要类 
DESCryptoServiceProvider descsp = new DESCryptoServiceProvider();

ICryptoTransform desEncrypt = descsp.CreateEncryptor(m_Key, m_IV);


//5. 准备stream
// mOut是输出流.
// mStream是输入流
// cs为转换流 
MemoryStream mStream = new MemoryStream(rbData);
CryptoStream cs = new CryptoStream(mStream, desEncrypt, CryptoStreamMode.Read);
MemoryStream mOut = new MemoryStream();

//6. 开始加密 
int bytesRead;
byte[] output = new byte[1024];
do
{
bytesRead = cs.Read(output,0,1024);
if (bytesRead != 0)
mOut.Write(output,0,bytesRead);
} while (bytesRead > 0);

//7. 返回加密结果
//因为是一个web项目，在这里转换为base64，因此在http上是不会出错的 
if (mOut.Length == 0)
strResult = "";
else
strResult = Convert.ToBase64String(mOut.GetBuffer(), 0, (int)mOut.Length);


Oracle db = new Oracle();
DataTable dt = new DataTable();



strData = strData.Replace("'", "''");

string sql = "Select get_password_c('" + strKey + strData + strKey + "') from dual";
db.ExcuteDataTable(dt, sql, CommandType.Text);
    if (dt.Rows.Count > 0)
    {
        strResult = dt.Rows[0][0].ToString();
    }
    else
    {
        strResult = "Error. ";

    }
 
return strResult;
}

*/
//解密函数 
/*
public string DecryptData(String strKey, String strData)
{
string strResult;
/*
//1. 生成解密key 
if (!InitKey(strKey))
{
strResult="Error. Fail to generate key for decryption";

return strResult;
}

//2. 初始化解密的主要类 
int nReturn = 0;
DESCryptoServiceProvider descsp = new DESCryptoServiceProvider();
ICryptoTransform desDecrypt = descsp.CreateDecryptor(m_Key, m_IV);

//3. 准备stream
// mOut为输出流
// cs为转换流 
MemoryStream mOut = new MemoryStream();
CryptoStream cs = new CryptoStream(mOut, desDecrypt, CryptoStreamMode.Write);

byte[] bPlain = new byte[strData.Length];
try
{
bPlain=Convert.FromBase64CharArray(strData.ToCharArray(),0,strData.Length);
}
catch (Exception)
{
strResult = "Error. Input Data is not base64 encoded.";
 
return strResult;
}

long lRead = 0;
long lTotal = strData.Length;

try
{
//5. 完成解密 
while (lTotal >= lRead)
{
cs.Write(bPlain,0,(int)bPlain.Length);
lRead = mOut.Length + Convert.ToUInt32(((bPlain.Length / descsp.BlockSize) * descsp.BlockSize));
};

ASCIIEncoding aEnc = new ASCIIEncoding();
strResult = aEnc.GetString(mOut.GetBuffer(), 0, (int)mOut.Length);

//6.去处存储长度的前5个字节的数据 
String strLen = strResult.Substring(0,5);
int nLen = Convert.ToInt32(strLen);
strResult = strResult.Substring(5, nLen);
nReturn = (int)mOut.Length;

return strResult;
}
catch (Exception)
{
strResult = "Error. Decryption Failed. Possibly due to incorrect Key or corrputed data";

return strResult;
}
   
Oracle db = new Oracle();
DataTable dt = new DataTable();
strData = strData.Replace("'", "''");
string sql = "Select  get_password_uc('" + strData + "') from dual";
db.ExcuteDataTable(dt, sql, CommandType.Text);
if (dt.Rows.Count > 0)
{
strResult = dt.Rows[0][0].ToString();

string l_key = strResult.Substring(0, strKey.Length);
if (l_key != strKey)
{
    strResult = "Error. ";
}
else
{
    l_key = strResult.Substring(strResult.Length - strKey.Length  , strKey.Length);
    if (l_key != strKey)
    {
        strResult = "Error. ";
    }
    else
    {
        strResult = strResult.Substring(strKey.Length, strResult.Length - strKey.Length * 2 );
    }

    
}



}
else
{
strResult = "Error. ";

}

return strResult;



}
  */
/**/
/**//**////////////////////////////////////////////////////////////// 
//生成key的函数 
/*
static private bool InitKey(String strKey)
{
try
{
// 转换key为字节流 
byte[] bp = new byte[strKey.Length];
ASCIIEncoding aEnc = new ASCIIEncoding();
aEnc.GetBytes(strKey, 0, strKey.Length, bp, 0);

SHA1CryptoServiceProvider sha = new SHA1CryptoServiceProvider();
byte[] bpHash = sha.ComputeHash(bp);

int i;
// 生成初始化DESCryptoServiceProvider的参数 
for (i=0; i<8; i++)
m_Key[i] = bpHash[i];

for (i=8; i<16; i++)
m_IV[i-8] = bpHash[i];

return true;
}
catch (Exception)
{
//错误处理 
return false;
}
    
}
*/
}
}


