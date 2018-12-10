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
using System.Text;
using System.Text.RegularExpressions;
using System.Data.OracleClient;
public partial class ExecXml : System.Web.UI.Page
{
    public string RequestXml = "";
    public string ReturnCode = "";
    public string ReturnMessage = "";
    public string MessageName = "";
    public  BaseFun Fun = new BaseFun();
    public string log_key = "";
    protected void Page_Load(object sender, EventArgs e)
    {

       


        ReturnCode = "0";
        try
        {
            Stream RequestStream = Request.InputStream;
            StreamReader RequestStreamReader = new StreamReader(RequestStream);
            RequestXml = RequestStreamReader.ReadToEnd();
            RequestStream.Close();      

        }
        catch (Exception ex)
        {
            ReturnCode = "-1";
            ReturnMessage = "错误报文格式！";
            Error_Resp("0","errorresp");
            return;
        }

        string clientip = Fun.getClientIp();

 //      '&' (ampersand) becomes '&amp;'
        RequestXml = RequestXml.Replace("&amp;", "&");


 //'"' (double quote) becomes '&quot;' when ENT_NOQUOTES is not set.
        RequestXml = RequestXml.Replace("&quot;", "\"");


 //''' (single quote) becomes '&#039;' only when ENT_QUOTES is set.

        RequestXml = RequestXml.Replace("&#039;", "'");
 //'<' (less than) becomes '&lt;'

        RequestXml = RequestXml.Replace("&lt;", "<");
 //'>' (greater than) becomes '&gt;'
        RequestXml = RequestXml.Replace("&gt;", ">");

        SaveLog.Verification(clientip + ":" + RequestXml);
        //获取MessageName
        try
        {
            MessageName = BaseFun.getAllHyperLinks(RequestXml, "<messagename>", "</messagename>")[0].Value;
            MessageName = MessageName.Substring(0, MessageName.Length - 3);
        }
        catch (Exception ex)
        {
            ReturnCode = "-1";
            ReturnMessage = "错误报文格式(-1)!";
            Error_Resp("0", "errorresp");
            return;
        }
   
        try
        {
            //检测报文消息的有效性
            string sql = "Select t.* from A319 t where  a319_id='" + MessageName + "'";
            DataTable dt_a319 = new DataTable();
            dt_a319 = Fun.getDtBySql(sql);
            if (dt_a319.Rows.Count == 0)
            {
                ReturnCode = "-1";
                ReturnMessage = "错误报文格式(-2)！" + MessageName + sql;
                Error_Resp("0", MessageName);
                return;
            }
            if (dt_a319.Rows[0]["A319_TYPE"].ToString() == "0")
            {
                ReturnCode = "-1";
                ReturnMessage = "错误报文格式(-3)!" + MessageName;
                Error_Resp("0", MessageName);
                return;
            }
            //检测报文状态失败有效
            if (dt_a319.Rows[0]["STATE"].ToString() != "1")
            {
                ReturnCode = "-1";
                ReturnMessage = "错误报文格式(-4)!" + MessageName;
                Error_Resp("0", MessageName);
                return;
            }
            //检测客户端的有效性
            sql = dt_a319.Rows[0]["REQSQL"].ToString();
          
            if (sql.Length > 10)
            {

                sql = sql.Replace("[CLIENTIP]", clientip);
                DataTable dt_temp = new DataTable();
                dt_temp = Fun.getDtBySql(sql);
                if (dt_temp.Rows.Count <= 0)
                {
                    ReturnCode = "-1";
                    ReturnMessage = "错误的客户端地址！" + MessageName;
                    Error_Resp("0", MessageName);
                    return;
                }
            }
            sql = "Select s_a31902 .nextval as c from dual";
            DataTable dt = new DataTable();
            dt = Fun.getDtBySql(sql);
            if (dt.Rows.Count <= 0)
            {
                ReturnCode = "-1";
                ReturnMessage = "获取日志编码失败！" + MessageName;
                Error_Resp("0", MessageName);
                return;
            }
            log_key = dt.Rows[0][0].ToString();

            //开始写日志         
            OracleParameter[] parmeters =
        {
            
                new OracleParameter("Messagename_", OracleType.NVarChar,200),
                new OracleParameter("A31902_Line_", OracleType.NVarChar,200),
                new OracleParameter("User_Id_", OracleType.NVarChar,200),
                new OracleParameter("Requestxml_", OracleType.Clob)
         };
            parmeters[0].Direction = ParameterDirection.Input;
            parmeters[1].Direction = ParameterDirection.Input;
            parmeters[2].Direction = ParameterDirection.Input;

            parmeters[0].Value = MessageName;
            parmeters[1].Value = log_key;
            parmeters[2].Value = clientip;
            parmeters[3].Value = RequestXml;
            //写日志
            int li_db =0;
                Fun.db.db_oracle.BeginTransaction();
                try
                {
                    li_db = Fun.db.db_oracle.ExecuteNonQuery("Pkg_a319_api.Save_Xml_", parmeters); //db.ExecuteNonQuery(str_sql, CommandType.Text);
                    if (li_db < 0)
                    {
                        Fun.db.db_oracle.Rollback();
                        ReturnCode = "-1";
                        ReturnMessage = "记录日志失败！" + MessageName;
                        Error_Resp("0", MessageName);
                        return;
                    }
                }
                catch (Exception ex)
                {
                    Fun.db.db_oracle.Rollback();
                    ReturnCode = "-1";
                    ReturnMessage = BaseFun.GetOracleMsg(ex.Message);
                    Error_Resp("0", MessageName);
                    return;
                }
                Fun.db.db_oracle.Commit();
   
            //处理报文

            OracleParameter[] parm =
           {
                new OracleParameter("A31902_Line_", OracleType.NVarChar,200)
           };
            parm[0].Direction = ParameterDirection.Input;
            parm[0].Value = log_key;
            //写日志
            Fun.db.db_oracle.BeginTransaction();
              try
              {
                    li_db = Fun.db.db_oracle.ExecuteNonQuery("Pkg_a319_api.Req_xml_", parm); //db.ExecuteNonQuery(str_sql, CommandType.Text);
                    if (li_db < 0)
                    {
                        Fun.db.db_oracle.Rollback();
                        ReturnCode = "-1";
                        ReturnMessage = "处理失败！" + MessageName;
                        Error_Resp("0", MessageName);
                        return;
                    }
              }
              catch (Exception ex)
              {
                  Fun.db.db_oracle.Rollback();
                  ReturnCode = "-1";
                  ReturnMessage = BaseFun.GetOracleMsg(ex.Message);
                  Error_Resp("0", MessageName);
                  return;
              }
            Fun.db.db_oracle.Commit();
            // responsexml = parmeters[1].Value.ToString();
            try
            {
                DataTable dt_send = new DataTable();
                dt_send = Fun.getDtBySql("select t.sendxml from a31902 t where line_no=" + log_key);
                Response.Write(dt_send.Rows[0][0].ToString()); 
            }
            catch
            {
                ReturnCode = "-1";
                ReturnMessage = "处理失败！" + MessageName;
                Error_Resp("0", MessageName);
            }

        }
        catch
        {
            ReturnCode = "-1";
            ReturnMessage = "处理失败！" + MessageName;
            Error_Resp("0", MessageName);
        }
    }

    protected void Error_Resp(string TransactionID_, string MessageName__ )
    {
        StringBuilder str_resp = new StringBuilder();
        string MessageName_ = MessageName__ + "resp";
        str_resp.Append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        str_resp.Append("<miap><miap-header><transactionid>" + TransactionID_ + "</transactionid>");
        str_resp.Append("<messagename>" + MessageName_ + "</messagename><returncode>" + ReturnCode + "</returncode>");
        str_resp.Append("<returnmessage>" + ReturnMessage + "</returnmessage></miap-header>");
        str_resp.Append("<miap-body><" + MessageName_ + "></" + MessageName_ + "></miap-body></miap>");
        Response.Write(str_resp.ToString());        
    }

}