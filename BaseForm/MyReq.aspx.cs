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
using System.Text.RegularExpressions;
public partial class BaseForm_MyReq  : BaseForm
{
    string main_key_value = string.Empty;
    string objid = string.Empty;
    string req_url = string.Empty;
    string req_id = string.Empty;
    public DataTable dt_rb = new DataTable();
    public DataTable dt_print = new DataTable();
    public DataTable dt_c = new DataTable();
    public DataTable dt_u = new DataTable();
    public DataTable dt_temp0 = new DataTable();
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
        
    }
    public string Get_Query_Sql(string a00201_key_, Boolean if_detail)
    {
        try
        {
            string sql_ = "select select_Sql,MAINKEY from a00601 t where t.user_id='" + GlobeAtt.A007_KEY + "' and a00201_key='" + a00201_key_ + "'";
            if (if_detail == true)
            {
                sql_ = "select q_Sql as select_Sql,MAINKEY from a00601 t where t.user_id='" + GlobeAtt.A007_KEY + "' and a00201_key='" + a00201_key_ + "'";

            }
            else
            {
                sql_ = "select m_Sql as select_Sql,MAINKEY from a00601 t where t.user_id='" + GlobeAtt.A007_KEY + "' and a00201_key='" + a00201_key_ + "'";

            }
            DataTable dt_sql = new DataTable();
            dt_sql = Fun.getDtBySql(sql_);
            sql_ = dt_sql.Rows[0][0].ToString();
            if (if_detail == true)
            {
                return sql_;
            }            
            string MAINKEY = dt_sql.Rows[0][1].ToString();
            if (MAINKEY != null && MAINKEY != "" && MAINKEY.Length > 0)
            {
                sql_ = sql_.Replace("'" + MAINKEY + "'", "'[MAINKEY]'");
            }
            return sql_;
        }
        catch
        {
            try
            {
                return Session["QUERY" + a00201_key].ToString();
            }
            catch
            {
                return "";
            }
        }
    }
}