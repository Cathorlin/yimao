using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing;
/// <summary>
/// Globe 的摘要说明
/// </summary>
public class GlobeAtt
{
    public GlobeAtt()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}
    private string A007_KEY_ = "";
    /// <summary>
    /// 用户主键
    /// </summary>
    /// <returns></returns>
    public  static string A007_KEY
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["A007_KEY"].ToString();

            }
            catch
            {
                 return "";
            }
        }

      
    }
    public  static string BS_LOG_SQL
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["BS_LOG_SQL"].ToString();

            }
            catch
            {
                 return "";
            }
        }

      
    }
    //获取配置的 值 用CFG_前缀
    public static string GetCfgValue(string id_)
    {
        return GetValue("CFG_" + id_);
    }
    public static string GetValue(string id_)
    { 

        try
        {
            return HttpContext.Current.Session[id_.ToUpper()].ToString();

        }
        catch
        {
            return "";
        }          
    }

    public  static string BS_LOG_A314
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["BS_LOG_A314"].ToString();

            }
            catch
            {
                 return "";
            }
        }

      
    }
    public static string BS_LOG_SELECTSQL
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["BS_LOG_SELECTSQL"].ToString();

            }
            catch
            {
                 return "0";
            }
        }

      
    }
    
    public static string SYS_MODE
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["SYS_MODE"].ToString();

            }
            catch
            {
                 return "U";
            }
        }

      
    }

    public static string RPT_TEMP_INDEX
    {
        get
        {
            System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
            int asciiCode = 28;
            byte[] byteArray = new byte[] { (byte)asciiCode };
            string strCharacter = asciiEncoding.GetString(byteArray);
            return (strCharacter);   
        }
    }
    public static string DATA_INDEX
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["DATA_INDEX"].ToString();

            }
            catch
            {
                System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
                int asciiCode = 31;
                byte[] byteArray = new byte[] { (byte)asciiCode };
                string strCharacter = asciiEncoding.GetString(byteArray);
                return (strCharacter);
            }
        }

      
    }

    
    public static string QueryList_PageRow
    {

        get
        {

            try
            {
                return HttpContext.Current.Session["QueryList_PageRow"].ToString();

            }
            catch
            {
                return "100";
            }
        }

     }

    public static string DetailRowS
    {

        get
        {

            try
            {
                return HttpContext.Current.Session["DetailRowS"].ToString();

            }
            catch
            {
                return "100";
            }
        }

     }

    
    public static string QueryList_MaxRow
    {

        get
        {

            try
            {
                return HttpContext.Current.Session["QueryList_MaxRow"].ToString();

            }
            catch
            {
                return "1000";
            }
        }

    }
    public static string LANGUAGE_ID
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["LANGUAGE_ID"].ToString();

            }
            catch
            {
                 return "CN";
            }
        }

      
    }
    
    public static string Sysdate
    {
        get
        {

            try
            {
                DataTable dt = new DataTable();
                BaseFun Fun = new BaseFun();
                dt = Fun.getDtBySql("Select to_char(sysdate,'YYYYMMDD') as c from dual");
                return dt.Rows[0][0].ToString();
            }
            catch
            {
                return "";
            }
        }


    }
    public static string Sysdatetime
    {
        get
        {

            try
            {
                DataTable dt = new DataTable();
                BaseFun Fun = new BaseFun();
                dt = Fun.getDtBySql("Select to_char(sysdate,'YYYYMMDDHH24MISS') as c from dual");
                return dt.Rows[0][0].ToString();
            }
            catch
            {
                return "";
            }
        }


    }

    /// <summary>
    /// 软件名称
    /// </summary>
    /// <returns></returns>
    public static string TITLE
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["TITLE"].ToString();

            }
            catch
            {
                return "";
            }
        }


    }


    public static string A002_KEY
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["JUMP_A002_KEY"].ToString();

            }
            catch
            {
                return "";
            }
        }


    }

    public static string HTTP_URL
    {
        get
        {
            string strTemp = "";
            if (System.Web.HttpContext.Current.Request.ServerVariables["HTTPS"] == "off")
            {
                strTemp = "http://";
            }
            else
            {
                strTemp = "https://";
            }

            strTemp = strTemp + System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"];

            if (System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"] != "80")
            {
                strTemp = strTemp + ":" + System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"];
            }

            strTemp = strTemp + System.Web.HttpContext.Current.Request.ApplicationPath;  //  System.Web.HttpContext.Current.Request.ServerVariables["URL"];


            return strTemp;
        }

    }

    public static string A007_NAME
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["A007_NAME"].ToString();

            }
            catch
            {
                return "";
            }
        }


    }
    private string A30001_KEY_ = "";
    public static string A30001_KEY
    {
        get
        {

            try
            {
                return HttpContext.Current.Session["A30001_KEY"].ToString();

            }
            catch
            {
                return "0";
            }
        }
       
    }


}
