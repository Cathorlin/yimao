using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Web;
using Base;
public partial class CRShow : BasePage
    {
        public CryReport CryReport = new CryReport();
        public string report_file = string.Empty;
        public string report_sql = string.Empty;
        public string report_parm = "";
        public string menu_name = string.Empty;
        public string report_conditon = "1";
        public DataTable dt_main = new DataTable();
        public  CrystalReportSource cs = new CrystalReportSource();
        public ReportDocument rd ;
        private   void   Page_Unload(object   sender,   EventArgs   e) 
        {
            cs.Dispose();
           // rd.Dispose();
            CrystalReportViewer1.Dispose();
            dt_main.Dispose();
        }

    protected void Page_Load(object sender, EventArgs e)
    {
        //   
        string showreport = Request.QueryString["showreport"] == null ? "0" : Request.QueryString["showreport"].ToString();
        //rd = new ReportDocument();
        if (showreport == "1")
        {
            try
            {
                this.Button1.Visible = false;
                string PARM = Request.QueryString["PARM"] == null ? "0" : Request.QueryString["PARM"].ToString();
                if (PARM != "0")
                {
                    string data_index = GlobeAtt.DATA_INDEX;
                    string strdata = data_index + DES.DESDecrypt(PARM, DES.Key);
                    strdata = strdata.Trim();
                    report_file = BaseFun.getStrByIndex(strdata, data_index + "REPORT_FILE|", data_index);
                    report_sql = BaseFun.getStrByIndex(strdata, data_index + "REPORT_SQL|", data_index);
                    report_parm = BaseFun.getStrByIndex(strdata, data_index + "REPORT_PARM|", data_index);
                }
                else
                {
                    report_file = Session["REPORT_FILE"].ToString();
                    report_sql = Session["REPORT_SQL"].ToString();
                    report_parm = Session["REPORT_PARM"].ToString();
                }
                // Response.Write(report_sql);
                ReportDocument rd = new ReportDocument();
            
                string file_ = Server.MapPath("../Report/" + report_file);
              
                try
                {
                    rd.Load(file_);
                   // cs.ReportDocument.Load(rd.FileName);
                    PageMargins pm = new PageMargins();

                    rd.PrintOptions.ApplyPageMargins(pm) ;
                   
                }
                catch (Exception ex)
                {
                    Response.Write(report_file + ex.Message);
                    return;

                }
                if (report_sql.Length > 10)
                {
                    Oracle db = new Oracle();
                    DataTable dt_report = new DataTable();
                    db.ExcuteDataTable(dt_report, report_sql, CommandType.Text);

                    rd.SetDataSource(dt_report);
                    CrystalReportViewer1.ReportSource = rd;
                    CrystalReportViewer1.DataBind();

                }
                else
                {
                    Oracle db = new Oracle();
                    ConnectionInfo ConnectionInfo1 = new ConnectionInfo();
                    ConnectionInfo1 = rd.Database.Tables[0].LogOnInfo.ConnectionInfo;
                    rd.SetDatabaseLogon(db.user_id, db.password);
                    ConnectionInfo1.DatabaseName = "";
                    ConnectionInfo1.UserID = db.user_id;
                    ConnectionInfo1.Password = db.password;
                    ConnectionInfo1.ServerName = db.data_source;
                    SetDBLogonForReport(ConnectionInfo1, rd);
                    if (rd.HasSavedData == true)
                    {
                        rd.Refresh();
                    }
                    string[] parm = report_parm.Split(',');
                    ParameterFields ParamFields=new ParameterFields();
                    for (int i = 0; i < rd.ParameterFields.Count; i++)
                    {
    
                        ParameterDiscreteValue ParamDiscreteValue = new ParameterDiscreteValue();
                        if (parm[i] != "[]")
                        {
                            ParamDiscreteValue.Value = parm[i].Replace(GlobeAtt.RPT_TEMP_INDEX,",");
                            if (i < parm.Length && parm[i] != "")
                            {
                                rd.ParameterFields[i].CurrentValues.Add(ParamDiscreteValue);
                            }
                        }
                     
                   

                    }




                    CrystalReportViewer1.ReportSource = rd;
                    CrystalReportViewer1.DataBind();
                    
                }
                
   

            }
            catch (Exception ex)
            {

                Response.Write(ex.Message);

                return;
            }


        }
        else
        {


            //   string   a002_key = Request.QueryString["A002KEY"] == null ? "-1" : Request.QueryString["A002KEY"].ToString();
            //   string A00201KEY = Request.QueryString["A00201KEY"] == null ? "-1" : Request.QueryString["A00201KEY"].ToString();
            string report_conditon = Request.QueryString["reportconditon"] == null ? "1" : Request.QueryString["reportconditon"].ToString();
            string key = Request.QueryString["JUMP_KEY"] == null ? "-1" : Request.QueryString["JUMP_KEY"].ToString();
            string a002_key = Request.QueryString["JUMP_A002_KEY"] == null ? "-1" : Request.QueryString["JUMP_A002_KEY"].ToString();
            string IF_JUMP = Request.QueryString["IF_JUMP"] == null ? "1" : Request.QueryString["IF_JUMP"].ToString();

            //   dt_a002 = Fun.getDtBySql("Select t.* from A002 t where menu_id='" + a002_key +"'");
            dt_main = Fun.getDtBySql("Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name  from A002_v01 t where a002_key='" + a002_key + "'");
            
            try
            {
                report_file = dt_main.Rows[0]["datawindow_name"].ToString();
            }
            catch (Exception ex)
            {

                Response.Write("report_file" + ex.Message);

                return;
            }

            try
            {
                menu_name = dt_main.Rows[0]["show_name"].ToString();
            }
            catch (Exception ex)
            {

                menu_name = "";
                Response.Write("title" + ex.Message);
            }


            try
            {
                if (report_conditon == "1")
                {
                    report_sql = dt_main.Rows[0]["query_table"].ToString();
                    if (report_sql.Length < 20)
                    {
                        report_sql = "Select t.* from " + report_sql + "t where 1=1 ";
                    }
                    Session["REPORT_SQL"] = report_sql;
                }
                else
                {
                    report_sql = Session["REPORT_SQL"].ToString();
                }
            }
            catch (Exception ex)
            {
                Response.Write("report_sql" + ex.Message);
                return;
            }

                string file_ = Server.MapPath("../report/" + report_file);
                try
                {

                    rd.Load(file_);

                    ConnectionInfo ConnectionInfo1 = new ConnectionInfo();
                    ConnectionInfo1 = rd.Database.Tables[0].LogOnInfo.ConnectionInfo;
                    ConnectionInfo1.DatabaseName = "";
                    ConnectionInfo1.UserID = Fun.db.user_id;
                    ConnectionInfo1.Password = Fun.db.password;
                    ConnectionInfo1.ServerName = Fun.db.data_source;
                    SetDBLogonForReport(ConnectionInfo1, rd);
                    if (rd.HasSavedData == true)
                    {
                        rd.Refresh();
                    }
                    CrystalReportViewer1.ReportSource = rd;
                    CrystalReportViewer1.DataBind();


                }
                catch (Exception ex)
                {
                    Response.Write(report_file + ex.Message);
                    return;

                }
                t_con.Visible = false;
                Button1.Visible = false;
  

            //else
            //{

            //    cs = (CrystalReportSource) CrystalReportViewer1.ReportSource;
            //}
            /*

            if (report_conditon == "1")
            {
                set_condition();
            }
            else
            {
                //  Response.Write(report_sql);
                t_con.Visible = false;
                Button1.Visible = false;
                //cs.ReportDocument.SetDatabaseLogon(Fun.db.user_id, Fun.db.password, Fun.db.data_source, Fun.db.data_source);
                //cs.ReportDocument.Refresh();
               // CrystalReportViewer1.ReportSource = cs;
                //CrystalReportViewer1.DataBind();
              //  cs.DataBind();
                return;
                Oracle db = new Oracle();
                DataTable dt_report = new DataTable();
                db.ExcuteDataTable(dt_report, report_sql, CommandType.Text);

                cs.ReportDocument.SetDataSource(dt_report);
                cs.DataBind();

                CrystalReportViewer1.ReportSource = cs;
                CrystalReportViewer1.DataBind();


            }



        }

       // CryReport.get_report_condition(CrystalReportViewer1, Server.MapPath("../report/" + report_file), t_con);
       */
        }
    }

    private void SetDBLogonForReport(ConnectionInfo connectionInfo, ReportDocument reportDocument)
    {
        try
        {
            Tables tables = reportDocument.Database.Tables;
            foreach (CrystalDecisions.CrystalReports.Engine.Table table in tables)
            {
                TableLogOnInfo tableLogonInfo = table.LogOnInfo;
                tableLogonInfo.ConnectionInfo = connectionInfo;
                table.ApplyLogOnInfo(tableLogonInfo);

            }
        }
        catch
        {

        }
    }



    public void set_condition()
    {

    //    ConnectionInfo 


    
            for (int i = 0; i < cs.ReportDocument.ParameterFields.Count; i++)
            {
                //string ls_part .Name;
                ParameterField param = cs.ReportDocument.ParameterFields[i];
            

                HtmlTableRow tr = new HtmlTableRow();

                HtmlTableCell td1 = new HtmlTableCell();
                td1.Attributes.Add("class", "td_1");
                td1.InnerHtml = param.PromptText;

                tr.Cells.Add(td1);

                HtmlTableCell td2 = new HtmlTableCell();
                td2.Attributes.Add("class", "td_2");
                td2.InnerHtml = "<span> =</span>";
                tr.Cells.Add(td2);

                HtmlTableCell td3 = new HtmlTableCell();

                TextBox tb = new TextBox();
                tb.ID = "COL_" + i.ToString();
                if (param.DefaultValues.Count > 0)
                {
                    ParameterDiscreteValue p = (ParameterDiscreteValue) param.DefaultValues[0];
                    tb.Text = p.Value.ToString();
                }
                td3.Attributes.Add("class", "td_3");
                td3.Controls.Add(tb);
                tr.Cells.Add(td3);

                tr.Attributes.Add("class", "tr_1");
                t_con.Rows.Add(tr);
                
            }

        }


    
    protected void Button1_Click(object sender, EventArgs e)
    {

          string report_sql_ = report_sql;
     
          for (int i = 0; i < cs.ReportDocument.ParameterFields.Count; i++)
          {  ParameterField param = cs.ReportDocument.ParameterFields[i];
              TextBox tb = (TextBox)t_con.FindControl("COL_" + i.ToString());

              string v = tb.Text;

             

              //
              ParameterDiscreteValue p =  new ParameterDiscreteValue();
              p.Value = v;

            //  cs.ReportDocument
 
              report_sql_ = report_sql_.Replace("{?" + param.Name + "}", v);

          }
          Session["REPORT_SQL"] = report_sql_;
          Session["report_conditon"] = "0";
          Random seedRnd = new Random();
          t_con.Visible = false;
          Button1.Visible = false;
         /*
            int asciiCode = seedRnd.Next(0, 10202);
            string url = Request.Url.ToString();
            if (url.IndexOf("reportconditon=") > 0)
            {
                url = url.Replace("reportconditon=1", "reportconditon=0");
            }
            else
            {
                url = url + "&reportconditon=0";
            }
            Response.Redirect(url + "&code=" + asciiCode.ToString());
         **/
       
    }
    protected void CrystalReportViewer1_DrillDownSubreport(object source, DrillSubreportEventArgs e)
    {

        Response.Write(source.ToString());


    }
    protected void Button2_Click(object sender, EventArgs e)
    {
              
    }
}

