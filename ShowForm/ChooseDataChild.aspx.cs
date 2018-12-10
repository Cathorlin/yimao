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

public partial class ShowForm_ChooseDataChild :BasePage
{
    public string Bs_Choose_Sql = "";
    public string result_rows = "0";
    public string title = "选择";
    public string A00201KEY = "";
    public string col_exist = "";
    public DataTable dt_data = new DataTable();
    public DataTable dt_a013010101 = new DataTable();
    public string rowscount = "100";
    public int[] a01301_row =  new int[100];
    public string Bs_Choose_Sql_CON = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
        A00201KEY = Request.QueryString["A00201KEY"] == null ? "0" : Request.QueryString["A00201KEY"].ToString();
        result_rows = Request.QueryString["result_rows"] == null ? "" : Request.QueryString["result_rows"].ToString();
        col_exist = Request.QueryString["col_exist"] == null ? "" : Request.QueryString["col_exist"].ToString();
        rowscount = Request.QueryString["rowscount"] == null ? "100" : Request.QueryString["rowscount"].ToString();
       string  table_id = Request.QueryString["table_id"] == null ? "" : Request.QueryString["table_id"].ToString();
        try
        {
            Bs_Choose_Sql = Session["BS_CHOOSE_SQL"].ToString();
        }
        catch
        {
            Bs_Choose_Sql = "";
        }
        try
        {
            Bs_Choose_Sql_CON = Session["Bs_Choose_Sql_CON"].ToString();
        }
        catch
        {
            Bs_Choose_Sql_CON = "";
        }
        string condition = Bs_Choose_Sql_CON;
        int pos = condition.IndexOf("ORDER BY");
        string str_order = "";
        if (pos > 0)
        {
            str_order = condition.Substring(pos);
            condition = condition.Substring(0, pos - 1);

        }

        Bs_Choose_Sql = Bs_Choose_Sql + condition + " AND rownum < " + rowscount +  " " +str_order;
        dt_data = Fun.getDtBySql(Bs_Choose_Sql);
        if (A00201KEY.Length > 2)
        {
            string a_Sql="Select t.* from A10001 t where t.table_id='"+ table_id +"' and column_id in ("  ;
            for(int i = 0 ;i < dt_data.Columns.Count ;i++)
            { 
                string column_id =dt_data.Columns[i].ColumnName.ToUpper();
                a_Sql +=  "'" + column_id + "',";         
                    
            }
            a_Sql = a_Sql + "'')" ;
            dt_a013010101 = Fun.getDtBySql(a_Sql);
            for (int i = 0; i < dt_data.Columns.Count; i++)
            {
                string data_column_id = dt_data.Columns[i].ColumnName.ToUpper();
                a01301_row[i] = 0;
                for (int r = 0; r < dt_a013010101.Rows.Count; r++)
                {
                    string column_id = dt_a013010101.Rows[r]["column_id"].ToString();
                    if (column_id == data_column_id)
                    {

                        a01301_row[i] = r + 1;
                        break;
                    }
                }

            }


        }
       

    }
}
