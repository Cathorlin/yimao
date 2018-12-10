using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Udb;

public partial class Organizational : System.Web.UI.Page
{
    public DataTable dt_table = new DataTable();
    public Oracle db = new Oracle();
    public string count_HR = string.Empty;
    public DataTable dt_table_hr = new DataTable();
    public string count_OA = string.Empty;
    public DataTable dt_table_oa = new DataTable();
    public string count_QA = string.Empty;
    public DataTable dt_table_qa = new DataTable();
    public string count_Training = string.Empty;
    public DataTable dt_table_tr = new DataTable();
    public string count_IB = string.Empty;
    public DataTable dt_table_ib = new DataTable();
    public string count_BJ = string.Empty;
    public DataTable dt_table_bj = new DataTable();
    public string count_SH = string.Empty;
    public DataTable dt_table_sh = new DataTable();
    public string count_GZ = string.Empty;
    public DataTable dt_table_gz = new DataTable();
    public string count_SZ = string.Empty;
    public DataTable dt_table_sz = new DataTable();
    public string count_CD = string.Empty;
    public string count_HZ = string.Empty;
    public string count_XA = string.Empty;
    public string count_NJ = string.Empty;
    public string count_CQ = string.Empty;
    public string count_NB = string.Empty;
    public string count_WH = string.Empty;
    public string count_FS = string.Empty;
    public string count_DG = string.Empty;
    public string count_WX = string.Empty;
    public string count_Supporting = string.Empty;
    public string count_Operation = string.Empty;
    public string count_Mini = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        string sql = "select * from h002_v_count t ";
        db.ExcuteDataTable(dt_table, sql, CommandType.Text);
        for (int i = 0; i < dt_table.Rows.Count; i++) {
            if (dt_table.Rows[i]["H002_NAME"].ToString() == "HR") { 
                count_HR=dt_table.Rows[i]["COUNT"].ToString();
                string sql_hr = "select * from h006 t where t.h002_name='HR'";
                db.ExcuteDataTable(dt_table_hr, sql_hr, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "OA")
            {
                count_OA = dt_table.Rows[i]["COUNT"].ToString();
                string sql_oa = "select * from h006 t where t.h002_name='OA'";
                db.ExcuteDataTable(dt_table_oa, sql_oa, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "QA")
            {
                count_QA = dt_table.Rows[i]["COUNT"].ToString();
                string sql_qa = "select * from h006 t where t.h002_name='QA'";
                db.ExcuteDataTable(dt_table_qa, sql_qa, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "Training")
            {
                count_Training = dt_table.Rows[i]["COUNT"].ToString();
                string sql_tr = "select * from h006 t where t.h002_name='Training'";
                db.ExcuteDataTable(dt_table_tr, sql_tr, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "IB")
            {
                count_IB = dt_table.Rows[i]["COUNT"].ToString();
                string sql_ib = "select * from h006 t where t.h002_name='IB'";
                db.ExcuteDataTable(dt_table_ib, sql_ib, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "BJ")
            {
                count_BJ = dt_table.Rows[i]["COUNT"].ToString();
                string sql_bj = "select * from h006 t where t.h002_name='BJ'";
                db.ExcuteDataTable(dt_table_bj, sql_bj, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "SH")
            {
                count_SH = dt_table.Rows[i]["COUNT"].ToString();
                string sql_sh = "select * from h006 t where t.h002_name='SH'";
                db.ExcuteDataTable(dt_table_sh, sql_sh, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "GZ")
            {
                count_GZ = dt_table.Rows[i]["COUNT"].ToString();
                string sql_gz = "select * from h006 t where t.h002_name='GZ'";
                db.ExcuteDataTable(dt_table_gz, sql_gz, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "SZ")
            {
                count_SZ = dt_table.Rows[i]["COUNT"].ToString();
                string sql_sz = "select * from h006 t where t.h002_name='SZ'";
                db.ExcuteDataTable(dt_table_sz, sql_sz, CommandType.Text);
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "CD")
            {
                count_CD = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "HZ")
            {
                count_HZ = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "XA")
            {
                count_XA = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "NJ")
            {
                count_NJ = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "CQ")
            {
                count_CQ = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "NB")
            {
                count_NB = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "WH")
            {
                count_WH = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "FS")
            {
                count_FS = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "DG")
            {
                count_DG = dt_table.Rows[i]["COUNT"].ToString();
            }
            else if (dt_table.Rows[i]["H002_NAME"].ToString() == "WX")
            {
                count_WX = dt_table.Rows[i]["COUNT"].ToString();
            }
            count_Supporting = dt_table.Rows[0]["Supporting"].ToString();
            count_Mini = dt_table.Rows[0]["Mini"].ToString();
            count_Operation = dt_table.Rows[0]["Operation"].ToString();
        }

    }
}