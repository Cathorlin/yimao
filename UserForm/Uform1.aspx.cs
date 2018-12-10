using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class UserForm_Uform1 : BasePage
{
    public string formid = ""; //展示的formid
    public DataTable dt_form = new DataTable();
    public DataTable dt_div = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        formid = Request.QueryString["formid"] == null ? "0" : Request.QueryString["formid"].ToString();
        dt_form = Fun.getDtBySql("Select t.* from  BL_FORM_CONFIG t where  t.form_id='" + formid + "'");
        dt_div = Fun.getDtBySql("Select t.* from  BL_FORM_CONFIG_DETAIL t where  t.form_id='" + formid + "' Order By t.sort_by ");
    }
}