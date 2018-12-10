using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
using Common;
public partial class Employee : System.Web.UI.Page
{
    public Oracle dt = new Oracle();
    public string name = string.Empty;
    public string mobile_no = string.Empty;
    public string sex = string.Empty;
    public string time1 = string.Empty;
    public string EmpId = string.Empty;
    public string Card_no = string.Empty;
    public DataTable date = new DataTable();
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
        }
    }


    protected void btn_Click(object sender, EventArgs e)
    {
      
        string id = EmpNo.Text.Trim();
        string i = iphone.Text.Trim();

        if (id == "" || id== null)
        {

            MessageBox.ShowAndBack("会员编号不能为空！！！");
            return;
        }
        if (i =="" || i == null)
        {

            MessageBox.ShowAndBack("手机号不能为空！！！");
            return;
        }
        string sql = "select * from M001_V01 t where t.m001_id='" + id + "' and t.mobile_no='" + i + "'";
        dt.ExcuteDataTable(date, sql, CommandType.Text);
        if (date.Rows.Count >0)
        {
            EmpNo.Text = date.Rows[0]["M001_ID"].ToString();
            iphone.Text = date.Rows[0]["MOBILE_NO"].ToString();
            EmpId = date.Rows[0]["M001_ID"].ToString();
            name= date.Rows[0]["M001_NAME"].ToString();
            time1 = date.Rows[0]["BIRTHDAY"].ToString();  
            mobile_no=date.Rows[0]["MOBILE_NO"].ToString();
            sex = date.Rows[0]["SEX"].ToString();
            Card_no = date.Rows[0]["CARD_NO"].ToString();
            
        
        }
      

       
    }
}