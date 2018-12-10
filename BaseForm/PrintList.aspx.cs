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

public partial class BaseForm_PrintList : BaseForm
{
    string main_key_value = string.Empty;
    string req_url = string.Empty;
    string objid = string.Empty;
    public DataTable dt_rb = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
        /*根据状态和数据获取主档的操作按钮*/
        dt_rb = Fun.getdtByJson(Fun.getJson(json, "P5"));
        req_url = BaseFun.getAllHyperLinks(RequestXml, "<URL>", "</URL>")[0].Value;
        objid = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
    }
}