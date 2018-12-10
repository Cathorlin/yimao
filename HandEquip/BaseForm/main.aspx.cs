using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;

public partial class HandEquip_BaseForm_main : System.Web.UI.Page
{
    public DataTable dt_A002 = new DataTable();
    public DataTable dt_A100 = new DataTable();
    public DataTable dt_A10001 = new DataTable();
    public DataTable dt_data = new DataTable();
    public BaseFun Fun = new BaseFun();
    public string RequestXml = "";

    public string menu_id = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Stream RequestStream = Request.InputStream;
        StreamReader RequestStreamReader = new StreamReader(RequestStream);
        RequestXml = RequestStreamReader.ReadToEnd();
        RequestStream.Close();

        menu_id = BaseFun.getAllHyperLinks(RequestXml, "<MENU_ID>", "</MENU_ID>")[0].Value;
        dt_A002 = Fun.getDtBySql("Select * From A002 t Where T.MENU_ID = '" + menu_id + "'");
        
    }
}