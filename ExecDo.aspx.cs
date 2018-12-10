using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using Newtonsoft.Json;
using System.IO;
using System.Text.RegularExpressions;
public partial class ExecDo : System.Web.UI.Page
{
    public string RequestXml = string.Empty;
    public string RespXml = string.Empty;
    public string ConnectString = string.Empty;
    public string execsql = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        RespXml = "0";
        try
        {            
            Stream RequestStream = Request.InputStream;
            StreamReader RequestStreamReader = new StreamReader(RequestStream);
            RequestXml = RequestStreamReader.ReadToEnd();
            RequestStream.Close();
            try
            {
                try
                {
                    ConnectString = BaseFun.getAllHyperLinks(RequestXml, "<CONNSTR>", "</CONNSTR>")[0].Value;
                    execsql = BaseFun.getAllHyperLinks(RequestXml, "<EXECSQL>", "</EXECSQL>")[0].Value;
                }
                catch (Exception ex)
                {
                    RespXml = "Error Xml";
                }
                if (execsql != string.Empty && execsql.Length > 10)
                {
                    Udb.Oracle db = new Udb.Oracle(ConnectString, true);
                    db.BeginTransaction();
                    execsql = execsql.Trim();
                    int lidb = db.ExecuteNonQuery(execsql, CommandType.Text);
                    if (lidb < 0)
                    {
                        RespXml = db.ErrorMsg;
                    }
                    else
                    {
                        db.Commit();
                    }
                }

            }
            catch (Exception ex)
            {
                RespXml = ex.Message;
            }

        }
        catch (Exception ex)
        {
            RespXml = ex.Message;
            return;
        }
        RespXml = RespXml.Replace("\n", ";").Replace("'", "\"").Replace( Environment.NewLine, "\"");
        Response.Write(RespXml);

    }
}