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

public partial class ShowForm_ChooseData :BasePage
{

    public string Bs_Choose_Sql = "";
    public string result_rows = "0";
    public string title = "选择";
    public string table_id = "";
    public DataTable dt_a00201 = new DataTable();
    public  int conrow = 1;
    public string A00201KEY = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
        table_id = Request.QueryString["table_id"] == null ? "" : Request.QueryString["table_id"].ToString();
        title = Request.QueryString["title"] == null ? "" : Request.QueryString["title"].ToString();
        string sql ="Select t.* from A00201_V01  t where t.table_id='"+table_id +"'";
        dt_a00201 =  Fun.getDtBySql(sql);
        if (dt_a00201.Rows.Count > 0)
        {
            A00201KEY = dt_a00201.Rows[0]["A00201_KEY"].ToString();
        }
        Session["Bs_Choose_Sql_CON"] = "";
        string BS_CHOOSE_SQL = "";
        try
        {
            BS_CHOOSE_SQL = Session["BS_CHOOSE_SQL"].ToString();
            BS_CHOOSE_SQL = BS_CHOOSE_SQL + " AND  1=2";

            DataTable dt_choose = new DataTable();
            string choosecolumn = "";
            dt_choose = Fun.getDtBySql(BS_CHOOSE_SQL);
            for (int i = 0; i < dt_choose.Columns.Count; i++)
            {
                choosecolumn += "[" + dt_choose.Columns[i].ColumnName + "]";
                conrow = conrow + 1;
            }
            Session["choosecolumn"] = choosecolumn;
        }
        catch
        {
            BS_CHOOSE_SQL = "";
        }
    }
}
