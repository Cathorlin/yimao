using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ShowForm_ShowDialog : BasePage
{
    public string url = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        url = Request.QueryString["url"] == null ? "" : Request.QueryString["url"].ToString();
        url = HttpUtility.UrlDecode(url);
    }
}