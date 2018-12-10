using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Base;
using Common;
using System.Data.OracleClient;

public partial class Prepaid : System.Web.UI.Page
{
    protected bool ispost = DNTRequest.IsPost();
    private Oracle db = new Oracle();
    public DataTable dt_m001 = new DataTable();
    public DataTable dt_m00203 = new DataTable();
    public DataTable dt_a007 = new DataTable();
    public string user_id = string.Empty;
    public string m002_key = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        var action = DNTRequest.GetString("action");
        user_id = DNTRequest.GetString("USER_ID");
        if (action == "")
        {//默认第一次进入
           
        }
        else if (action == "query")
        {

            Query();
        }       
        else if (action == "chongzhi")
        {
            Chongzhi();
        }
    }

    private void Query()
    {
        var vip_id = txt_vip_id.Value;
        string sql = "select * from m001 where mobile_no='" + vip_id + "' or ucid='" + vip_id + "'";
        db.ExcuteDataTable(dt_m001, sql, CommandType.Text);
        if (dt_m001.Rows.Count == 0)
        {
            MessageBox.ShowAndBack("手机或卡号错误！");
            return;
        }
        else
        {
            vip_info.Value = dt_m001.Rows[0]["M001_NAME"].ToString();
            txt_m001_key.Value = dt_m001.Rows[0]["M001_KEY"].ToString();
        }
        string sql0 = "select * from a007 where a007_id='" + user_id + "'";
        db.ExcuteDataTable(dt_a007, sql0, CommandType.Text);
        if (dt_a007.Rows.Count != 0)
        {
            m002_key = dt_a007.Rows[0]["m002_key"].ToString();
        }
        string sql1 = "select * from m00203 where m002_key='" + m002_key + "' or '"+user_id+"'='WTL' and state='0'";
        db.ExcuteDataTable(dt_m00203, sql1, CommandType.Text);
        txt_vip_id.Value = vip_id;
    }

 

    private  void Chongzhi(){
        var count = card_count.Value;
        var m001_key = txt_m001_key.Value;
        var m00203_key = DNTRequest.GetString("card_name").Trim();
        if (!string.IsNullOrEmpty(count))
        {
            if (m00203_key != "19591")
            {
                string sql2 = "ucbmp.M101_M00203(" + m00203_key + "," + m001_key + "," + count + ",'" + user_id + "','888801',0,'0')";
                db.BeginTransaction();
                int i = db.ExecuteNonQuery(sql2, CommandType.Text);
                db.Commit();
                if (i == 1)
                {
                    card_count.Value = "";
                    MessageBox.ShowAndBack("充值成功！");
                    return;
                }
                else
                {
                    MessageBox.ShowAndBack("充值失败！");
                    return;
                }
            }
            else
            {
                string sql0 = "select * from a007 where a007_id='" + user_id + "'";
                db.ExcuteDataTable(dt_a007, sql0, CommandType.Text);
                if (dt_a007.Rows.Count != 0)
                {
                    m002_key = dt_a007.Rows[0]["m002_key"].ToString();
                }    
                
                string sql2 = "ucbmp.Acct_Proc(" + m001_key + "," + count + ",'888801','" + m002_key + "','1001')";
                db.BeginTransaction();
                int i = db.ExecuteNonQuery(sql2, CommandType.Text);
                db.Commit();
                if (i == 1)
                {
                    card_count.Value = "";
                    MessageBox.ShowAndBack("充值成功！");
                    return;
                }
                else
                {
                    MessageBox.ShowAndBack("充值失败！");
                    return;
                }
            }
        }

    }
}