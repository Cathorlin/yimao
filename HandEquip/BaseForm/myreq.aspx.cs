using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;

//public partial class HandEquip_BaseForm_myreq : BaseForm
//{
//    public DataTable dt_temp = new DataTable();
//    protected void Page_Load(object sender, EventArgs e)
//    {
//        base.PageBase_Load(sender, e);
//    }
//}

public partial class HandEquip_BaseForm_myreq : System.Web.UI.Page
{
    public DataTable dt_temp = new DataTable();
    public BaseFun Fun = new BaseFun();
    public string RequestXml = "";
    public DataTable dt_a00201 = new DataTable();
    public DataTable dt_a00210 = new DataTable();
    public string menu_id =string.Empty ;
    public string reqtype = string.Empty;
    public string A00201_Key = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Stream RequestStream = Request.InputStream;
        StreamReader RequestStreamReader = new StreamReader(RequestStream);
        RequestXml = RequestStreamReader.ReadToEnd();
        RequestStream.Close();
        reqtype = BaseFun.getAllHyperLinks(RequestXml, "<REQTYPE>", "</REQTYPE>")[0].Value;
        if (reqtype=="HEQ_SAVE")
        {
            menu_id = BaseFun.getAllHyperLinks(RequestXml, "<MENU_ID>", "</MENU_ID>")[0].Value;
            dt_a00201 = Fun.getDtBySql("select * from A00201_V01 t Where t.Menu_Id='" + menu_id + "'");
            dt_a00210 = Fun.getDtBySql("Select * From A00210 t Where t.menu_id='" + menu_id + "'");
        }
        if (reqtype == "HEQ_NEW")
        {
            menu_id = BaseFun.getAllHyperLinks(RequestXml, "<MENU_ID>", "</MENU_ID>")[0].Value;
            A00201_Key = BaseFun.getAllHyperLinks(RequestXml, "<A00201KEY>", "</A00201KEY>")[0].Value;
            dt_a00201 = Fun.getDtBySql("select * from A00201_V01 t Where t.A00201_Key='" + A00201_Key + "'");
        }
        
    }

    public string Get_Item_Value(string name, string source)
    {
        string result_ = "";
        int index = source.IndexOf(name + "|");
        if (index < 0)
        {
            result_ = "";
        }
        else
        {
            result_ = source.Substring(index + name.Length + 1);
            index = result_.IndexOf(GlobeAtt.DATA_INDEX);
            result_ = result_.Substring(0, index);
        }
        return result_;
    }
    public string Set_Item_Value(string name, string value, string source) {
        string result_ = "";
        int index = source.IndexOf(name + "|");
        if (index >= 0)
        {
            string sleft = source.Substring(0, index);
            string sright = source.Substring(source.Substring(index + name.Length + 1).IndexOf(GlobeAtt.DATA_INDEX) + 1);
            result_ = sleft + name + "|" + value + GlobeAtt.DATA_INDEX + sright;
        }
        else
        {
            result_ = source + name + "|" + value.ToString() + GlobeAtt.DATA_INDEX;
        }
        return result_;
    }

    public string Replace_Rowlist(string table_id,string rowlist) {
        string result_ = rowlist;
        DataTable dt = new DataTable();
        dt = Fun.getDtBySql("select t.*, t.rowid from A10001 t Where t.table_id='"+ table_id +"'");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            result_ = result_.Replace(GlobeAtt.DATA_INDEX + dt.Rows[i]["LINE_NO"].ToString() + "|", GlobeAtt.DATA_INDEX + dt.Rows[i]["COLUMN_ID"].ToString() + "|");
        }
        return result_;
    }
}