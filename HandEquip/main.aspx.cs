using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;

public partial class HandEquip_main : BasePage
{
    public DataTable dt_a002 = new DataTable();
    public DataTable dt_a00201 = new DataTable();
    public string menu_id = string.Empty;
    public string option = string.Empty;
    public string main_keyvalue = string.Empty;
    public string main_key = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        base.PageBase_Load(sender, e);

        menu_id = Request.QueryString["A002_ID"].ToString();
        option = Request.QueryString["OPTION"].ToString();
        if (option == "")
        {
            option = "I";
        }
        main_keyvalue = Request.QueryString["KEY"].ToString();
        dt_a002 = Fun.getDtBySql("Select * From A002 t Where T.MENU_ID = '" + menu_id + "'");
        main_key=dt_a002.Rows[0]["MIAN_KEY"].ToString();
        dt_a00201 = Fun.getDtBySql("Select * From a00201 t Where t.menu_id='" + menu_id + "' order by t.line_no");
    }
}