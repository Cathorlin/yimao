using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class MainWinF : BasePage 
{
    public DataTable dt_child = new DataTable();
    public DataTable dt_child_child = new DataTable();
    public DataTable dt_menu = new DataTable();
    public DataTable dt_all = new DataTable();
    public DataTable menu_type = new DataTable();
    public string sql = "";
    public string menu_name = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        //获取用户名和用户名称
        base.PageBase_Load(sender, e);
        string menu_id = Request.QueryString["menu_id"] == null ? "" : Request.QueryString["menu_id"].ToString();
        menu_id = "00";
        menu_name = Request.QueryString["menu_name"] == null ? "主菜单" : Request.QueryString["menu_name"].ToString();
        sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where  active ='1' and pkg_a.getUserMenu(t.menu_id,'" + A007_KEY + "'," + A30001_KEY + ") = '1' order by  PARENT_ID ,sort_by,menu_id "; //order by  PARENT_ID ,sort_by,menu_id
        sql = "Select t.*, Pkg_Fun.Get_User_Menu_(t.Menu_Id, '" + GlobeAtt.A007_KEY + "') As Useable, pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name ";
        sql += " From A002_V01 t Where t.Active = '1' ";
        sql += " And Exists (Select 1  From A01301 a  Inner Join A00701 A1  On A1.A007_Id = '" + GlobeAtt.A007_KEY + "' And A1.A013_Id = a.A013_Id  ";
        sql += "    Where a.A002_Id = t.Menu_Id  And a.Rb_Do = 'Use'  And a.Useable = '1') order by  PARENT_ID ,sort_by,menu_id ";

        dt_all = Fun.getDtBySql(sql);

    }


   
}