using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class ShowForm_MainForm :BasePage
{

    public DataTable dt_main = new DataTable();
    public DataTable dt_a00211 = new DataTable();
    public DataTable dt_a00212 = new DataTable();
    public DataTable dt_detail = new DataTable();
    public DataTable dt_a313 = new DataTable();
    public DataTable dt_temp = new DataTable();
    public string a002_key = "";
    public string ver  = "1";
    public string ISAVE = "0";
    public string A00201KEY = "";
    public string  PARENTROWID = "";
    public string status;
    public string key = "-1";
    public string option = "M";//当前显示的界面是新增修改还是浏览
    public string S_ID = "";//取主键序列 的 sql
    public string nodate = "0";
    public string ITREE = "1";
    public string Tab_Width = "0";
    public string showtab = "0";
    public string if_showall = "0";
    public string title_ = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        base.PageBase_Load(sender, e);
        dialog = Request.QueryString["dialog"] == null ? "0" : Request.QueryString["dialog"].ToString();//不需要日期控件
        
        key = Request.QueryString["KEY"] == null ? "" : Request.QueryString["KEY"].ToString();
        option = Request.QueryString["option"] == null ? "V" : Request.QueryString["option"].ToString();
        a002_key = Request.QueryString["A002KEY"] == null ? "-1" : Request.QueryString["A002KEY"].ToString();
        A00201KEY = Request.QueryString["A00201KEY"] == null ? "-1" : Request.QueryString["A00201KEY"].ToString();
        PARENTROWID = Request.QueryString["ROWID"] == null ? "-1" : Request.QueryString["ROWID"].ToString();
        nodate = Request.QueryString["nodate"] == null ? "0" : Request.QueryString["nodate"].ToString();//不需要日期控件
        ISAVE = Request.QueryString["ISAVE"] == null ? "0" : Request.QueryString["ISAVE"].ToString();//不需要日期控件
        ITREE = Request.QueryString["ITREE"] == null ? "1" : Request.QueryString["ITREE"].ToString();//不需要日期控件
        showtab = Request.QueryString["showtab"] == null ? "1" : Request.QueryString["showtab"].ToString();//不需要日期控件
        if_showall = Request.QueryString["showall"] == null ? "0" : Request.QueryString["showall"].ToString();//不需要日期控件
        //try
        //{
        //    A007_KEY = GlobeAtt.A007_KEY;
        //    A30001_KEY = GlobeAtt.A30001_KEY;
        //}
        //catch
        //{
        //    A007_KEY = "";
        //    A30001_KEY = "";
        //}

        //if (A007_KEY == "" && Request.Path.ToUpper().IndexOf("LOGIN.ASPX") < 0)
        //{
        //    Response.Write("<script>parent.parent.location.href='" + GlobeAtt.HTTP_URL + "\\login.aspx?code=0'</script>");
        //    return;
        //}

      
        dt_a002 = Fun.getDtBySql("Select t.* from A002 t where menu_id='" + a002_key + "'");
        if (key == "")
        {
            option = "I";
        }
        else
        {

            dt_a313 = Fun.getDtBySql("Select t.* from A313 t where t.a313_id='"+ a002_key +"' and t.a313_name='"+ key +"'");
            if (dt_a313.Rows.Count == 0)
            {
                string sql_ = "insert into A313(a313_id,a313_name, ver ,enter_date,enter_user)";
                sql_ += " Select '" + a002_key + "','" + key + "','1',sysdate,'" + GlobeAtt.A007_KEY + "' from dual";
                Fun.execSqlOnly(sql_);
                ver = "1";
            }
            else
            {
                ver = dt_a313.Rows[0]["ver"].ToString();
            }
        
        }
        if (option != "I")
        {
            dt_a00211 = Fun.getDtBySql("Select t.* from A00211 t where menu_id='" + a002_key + "' order by sort_by");
            if (ITREE == "1")
            {
                dt_a00212 = Fun.getDtBySql("Select t.* from A00212 t where menu_id='" + a002_key + "' and rownum <= 1");
            }
        }
        if (PARENTROWID == "-1")
        {
            if (A00201KEY == "-1")
            {
                dt_main = Fun.getDtBySql("Select t.* from A00201_V01 t where t.a00201_key='" + a002_key + "-0'");
            }
            else
            {
                dt_main = Fun.getDtBySql("Select t.* from A00201_V01 t where t.a00201_key='" + A00201KEY + "'  ");
            }

        }
        else
        {
            dt_main = Fun.getDtBySql("Select t.* from A00201_V01 t where t.a00201_key='" + A00201KEY + "'  ");
        }
        if (A00201KEY == "-1")
        {
            dt_detail = Fun.getDtBySql("Select t.* from A00201_V01 t where t.menu_id='" + a002_key + "' and line_no > 0  order by sort_by");
        }
        title_ = dt_main.Rows[0]["tab_original"].ToString();
    }

    protected void Page_Unload(object sender, EventArgs e)
    {
        Session["LINK_P_URL"] = "";
    }
}
