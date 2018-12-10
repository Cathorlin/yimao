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
using System.Text;
public partial class BaseForm_Head : BaseForm
{

    BaseFun fun = new BaseFun();
    public DataTable dt_data = new DataTable();
    public string if_showrow = string.Empty;
    public string PARENTROWID = string.Empty;
    public string main_key_value = string.Empty;
    public string option = string.Empty;
    public string IFSHOW = string.Empty;
    public string rowlist = string.Empty;
    public string ROWID = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
        try
        {
            IFSHOW = BaseFun.getAllHyperLinks(RequestXml, "<IFSHOW>", "</IFSHOW>")[0].Value;
            ROWID = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
            ROWID = ROWID.Replace(a00201_key+"_","");
        }
        catch
        {
            IFSHOW = "0";
            ROWID = "0";
        }
        try
        {
            main_key_value = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
            if (IFSHOW == "1")
            {
                rowlist = main_key_value;
                main_key_value = "";
            }
            option = BaseFun.getAllHyperLinks(RequestXml, "<OPTION>", "</OPTION>")[0].Value;
            /*新增*/
            string data_sql = "";
           
            if (option == "I")
            {
                data_sql = showdatasql + " AND 1=2";
            }
            else
            {
                string nullhead = "0";
                try
                {
                    nullhead = dt_a00201.Rows[0]["nullhead"].ToString();
                }
                catch
                {
                    nullhead = "0";
                }
                if (nullhead != "1")
                {
                    if (dt_a00201.Rows[0]["MAIN_KEY"].ToString() != "")
                    {
                        data_sql = showdatasql + " AND " + dt_a00201.Rows[0]["MAIN_KEY"].ToString() + "='" + main_key_value + "'";
                    }
                    else
                    {
                        data_sql = showdatasql + " AND " + dt_a00201.Rows[0]["TABLE_KEY"].ToString() + "='" + main_key_value + "'";
                    }
                }
                else
                {
                    data_sql = showdatasql;
                }
               
                //判断用户有没有菜单的权限


                string show_condition = dt_a00201.Rows[0]["SHOW_CONDITION"].ToString();
                if (show_condition == null)
                {
                    show_condition = "";
                }
                if (show_condition.Length > 1)
                {
                    show_condition = show_condition.Replace("[MAIN_KEY]", main_key_value);
                    if (show_condition.Trim().ToLower().IndexOf("and") != 0)
                    {
                        show_condition = " AND " + show_condition;
                    }
                    data_sql = data_sql + show_condition;
                }


            }
          
            if (IFSHOW == "1")
            {
                data_sql = data_sql + " AND 1=2";
            }
            /*把查询的写日志记录到A00601中*/
            if (GlobeAtt.BS_LOG_SELECTSQL == "1")
            {
                string log_sql = "pkg_a.saveQuerySql('" + GlobeAtt.A007_KEY + "', '" + a00201_key + "' , '" + data_sql.Replace("'", "''") + "','" + main_key_value + "' ) ";

               // Fun.execSqlOnly(log_sql);
                try
                {
                    Fun.saveQuerySql(a00201_key, data_sql,main_key_value, option);
                }
                catch
                {

                }
            }
            Session["QUERY" + a00201_key] = data_sql;  
            dt_data = Fun.getDtBySql(data_sql);
            if (dt_data.Rows.Count == 0)
            {
                DataRow dr = dt_data.NewRow();
                dt_data.Rows.Add(dr);
            }
        }
        catch(Exception ex)
        {
            Response.Write("ERROR URL");
        }

    
    }
}
