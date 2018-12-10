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
public partial class BaseForm_MainRbutton : BaseForm
{
    string main_key_value = string.Empty;
    string option = string.Empty;
    string status = string.Empty;
    public string req_url = string.Empty;
    public string objid = "";
    public DataTable dt_rb = new DataTable();
    public DataTable dt_print = new DataTable();

    public string selectrowlist = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
        /*根据状态和数据获取主档的操作按钮*/
        dt_rb = Fun.getdtByJson(Fun.getJson(json, "P5"));
        try
        {
            dt_print = Fun.getdtByJson(Fun.getJson(json, "P8"));
        }
        catch
        { 
            
        }
        req_url = BaseFun.getAllHyperLinks(RequestXml, "<URL>", "</URL>")[0].Value;
        objid = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
        selectrowlist = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
    }


       
    public string  getRbUseable(string a014_id)
    {
        DataTable dt_user = new DataTable();
        try
        {
            string sql = "Select f_Check_A014_Use('" + a00201_key + "','" + a014_id + "','" + objid + "', '[USER_ID]')  as c from dual";
        
            dt_user = Fun.getDtBySql(sql);
            return dt_user.Rows[0][0].ToString();
        }
        catch
        {
            return "0";
        }
        finally
        {
            dt_user.Dispose();
        }
    }
}