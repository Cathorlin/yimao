using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ShowForm_MainFormN : System.Web.UI.Page
{
    public string mainformurl = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        mainformurl = Request.Url.ToString().ToLower().Replace("mainformn.aspx", "mainform.aspx");

    }
}