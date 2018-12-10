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
using System.Data.OracleClient;

public partial class login :BasePage
{
    public DataTable dt_temp = new DataTable();
    public BaseFun fun = new BaseFun();
    protected void Page_Load(object sender, EventArgs e)
    {
        string linkcode = Request.QueryString["linkcode"] == null ? "" : Request.QueryString["linkcode"].ToString();
        string LINK_P_URL = "";
        string LINK_A306 = "";
        string LINK_A007_ID = "";
        string LANGUAGE_ID = GlobeAtt.LANGUAGE_ID ;
        try
        {
             LINK_P_URL = Session["LINK_P_URL"].ToString();
             LINK_A306 = Session["LINK_A306"].ToString();
             LINK_A007_ID = Session["LINK_A007_ID"].ToString();
        }
        catch
        {
            LINK_P_URL = "";
            LINK_A306 = "";
            LINK_A007_ID = "";
        }
        base.PageBase_Load(sender, e);
        
        Session.Clear();
        string title = Fun.getA022Name("BS_TITLE");
        Session["LANGUAGE_ID"] = LANGUAGE_ID;

        Session["TITLE"] = title;

        Session["LINK_P_URL"] = LINK_P_URL;
        Session["LINK_A306"] =  LINK_A306 ;
        Session["LINK_A007_ID"] = LINK_A007_ID;
    }
   
}
