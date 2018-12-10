using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class CarDes : System.Web.UI.Page
{
    public string http_url = "";
    Oracle db = new Oracle();
    public DataTable dt_m0203_m036 = new DataTable();
    public DataTable dt_m0203_v01 = new DataTable();
    public DataTable dt_m0203_v02 = new DataTable();
    public DataTable dt_m001 = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        http_url = GetIndexUrl(); 
        string m00203_key = Request.QueryString["keyid"].ToString();
        string sql = "select '首页' as 首页 ,t.* from M00203_LB_ALL t where t.m00203_key ='" + m00203_key + "'";
        db.ExcuteDataTable(dt_m0203_m036, sql, CommandType.Text);
        sql = "select * from M00203_LB_ALL t where t.m00203_key = '" + m00203_key + "'";
        db.ExcuteDataTable(dt_m0203_v01, sql, CommandType.Text);
        sql = "select * from M00203_LB_ALL where status in (1) and A03601_name = '温州'";
        db.ExcuteDataTable(dt_m0203_v02, sql, CommandType.Text);
        HttpContext.Current.Session["M00203_KEY"] = dt_m0203_v01.Rows[0]["M00203_KEY"].ToString();
    }
    protected void liji_buy(object sender, EventArgs e) 
    {
        string user_ = CheckUserLogin();
        if (user_ == "-1")
        {
            Response.Redirect("lubanglogin/login1.aspx");
        }
        else
        {
            string m001_key = Session["M001_KEY"].ToString();
            Response.Redirect("order/cart.aspx?userid="+ m001_key +"");
        }
    }
    public string CheckUserLogin()
    {
        string user_id_ = string.Empty;

        try
        {
            user_id_ = Session["user_id"].ToString();
        }
        catch
        {
            return "-1";
        }
        return user_id_;

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