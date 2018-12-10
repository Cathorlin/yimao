using System;
using System.Collections;
using System.IO;
using System.Text;
using System.Security;
using System.Data;
using System.Text;
using System.Security.Cryptography;
public class MD5
    {
        //static state variables
        private static UInt32 A;
        private static UInt32 B;
        private static UInt32 C;
        private static UInt32 D;

        //number of bits to rotate in tranforming
        private const int S11 = 7;
        private const int S12 = 12;
        private const int S13 = 17;
        private const int S14 = 22;
        private const int S21 = 5;
        private const int S22 = 9;
        private const int S23 = 14;
        private const int S24 = 20;
        private const int S31 = 4;
        private const int S32 = 11;
        private const int S33 = 16;
        private const int S34 = 23;
        private const int S41 = 6;
        private const int S42 = 10;
        private const int S43 = 15;
        private const int S44 = 21;


        /* F, G, H and I are basic MD5 functions.
         * 四个非线性函数:
         * 
         * F(X,Y,Z) =(X&Y)|((~X)&Z)
         * G(X,Y,Z) =(X&Z)|(Y&(~Z))
         * H(X,Y,Z) =X^Y^Z
         * I(X,Y,Z)=Y^(X|(~Z))
         * 
         * （&与，|或，~非，^异或）
         */
        private static UInt32 F(UInt32 x, UInt32 y, UInt32 z)
        {
            return (x & y) | ((~x) & z);
        }
        private static UInt32 G(UInt32 x, UInt32 y, UInt32 z)
        {
            return (x & z) | (y & (~z));
        }
        private static UInt32 H(UInt32 x, UInt32 y, UInt32 z)
        {
            return x ^ y ^ z;
        }
        private static UInt32 I(UInt32 x, UInt32 y, UInt32 z)
        {
            return y ^ (x | (~z));
        }

        /* FF, GG, HH, and II transformations for rounds 1, 2, 3, and 4.
         * Rotation is separate from addition to prevent recomputation.
         */
        private static void FF(ref UInt32 a, UInt32 b, UInt32 c, UInt32 d, UInt32 mj, int s, UInt32 ti)
        {
            a = a + F(b, c, d) + mj + ti;
            a = a << s | a >> (32 - s);
            a += b;
        }
        private static void GG(ref UInt32 a, UInt32 b, UInt32 c, UInt32 d, UInt32 mj, int s, UInt32 ti)
        {
            a = a + G(b, c, d) + mj + ti;
            a = a << s | a >> (32 - s);
            a += b;
        }
        private static void HH(ref UInt32 a, UInt32 b, UInt32 c, UInt32 d, UInt32 mj, int s, UInt32 ti)
        {
            a = a + H(b, c, d) + mj + ti;
            a = a << s | a >> (32 - s);
            a += b;
        }
        private static void II(ref UInt32 a, UInt32 b, UInt32 c, UInt32 d, UInt32 mj, int s, UInt32 ti)
        {
            a = a + I(b, c, d) + mj + ti;
            a = a << s | a >> (32 - s);
            a += b;
        }

        private static void MD5_Init()
        {
            A = 0x67452301;  //in memory, this is 0x01234567
            B = 0xefcdab89;  //in memory, this is 0x89abcdef
            C = 0x98badcfe;  //in memory, this is 0xfedcba98
            D = 0x10325476;  //in memory, this is 0x76543210
        }

        private static UInt32[] MD5_Append(byte[] input)
        {
            int zeros = 0;
            int ones = 1;
            int size = 0;
            int n = input.Length;
            int m = n % 64;
            if (m < 56)
            {
                zeros = 55 - m;
                size = n - m + 64;
            }
            else if (m == 56)
            {
                zeros = 0;
                ones = 0;
                size = n + 8;
            }
            else
            {
                zeros = 63 - m + 56;
                size = n + 64 - m + 64;
            }

            ArrayList bs = new ArrayList(input);
            if (ones == 1)
            {
                bs.Add((byte)0x80); // 0x80 = $10000000
            }
            for (int i = 0; i < zeros; i++)
            {
                bs.Add((byte)0);
            }

            UInt64 N = (UInt64)n * 8;
            byte h1 = (byte)(N & 0xFF);
            byte h2 = (byte)((N >> 8) & 0xFF);
            byte h3 = (byte)((N >> 16) & 0xFF);
            byte h4 = (byte)((N >> 24) & 0xFF);
            byte h5 = (byte)((N >> 32) & 0xFF);
            byte h6 = (byte)((N >> 40) & 0xFF);
            byte h7 = (byte)((N >> 48) & 0xFF);
            byte h8 = (byte)(N >> 56);
            bs.Add(h1);
            bs.Add(h2);
            bs.Add(h3);
            bs.Add(h4);
            bs.Add(h5);
            bs.Add(h6);
            bs.Add(h7);
            bs.Add(h8);
            byte[] ts = (byte[])bs.ToArray(typeof(byte));

            /* Decodes input (byte[]) into output (UInt32[]). Assumes len is
             * a multiple of 4.
             */
            UInt32[] output = new UInt32[size / 4];
            for (Int64 i = 0, j = 0; i < size; j++, i += 4)
            {
                output[j] = (UInt32)(ts[i] | ts[i + 1] << 8 | ts[i + 2] << 16 | ts[i + 3] << 24);
            }
            return output;
        }
        private static UInt32[] MD5_Trasform(UInt32[] x)
        {

            UInt32 a, b, c, d;

            for (int k = 0; k < x.Length; k += 16)
            {
                a = A;
                b = B;
                c = C;
                d = D;

                /* Round 1 */
                FF(ref a, b, c, d, x[k + 0], S11, 0xd76aa478); /* 1 */
                FF(ref d, a, b, c, x[k + 1], S12, 0xe8c7b756); /* 2 */
                FF(ref c, d, a, b, x[k + 2], S13, 0x242070db); /* 3 */
                FF(ref b, c, d, a, x[k + 3], S14, 0xc1bdceee); /* 4 */
                FF(ref a, b, c, d, x[k + 4], S11, 0xf57c0faf); /* 5 */
                FF(ref d, a, b, c, x[k + 5], S12, 0x4787c62a); /* 6 */
                FF(ref c, d, a, b, x[k + 6], S13, 0xa8304613); /* 7 */
                FF(ref b, c, d, a, x[k + 7], S14, 0xfd469501); /* 8 */
                FF(ref a, b, c, d, x[k + 8], S11, 0x698098d8); /* 9 */
                FF(ref d, a, b, c, x[k + 9], S12, 0x8b44f7af); /* 10 */
                FF(ref c, d, a, b, x[k + 10], S13, 0xffff5bb1); /* 11 */
                FF(ref b, c, d, a, x[k + 11], S14, 0x895cd7be); /* 12 */
                FF(ref a, b, c, d, x[k + 12], S11, 0x6b901122); /* 13 */
                FF(ref d, a, b, c, x[k + 13], S12, 0xfd987193); /* 14 */
                FF(ref c, d, a, b, x[k + 14], S13, 0xa679438e); /* 15 */
                FF(ref b, c, d, a, x[k + 15], S14, 0x49b40821); /* 16 */

                /* Round 2 */
                GG(ref a, b, c, d, x[k + 1], S21, 0xf61e2562); /* 17 */
                GG(ref d, a, b, c, x[k + 6], S22, 0xc040b340); /* 18 */
                GG(ref c, d, a, b, x[k + 11], S23, 0x265e5a51); /* 19 */
                GG(ref b, c, d, a, x[k + 0], S24, 0xe9b6c7aa); /* 20 */
                GG(ref a, b, c, d, x[k + 5], S21, 0xd62f105d); /* 21 */
                GG(ref d, a, b, c, x[k + 10], S22, 0x2441453); /* 22 */
                GG(ref c, d, a, b, x[k + 15], S23, 0xd8a1e681); /* 23 */
                GG(ref b, c, d, a, x[k + 4], S24, 0xe7d3fbc8); /* 24 */
                GG(ref a, b, c, d, x[k + 9], S21, 0x21e1cde6); /* 25 */
                GG(ref d, a, b, c, x[k + 14], S22, 0xc33707d6); /* 26 */
                GG(ref c, d, a, b, x[k + 3], S23, 0xf4d50d87); /* 27 */
                GG(ref b, c, d, a, x[k + 8], S24, 0x455a14ed); /* 28 */
                GG(ref a, b, c, d, x[k + 13], S21, 0xa9e3e905); /* 29 */
                GG(ref d, a, b, c, x[k + 2], S22, 0xfcefa3f8); /* 30 */
                GG(ref c, d, a, b, x[k + 7], S23, 0x676f02d9); /* 31 */
                GG(ref b, c, d, a, x[k + 12], S24, 0x8d2a4c8a); /* 32 */

                /* Round 3 */
                HH(ref a, b, c, d, x[k + 5], S31, 0xfffa3942); /* 33 */
                HH(ref d, a, b, c, x[k + 8], S32, 0x8771f681); /* 34 */
                HH(ref c, d, a, b, x[k + 11], S33, 0x6d9d6122); /* 35 */
                HH(ref b, c, d, a, x[k + 14], S34, 0xfde5380c); /* 36 */
                HH(ref a, b, c, d, x[k + 1], S31, 0xa4beea44); /* 37 */
                HH(ref d, a, b, c, x[k + 4], S32, 0x4bdecfa9); /* 38 */
                HH(ref c, d, a, b, x[k + 7], S33, 0xf6bb4b60); /* 39 */
                HH(ref b, c, d, a, x[k + 10], S34, 0xbebfbc70); /* 40 */
                HH(ref a, b, c, d, x[k + 13], S31, 0x289b7ec6); /* 41 */
                HH(ref d, a, b, c, x[k + 0], S32, 0xeaa127fa); /* 42 */
                HH(ref c, d, a, b, x[k + 3], S33, 0xd4ef3085); /* 43 */
                HH(ref b, c, d, a, x[k + 6], S34, 0x4881d05); /* 44 */
                HH(ref a, b, c, d, x[k + 9], S31, 0xd9d4d039); /* 45 */
                HH(ref d, a, b, c, x[k + 12], S32, 0xe6db99e5); /* 46 */
                HH(ref c, d, a, b, x[k + 15], S33, 0x1fa27cf8); /* 47 */
                HH(ref b, c, d, a, x[k + 2], S34, 0xc4ac5665); /* 48 */

                /* Round 4 */
                II(ref a, b, c, d, x[k + 0], S41, 0xf4292244); /* 49 */
                II(ref d, a, b, c, x[k + 7], S42, 0x432aff97); /* 50 */
                II(ref c, d, a, b, x[k + 14], S43, 0xab9423a7); /* 51 */
                II(ref b, c, d, a, x[k + 5], S44, 0xfc93a039); /* 52 */
                II(ref a, b, c, d, x[k + 12], S41, 0x655b59c3); /* 53 */
                II(ref d, a, b, c, x[k + 3], S42, 0x8f0ccc92); /* 54 */
                II(ref c, d, a, b, x[k + 10], S43, 0xffeff47d); /* 55 */
                II(ref b, c, d, a, x[k + 1], S44, 0x85845dd1); /* 56 */
                II(ref a, b, c, d, x[k + 8], S41, 0x6fa87e4f); /* 57 */
                II(ref d, a, b, c, x[k + 15], S42, 0xfe2ce6e0); /* 58 */
                II(ref c, d, a, b, x[k + 6], S43, 0xa3014314); /* 59 */
                II(ref b, c, d, a, x[k + 13], S44, 0x4e0811a1); /* 60 */
                II(ref a, b, c, d, x[k + 4], S41, 0xf7537e82); /* 61 */
                II(ref d, a, b, c, x[k + 11], S42, 0xbd3af235); /* 62 */
                II(ref c, d, a, b, x[k + 2], S43, 0x2ad7d2bb); /* 63 */
                II(ref b, c, d, a, x[k + 9], S44, 0xeb86d391); /* 64 */

                A += a;
                B += b;
                C += c;
                D += d;
            }
            return new UInt32[] { A, B, C, D };
        }
        public static byte[] MD5Array(byte[] input)
        {
            MD5_Init();
            UInt32[] block = MD5_Append(input);
            UInt32[] bits = MD5_Trasform(block);

            /* Encodes bits (UInt32[]) into output (byte[]). Assumes len is
             * a multiple of 4.
                 */
            byte[] output = new byte[bits.Length * 4];
            for (int i = 0, j = 0; i < bits.Length; i++, j += 4)
            {
                output[j] = (byte)(bits[i] & 0xff);
                output[j + 1] = (byte)((bits[i] >> 8) & 0xff);
                output[j + 2] = (byte)((bits[i] >> 16) & 0xff);
                output[j + 3] = (byte)((bits[i] >> 24) & 0xff);
            }
            return output;
        }

        public static string ArrayToHexString(byte[] array, bool uppercase)
        {
            string hexString = "";
            string format = "x2";
            if (uppercase)
            {
                format = "X2";
            }
            foreach (byte b in array)
            {
                hexString += b.ToString(format);
            }
            return hexString;
        }

        public static string MDString(string message)
        {
            //char[] c = message.ToCharArray();
            //byte[] b = new byte[c.Length];
            byte[] b = Encoding.UTF8.GetBytes(message);
            //for(int i=0;i<c.Length;i++){
            //  b[i]=(byte)c[i];
            //}
            byte[] digest = MD5Array(b);
            return ArrayToHexString(digest, false);
        }
        public static string MDFile(string fileName)
        {
            FileStream fs = File.Open(fileName, FileMode.Open, FileAccess.Read);
            byte[] array = new byte[fs.Length];
            fs.Read(array, 0, (int)fs.Length);
            byte[] digest = MD5Array(array);
            fs.Close();
            return ArrayToHexString(digest, false);
        }

        // public static string Test(string message){
        // return "rnMD5 ("+message+ ") = " + MD5.MDString(message);
        // }
        /*
      public static string TestSuite(){    
        string s = "";
        s+=Test("");
        s+=Test("a");
        s+=Test("abc");
        s+=Test("message digest");
        s+=Test("abcdefghijklmnopqrstuvwxyz");
        s+=Test("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
        s+=Test("12345678901234567890123456789012345678901234567890123456789012345678901234567890");
        return s;    
      }
         */





    }
