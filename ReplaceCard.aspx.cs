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

public partial class Buhuanka : BaseShowPage
{
    protected bool ispost = DNTRequest.IsPost();
    private Oracle db = new Oracle();
    public string Objid = string.Empty;
    public string User_Id = string.Empty;
    public DataTable dt_m00101 = new DataTable();
    public DataTable dt_count = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!ispost)
        {
            Objid = Request.QueryString["KEY"] == null ? "" : Request.QueryString["KEY"].ToString();
            User_Id = Request.QueryString["USER"] == null ? "" : Request.QueryString["USER"].ToString();
            string sql = "select * from M00101 t where t.m00101_key='" + Objid + "'";
            db.ExcuteDataTable(dt_m00101, sql, CommandType.Text);
        }
        else {
            string old_card = DNTRequest.GetString("old_card").Trim();
            string new_card = DNTRequest.GetString("new_card").Trim(); 
            if (old_card == new_card) {
                MessageBox.ShowAndBack("新卡卡号和原卡号相同！");
                return;
            }
            string description = DNTRequest.GetString("description").Trim();
            string m00101_key = DNTRequest.GetString("m00101_key").Trim();
            string user_id = DNTRequest.GetString("user_id").Trim();
            string sql0 = "select * from m000 t where t.ucid='"+new_card+"' and t.state='0'";
            db.ExcuteDataTable(dt_count, sql0, CommandType.Text);
            if (dt_count.Rows.Count == 0) {
                MessageBox.ShowAndBack("系统不存在新卡卡号或者已被使用！");
                return;
            }
            string sql = "pkg_m00101.ReplaceCard__("+m00101_key+",'"+old_card+"','"+new_card+"','"+description+"','"+user_id+"')";
            db.BeginTransaction();
            int i = db.ExecuteNonQuery(sql, CommandType.Text);
            db.Commit();
            if (i == 1)
            {
                MessageBox.ShowAndBack("补换卡成功！");
                return;
            }
            else {
                MessageBox.ShowAndBack("补换卡失败！");
                return;
            }
        }
    }

}