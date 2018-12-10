using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class lubang_main_form_rementuijian : System.Web.UI.UserControl
{
    Oracle db = new Oracle();
    public DataTable m00202_m036_A0360101_v01_6 = new DataTable();
    public string http_url = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string sql = "select * from M00203_LB01 t where rownum < 5";
        db.ExcuteDataTable(m00202_m036_A0360101_v01_6, sql, CommandType.Text);
        http_url = GetIndexUrl();
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