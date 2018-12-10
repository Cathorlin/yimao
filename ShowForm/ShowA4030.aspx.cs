using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class ShowForm_ShowA4030 : BasePage
{
    public DataTable dt_a403 = new DataTable();
    public DataTable dt_a40301 = new DataTable();
    public string a403_id = string.Empty;
    public string if_edit = string.Empty;//编辑
    protected void Page_Load(object sender, EventArgs e)
    {
        a403_id = Request.QueryString["KEY"] == null ? "1" : Request.QueryString["KEY"].ToString();
        if_edit = Request.QueryString["IFEDIT"] == null ? "0" : Request.QueryString["IFEDIT"].ToString();
        dt_a403 = Fun.getDtBySql("SELECT T.* from  A403_v01 t  where  a403_id='" + a403_id + "'");
        //如果不是未维护的状态 不能编辑
        if (dt_a403.Rows[0]["state"].ToString() != "0")
        {
            if_edit = "0";
        }
        dt_a40301 = Fun.getDtBySql("SELECT T.* from  A40301_v01 t  where  a403_id='" + a403_id + "' order by t.line_no");
    }
}