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

public partial class top : BasePage
{
    public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
       
      base.PageBase_Load(sender, e);
      string   sql = "Select t.* from A002_V01 t where  parent_id = '[PARENT_ID]'  and active ='1' and pkg_a.getUserMenu(t.menu_id,'" + A007_KEY + "'," + A30001_KEY + ") = '1' order by sort_by,menu_id";
      sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where  parent_id = '[PARENT_ID]'  and active ='1' and pkg_a.getUserMenu(t.menu_id,'" + A007_KEY + "'," + A30001_KEY + ") = '1' and READ_ONLY ='1' and rownum < 10 order by sort_by,menu_id";
  
      dt = Fun.getDtBySql(sql.Replace("[PARENT_ID]", "00"));
    
    }
}
