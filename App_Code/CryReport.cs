using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Web;
using System.Data.OracleClient;


/// <summary>
/// Class1 的摘要说明
/// </summary>

    public class CryReport    {
        private System.Data.OracleClient.OracleConnection Connection;
        private bool needTransaction = false;
        private bool mustCloseConnection = true;
        private System.Data.IDbTransaction tran;
        DataTable dt_report = new DataTable();
        public CryReport()
        {
            //
            // TODO: 在此处添加构造函数逻辑
            //

            try
            {
                this.Connection = new OracleConnection(System.Configuration.ConfigurationSettings.AppSettings["ConnectionString_Report"]);
            }
            catch (OracleException ex)
            {
                throw ex;
            }
        }
        private void PrepareCommand(IDbCommand command, IDbConnection connection, IDbTransaction transaction,
            CommandType commandType, string commandText)
        {
            if (command == null) throw new ArgumentNullException("command");
            if (commandText == null || commandText.Length == 0) throw new ArgumentNullException("commandText");

            // Associate the connection with the command

            command.Connection = connection;

            // Set the command text (stored procedure name or SQL statement)
            command.CommandText = commandText;

            // If we were provided a transaction, assign it
            if (transaction != null)
            {
                if (transaction.Connection == null)
                    throw new ArgumentException("The transaction was rollbacked or commited, please provide an open transaction.", "transaction");
                command.Transaction = transaction;
            }

            // Set the command type
            command.CommandType = commandType;
            return;
        }

        public int ExcuteDataTable(DataTable srcTable, string commandText, System.Data.CommandType commandType)
        {
            if (this.Connection.State != System.Data.ConnectionState.Open)
                this.Connection.Open();
            if (!this.needTransaction)
                tran = null;
            OracleCommand cmd = new OracleCommand();

            PrepareCommand(cmd, this.Connection, tran, CommandType.Text, commandText);

            OracleDataAdapter da = new OracleDataAdapter(cmd);

            try
            {
                da.Fill(srcTable);
                da.Dispose();
            }
            catch (System.Data.OracleClient.OracleException ex)
            {

                return -1;
            }
            finally
            {
                if (mustCloseConnection)
                {
                    if (!needTransaction)
                    {
                        Connection.Close();
                    }
                }

            }
            return 1;
        }


        ///<summary>
        ///功能：拉模式提取水晶报表
        ///个人主页：http://www.dzend.com/
        ///</summary>
        ///<param name="sender"></param>
        ///<param name="e"></param>
        ///
        public int view_report(CrystalReportViewer CrystalReportViewer1, string file_name, string report_sql)
        {
            // CrystalReport.rpt是水晶报表文件的名称；CrystalReportSource1是从工具箱加到页面上的水晶报表数据源对像。


            ExcuteDataTable(dt_report, report_sql, CommandType.Text);
            try
            {
                CrystalReportSource cs = new CrystalReportSource();
                cs.ReportDocument.Load(file_name);
                cs.ReportDocument.SetDataSource(dt_report);
                cs.DataBind();

                for (int i = 0; i < cs.ReportDocument.ParameterFields.Count; i++)
                {
                    string ls_part = cs.ReportDocument.ParameterFields[i].Name;

                }

                CrystalReportViewer1.ReportSource = cs;
                CrystalReportViewer1.DataBind();

                return 1;
            }
            catch (Exception e)
            {

                return -1;
            }

        }



        public string get_report_condition(CrystalReportViewer CrystalReportViewer1, string file_name, System.Web.UI.HtmlControls.HtmlTable lb_table)
        {
            // CrystalReport.rpt是水晶报表文件的名称；CrystalReportSource1是从工具箱加到页面上的水晶报表数据源对像。

            string ls_conditon = "";
            try
            {
                CrystalReportSource cs = new CrystalReportSource();
                cs.ReportDocument.Load(file_name);
                cs.ReportDocument.SetDataSource(dt_report);
                cs.DataBind();


                for (int i = 0; i < cs.ReportDocument.ParameterFields.Count; i++)
                {
                    //string ls_part .Name;
                    ParameterField param = cs.ReportDocument.ParameterFields[i];

                    HtmlTableRow tr = new HtmlTableRow();

                    HtmlTableCell td1 = new HtmlTableCell();

                    td1.InnerHtml = param.PromptText;

                    tr.Cells.Add(td1);

                    HtmlTableCell td2 = new HtmlTableCell();
                    td2.InnerHtml = "<span> =</span>";
                    tr.Cells.Add(td2);

                    HtmlTableCell td3 = new HtmlTableCell();
                    td3.InnerHtml = "<input type=\"text\" >";
                    tr.Cells.Add(td3);

                    lb_table.Rows.Add(tr);


                }
                return "1";

            }
            catch (Exception e)
            {

                return "-1";
            }
            return "0";
        }


    }
