using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class ShowForm_UserBi : BasePage
{
    public DataTable dt_a404 = new DataTable();
    public DataTable dt_a40401 = new DataTable();
    public string a404_id = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        a404_id = Request.QueryString["KEY"] == null ? "A000001" : Request.QueryString["KEY"].ToString();
        dt_a404 = Fun.getDtBySql("SELECT T.* from  A404_v01 t  where  a404_id='" + a404_id + "'");
      
        dt_a40401 = Fun.getDtBySql("SELECT T.* from  A40401_v01 t  where  a404_id='" + a404_id + "' order by t.col_group,t.line_no");
    }
}