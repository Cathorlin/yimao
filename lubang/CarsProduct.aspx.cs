using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
public partial class CarsSerive : System.Web.UI.Page
{
    Oracle db = new Oracle();
    public DataTable dt_a03601 = new DataTable();
    public DataTable dt_m036 = new DataTable();
    public DataTable dt_m03601 = new DataTable();
    public DataTable dt_m00203_m036 = new DataTable();
    public string http_url = "";
    public string m036_key{
        get { return Session["m036_key"] == null ? "" : Session["m036_key"].ToString(); }
        set { Session["m036_key"] = value; }
    }
    public string m03601_key{
        get { return Session["m03601_key"] == null ? "" : Session["m03601_key"].ToString(); ; }
        set { Session["m03601_key"] = value; }
    }
    public string a0360101_key
    {
        get { return Session["a0360101_key"] == null ? "" : Session["a0360101_key"].ToString(); ; }
        set { Session["a0360101_key"] = value; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        m036_key = Request.QueryString["mnameid"] == null ? m036_key : Request.QueryString["mnameid"].ToString();
        m03601_key = Request.QueryString["nameid"] == null ? m03601_key : Request.QueryString["nameid"].ToString();
        a0360101_key = Request.QueryString["anameid"] == null ? a0360101_key : Request.QueryString["anameid"].ToString();
        if (!IsPostBack)
        {
            string sql = "select * from A0360101_M002_V01 t where t.A03601_NAME = '温州'";
            db.ExcuteDataTable(dt_a03601, sql, CommandType.Text);
            sql = "select a.m036_key, a.m036_name, b.icount from m036 a left join (select m036_key, m036_name, count(*) as icount from m00202_m036_A0360101_v01 where a03601_name = '温州' group by m036_key, m036_name) b on a.m036_key = b.m036_key where a.CLASSIFYONE_STATUS = '1' and BELONG_TO = '1' order by m036_key";
            db.ExcuteDataTable(dt_m036, sql, CommandType.Text);
            sql = "select a.m03601_key,a.m03601_name,b.icount from m03601 a inner join m036 c on a.m036_key = c.m036_key left join  (select m03601_key,m03601_name,count(*) as icount from m00202_m036_A0360101_v01 where a03601_name = '温州' and m036_key='"+m036_key+"' group by m03601_key,m03601_name)b on a.m03601_key = b.m03601_key where  c.CLASSIFYONE_STATUS = '1' and BELONG_TO = '1' order by m03601_key ";
            db.ExcuteDataTable(dt_m03601, sql, CommandType.Text);
        }
        http_url = GetIndexUrl();
    }
    protected void ListView1_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
    {
        DataPager1.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
        BindData();
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

        // string a03601_key = dt_a03601.Rows[0]["a03601_key"].ToString();
        string sql, sqlstr, wheretj = "", orderbystr = "";
        string conditon = m036_key + "|" + m03601_key + "|" + a0360101_key;
        sqlstr = "select * from M00203_LB02 t where pkg_m00203.m00203_serch('" + conditon + "',t.m00203_key) = 1";
        //if (m036_key != "")
        //{
        //    wheretj = "and m036_key = '" + m036_key + "'";
        //}
        //if (a0360101_key != "")
        //{
        //    wheretj = "and a0360101_key = '" + a0360101_key + "' ";
        //}
        //if (m036_key != "" && m03601_key != "")
        //{
        //    wheretj = "and m036_key = '" + m036_key + "'  and m03601_key = '" + m03601_key + "'";
        //}

        //if (m036_key != "" && m03601_key != "" && a0360101_key != "")
        //{
        //    wheretj = " and m036_key = '" + m036_key + "' and m03601_key = '" + m03601_key + "' and a0360101_key = '" + a0360101_key + "'";
        //}
        //if(a0360101_key != "" && a03601_key != "")
        //{
        //    wheretj = " and  a03601_key = '" + a03601_key + "' and a0360101_key = '" + a0360101_key + "'";
        //}
        //orderbystr = "order by m00203_key desc))) order by m00203_key desc";
        sql = sqlstr;
        //string sql = "select * from m00202_m036_A0360101_v01 where rowid in(select rid from (select rownum rn,rid from(select rowid rid,m00202_key from m00202_m036_A0360101_v01  where 1 = 1 order by m00202_key desc))) order by m00202_key desc";
        db.ExcuteDataTable(dt_m00203_m036, sql, CommandType.Text);
        this.ListView1.DataSource = dt_m00203_m036;
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