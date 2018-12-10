using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Configuration;
using System.Web;
using System.Security.Cryptography;
using System.Net;
using System.IO;
using System.Data;
using System.Collections;
using System.Reflection;
using System.Net.Mail;
using System.Web.Security;

namespace Common
{
    public class Utils
    {

        public static string GetRemoteHtml(string strUrl, int timeout, string postData)
        {
            string strResult = string.Empty;
            try
            {
                HttpWebRequest myReq = (HttpWebRequest)HttpWebRequest.Create(strUrl);
                myReq.Timeout = timeout;
                myReq.Referer = string.Empty;
                myReq.Accept = "text/html";
                myReq.Headers.Add("Accept-Language", "zh-cn");
                myReq.UserAgent = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2)";
                if (string.IsNullOrEmpty(postData))
                {
                    myReq.Method = "GET";
                }
                else
                {
                    myReq.Method = "POST";
                    byte[] data = new System.Text.UTF8Encoding().GetBytes(postData);
                    myReq.ContentType = "application/x-www-form-urlencoded";
                    myReq.ContentLength = data.Length;
                    Stream newStream = myReq.GetRequestStream();

                    //发送数据
                    newStream.Write(data, 0, data.Length);
                    newStream.Close();
                }
                HttpWebResponse HttpWResp = (HttpWebResponse)myReq.GetResponse();
                Stream myStream = HttpWResp.GetResponseStream();
                StreamReader sr = new StreamReader(myStream, Encoding.UTF8);
                strResult = sr.ReadToEnd();

            }
            catch
            {
                //strResult = "Error";//"错误:" + exp.Message;
            }
            return strResult;
        }

        #region 将字符串转换为数组
        public static string[] SplitString(string strContent, string strSplit)
        {
            if (!string.IsNullOrEmpty(strContent))
            {
                if (strContent.IndexOf(strSplit) < 0)
                {
                    string[] tmp = { strContent };
                    return tmp;
                }
                return Regex.Split(strContent, Regex.Escape(strSplit), RegexOptions.IgnoreCase);
            }
            else
            {
                return new string[0] { };
            }
        }
        #endregion

        public static byte StrToByte(string strValue)
        {
            byte num;
            if (!byte.TryParse(strValue, out num))
            {
                num = 0;
            }
            return num;
        }
        public static int StrToInt(string strValue)
        {
            int num;
            if (!int.TryParse(strValue, out num))
            {
                num = 0;
            }
            return num;
        }

