using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;

public partial class HandEquip_iframe_mainiframe : System.Web.UI.Page
{
    public DataTable dt_menudtl = new DataTable();
    public DataTable dt_a10001 = new DataTable();
    public DataTable dt_temp = new DataTable();
    public string menu_id = string.Empty;
    public string line_no = string.Empty;
    public DataTable dt_a00201 = new DataTable();
    public DataTable dt_a002 = new DataTable();
    public string RequestXml = "";
    public BaseFun Fun = new BaseFun();
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Stream RequestStream = Request.InputStream;
        StreamReader RequestStreamReader = new StreamReader(RequestStream);
        RequestXml = RequestStreamReader.ReadToEnd();
        RequestStream.Close();

        menu_id = BaseFun.getAllHyperLinks(RequestXml, "<MENU_ID>", "</MENU_ID>")[0].Value;
        line_no = BaseFun.getAllHyperLinks(RequestXml, "<LINE_NO>", "</LINE_NO>")[0].Value;
        string key = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
        dt_a002 = Fun.getDtBySql("Select t.* From a002 t Where t.menu_id='" + menu_id + "'");
        dt_a00201 = Fun.getDtBySql("Select t.* From a00201 t Where t.menu_id='"+ menu_id +"' And t.line_no='"+ line_no +"'");
        dt_a10001 = Fun.getDtBySql("select * from a10001 where table_id='" + dt_a00201.Rows[0]["TABLE_ID"].ToString() + "' Order By COL_X");        
        dt_temp = Fun.getDtBySql("select * from " + dt_a00201.Rows[0]["TABLE_ID"].ToString() + " t where t." + dt_a002.Rows[0]["MIAN_KEY"].ToString() + "='" + key + "' " + dt_a00201.Rows[0]["SORT_COL"].ToString());
    }
}