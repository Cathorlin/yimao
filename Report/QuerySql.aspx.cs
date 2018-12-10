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

public partial class Report_QuerySql : BasePage
{

    public DataTable dt_data = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {

        base.PageBase_Load(sender, e);
     
        dt_data = Fun.getDtBySql("Select t.* from a002 t ");
        GridView1.DataSource = dt_data;
        this.GridView1.DataBind();

    }
}
