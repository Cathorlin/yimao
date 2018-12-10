using System;
using System.Data;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Web;

public partial class ShowErpForm_Report_Default : System.Web.UI.Page 
{
    ReportDocument rd1 = new ReportDocument();

    protected void Page_Load(object sender, EventArgs e)
    {
        //也可在这访问数据库，取得报表内容
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        //string str1 = null;
        string strSql1 = null;
        //string strSql2 = null;
        DataTable ds = new DataTable();        

        //((Button)CrystalReportViewer1.Controls[1]).Click

        try
        {
            rd1.Load(Server.MapPath("rptSerialTrain.rpt"));
            //strSql1 = "select * from Employees where EmployeeID<10";
            //strSql2 = "select * from Orders where OrderID<10270";  // where uidN='03557115-2526'";

            //ds = com.TFMI.DAL.TFMIDbHelper.selectDataSetBindReport(strSql1, "Employees", strSql2, "Orders", "Default.aspx");
            strSql1 = "select * from bl_v_rpt_serial_transaction t Where t.transaction_id='3633361'";
            BaseFun fun = new BaseFun();
            ds = fun.getDtBySql(strSql1);
            rd1.SetDataSource(ds);

            //"http://localhost/ShowErpForm/Report/Code39handler.ashx?Code=" & {BL_V_RPT_SERIAL_TRANSACTION.SERIAL_NO}
            //rd1.SetParameterValue("P1", "ABC-X78901234");

            CrystalReportViewer1.ReportSource = rd1;
        }
        catch (LoadSaveReportException ex)
        {
            Response.Write(ex.Message);     // 報表載入失敗
        }
        catch (PrintException ex)
        {
            Response.Write(ex.Message);     // 報表載入失敗
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);     // 報表載入失敗
        }
    }

    // 釋放報表資源
    private void Page_Unload(object sender, EventArgs e)
    {
        rd1.Close();
        rd1.Dispose();      // 釋放相關資源，再刪除先前產生的暫存檔
    }
}
