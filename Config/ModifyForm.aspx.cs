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

public partial class Config_ModifyForm :BasePage
{
    BaseFun Fun = new BaseFun();
    public DataTable dt_a10001 = new DataTable();
    public DataTable dt_data = new DataTable();
    public string a00201_key = "";
    public string table_id___ = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
        a00201_key = Request.QueryString["A00201KEY"] == null ? "-1" : Request.QueryString["A00201KEY"].ToString();

        dt_a10001 = Fun.getA013010101(a00201_key);
        if (dt_a10001.Rows.Count > 0)
        {
            table_id___ = dt_a10001.Rows[0]["table_id"].ToString();
        
        }
        dt_data = Fun.getDtBySql(Fun.getShowDataSql(a00201_key) + "  and rownum <  4 ");
   

    }
}
