using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class lubang_pdetail : System.Web.UI.Page
{
    public string http_url = "";
    Oracle db = new Oracle();
    public DataTable dt_m00203 = new DataTable();
    public string mainkey = "200";
    protected void Page_Load(object sender, EventArgs e)
    {
        http_url = GetIndexUrl();

    }
    protected void button_click(object sender, EventArgs e)
    {
    }
    public static string GetIndexUrl()
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

        strTemp = strTemp;
        return strTemp;
    }
  
}