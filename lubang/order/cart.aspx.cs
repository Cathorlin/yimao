using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class lubang_order_cart : System.Web.UI.Page
{
    Oracle db = new Oracle();
    public DataTable dt_m001 = new DataTable();
    public string http_url = "";
    public Custom.BaseObject.Function Fun = new Custom.BaseObject.Function();
    protected void Page_Load(object sender, EventArgs e)
    {
        http_url = GetIndexUrl();
        string m001_key = Request.QueryString["userid"].ToString();
        string sql = "select * from m001 t where t.m001_key=" + m001_key + "";
        db.ExcuteDataTable(dt_m001, sql, CommandType.Text);
        DateTime currentTime = DateTime.Now;
        HttpContext.Current.Session["uType"] = "1";
        HttpContext.Current.Session["uLoginType"] = "1";
        HttpContext.Current.Session["logintype"] = "2";
        HttpContext.Current.Session["M002_KEY"] = "0";
        HttpContext.Current.Session["M002_NAME"] = "联盟卡";
        HttpContext.Current.Session["userInnerHtml"] = dt_m001.Rows[0]["m001_name"].ToString();
        HttpContext.Current.Session["user_id"] = dt_m001.Rows[0]["m001_key"].ToString();
        HttpContext.Current.Session["M001_KEY"] = dt_m001.Rows[0]["m001_key"].ToString();
        HttpContext.Current.Session["M001_ID"] = dt_m001.Rows[0]["M001_ID"].ToString();
        HttpContext.Current.Session["user_name"] = dt_m001.Rows[0]["m001_name"].ToString();
        HttpContext.Current.Session["show_name"] = dt_m001.Rows[0]["m001_name"].ToString();
        HttpContext.Current.Session["NICKNAME"] = dt_m001.Rows[0]["NICKNAME"].ToString();
        HttpContext.Current.Session["login"] = "1";
        HttpContext.Current.Session["login_datetime"] = currentTime.ToString();
        HttpContext.Current.Session["parent_menu_id"] = "20";
        HttpContext.Current.Session["state"] = dt_m001.Rows[0]["state"].ToString();//卡的状态
        HttpContext.Current.Session["link_url"] = "User/Index.aspx";
        HttpContext.Current.Session["PAY_KEY"] = dt_m001.Rows[0]["m001_key"].ToString();
        Fun.saveLogin("IN");
    }
    public static string GetIndexUrl()
    {
        //  2009年12月15日 11:45:24
        //  B哥 kuibono@163.com
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