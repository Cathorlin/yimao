using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class index_b : System.Web.UI.Page
{
    public string http_url = "";
    Oracle db = new Oracle();
    public DataTable dt_m00202_v01 = new DataTable();
    public DataTable dt_m00201 = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        http_url = GetIndexUrl();
        string m00203_key = Request.QueryString["keyid"].ToString();
        string sql = "select * from M00203_LB_ALL t where t.m00203_key = '" + m00203_key + "'";
        db.ExcuteDataTable(dt_m00202_v01, sql, CommandType.Text);
    }
    protected void DataPager1_PreRender(object sender, EventArgs e)
    {
        if (!IsPostBackEventControlRegistered)
        {
            BindData();
        }
    }
    private void BindData()
    {
        string m00201_key = dt_m00202_v01.Rows[0]["m00201_key"].ToString();
        string sql = "select * from M00203_LB_ALL t where t.m00201_key = '" + m00201_key + "'";
        db.ExcuteDataTable(dt_m00201,sql,CommandType.Text);
        this.ListView1.DataSource = dt_m00201;
        this.ListView1.DataBind();
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