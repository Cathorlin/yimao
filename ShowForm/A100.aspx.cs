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

public partial class ShowForm_A100 : BasePage
{

    public DataTable dt_a013 = new DataTable();
    public string A002ID = ""; //要编辑的菜单编码
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);        
        A002ID = Request.QueryString["A002ID"] == null ? "" : Request.QueryString["A002ID"].ToString();
        dt_a013 = Fun.getDtBySql("Select t.* from A00201_v01 t where menu_id='" + A002ID + "' order by A00201_key  ");
    }





}
