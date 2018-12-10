using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Data;

public partial class HandEquip_BaseForm_choose : System.Web.UI.Page
{
    public BaseFun Fun = new BaseFun();
    public string RequestXml = "";

    public string menu_id = string.Empty;
    public string line_no = string.Empty;
    public string col_line_no = string.Empty;
    public string rowlist = string.Empty;
    public string mainrowlist = string.Empty;
    public string colid = string.Empty;

    public DataTable dt_A00201 = new DataTable();
    public DataTable dt_A10001 = new DataTable();
    public DataTable dt_choose = new DataTable();
    public DataTable dt_table_select = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Stream RequestStream = Request.InputStream;
        StreamReader RequestStreamReader = new StreamReader(RequestStream);
        RequestXml = RequestStreamReader.ReadToEnd();
        RequestStream.Close();
        menu_id = BaseFun.getAllHyperLinks(RequestXml, "<MENU_ID>", "</MENU_ID>")[0].Value;
        line_no = BaseFun.getAllHyperLinks(RequestXml, "<LINE_NO>", "</LINE_NO>")[0].Value;
        col_line_no = BaseFun.getAllHyperLinks(RequestXml, "<COL_LINE_NO>", "</COL_LINE_NO>")[0].Value;
        rowlist = BaseFun.getAllHyperLinks(RequestXml, "<ROWLIST>", "</ROWLIST>")[0].Value;
        mainrowlist = BaseFun.getAllHyperLinks(RequestXml, "<MAINROWLIST>", "</MAINROWLIST>")[0].Value;
        colid = BaseFun.getAllHyperLinks(RequestXml, "<COLID>", "</COLID>")[0].Value;

        dt_A00201 = Fun.getDtBySql("select * from A00201_V01 t Where t.Menu_Id='"+ menu_id +"' And t.Line_No=" + line_no);
        dt_A10001 = Fun.getDtBySql("Select * From a10001 t Where t.table_id='"+ dt_A00201.Rows[0]["TABLE_ID"].ToString() +"'");
        
    }

    public string Get_Item_Value(string name_, string Attr_) {
        string result = string.Empty;
        string data_index = GlobeAtt.DATA_INDEX;
        int index = Attr_.IndexOf(data_index + name_ + "|");
        if (index>=0)
        {
            string str1 = Attr_.Substring(index +1);
            index = str1.IndexOf(data_index);
            if (index>=0)
            {
                int a = str1.IndexOf("|");
                result = str1.Substring(str1.IndexOf("|") + 1, index-a-1);
            }
        }
        return result;
    }
}