using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class main_form_head : AjaxUc
{
    Oracle db = new Oracle();
    public DataTable dt_a0360101 = new DataTable();
    public DataTable dt_m001 = new DataTable();
    public string http_url = "";
    public string m001_key = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        http_url = GetIndexUrl();
        string A03601_NAME = "温州";
        string sql = "select * from A0360101_M002_V01 t where t.A03601_NAME = '" + A03601_NAME + "'";
        db.ExcuteDataTable(dt_a0360101,sql,CommandType.Text);
        HttpContext.Current.Session["A03601_NAME"] = dt_a0360101.Rows[0]["A03601_NAME"].ToString();
        try
        {
            m001_key = Session["m001_key"].ToString();
            sql = "select * from M001 t where t.m001_key = '" + m001_key + "'";
            db.ExcuteDataTable(dt_m001, sql, CommandType.Text);
        }
        catch
        {
            m001_key = "";
        }
        
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