        public static int StrToInt(string strValue, int defValue)
        {
            int num;
            if (!int.TryParse(strValue, out num))
            {
                num = defValue;
            }
            return num;
        }
        public static int ObjectToInt(object obj, int defValue)
        {
            if (obj == null)
            {
                return defValue;
            }
            int num;
            if (!int.TryParse(obj.ToString(), out num))
            {
                num = defValue;
            }
            return num;
        }
        public static long ObjectToLong(object obj, long defValue)
        {
            if (obj == null)
            {
                return defValue;
            }
            long num;
            if (!long.TryParse(obj.ToString(), out num))
            {
                num = defValue;
            }
            return num;
        }
        public static long StrToLong(string obj, long defValue)
        {
            long num;
            if (!long.TryParse(obj, out num))
            {
                num = defValue;
            }
            return num;
        }
        public static float StrToFloat(string strValue, float defValue)
        {
            float num;
            if (!float.TryParse(strValue, out num))
            {
                num = defValue;
            }
            return num;
        }
        public static decimal StrToDecimal(string strValue, decimal defValue)
        {
            decimal num;
            if (!decimal.TryParse(strValue, out num))
            {
                num = defValue;
            }
            return num;
        }
        public static decimal StrToDecimal(string strValue)
        {
            decimal num;
            if (!decimal.TryParse(strValue, out num))
            {
                num = 0m;
            }
            return num;
        }
        public static decimal ObjectToDecimal(object strValue)
        {
            if (null == strValue)
            {
                return 0m;
            }
            decimal num;
            if (!decimal.TryParse(strValue.ToString(), out num))
            {
                num = 0m;
            }
            return num;
        }
        public static DateTime StrToDateTime(string strValue)
        {
            DateTime num;
            if (!DateTime.TryParse(strValue, out num))
            {
                num = DateTime.Now;
            }
            return num;
        }
        public static DateTime StrToDateTime(string strValue, DateTime defValue)
        {
            DateTime num;
            if (!DateTime.TryParse(strValue, out num))
            {
                num = defValue;
            }
            return num;
        }
        public static DateTime ObjectToDateTime(object strValue, DateTime defValue)
        {
            if (strValue == null)
            {
                return defValue;
            }
            DateTime num;
            if (!DateTime.TryParse(strValue.ToString(), out num))
            {
                num = defValue;
            }
            return num;
        }
        public static DateTime ObjectToDateTime(object strValue)
        {
            return ObjectToDateTime(strValue, new DateTime(2000, 1, 1));
        }
        public static string ObjectToCurrencyString(object obj)
        {
            return string.Format("{0:N}", Utils.ObjectToDecimal(obj));
        }
        public static string DecimalToCurrencyString(decimal num)
        {
            return string.Format("{0:N}", num);
        }
        public static bool StrToBool(string strValue, bool defValue)
        {
            if (strValue != null)
            {
                switch (strValue)
                {
                    case "False":
                    case "false":
                    case "0":
                    case "off":
                    case "":
                        return false;
                    case "True":
                    case "true":
                    case "1":
                    case "on":
                        return true;
                    default:
                        return false;
                }
            }
            return defValue;
        }
        public static bool ObjectToBool(object obj, bool defValue)
        {
            if (obj != null)
            {
                switch (obj.ToString())
                {
                    case "False":
                    case "false":
                    case "0":
                    case "off":
                    case "":
                        return false;
                    case "True":
                    case "true":
                    case "1":
                    case "on":
                        return true;
                    default:
                        return false;
                }
            }
            return defValue;
        }

        public static bool IsNumericArray(string strNumber)
        {
            if (string.IsNullOrEmpty(strNumber))
            {
                return false;
            }
            return IsNumericArray(strNumber.Split(','));
        }
        public static bool IsNumericArray(string[] strNumber)
        {
            if (strNumber == null)
            {
                return false;
            }
            if (strNumber.Length < 1)
            {
                return false;
            }
            foreach (string id in strNumber)
            {
                if (!IsDigits(id))
                {
                    return false;
                }
            }
            return true;
        }
        public static bool IsDigits(string expression)
        {
            if (expression != null)
            {
                string str = expression;
                if (str.Length > 0 && str.Length <= 11 && Regex.IsMatch(str, @"^[-]?[0-9]*[.]?[0-9]*$"))
                {
                    return true;
                }
            }
            return false;

        }
        public static bool IsNumber(string str)
        {
            return Regex.IsMatch(str, @"^\d{1,20}$");
        }
        public static bool IsNumber2(string str)
        {
            return Regex.IsMatch(str, @"^\d{1,38}$");
        }
        /// <summary>
        /// 是否为ip
        /// </summary>
        /// <param name="ip"></param>
        /// <returns></returns>
        public static bool IsIP(string ip)
        {
            return Regex.IsMatch(ip, @"^((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$");
        }
        /// <summary>
        /// 检测是否有Sql危险字符
        /// </summary>
        /// <param name="str">要判断字符串</param>
        /// <returns>判断结果</returns>
        public static bool IsSafeSqlString(string str)
        {
            return !Regex.IsMatch(str, @"[-|;|,|\/|\(|\)|\[|\]|\}|\{|%|@|\*|!|\']");
        }
        public static bool IsSafeUserName(string str)
        {
            return Regex.IsMatch(str, @"^[0-9a-zA-Z_]+$");
        }
        public static bool IsInt(string str)
        {

            return Regex.IsMatch(str, @"^[0-9]*$");
        }
        public static bool IsMobile(string str)
        {
            return Regex.IsMatch(str, @"^\d{11}$");
        }
        public static bool IsQQ(string str)
        {
            return Regex.IsMatch(str, @"^[1-9]\d{5,12}$");
        }
        public static bool IsIdCard(string str)
        {
            return Regex.IsMatch(str, @"^(^\d{15}$|^\d{18}$|^\d{17}(\d|X|x))$");
        }
        public static bool IsUrl(string url)
        {
            return Regex.IsMatch(url, @"^(http|https)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{1,10}))(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\?\'\\\+&%\$#\=~_\-]+))*$");
        }

