using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
using Common;
public partial class Class_Record : System.Web.UI.Page
{
    Oracle dt = new Oracle();
    public string Card_no = string.Empty;
    public string QTY = string.Empty;
    public string Validate = string.Empty;
    public string Card_Type = string.Empty;
    public string Amount = string.Empty;
    public string m009_key = string.Empty;
    public string num = string.Empty;
    public string used = string.Empty;
    public string balance = string.Empty;
    public string beg_date = string.Empty;
    public string end_date = string.Empty;
    public DataTable date = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


        }
    }

   
    protected void  btn_Click(object sender, EventArgs e)
    {
        Card_no = EmpNo.Text.Trim();

     
        string sql = "SELECT  t.card_no,t.card_type,t.BILL_DATE,t.QTY,t1.M009_KEY,t1.QTY as num,t1.used,t1.balance,t1.VALID_BEG,t1.VALID_END from M00101_V01 t1  inner join M101_V01 t on t.M001_KEY=t1.M001_KEY where t.card_no='" + Card_no + "'order by t.bill_date desc";
        dt.ExcuteDataTable(date, sql, CommandType.Text);
        for (int i = 0; i < date.Rows.Count;i++ )
        {

            
            Card_no = date.Rows[i]["CARD_NO"].ToString();
            QTY = date.Rows[i]["QTY"].ToString();
            Validate = DateTime.Parse( date.Rows[i]["BILL_DATE"].ToString()).ToString("yyyy/MM/dd");
            Card_Type = date.Rows[i]["CARD_TYPE"].ToString();

            num = date.Rows[i]["NUM"].ToString();
            used = date.Rows[i]["USED"].ToString();
            balance = date.Rows[i]["BALANCE"].ToString();
            beg_date = date.Rows[i]["VALID_BEG"].ToString();
            end_date = date.Rows[i]["VALID_END"].ToString();


        }
     }
    
}