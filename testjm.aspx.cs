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

public partial class testjm : System.Web.UI.Page
{
    public string t;
    protected void Page_Load(object sender, EventArgs e)
    {
        t = DES.DESEncrypt("12345", "12345678");

    }
}
