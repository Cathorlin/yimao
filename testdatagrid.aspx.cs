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
using Base;

public partial class testdatagrid : System.Web.UI.Page
{
    BaseFun fun = new BaseFun();
     public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        
        dt = fun.getDtBySql("Select t.* from a002 t ");
        this.GridView1.DataSource = dt;
        this.GridView1.DataBind();
        
    }
    protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
    {

        Response.Write("1111");
    }
}
