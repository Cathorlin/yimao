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

public partial class ShowForm_QueryData : BasePage
{
    public string a002_key = "";
    public string key = "";
    public string IF_JUMP = "1";
    public string option = "";
    public DataTable dt_main = new DataTable();
    public string table_id_ = "";
    public string query_id = "";
    public string showchild = "";
    public DataTable dt_detail = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        try
        {
            // str_a002 = Session["JUMP_A002"].ToString();
            key = Session["JUMP_KEY"].ToString(); //菜单的跳转KEY 
            a002_key = Session["JUMP_A002_KEY"].ToString();
        }
        catch
        {
            key = "-1";
            a002_key = "-1";
        }
        try
        {
            IF_JUMP = Session["IF_JUMP"].ToString();
        }
        catch
        {
            IF_JUMP = "1";
        }
        key = Request.QueryString["JUMP_KEY"] == null ? "-1" : Request.QueryString["JUMP_KEY"].ToString();
        a002_key = Request.QueryString["JUMP_A002_KEY"] == null ? "-1" : Request.QueryString["JUMP_A002_KEY"].ToString();
        IF_JUMP = Request.QueryString["IF_JUMP"] == null ? "1" : Request.QueryString["IF_JUMP"].ToString();
        string QUERY = Request.QueryString["QUERY"] == null ? "0" : Request.QueryString["QUERY"].ToString();
        dt_main = Fun.getDtBySql("Select t.* from A002_v01 t where a002_key='" + a002_key + "'");

         showchild = GlobeAtt.GetValue("SHOWCHILD_" + a002_key);
          if (showchild == "")
          {
              Session["SHOWCHILD_" + a002_key] = "0";
              showchild = "0";
          }
          string if_showdetail = "1";
          try
          {
              if_showdetail = dt_main.Rows[0]["if_showdetail"].ToString();
          }
          catch
          {
              if_showdetail = "0";
          }
          if (if_showdetail == "1")
          {
              dt_detail = Fun.getDtBySql("Select t.* from A00201_V01 t where t.menu_id='" + dt_main.Rows[0]["MENU_ID"].ToString() + "' and line_no > 0  order by control_id");
          }
          else
          {
              dt_detail = Fun.getDtBySql("Select t.* from A00201_V01 t where t.menu_id='" + dt_main.Rows[0]["MENU_ID"].ToString() + "' and line_no > 0  and 1=2 order by control_id");
 
          }
        query_id = "";
        if (QUERY == "0")
        {
            DataTable dt_a006 = new DataTable();
            string a006_sql = "Select query_id  from A006 t  where user_id='" + GlobeAtt.A007_KEY + "' AND a00201_key ='" + a002_key + "' and DEF_FLAG ='1' and rownum = 1";

            dt_a006 = Fun.getDtBySql(a006_sql);
            if (dt_a006.Rows.Count > 0)
            {
                query_id = dt_a006.Rows[0][0].ToString();
            }
            else
            {
                query_id = "";
            }
        }
        else
        {
            query_id = "最近的查询";
        }
        
   
    }
}
