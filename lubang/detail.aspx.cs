using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class lubang_detail : System.Web.UI.Page
{
    public string http_url = "";
    Oracle db = new Oracle();
    public DataTable dt_m002 = new DataTable();
    public DataTable dt_m00203 = new DataTable();
    public string mainkey = "100000630";
    public string code = "0";
    public int j = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        BaseFun fun = new BaseFun();
        try
        {
            mainkey = Request.QueryString["KEY"].ToString(); //Session["PK_KEY_PIC"].ToString();
            code = Request.QueryString["code"].ToString();
            if (code == "0")
            {
                j = 20;
            }
            else if (code == "1")
            {
                j = 0;
            }
            else if (code == "2"){
                j = 21;
            }
        }
        catch
        {
            mainkey = "100000630";
        }

        dt_m00203 = fun.getDtBySql("Select t.* from M00201 t where t.m00201_key=" + mainkey);
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
    protected void Button1_Click(object sender, EventArgs e)
    {
       
    }
}