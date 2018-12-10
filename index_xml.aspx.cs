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
using System.Xml;
using System.IO;
using System.Data.OracleClient;
using Base;
using System.Text.RegularExpressions;
using System.Net.Sockets;
using System.Net;
using System.Text;

public partial class index_xml : System.Web.UI.Page
{

    public DataTable dt_m106 = new DataTable();
    public DataTable dt_m10601 = new DataTable();
    public DataTable dt_m10602 = new DataTable();
    public DataTable dt_resp = new DataTable();
    public int li_db = 0;
    public string ReturnCode = "00";
    public string ReturnMessage = string.Empty;
    public string table_id;
    public string m905_key = "";
    public string M907_key = "0";
    public string exec_sql = "";
    public Oracle db = new Oracle();
    public Custom.BaseObject.Function Fun = new Custom.BaseObject.Function();
    //获取表头的信息



    public string HeaderXml = string.Empty;


    public string TransactionID = string.Empty;
    public string Version = string.Empty;
    public string MessageName = string.Empty;
    public string TestFlag = string.Empty;
    public string BPID = string.Empty;
    public string RequestXml = string.Empty;
    public string ResponseXml = string.Empty;
    public string body = string.Empty;
    public string clientip = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {

            clientip = Fun.getClientIp();
            save_request();
            Stream RequestStream = Request.InputStream;
            StreamReader RequestStreamReader = new StreamReader(RequestStream);
            RequestXml = RequestStreamReader.ReadToEnd();
            RequestStream.Close();
            //RequestXml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
            //RequestXml = RequestXml + "<MIAP>";
            //RequestXml = RequestXml + "<MIAP-Header>";
            //RequestXml = RequestXml + "<TransactionID>20110909090909000001</TransactionID>";
            //RequestXml = RequestXml + "<Version>1.0</Version>";
            //RequestXml = RequestXml + "<MessageName>ActiveTestReq</MessageName>";
            //RequestXml = RequestXml + "<TestFlag>1</TestFlag>";
            //RequestXml = RequestXml + "</MIAP-Header>";
            //RequestXml = RequestXml + "<MIAP-Body>";
            //RequestXml = RequestXml + "<ActiveTestReq>";
            //RequestXml = RequestXml + "<BPID>110110</BPID>";
            //RequestXml = RequestXml + "</ActiveTestReq>";
            //RequestXml = RequestXml + "</MIAP-Body>";
            //RequestXml = RequestXml + "</MIAP>";

            li_db = 1;

            try
            {

                HeaderXml = Fun.getAllHyperLinks(RequestXml, "<MIAP-Header>", "</MIAP-Header>")[0].Value;
                BPID = Fun.getAllHyperLinks(RequestXml, "<BPID>", "</BPID>")[0].Value;
                //检测ip是否是合理的ip地址

                Boolean lb_check = checkClient(BPID, clientip);
                if (lb_check == false)
                {
                    li_db = -1;
                    ReturnCode = "1";
                    ReturnMessage = "错误格式的XML";//ex.Message ;

                    Response.Write("错误的BPID" + BPID + "和客户端" + clientip);
                    return;
                }
                getRequestHead(HeaderXml);
                if (li_db == 1)
                {
                    body = Fun.getAllHyperLinks(RequestXml, "<MIAP-Body>", "</MIAP-Body>")[0].Value;
                    //根据body 获取对应的数据  ActiveTestReq <BPID>110110</BPID>
                    getM106(MessageName);
                    if (dt_m106.Rows.Count == 0)
                    {
                        li_db = -1;
                        ReturnCode = "1";
                        ReturnMessage = MessageName + "接口未定义";

                    }
                    else
                    {
                        string key_Sql = "Select S_M905.nextval as c from dual ";
                        DataTable dt_key = new DataTable();
                        db.ExcuteDataTable(dt_key, key_Sql, CommandType.Text);
                        m905_key = dt_key.Rows[0][0].ToString();

                        string send_xml = Fun.getAllHyperLinks(body, "<" + MessageName + ">", "</" + MessageName + ">")[0].Value;   //<ActiveTestReq>
                        string where_sql = dt_m106.Rows[0]["WHERE_SQL"].ToString();
                        string select_sql = dt_m106.Rows[0]["SELECT_SQL"].ToString();
                        string update_sql = dt_m106.Rows[0]["UPDATE_SQL"].ToString();
                        where_sql = where_sql.Replace("[LOG_KEY]", m905_key);
                        select_sql = select_sql.Replace("[LOG_KEY]", m905_key);
                        if (update_sql.IndexOf("SQL=") == 0)
                        {
                            update_sql = update_sql.Replace("SQL=", "");
                            #region 获取传入的参数值 并校验 参数的准确性
                            /*获取传入的参数值 并校验 参数的准确性 */
                            for (int i = 0; i < dt_m10601.Rows.Count; i++)
                            {
                                string col = dt_m10601.Rows[i]["COL"].ToString();

                                MatchCollection colls = Fun.getAllHyperLinks(body, "<" + col + ">", "</" + col + ">");

                                string data = string.Empty;
                                if (colls != null && colls.Count > 0)
                                {
                                    data = Fun.getAllHyperLinks(body, "<" + col + ">", "</" + col + ">")[0].Value;
                                }

                                string NECESSARY = dt_m10601.Rows[i]["NECESSARY"].ToString();
                                if (NECESSARY == "1" && (data == "" || data == null))
                                {
                                    li_db = -1;
                                    ReturnCode = "1";
                                    ReturnMessage = col + ":字段不允许为空 ";
                                    break;
                                }
                                dt_m10601.Rows[i]["col_data"] = data;
                                update_sql = update_sql.Replace("[" + col + "]", data);
                            }
                            #endregion


                            DataTable dt_sql = new DataTable();
                            db.ExcuteDataTable(dt_sql, update_sql, CommandType.Text);
                            update_sql = dt_sql.Rows[0][0].ToString();

                        }

                        if (update_sql.IndexOf("M107_KEY=") == 0)
                        {
                            #region 处理 M107

                            // --先 M106 从M10601找列  替换到M107的Get_SQL 然后用Get_SQl 的数据替换 sendxml的数据 作为请求 
                            //--请求的结果在日志表M10702中  如果成功以后执行 update_sql 组 M106的返回包  
                            string M107_KEY = update_sql.Replace("M107_KEY=", "");
                            DataTable dt_m107 = new DataTable();
                            string Sql = "Select t.* from M107 t where m107_key=" + M107_KEY;
                            db.ExcuteDataTable(dt_m107, Sql, CommandType.Text);
                            if (dt_m107.Rows.Count == 0)
                            {

                                ReturnCode = "1";
                                ReturnMessage = "M107_KEY=" + M107_KEY + "不存在 ";

                            }
                            else
                            {
                                #region 开始处理 M107
                                string Get_Sql = dt_m107.Rows[0]["GET_SQL"].ToString();
                                string Update_SQL = dt_m107.Rows[0]["UPDATE_SQL"].ToString();


                                /*格式化SQL*/
                                #region 获取传入的参数值 并校验 参数的准确性
                                /*获取传入的参数值 并校验 参数的准确性 */
                                for (int i = 0; i < dt_m10601.Rows.Count; i++)
                                {
                                    string col = dt_m10601.Rows[i]["COL"].ToString();

                                    MatchCollection colls = Fun.getAllHyperLinks(body, "<" + col + ">", "</" + col + ">");

                                    string data = string.Empty;
                                    if (colls != null && colls.Count > 0)
                                    {
                                        data = Fun.getAllHyperLinks(body, "<" + col + ">", "</" + col + ">")[0].Value;
                                    }

                                    string NECESSARY = dt_m10601.Rows[i]["NECESSARY"].ToString();
                                    if (NECESSARY == "1" && (data == "" || data == null))
                                    {
                                        li_db = -1;
                                        ReturnCode = "1";
                                        ReturnMessage = col + ":字段不允许为空 ";
                                        break;
                                    }
                                    dt_m10601.Rows[i]["col_data"] = data;

                                    Get_Sql = Get_Sql.Replace("[" + col + "]", data);
                                    Update_SQL = Update_SQL.Replace("[" + col + "]", data);
                                    where_sql = where_sql.Replace("[" + col + "]", data);
                                    select_sql = select_sql.Replace("[" + col + "]", data);

                                }
                                #endregion

                                if (li_db != -1)
                                {
                                    #region 写M905日志
                                    string log_sql = "Insert into M905(M905_KEY,SEND_XML,enter_date,BPID)";
                                    log_sql = log_sql + " Select " + m905_key + ",'" + RequestXml + "',sysdate,'" + BPID + "' from dual";
                                    db.BeginTransaction();
                                    li_db = db.ExecuteNonQuery(log_sql, CommandType.Text);
                                    if (li_db < 0)
                                    {
                                        ReturnCode = "1";
                                        ReturnMessage = "M905日志失败 ";
                                        db.Rollback();
                                    }
                                    else
                                    {
                                        /*开始执行sql*/
                                        db.Commit();
                                    }
                                    #endregion
                                    Get_Sql = Get_Sql.Replace("[M905_KEY]", m905_key);
                                    Update_SQL = Update_SQL.Replace("[M905_KEY]", m905_key);
                                    if (li_db != -1)
                                    {
                                        #region 处理M107
                                        string m107_send_xml = dt_m107.Rows[0]["send_xml"].ToString();
                                        DataTable dt_send = new DataTable();
                                        db.ExcuteDataTable(dt_send, Get_Sql, CommandType.Text);






                                        if (dt_send.Rows.Count != 1)
                                        {
                                            ReturnCode = "1";
                                            ReturnMessage = "M107_KEY=" + M107_KEY + " ,GET_SQL错误 ";

                                        }
                                        else
                                        {
                                            string CHECKMSG = "";
                                            try
                                            {
                                                CHECKMSG = dt_send.Rows[0]["CHECKMSG"].ToString();
                                            }
                                            catch
                                            {
                                                CHECKMSG = "";
                                            }
                                            if (CHECKMSG.Length <= 1)
                                            {
                                                string M107_type = dt_m107.Rows[0]["M107_TYPE"].ToString();
                                                string m107_http = dt_m107.Rows[0]["LINK_URL"].ToString();
                                                bool lb_open = false;
                                                string receivexml_ = "";

                                                // if M107_type == "SOCKET" 

                                                #region 组HTTP包
                                                string sendxml_ = m107_send_xml;
                                                for (int c = 0; c < dt_send.Columns.Count; c++)
                                                {
                                                    string col_data = dt_send.Rows[0][c].ToString();
                                                    string col = dt_send.Columns[c].ColumnName.ToUpper();
                                                    sendxml_ = sendxml_.Replace("[" + col + "]", col_data);
                                                }

                                                #endregion
                                                #region 发送http请求
                                                if (M107_type == "WEBSERVICES")
                                                {
                                                    try
                                                    {
                                                        string url = m107_http;//wsdl地址

                                                        string name = Fun.getAllHyperLinks(sendxml_, "<Method>", "</Method>")[0].Value; //javaWebService开放的接口  
                                                        int ccount = int.Parse(Fun.getAllHyperLinks(sendxml_, "<ParmCount>", "</ParmCount>")[0].Value);
                                                        TPSVService.WebServiceProxy wsd = new TPSVService.WebServiceProxy(url, name);
                                                        string[] str = new string[ccount];
                                                        for (int rr_ = 0; rr_ < ccount; rr_++)
                                                        {
                                                            str[rr_] = Fun.getAllHyperLinks(sendxml_, "<P" + rr_.ToString() + ">", "</P" + rr_.ToString() + ">")[0].Value;
                                                        }

                                                        receivexml_ = (string)wsd.ExecuteQuery(name, str).ToString();
                                                        lb_open = true;
                                                    }
                                                    catch (Exception ex)
                                                    {
                                                        lb_open = false;
                                                    }

                                                    if (lb_open == false)
                                                    {
                                                        ReturnCode = "1";
                                                        ReturnMessage = "M107_KEY=" + M107_KEY + "发送请求失败 ";

                                                    }
                                                    else
                                                    {
                                                        ReturnMessage = "";
                                                    }
                                                }

                                                if (M107_type == "HTTP" || M107_type == "HTTP_GET")
                                                {
                                                    Bm.HttpRequest http_ = new Bm.HttpRequest();
                                                    http_.CharacterSet = "utf-8";
                                                    http_.RequestUriString = m107_http;
                                                    if (M107_type == "HTTP_GET")
                                                    {
                                                        lb_open = http_.OpenRequest(m107_http + "?" + sendxml_, m107_http + "?" + sendxml_);
                                                    }
                                                    else
                                                    {
                                                        lb_open = http_.OpenRequest(m107_http, m107_http, sendxml_);
                                                    }
                                                    if (lb_open == false)
                                                    {
                                                        ReturnCode = "1";
                                                        ReturnMessage = "M107_KEY=" + M107_KEY + "发送请求失败 ";

                                                    }
                                                    else
                                                    {
                                                        receivexml_ = http_.HtmlDocument;
                                                    }
                                                }
                                                if (M107_type == "SOCKET")
                                                {
                                                    lb_open = true;
                                                    try
                                                    {
                                                        Socket client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);

                                                        string[] ipport = m107_http.Split(':');


                                                        IPEndPoint ie = new IPEndPoint(IPAddress.Parse(ipport[0]), int.Parse(ipport[1]));//服务器的IP和端口

                                                        client.Connect(ie);

                                                        client.Send(Encoding.Default.GetBytes(sendxml_));

                                                        byte[] data1 = new byte[1024];
                                                        int recv = client.Receive(data1);
                                                        string stringdata = Encoding.Default.GetString(data1, 0, recv);


                                                        receivexml_ = stringdata;
                                                    }
                                                    catch (Exception ex)
                                                    {
                                                        lb_open = false;
                                                        ReturnCode = "1";
                                                        ReturnMessage = "M107_KEY=" + M107_KEY + "发送请求失败 :" + ex.Message;
                                                    }

                                                }


                                                if (lb_open == true)
                                                {

                                                    #region 执行 http请求以后 的处理

                                                    string m10702_key = save_log(M107_KEY, sendxml_, receivexml_, "0");
                                                    Update_SQL = Update_SQL.Replace("[M10702_KEY]", m10702_key);


                                                    db.BeginTransaction();
                                                    li_db = db.ExecuteNonQuery(Update_SQL, CommandType.Text);
                                                    if (li_db < 0)
                                                    {
                                                        li_db = -1;
                                                        ReturnCode = "1";
                                                        ReturnMessage += "Deal failed";
                                                        db.Rollback();
                                                        //  break;

                                                    }
                                                    else
                                                    {
                                                        db.Commit();
                                                        log_sql = "Select t.XML_RES,t.XML_MSG from M905 t where M905_KEY = " + m905_key;
                                                        DataTable dt_m905 = new DataTable();
                                                        db.ExcuteDataTable(dt_m905, log_sql, CommandType.Text);
                                                        ReturnCode = dt_m905.Rows[0]["XML_RES"].ToString();
                                                        ReturnMessage += dt_m905.Rows[0]["XML_MSG"].ToString();
                                                    }
                                                    #endregion

                                                    string selSq = select_sql + " " + where_sql;
                                                    db.ExcuteDataTable(dt_resp, selSq, CommandType.Text);
                                                }
                                                #endregion
                                            }
                                            else
                                            {
                                                ReturnCode = "1";
                                                ReturnMessage = CHECKMSG;
                                            }
                                        }
                                        #endregion
                                    }
                                }
                                #endregion
                            }

                            #endregion

                        }
                        else
                        {
                            where_sql = where_sql.Replace("[LOG_KEY]", m905_key);
                            select_sql = select_sql.Replace("[LOG_KEY]", m905_key);

                            #region 获取传入的参数值 并校验 参数的准确性
                            /*获取传入的参数值 并校验 参数的准确性 */
                            for (int i = 0; i < dt_m10601.Rows.Count; i++)
                            {
                                string col = dt_m10601.Rows[i]["COL"].ToString();

                                MatchCollection colls = Fun.getAllHyperLinks(body, "<" + col + ">", "</" + col + ">");

                                string data = string.Empty;
                                if (colls != null && colls.Count > 0)
                                {
                                    data = Fun.getAllHyperLinks(body, "<" + col + ">", "</" + col + ">")[0].Value;
                                }

                                string NECESSARY = dt_m10601.Rows[i]["NECESSARY"].ToString();
                                if (NECESSARY == "1" && (data == "" || data == null))
                                {
                                    li_db = -1;
                                    ReturnCode = "1";
                                    ReturnMessage = col + ":字段不允许为空 ";
                                    break;
                                }
                                dt_m10601.Rows[i]["col_data"] = data;

                                where_sql = where_sql.Replace("[" + col + "]", data);
                                select_sql = select_sql.Replace("[" + col + "]", data);
                                update_sql = update_sql.Replace("[" + col + "]", data);
                            }
                            #endregion

                            dt_m106.Rows[0]["WHERE_SQL_N"] = where_sql;
                            dt_m106.Rows[0]["SELECT_SQL_N"] = select_sql;

                            #region

                            string log_sql = "Insert into M905(M905_KEY,SEND_XML,enter_date,BPID)";
                            log_sql = log_sql + " Select " + m905_key + ",'" + RequestXml + "',sysdate,'" + BPID + "' from dual";
                            db.BeginTransaction();
                            li_db = db.ExecuteNonQuery(log_sql, CommandType.Text);
                            if (li_db < 0)
                            {
                                #region
                                li_db = -1;
                                ReturnCode = "1";
                                ReturnMessage += "Deal failed";
                                db.Rollback();
                                //  break;
                                #endregion
                            }
                            else
                            {
                                /*开始执行sql*/
                                db.Commit();
                                #region 处理 update_SQL
                                if (update_sql.Length > 10)
                                {
                                    exec_sql = update_sql;
                                    update_sql = update_sql.Replace("[LOG_KEY]", m905_key);
                                    db.BeginTransaction();
                                    try
                                    {
                                        li_db = db.ExecuteNonQuery(update_sql, CommandType.Text);
                                        if (li_db < 0)
                                        {
                                            li_db = -1;
                                            ReturnCode = "1";
                                            ReturnMessage += "Deal failed";
                                            db.Rollback();
                                            //  break;

                                        }
                                        else
                                        {
                                            db.Commit();
                                            log_sql = "Select t.XML_RES,t.XML_MSG from M905 t where M905_KEY = " + m905_key;
                                            DataTable dt_m905 = new DataTable();
                                            db.ExcuteDataTable(dt_m905, log_sql, CommandType.Text);
                                            ReturnCode = dt_m905.Rows[0]["XML_RES"].ToString();
                                            ReturnMessage += dt_m905.Rows[0]["XML_MSG"].ToString();
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        db.Rollback();
                                        li_db = -1;
                                        ReturnCode = "1";
                                        ReturnMessage = GetOracleMsg(ex.Message);
                                    }
                                }
                                #endregion
                                string selSq = select_sql + " " + where_sql;
                                db.ExcuteDataTable(dt_resp, selSq, CommandType.Text);
                                /* 和 组成要返回的xm*/

                            }
                            #endregion

                        }


                    }
                }
            }
            catch (Exception ex)
            {
                li_db = -1;
                ReturnCode = "1";
                ReturnMessage = "错误格式的XML" + ex.Message;
                ReturnMessage = GetOracleMsg(ex.Message);
                //  ReturnCode = "2";
                //   ReturnMessage = "Part of the process is successful";
            }
            try
            {

                string ls_url = SetXml();
                /* if (ls_url != null && ls_url != "")
                {
                    Response.Redirect(ls_url);
                }
                else
                {
                    Response.Write(ResponseXml);
                }
                 */
                Response.Write(ResponseXml);
            }
            catch
            {
                Response.Write(ResponseXml);
            }

        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }

    }


    //获取传入的表头数据
    public static string getStrByIndex(String text, String s, String e)
    {
        string v = "";
        int pos1 = text.IndexOf(s);
        if (pos1 < 0)
        {
            return "";
        }
        string ri = text.Substring(pos1 + s.Length);
        pos1 = ri.IndexOf(e);
        if (pos1 < 0)
        {
            v = ri;
        }
        else
        {
            v = ri.Substring(0, pos1);
        }
        return v;
    }
    public static string GetOracleMsg(string msg_)
    {
        string result = msg_.Replace("\n", ";").Replace("'", "\"");

        if (msg_.IndexOf("ORA-") >= 0)
        {
            result = getStrByIndex(result, "ORA-", "ORA-");
            result = getStrByIndex(result, ":", ";");
            return result;
        }
        else
        {
            return result;
        }

        return result;

    }

    public void getRequestHead(string head_xml)
    {
        try
        {
            TransactionID = Fun.getAllHyperLinks(head_xml, "<TransactionID>", "</TransactionID>")[0].Value;
            Version = Fun.getAllHyperLinks(head_xml, "<Version>", "</Version>")[0].Value;
            MessageName = Fun.getAllHyperLinks(head_xml, "<MessageName>", "</MessageName>")[0].Value;
            TestFlag = Fun.getAllHyperLinks(head_xml, "<TestFlag>", "</TestFlag>")[0].Value;
        }
        catch
        {
            ReturnCode = "1";
            ReturnMessage = "Deal failed";
            li_db = -1;
        }
    }

    public Boolean checkClient(string BPID_, string clientip_)
    {
        DataTable dt_m025 = new DataTable();
        string sql = "Select f_check_client('" + BPID_ + "','" + clientip_ + "') as c from dual ";
        int lidb = db.ExcuteDataTable(dt_m025, sql, CommandType.Text);
        if (lidb < 0)
        {
            return false;
        }
        if (dt_m025.Rows.Count == 0)
        {
            return false;
        }
        if (dt_m025.Rows[0][0].ToString() != "1")
        {
            return true;
        }

        return true;

    }


    public string getpicstring(string filename)
    {
        // 使用文件流构造一个二进制读取器将基元数据读作二进制值

        string ls_file = Server.MapPath(filename);
        if (File.Exists(ls_file))
        {
            FileStream fs = new FileStream(ls_file, FileMode.Open);
            BinaryReader br = new BinaryReader(fs);
            byte[] imageBuffer = new byte[br.BaseStream.Length];
            br.Read(imageBuffer, 0, Convert.ToInt32(br.BaseStream.Length));
            string textString = System.Convert.ToBase64String(imageBuffer);
            fs.Close();
            br.Close();

            return textString;
        }
        return "";
    }

    //获取传入的表头数据



    public void getM106(string M106_ID)
    {
        string sql = "Select t.* , t.SELECT_SQL as  SELECT_SQL_N, t.WHERE_SQL as WHERE_SQL_N  from M106 t where t.M106_ID='" + M106_ID + "'";
        db.ExcuteDataTable(dt_m106, sql, CommandType.Text);
        if (dt_m106.Rows.Count > 0)
        {
            sql = "Select t.*,t.DESCRIPTION  as col_data from M10601 t where t.M106_KEY=" + dt_m106.Rows[0]["M106_KEY"];
            db.ExcuteDataTable(dt_m10601, sql, CommandType.Text);

            sql = "Select t.* from M10602 t where t.M106_KEY=" + dt_m106.Rows[0]["M106_KEY"];
            db.ExcuteDataTable(dt_m10602, sql, CommandType.Text);
        }


    }
    public void save_request()
    {
        /*写日志*/
        DataTable dt_key = new DataTable();
        string ContentLength = Request.ContentLength.ToString();
        string ContentEncoding = Request.ContentEncoding.EncodingName;
        string UserAgent = Request.UserAgent;
        string UserHostAddress = Request.UserHostAddress;
        string UserHostName = Request.UserHostName;
        string TotalBytes = Request.TotalBytes.ToString();

        string sql_key = "Select S_M907.Nextval as c from dual ";
        db.ExcuteDataTable(dt_key, sql_key, CommandType.Text);
        M907_key = dt_key.Rows[0][0].ToString();
        string sql = "Insert into M907(M907_KEY,clientip,ContentLength,ContentEncoding,UserAgent,UserHostAddress,UserHostName,TotalBytes,ENTER_DATE)";
        sql = sql + " Select " + M907_key + " ,'" + clientip + "'," + ContentLength + ",'" + ContentEncoding + "','"
            + UserAgent + "','" + UserHostAddress + "','"
            + UserHostName + "'," + TotalBytes + ",sysdate from dual ";

        db.BeginTransaction();
        li_db = db.ExecuteNonQuery(sql, CommandType.Text);
        if (li_db < 0)
        {
            db.Rollback();
        }
        else
        {
            db.Commit();
        }

    }


    public string SetXml()
    {

        System.Xml.XmlDocument doc = new XmlDocument();
        System.Xml.XmlDocument savedoc = new XmlDocument();
        System.Xml.XmlDeclaration declare = doc.CreateXmlDeclaration("1.0", "UTF-8", null);
        doc.InsertBefore(declare, doc.DocumentElement);
        XmlElement rootnode = doc.CreateElement("MIAP");


        XmlElement headNode = doc.CreateElement("MIAP-Header");

        XmlElement TransactionID_Node = doc.CreateElement("TransactionID");
        TransactionID_Node.InnerText = TransactionID;
        headNode.AppendChild(TransactionID_Node);

        XmlElement Version_Node = doc.CreateElement("Version");
        Version_Node.InnerText = Version;
        headNode.AppendChild(Version_Node);


        XmlElement MessageName_Node = doc.CreateElement("MessageName");
        MessageName_Node.InnerText = MessageName.Replace("Req", "Resp");
        headNode.AppendChild(MessageName_Node);


        XmlElement TestFlag_Node = doc.CreateElement("TestFlag");
        TestFlag_Node.InnerText = TestFlag;
        headNode.AppendChild(TestFlag_Node);

        XmlElement ReturnCode_Node = doc.CreateElement("ReturnCode");
        ReturnCode_Node.InnerText = ReturnCode;
        headNode.AppendChild(ReturnCode_Node);


        XmlElement ReturnMessage_Node = doc.CreateElement("ReturnMessage");
        ReturnMessage_Node.InnerText = ReturnMessage;
        headNode.AppendChild(ReturnMessage_Node);

        rootnode.AppendChild(headNode);


        XmlElement bodyNode = doc.CreateElement("MIAP-Body");



        string MessageName_Resp = MessageName.Replace("Req", "Resp");
        /*根据记录集返回数据*/
        for (int i = 0; i < dt_resp.Rows.Count; i++)
        {
            XmlElement Resp_Node = doc.CreateElement(MessageName_Resp);
            for (int c = 0; c < dt_resp.Columns.Count; c++)
            {
                string col_id = dt_resp.Columns[c].ColumnName;

                XmlElement colNode = doc.CreateElement(col_id);
                string col_data = dt_resp.Rows[i][c].ToString();
                if (col_data == null)
                {
                    col_data = "";
                }
                if (col_id.ToUpper().IndexOf("PIC_") == 0)
                {
                    colNode.InnerText = getpicstring(col_data);
                }
                else
                {
                    colNode.InnerText = col_data;
                }

                Resp_Node.AppendChild(colNode);
            }
            bodyNode.AppendChild(Resp_Node);
        }


        rootnode.AppendChild(bodyNode);

        doc.AppendChild(rootnode);

        ResponseXml = doc.OuterXml;

        ResponseXml = ResponseXml.Replace("&lt;", "<");
        ResponseXml = ResponseXml.Replace("&gt;", ">");

     
        string yyyymmdd = DateTime.Now.ToString("yyyyMMdd");
        string path = Server.MapPath("\\XML_LOG\\" + yyyymmdd);
        string filename = Guid.NewGuid().ToString() + ".xml";
        string ls_url = Fun.GetIndexUrl() + "XML_LOG/" + yyyymmdd + "/" + filename;
        //log_sql = log_sql + " Select ,'" + RequestXml + "','" + yyyymmdd + "\\" + filename + "',sysdate from dual ";
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }
        string log_sql = "update  M905 set M907_KEY= " + M907_key + ", RECEIVE_FILE ='" + yyyymmdd + "\\" + filename + "', modi_date= sysdate where m905_key=" + m905_key;

        db.BeginTransaction();
        int li_db = db.ExecuteNonQuery(log_sql, CommandType.Text);
        if (li_db < 0)
        {
            db.Rollback();
        }
        else
        {
            db.Commit();
        }
        doc.Save(path + "\\" + filename);
        return ls_url;
    }


    private string save_log(string m107_key_, string sendxml_, string receivexml_, string mobileno_)
    {

        /*写日志*/
        DataTable dt_key = new DataTable();
        string sql_key = "Select S_M10702.Nextval as c from dual ";
        db.ExcuteDataTable(dt_key, sql_key, CommandType.Text);
        string M10702_KEY_ = dt_key.Rows[0][0].ToString();

        OracleParameter[] parmeters =
            {
                new  System.Data.OracleClient.OracleParameter("m10702_key_", OracleType.LongVarChar,4000),
                new  System.Data.OracleClient.OracleParameter("m107_key_", OracleType.LongVarChar,4000),
                new  System.Data.OracleClient.OracleParameter("xml_key_", OracleType.LongVarChar,4000),
                new  System.Data.OracleClient.OracleParameter("send_xml_", OracleType.LongVarChar,4000),
                new  System.Data.OracleClient.OracleParameter("xmlreceive_", OracleType.LongVarChar,30000),
                new  System.Data.OracleClient.OracleParameter("m905_key_", OracleType.LongVarChar,4000)
              };

        parmeters[0].Direction = ParameterDirection.Input;
        parmeters[1].Direction = ParameterDirection.Input;
        parmeters[2].Direction = ParameterDirection.Input;
        parmeters[3].Direction = ParameterDirection.Input;
        parmeters[4].Direction = ParameterDirection.Input;
        parmeters[5].Direction = ParameterDirection.Input;


        parmeters[0].Value = M10702_KEY_;
        parmeters[1].Value = m107_key_;
        parmeters[2].Value = mobileno_;
        parmeters[3].Value = sendxml_.Replace("'", "{");
        parmeters[4].Value = receivexml_.Replace("'", "{");
        parmeters[5].Value = m905_key;

        db.BeginTransaction();
        int i = db.ExecuteNonQuery("Proc_Insert_m10702_", parmeters);
        if (i < 0)
        {
            db.Rollback();
        }
        else
        {
            db.Commit();
        }






        //string sql = "Insert into M10702(M10702_KEY,M107_KEY,XML_KEY,SEND_XML,RECEIVE_XML,ENTER_DATE,M905_KEY)";
        //sql = sql + " Select " + M10702_KEY_ + " ," + m107_key_ + ",'" + mobileno_ + "','" + sendxml_.Replace("'", "{") + "','" + receivexml_.Replace("'", "{") + "',sysdate," + m905_key + " from dual ";

        //db.BeginTransaction();
        //li_db = db.ExecuteNonQuery(sql, CommandType.Text);
        //if (li_db < 0)
        //{
        //    db.Rollback();
        //}
        //else
        //{
        //    db.Commit();
        //}





        return M10702_KEY_;

    }
}
