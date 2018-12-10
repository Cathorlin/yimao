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

public partial class BaseForm_MainButton : BaseForm
{
    public string main_key_value = string.Empty;
    public string option = string.Empty;
    public string status = string.Empty;
    public DataTable dt_a00204 = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            base.PageBase_Load(sender, e);
            /*根据状态和数据获取主档的操作按钮*/
            //BaseFun Fun = new BaseFun();
            main_key_value = Request.QueryString["KEY"] == null ? "-1" : Request.QueryString["KEY"].ToString();
            option = Request.QueryString["option"] == null ? "V" : Request.QueryString["option"].ToString();
            string status = "0";
            string sql_ = "Select pkg_show.geta00204('" + a00201_key + "','" + main_key_value + "','" + GlobeAtt.A007_KEY + "','0','" + option + "','" + status + "') as c  from dual ";
            dt_a00204 = Fun.getDtBySql(sql_);
            //读取表的右键功能     
        }
        catch (Exception ex)
        {
            Response.Write("ERROR URL");
        }
    }
}