        /// <summary>
        /// 检测是否符合email格式
        /// </summary>
        /// <param name="strEmail">要判断的email字符串</param>
        /// <returns>判断结果</returns>
        public static bool IsValidEmail(string strEmail)
        {
            //return Regex.IsMatch(strEmail, @"^[A-Za-z0-9-_]+@[A-Za-z0-9-_]+[\.][A-Za-z0-9-_]");
            return Regex.IsMatch(strEmail, @"^[\w\.]+@[A-Za-z0-9-_]+[\.][A-Za-z0-9-_]");
        }

        /// <summary>
        /// Method to make sure that user's inputs are not malicious
        /// </summary>
        /// <param name="text">User's Input</param>
        /// <param name="maxLength">Maximum length of input</param>
        /// <returns>The cleaned up version of the input</returns>
        public static string RemoveUnsafeText(string text, int maxLength)
        {
            if (string.IsNullOrEmpty(text))
            {
                return string.Empty;
            }
            text = text.Trim();
            text = Regex.Replace(text, "<(.|\\n)*?>", string.Empty);	//html tags
            text = text.Replace("'", string.Empty);
            text = text.Replace("%", string.Empty);
            text = text.Replace("_", string.Empty);
            if (text.Length > maxLength)
                text = text.Substring(0, maxLength);
            return text;
        }

        public static string RemoveUnsafeText(string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return string.Empty;
            }
            text = text.Trim();

