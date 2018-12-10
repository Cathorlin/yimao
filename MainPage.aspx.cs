using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MainPage : BaseShowPage
{
    public DataTable dt = new DataTable();
    public int BS_MSG_TIME = 5;
    public int BS_MSG_SPEED = 10;
    public int BS_MSG_STEP = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        string sql = "Select t.* from A002_V01 t where  parent_id = '[PARENT_ID]'  and active ='1' and pkg_a.getUserMenu(t.menu_id,'" + GlobeAtt.A007_KEY + "'," + GlobeAtt.A30001_KEY + ") = '1' order by sort_by,menu_id";
        sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where  parent_id = '[PARENT_ID]'  and active ='1' and pkg_a.getUserMenu(t.menu_id,'" + GlobeAtt.A007_KEY + "'," + GlobeAtt.A30001_KEY + ") = '1' and READ_ONLY ='1' and rownum < 10 order by sort_by,menu_id";
        sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where  parent_id = '00'  and active ='1'  and rownum < 10 order by sort_by,menu_id";
        dt = Fun.getDtBySql(sql.Replace("[PARENT_ID]", "00"));

        try
        {
            BS_MSG_TIME = int.Parse(Fun.getA022Name("BS_MSG_TIME"));
        }
        catch
        {
            BS_MSG_TIME = 5;
        }
        BS_MSG_TIME = BS_MSG_TIME * 1000;
        try
        {
            BS_MSG_SPEED = int.Parse(Fun.getA022Name("BS_MSG_SPEED"));
        }
        catch
        {
            BS_MSG_SPEED = 10;
        }

        try
        {
            BS_MSG_STEP = int.Parse(Fun.getA022Name("BS_MSG_STEP"));
        }
        catch
        {
            BS_MSG_STEP = 1;
        }
    }
}