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

public partial class jump : BasePage
{
    public string url;
    public string menu_name;
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);            
        string user_id = "";
        string menu_id = Request.QueryString["menu_id"] == null ? "" : Request.QueryString["menu_id"].ToString();
        string key = Request.QueryString["key"] == null ? "-1" : Request.QueryString["key"].ToString();

        /*初始化菜单的Session*/
        DataTable dt_a002 = new DataTable();
       
        string sql = "Select t.* from A002_V01 t where a002_key = '" + menu_id + "'";
        sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where a002_key = '" + menu_id + "'";
 
        dt_a002 = Fun.getDtBySql(sql);

        Session["JUMP_A002"] = Fun.setPkgStr(dt_a002);
        Session["JUMP_A002_KEY"] = dt_a002.Rows[0]["A002_KEY"].ToString();
        Session["IF_JUMP"] = "1";
        menu_name = dt_a002.Rows[0]["show_name"].ToString();
        url = dt_a002.Rows[0]["BS_URL"].ToString();
        //判断url格式
        if (url.IndexOf("FUN_") == 0)
        {
            DataTable dt_fun = new DataTable();
            string sql_ = url.Substring(4).Replace("[USER_ID]", GlobeAtt.A007_KEY);
            sql_ = sql_.Replace("&", "'|| '&' ||'");
            sql_ = "SELECT " + sql_ + " as url  from dual ";
            dt_fun = Fun.getDtBySql(sql_);
            if (dt_fun.Rows.Count > 0)
            {
                url = dt_fun.Rows[0][0].ToString();
            }
          
        }

        if (key == "-1" && url.IndexOf("&key=") > 0)
        {
            int pos = url.IndexOf("&key=");
            string right = url.Substring(pos + 1);
            if (right.IndexOf("&") < 0)
            {
                key = right.Substring(4);
            }
            else
            {
                key = right.Substring(4, right.IndexOf("&") - 4);
            }
            
        }
        Session["JUMP_KEY"] = key;
        if (url.IndexOf("?") > 0)
        {
            url = url + "&JUMP_A002_KEY=" + dt_a002.Rows[0]["A002_KEY"].ToString() + "&IF_JUMP=1&JUMP_KEY=" + key;
        }
        else
        {
            url = url + "?JUMP_A002_KEY=" + dt_a002.Rows[0]["A002_KEY"].ToString() + "&IF_JUMP=1&JUMP_KEY=" + key;
        }
        url = url.Replace("[USER_ID]", GlobeAtt.A007_KEY);

        Random seedRnd = new Random();

        int asciiCode = seedRnd.Next(0, 10202);
        url = url + "&rcode=" + asciiCode.ToString();
        url = url.Replace("MainFrom.aspx", "mainfromn.aspx");
        url = url.Replace("Mainfrom.aspx", "mainfromn.aspx");
        url = url.Replace("mainfrom.aspx", "mainfromn.aspx");
        url = url.Replace("MAINFORM.aspx", "mainfromn.aspx");
        url = url.Replace("MAINFORM.Aspx", "mainfromn.aspx");
        if (url.Length > 5)
        {
            if (url.ToLower().IndexOf("menu_id=") > 0)
            {
                Response.Write("<script> location.href = \"" + url + "\"</script>");

            }
            else
            {
                Response.Write("<script> location.href = \"" + url + "&menu_id=" + menu_id + "\"</script>");
            }
        }
    }
}
