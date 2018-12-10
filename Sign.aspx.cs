using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
using Common;
public partial class Sign : System.Web.UI.Page
{
    Oracle dt = new Oracle();
    public string Card_no = string.Empty;
    public string classType = string.Empty;
    public string name = string.Empty;
    public string Validate = string.Empty;
    public string Card_Type = string.Empty;
    public string qty = string.Empty;
    public string Amount = string.Empty;
    public DataTable date = new DataTable();

    public int state = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


        }

    }
    protected void btn_Click(object sender, EventArgs e)
    {

        Card_no = EmpNo.Text.Trim();

        string sql = "SELECT * FROM (SELECT t.m001_name,t1.card_no,t.qty,t1.card_type,t.amount,t1.BILL_DATE  FROM  M00101_V02 T inner join M101_V01 t1 on t.M001_KEY=t1.M001_KEY where t.card_no='" + Card_no + "' or t.mobile_no='" + Card_no + "')";
        dt.ExcuteDataTable(date, sql, CommandType.Text);
       


        if (state == 0)
        {
            for (int i = 0; i < date.Rows.Count;i++ )
            {

            
                Card_no = date.Rows[i]["CARD_NO"].ToString();
                name = date.Rows[i]["M001_NAME"].ToString();
                Validate = date.Rows[i]["BILL_DATE"].ToString();
                Card_Type = date.Rows[i]["CARD_TYPE"].ToString();
                qty = date.Rows[i]["QTY"].ToString();
                this.btn.Text = "确定";
                this.state = 1;



            }
        }
        else  if  (state == 1)
        {

            this.btn.Text = "Select";
            this.state = 0;
        }

        else if (state == 0)
        {

            this.btn.Text = "xxxx";
            this.state = 1;
        }
        
    }
}