public class DES
{
    private static string _defaultkey_ = "wtlqlwyc";
    public DES()
    { 
    
    }
     public static string Key
     {
         get
         {
             return _defaultkey_;
         }
      }
    


    
    private static byte[] Keys = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
    //解密
    public static string Decrypt_Des(String strMing, String KeyStr, CipherMode Mode)
    {
        string result = "";


        int li_length = strMing.Length / 2 ;
        byte[] strMingbyte = new byte[li_length];
        for (int i = 0; i < li_length; i++)
        { 
            int d = Convert.ToInt32(strMing.Substring(i* 2 ,2), 16);
            strMingbyte[i] = (byte)d;
        }

        string keystr = MD5.MDString(KeyStr).Substring(0, 16).ToUpper();

        DESCryptoServiceProvider des = new DESCryptoServiceProvider();
        byte[] inputByteArray = strMingbyte;// Encoding.ASCII.GetBytes(strMing.ToString());
        li_length = 8;
        byte[] bkey = new byte[8];  
        for (int i = 0; i < li_length; i++)
        {
            int d = Convert.ToInt32(keystr.Substring(i * 2, 2), 16);
            bkey[i] = (byte)d;
        }

        // 
        des.Key = bkey;// ASCIIEncoding.Default.GetBytes(keystr);


        des.IV = Keys;
        des.Mode = Mode;

        des.Padding = PaddingMode.Zeros;
        MemoryStream ms = new MemoryStream();
        CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(), CryptoStreamMode.Write);
        cs.Write(inputByteArray, 0, inputByteArray.Length);
             StringBuilder ret = new StringBuilder();
        try
        {
            cs.FlushFinalBlock();
       
                  }
        catch
        {
            //MessageBox.Show("溢出，解密有误");
            return "";
        }

