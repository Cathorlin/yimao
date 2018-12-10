using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;

public partial class HandEquip_BaseForm_mainbutton : System.Web.UI.Page
{
    public DataTable dt_a00201 = new DataTable();
    public BaseFun Fun = new BaseFun();
    public string RequestXml = "";
    public string menu_id = string.Empty;
    public string f_save = "1";
    public string f_del = "1";
    public string pkg_name = string.Empty;
    public DataTable dt_btn = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Stream RequestStream = Request.InputStream;
        StreamReader RequestStreamReader = new StreamReader(RequestStream);
        RequestXml = RequestStreamReader.ReadToEnd();
        RequestStream.Close();

        menu_id = BaseFun.getAllHyperLinks(RequestXml, "<MENU_ID>", "</MENU_ID>")[0].Value;
        dt_a00201 = Fun.getDtBySql("Select * From A00201_V01 t Where t.menu_id='" + menu_id + "' order by t.line_no");
        pkg_name=dt_a00201.Rows[0]["PKG_NAME"].ToString();
        if (pkg_name != "")
        {
            dt_btn = Fun.getDtBySql("select " + pkg_name + ".Checkbutton__('BTN_SAVE','','" + GlobeAtt.A007_KEY + "') as save," + pkg_name + ".Checkbutton__('BTN_DEL','','" + GlobeAtt.A007_KEY + "') as del from dual");
            if (dt_btn.Rows.Count > 0)
            {
                f_save = dt_btn.Rows[0]["save"].ToString();
                f_del = dt_btn.Rows[0]["del"].ToString();
            }

        }
        
    }
}