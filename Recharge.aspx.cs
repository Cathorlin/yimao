using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data;
using Base;
using Common;
using System.Data.OracleClient;
using System.IO;


public partial class Recharge : System.Web.UI.Page
{
    private Oracle db = new Oracle();
    public string Objid = string.Empty;
    public string ucid;
    public string m001_name;
    public string m001_key;
    public string member_level;
    public string m002_key;
    public string m101_key = string.Empty;
    public string user_id;
    public string recharge_money;
    public string name = string.Empty;
    public string id = string.Empty;
    public string card_no;
    public string balance;
    public string m012_id = string.Empty;
    public string m012_key = string.Empty;
    public DateTime enter_date;
    public string ajax;
    public DataTable dt_m00101 = new DataTable();
    public DataTable dt_m002 = new DataTable();
    public DataTable dt_m001 = new DataTable();
    public DataTable dt_m0120101 = new DataTable();
    public DataTable dt_m01201 = new DataTable();
    public DataTable dt_count = new DataTable();
    public DataTable v_member_level = new DataTable();
    protected bool ispost = DNTRequest.IsPost();
    M1Card m1card = new M1Card();
    protected void Page_Load(object sender, EventArgs e)
    {
        m002_key = Request.QueryString["M002_KEY"] == null ? "" : Request.QueryString["M002_KEY"].ToString();
        var action = DNTRequest.GetString("action");
        string sql0 = "select * from v_member_level";
        db.ExcuteDataTable(v_member_level, sql0, CommandType.Text);
        if (action == "")
        {
            Fristshow();
        }
        else if (action == "readcard")
        {
            Readcard();
        }
        else if (action == "recharge")
        {
            recharge();
        }

    }

    private void Fristshow()
    {
        ucid = Request.QueryString["UCID"] == null ? "" : Request.QueryString["UCID"].ToString();
        m001_name = Request.QueryString["M001_NAME"] == null ? "" : Request.QueryString["M001_NAME"].ToString();
        m001_key = Request.QueryString["M001_KEY"] == null ? "" : Request.QueryString["M001_KEY"].ToString();
        member_level = Request.QueryString["MEMBER_LEVEL"] == null ? "" : Request.QueryString["MEMBER_LEVEL"].ToString();
        string sql1 = "select * from m0120101 t inner join m00101 t1 on t1.m001_key=t.m001_key where t1.ucid='" + ucid + "'";
        db.ExcuteDataTable(dt_m0120101, sql1, CommandType.Text);
        if (dt_m0120101.Rows.Count != 0)
        {
            enter_date = Convert.ToDateTime(dt_m0120101.Rows[0]["VALID_END"]);
        }
        string sql2 = "select * from m01201 t inner join m001 t1 on t1.m001_key=t.m001_key where t1.ucid='" + ucid + "' and m012_key='10000001'";
        db.ExcuteDataTable(dt_m01201, sql2, CommandType.Text);
        if (dt_m01201.Rows.Count != 0)
        {
            balance = dt_m01201.Rows[0]["BALANCE"].ToString();
        }
    }
    private void Readcard()
    {
        card_no = DNTRequest.GetString("card_no");
        string sqls = "select * from m001 where ucid='" + card_no + "'";
        db.ExcuteDataTable(dt_m001, sqls, CommandType.Text);
        if (dt_m001.Rows.Count != 0)
        {
            m001_name = dt_m001.Rows[0]["M001_NAME"].ToString();
            m001_key = dt_m001.Rows[0]["M001_KEY"].ToString();
            ucid = dt_m001.Rows[0]["UCID"].ToString();
        }
        else {
            ucid = card_no;
            MessageBox.ShowAndBack("此卡不存在！");
        }
        string sqls1 = "select * from m0120101 t inner join m00101 t1 on t1.m001_key=t.m001_key where t1.ucid='" + card_no + "'";
        db.ExcuteDataTable(dt_m0120101, sqls1, CommandType.Text);
        if (dt_m0120101.Rows.Count != 0)
        {
            enter_date = Convert.ToDateTime(dt_m0120101.Rows[0]["VALID_END"]);
        }
        string sqls2 = "select * from m01201 t inner join m001 t1 on t1.m001_key=t.m001_key where t1.ucid='" + card_no + "' and m012_key='10000001'";
        db.ExcuteDataTable(dt_m01201, sqls2, CommandType.Text);
        if (dt_m01201.Rows.Count != 0)
        {
            balance = dt_m01201.Rows[0]["BALANCE"].ToString();
        }
        string sqls3 = "select * from m00101 where ucid='" + card_no + "'";
        db.ExcuteDataTable(dt_m00101, sqls3, CommandType.Text);
        if (dt_m00101.Rows.Count != 0)
        {
            member_level = dt_m00101.Rows[0]["MEMBER_LEVEL"].ToString();
        }
    }
    private void recharge()
    {
        recharge_money = DNTRequest.GetString("recharge_money").Trim();
        ucid = DNTRequest.GetString("card_no").Trim();
        string sql = "ucbmp.Acct_Proc('" + ucid + "'," + recharge_money + ",'888805'," + m002_key + ",'0001')";
        db.BeginTransaction();
        int i = db.ExecuteNonQuery(sql, CommandType.Text);
        db.Commit();
        if (i == 1)
        {
            string url = Request.Url.ToString();
            MessageBox.ShowAndRedirect("充值成功！", url);
            //MessageBox.ShowAndBack("充值成功！");
            return;
        }
        else
        {
            MessageBox.ShowAndBack("充值失败！");
            return;
        }

    }
    
}