        return Encoding.Default.GetString(ms.ToArray());

        //return ret.ToString();

    }
    //DES加密
    public static string Encrypt_Des(String strMing, String KeyStr, CipherMode Mode)
    {
        string result = "";
        try
        {
         if(strMing.Length>8)
			throw new Exception("密码长度不能超过8位");
        }
        catch
        {
            throw new  Exception("加解密字符串失败！");
        }
        int li_length = strMing.Length;
        if (strMing.Length < 8)
        { 
          
            for (int i = 0; i < 8 - li_length; i++)
            {
                strMing = strMing + "F";
            }
                    
        }

        byte[] strMingbyte = Encoding.Default.GetBytes(strMing);
        li_length = strMingbyte.Length;
      
        StringBuilder str_data = new StringBuilder();
        str_data.Append(strMing);
     

        string keystr = MD5.MDString(KeyStr).Substring(0,16).ToUpper();


         DESCryptoServiceProvider des = new DESCryptoServiceProvider();

        byte[] bkey = new byte[8];
        for (int i = 0; i < li_length; i++)
        {
            int d = Convert.ToInt32(keystr.Substring(i * 2, 2), 16);
            bkey[i] = (byte)d;
        }

        des.Mode = Mode;

        des.Padding = PaddingMode.Zeros;
        des.Key = bkey;
        //des.KeySize = 64;
        //des.BlockSize = 64;

       // des.FeedbackSize = 128;
        
     //   des.Key = ASCIIEncoding.ASCII.GetBytes(sKey);
        // sKey;203:802
       //  byte[] sIV;
      //  byte[] keyByteArray = Encoding.Default.GetBytes(keystr);
       // SHA1 ha = new SHA1Managed();
       // byte[] hb = ha.ComputeHash(keyByteArray);
      //  byte[] sKey = new byte[8];
      //  byte[] sIV = new byte[8];
     //   for (int i = 0; i < 8; i++)
     //       sKey[i] = hb[i];
     //   for (int i = 8; i < 16; i++)
    //        sIV[i - 8] = hb[i];

   //     des.Key = sKey;
     //   des.IV = sIV;
//


   //    des.Key = ASCIIEncoding.ASCII.GetBytes(keystr);
       des.IV = Keys;// ASCIIEncoding.ASCII.GetBytes(keystr.Substring(0, 8));
       // des.IV = ASCIIEncoding.UTF8.GetBytes(keystr.Substring(0,16)); ;
           //      byte[] buffer = Encrypt(str_data.ToString(), des);

     //   des.Key = ASCIIEncoding.UTF8.GetBytes(keystr);
        //  
       // des.IV = ASCIIEncoding.UTF8.GetBytes(keystr.Substring(8, 8));// ASCIIEncoding.ASCII.GetBytes(keystr.Substring(0, 8));

      /*  byte[] inputByteArray = new byte[str_data.Length / 2];
        for (int i = 0; i < (str_data.Length / 2); i++)
        {
            int num2 = Convert.ToInt32(str_data.Substring(i * 2, 2), 0x10);
            inputByteArray[i] = (byte)num2;
        }

       */

        byte[] inputByteArray = Encoding.ASCII.GetBytes(str_data.ToString());
        MemoryStream ms = new MemoryStream();
        CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(), CryptoStreamMode.Write);
      

        cs.Write(inputByteArray, 0, inputByteArray.Length);
        cs.FlushFinalBlock();
        StringBuilder ret = new StringBuilder();
        string s = "";
        foreach (byte b in ms.ToArray())
        {
            ret.AppendFormat("{0:X2}", b);
        }
      //  return Convert.ToBase64String(ms.ToArray());
     //   ret.ToString();
        return ret.ToString();


	
    
    }
    public static byte[] Encrypt(string PlainText, SymmetricAlgorithm key)
    {
        // Create a memory stream.
        MemoryStream ms = new MemoryStream();

        // Create a CryptoStream using the memory stream and the 
        // CSP DES key.  
        CryptoStream encStream = new CryptoStream(ms, key.CreateEncryptor(), CryptoStreamMode.Write);

        // Create a StreamWriter to write a string
        // to the stream.
        StreamWriter sw = new StreamWriter(encStream);

        // Write the plaintext to the stream.
        sw.WriteLine(PlainText);

        // Close the StreamWriter and CryptoStream.
        sw.Close();
        encStream.Close();

        // Get an array of bytes that represents
        // the memory stream.
        byte[] buffer = ms.ToArray();

        // Close the memory stream.
        ms.Close();

        // Return the encrypted byte array.
        return buffer;
    }


    /// <summary>
    /// 加密
    /// </summary>
    /// <param name="pToEncrypt"></param>
    /// <param name="sKey"></param>
    /// <param name="mode"></param>
    /// <param name="padding"></param>
    /// <param name="ib_base64"></param>
    /// <returns></returns>
    public static string DESEncrypt(string pToEncrypt, string sKey, CipherMode mode, PaddingMode padding ,Boolean ib_base64)
    {

        DESCryptoServiceProvider des = new DESCryptoServiceProvider();
        byte[] inputByteArray = Encoding.Default.GetBytes(pToEncrypt);
        des.Key = ASCIIEncoding.ASCII.GetBytes(sKey.Substring(0, 8));
        des.IV = Keys;// ASCIIEncoding.ASCII.GetBytes(sKey.Substring(0, 8));
        des.Mode = mode;// CipherMode.ECB;
        des.Padding = padding;// PaddingMode.PKCS7;
        MemoryStream ms = new MemoryStream();
        CryptoStream cs = new CryptoStream(ms, des.CreateEncryptor(), CryptoStreamMode.Write);
        cs.Write(inputByteArray, 0, inputByteArray.Length);
        cs.FlushFinalBlock();
        StringBuilder ret = new StringBuilder();

        if (ib_base64)
        {
            return Convert.ToBase64String(ms.ToArray());
        } 
        foreach (byte b in ms.ToArray())
        {
            ret.AppendFormat("{0:X2}", b);
        }
        ret.ToString();
        
        return ret.ToString();
    }
    public static string DESEncrypt(string pToEncrypt, string sKey)
    {


        return DESEncrypt(pToEncrypt, sKey, CipherMode.ECB,PaddingMode.PKCS7, false);

       
    }
    /// <summary>
    /// 解密
    /// </summary>
    /// <param name="pToDecrypt_"></param>
    /// <param name="sKey"></param>
    /// <returns></returns>
    public static string DESDecrypt(string pToDecrypt_, string sKey)
    {
        return DESDecrypt(pToDecrypt_, sKey, CipherMode.ECB, PaddingMode.PKCS7, false);
    }


    ///DES解密 
    public static string DESDecrypt(string pToDecrypt_, string sKey, CipherMode mode, PaddingMode padding, Boolean ib_base64)
    {
        DESCryptoServiceProvider des = new DESCryptoServiceProvider();
        des.Key = ASCIIEncoding.ASCII.GetBytes(sKey.Substring(0, 8));
        des.IV = Keys;// ASCIIEncoding.ASCII.GetBytes(sKey.Substring(0, 8));
        des.Mode = mode;// CipherMode.ECB;
        des.Padding = padding;// PaddingMode.PKCS7;
        string pToDecrypt = pToDecrypt_;
        if (ib_base64)
        {
            pToDecrypt =ASCIIEncoding.ASCII.GetString(Convert.FromBase64String(pToDecrypt_));
        } 

        byte[] inputByteArray = new byte[pToDecrypt.Length / 2];
        for (int x = 0; x < pToDecrypt.Length / 2; x++)
        {
            int i = (Convert.ToInt32(pToDecrypt.Substring(x * 2, 2), 16));
            inputByteArray[x] = (byte)i;
        }

        des.Key = ASCIIEncoding.ASCII.GetBytes(sKey);
        des.IV = ASCIIEncoding.ASCII.GetBytes(sKey);
        MemoryStream ms = new MemoryStream();
        CryptoStream cs = new CryptoStream(ms, des.CreateDecryptor(), CryptoStreamMode.Write);
        cs.Write(inputByteArray, 0, inputByteArray.Length);
        try
        {
            cs.FlushFinalBlock();
            StringBuilder ret = new StringBuilder();

        }
        catch
        {
           //MessageBox.Show("溢出，解密有误");
            return "";
        }
        return System.Text.Encoding.Default.GetString(ms.ToArray());
    }

}



