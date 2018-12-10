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


public partial class main :BasePage
{
    public int BS_TABS = 10;
    public int BS_MSG_TIME = 5;
    public int BS_MSG_SPEED = 10;
    public int BS_MSG_STEP = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
       
        BS_TABS =int.Parse( Fun.getA022Name("BS_TABS"));
        try
        {
            BS_MSG_TIME = int.Parse(Fun.getA022Name("BS_MSG_TIME"));
        }
        catch
        {
            BS_MSG_TIME = 5;
        }
        BS_MSG_TIME = BS_MSG_TIME  * 1000;
        try
        {
            BS_MSG_SPEED = int.Parse(Fun.getA022Name("BS_MSG_SPEED"));
        }
        catch
        {
            BS_MSG_SPEED = 10;
        }

        try
        {
            BS_MSG_STEP = int.Parse(Fun.getA022Name("BS_MSG_STEP"));
        }
        catch
        {
            BS_MSG_STEP = 1;
        }
       
      
    }

}
