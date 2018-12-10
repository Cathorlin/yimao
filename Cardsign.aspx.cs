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
using System.IO;
using System.IO.Ports;


public partial class Card_sign : System.Web.UI.Page
{
    private Oracle db = new Oracle();
    public DataTable dt_m001 = new DataTable();

    protected bool ispost = DNTRequest.IsPost();

    public string vip_name = string.Empty;
    public string ucid = string.Empty;
    public string mobile_no = string.Empty;
    public string m001_key = string.Empty;
    M1Card m1card = new M1Card();

    protected void Page_Load(object sender, EventArgs e)
    {
        ucid = DNTRequest.GetString("card_no").Trim();
        var action = DNTRequest.GetString("action");
        if (action == "readcard")
        {
            readcard();
        }
        else if (action == "sign")
        {
            sign();
        }
    }

    private void readcard()
    {
        ucid = DNTRequest.GetString("card_no").Trim();
        string sql = "select * from m001 where ucid='" + ucid + "'";
        db.ExcuteDataTable(dt_m001, sql, CommandType.Text);
        if (dt_m001.Rows.Count != 0)
        {
            vip_name = dt_m001.Rows[0]["M001_NAME"].ToString();
            mobile_no = dt_m001.Rows[0]["MOBILE_NO"].ToString();
            m001_key = dt_m001.Rows[0]["M001_KEY"].ToString();
        }
        else
        {
            MessageBox.ShowAndBack("此卡号还不是会员！");
            return;
        }
    }

    private void sign()
    {
        vip_name = DNTRequest.GetString("vip_name").Trim();
        m001_key = DNTRequest.GetString("m001_key").Trim();
        mobile_no = DNTRequest.GetString("mobile_no").Trim();
        if (!string.IsNullOrEmpty(vip_name))
        {
            string sql1 = "insert into m0010103(m0010103_key,m001_key,m001_name,mobile_no,ucid) values(S_M0010103.NEXTVAL," + m001_key + ",'" + vip_name + "'," + mobile_no + "," + ucid + ")";
            int rows = db.ExecuteNonQuery(sql1, CommandType.Text);
            if (rows == 1)
            {
                MessageBox.ShowAndBack("成功签到！");
                return;
            }
            else
            {
                MessageBox.ShowAndBack("签到失败！");
                return;
            }
        }
        else
        {
            MessageBox.ShowAndBack("请您先读出会员卡！");
            return;
        }
    }
}