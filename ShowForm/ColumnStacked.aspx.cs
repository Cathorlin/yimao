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

public partial class ShowForm_ColumnStacked : BasePage
{
    public DataTable dt_x = new DataTable();//显示的X坐标 表示有多少列
    public DataTable dt_y = new DataTable(); //显示的Y坐标 
    public DataTable dt_data = new DataTable();
    public DataTable dt_a061 = new DataTable();
    public DataTable dt_title = new DataTable(); 
    public string  title = string.Empty;
    public string A061_ID = string.Empty;
    public string KEY = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        A061_ID = Request.QueryString["A061ID"] == null ? "1" : Request.QueryString["A061ID"].ToString();
        KEY = Request.QueryString["KEY"] == null ? "0" : Request.QueryString["KEY"].ToString();
        dt_a061 = Fun.getDtBySql("Select t.* from A061 t where t.a061_id='" + A061_ID + "'");
    }
}