            text = Regex.Replace(text, "<(.|\\n)*?>", string.Empty);	//html tags
            text = text.Replace("'", string.Empty);
            text = text.Replace("%", string.Empty);
            text = text.Replace("_", string.Empty);
            return text;
        }


        /// <summary>
        /// 写cookie值
        /// </summary>
        /// <param name="strName">名称</param>
        /// <param name="strValue">值</param>
        public static void WriteCookie(string strName, string strValue)
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies[strName];
            if (cookie == null)
            {
                cookie = new HttpCookie(strName);
            }
            cookie.Value = strValue;
            HttpContext.Current.Response.AppendCookie(cookie);
        }

        /// <summary>
        /// 写cookie值
        /// </summary>
        /// <param name="strName">名称</param>
        /// <param name="strValue">值</param>
        public static void WriteCookie(string strName, string key, string strValue)
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies[strName];
            if (cookie == null)
            {
                cookie = new HttpCookie(strName);
            }
            cookie[key] = strValue;
            HttpContext.Current.Response.AppendCookie(cookie);
        }

        /// <summary>
        /// 写cookie值
        /// </summary>
        /// <param name="strName">名称</param>
        /// <param name="strValue">值</param>
        /// <param name="strValue">过期时间(分钟)</param>
        public static void WriteCookie(string strName, string strValue, int expires)
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies[strName];
            if (cookie == null)
            {
                cookie = new HttpCookie(strName);
            }
            cookie.Value = strValue;
            cookie.Expires = DateTime.Now.AddMinutes(expires);
            HttpContext.Current.Response.AppendCookie(cookie);
        }

        /// <summary>
        /// 读cookie值
        /// </summary>
        /// <param name="strName">名称</param>
        /// <returns>cookie值</returns>
        public static string GetCookie(string strName)
        {
            if (HttpContext.Current.Request.Cookies != null && HttpContext.Current.Request.Cookies[strName] != null)
                return HttpContext.Current.Request.Cookies[strName].Value.ToString();

            return "";
        }

        /// <summary>
        /// 读cookie值
        /// </summary>
        /// <param name="strName">名称</param>
        /// <returns>cookie值</returns>
        public static string GetCookie(string strName, string key)
        {
            if (HttpContext.Current.Request.Cookies != null && HttpContext.Current.Request.Cookies[strName] != null && HttpContext.Current.Request.Cookies[strName][key] != null)
                return HttpContext.Current.Request.Cookies[strName][key].ToString();

            return "";
        }
        public static void RemoveCookie(string cookieName)
        {
            string str = string.Empty;

            HttpCookie cookie = new HttpCookie(cookieName, str);
            cookie.HttpOnly = true;
            cookie.Path = System.Web.Security.FormsAuthentication.FormsCookiePath;
            cookie.Expires = DateTime.Now.AddDays(-1);
            cookie.Secure = FormsAuthentication.RequireSSL;

            HttpContext.Current.Response.Cookies.Remove(cookieName);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }
        public static string GetRandomString(int len)
        {
            string s = "123456789abcdefghijklmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ";
            string reValue = string.Empty;
            Random rnd = new Random(getNewSeed());
            while (reValue.Length < len)
            {
                string s1 = s[rnd.Next(0, s.Length)].ToString();
                if (reValue.IndexOf(s1) == -1) reValue += s1;
            }
            return reValue;
        }
        private static int getNewSeed()
        {
            byte[] rndBytes = new byte[4];
            System.Security.Cryptography.RNGCryptoServiceProvider rng = new System.Security.Cryptography.RNGCryptoServiceProvider();
            rng.GetBytes(rndBytes);
            return BitConverter.ToInt32(rndBytes, 0);
        }
        public static string GetRandomNumString(int len)
        {
            string s = "1234567890";
            string reValue = string.Empty;
            Random rnd = new Random(getNewSeed());
            while (reValue.Length < len)
            {
                string s1 = s[rnd.Next(0, s.Length)].ToString();
                if (reValue.IndexOf(s1) == -1) reValue += s1;
            }
            return reValue;
        }
        public static bool IsMicroMessenger()
        {
            //是否是微信浏览器
            string userAgent = System.Web.HttpContext.Current.Request.UserAgent;
            if (string.IsNullOrEmpty(userAgent))
            {
                return false;
            }
            return System.Text.RegularExpressions.Regex.IsMatch(userAgent, "MicroMessenger", System.Text.RegularExpressions.RegexOptions.IgnoreCase);
        }

        /// <summary>
        /// 转换时间为unix时间戳
        /// </summary>
        /// <param name="date">需要传递UTC时间,避免时区误差,例:DataTime.UTCNow</param>
        /// <returns></returns>
        public static double ConvertToUnixTimestamp(DateTime date)
        {
            DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0);
            TimeSpan diff = date - origin;
            return Math.Floor(diff.TotalSeconds);
        }
        public static bool SendEmail(string fromMailId, string fromMailName, string toMailId, string toMailName, string MailTitle, string MailInfo, string MailSmtpServer, string MailPwd)
        {
            ////设置发件人信箱,及显示名字 
            MailAddress from_mail = new MailAddress(fromMailId, fromMailName);
            //设置收件人信箱,及显示名字 
            MailAddress to_mail = new MailAddress(toMailId, toMailName);
            //创建一个MailMessage对象 
            MailMessage oMail = new MailMessage(from_mail, to_mail);
            oMail.Subject = MailTitle; //邮件标题 
            oMail.Body = MailInfo; //邮件内容 
            oMail.IsBodyHtml = true; //指定邮件格式,支持HTML格式 
            oMail.BodyEncoding = System.Text.Encoding.GetEncoding("GB2312");//邮件采用的编码 
            oMail.Priority = MailPriority.Normal;//设置邮件的优先级为高 

            //发送邮件服务器 
            SmtpClient client = new SmtpClient();
            client.Host = MailSmtpServer; //指定邮件服务器 
            client.Credentials = new NetworkCredential(fromMailId, MailPwd);//指定服务器邮件,及密码 

            //发送 
            try
            {
                client.Send(oMail); //发送邮件 
                return true;
            }
            catch
            {
                return false;
            }
            finally
            {
                oMail.Dispose(); //释放资源 
            }

        }
    }
}
