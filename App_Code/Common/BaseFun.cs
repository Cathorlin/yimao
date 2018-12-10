using Newtonsoft.Json;
using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using Base;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Text;
using System.Globalization;
using System.Security.Cryptography;
using System.Xml;
using System.Data.OracleClient;
using System.IO;
using Newtonsoft.Json.Linq;
using System.Net;
using System.Net.Sockets;
using System.Threading;
// ://localhost/Bin/Newtonsoft.Json.dll.refresh
/// <summary>
/// BaseFun 的摘要说明

/// </summary>
public class BaseFun
{
    public db20120229 db = new db20120229();
    public string A007_KEY = ""; //登录的用户key
    public string A30001_KEY = "";//当前登录用户的日志KEY
    public int SW;
    public int SH;
    public string enablefontcolor =  BaseMsg.getMsg("M0019");// "color:#C0C0C0";
    private BaseMsg usermsg = new BaseMsg();
    
    public BaseFun()
    {
          
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    //获取配置的 值 用CFG_前缀
    public  string GetDbName ()
    {
                 return db.data_source;
       
    }
    public string format_u_name(string col_value)
    {
        return format_u_name(col_value, "9");
    }
    public string format_u_name(string col_value, string  col_precision)
    {
        int user_dec = int.Parse( col_precision) ;
        int user_dec_ =int.Parse(GlobeAtt.GetValue("USER_DEC"));  ;
        if (user_dec < user_dec_)
        {
            user_dec = user_dec_;
        }

        try
        {
            decimal d = decimal.Round(decimal.Parse(col_value), user_dec);
            return d.ToString();
        }
        catch
        {
            return col_value;
        }
        return col_value;
    }

    public string Set_Item_Value(string name_ ,string  value_,string attr_)
    {
           OracleParameter[] parmeters =
           {
                new OracleParameter("name_", OracleType.NVarChar,500),
                new OracleParameter("value_", OracleType.NVarChar,500),
                new OracleParameter("attr_", OracleType.NVarChar,4000)            
           };
           parmeters[0].Direction = ParameterDirection.Input;
           parmeters[1].Direction = ParameterDirection.Input;
           parmeters[2].Direction = ParameterDirection.InputOutput;
           parmeters[0].Value = name_;
           parmeters[1].Value = value_;
           parmeters[2].Value = attr_;

           db.db_oracle.ExecuteNonQuery("client_sys.Set_Item_Value", parmeters);
           return parmeters[2].Value.ToString() ;    
    }

    public void save_eve_time(string eve_name)
    {
        string sql = "begin pkg_a.set_do_time('" + eve_name + "'); end ;";
        execSqlOnly(sql);
    }
    public string Set_Item_Value(string name_, DateTime value_, string attr_)
    {
        OracleParameter[] parmeters =
           {
                new OracleParameter("name_", OracleType.NVarChar,500),
                new OracleParameter("value_", OracleType.NVarChar,500),
                new OracleParameter("attr_", OracleType.NVarChar,4000)            
           };
        parmeters[0].Direction = ParameterDirection.Input;
        parmeters[1].Direction = ParameterDirection.Input;
        parmeters[2].Direction = ParameterDirection.InputOutput;
        parmeters[0].Value = name_;
        parmeters[1].Value = value_;
        parmeters[2].Value = attr_;
        db.db_oracle.ExecuteNonQuery("client_sys.Set_Item_Value", parmeters);

        return parmeters[2].Value.ToString();
    }
    public string Set_Item_Value(string name_, Double value_, string attr_)
    {
        OracleParameter[] parmeters =
           {
                new OracleParameter("name_", OracleType.NVarChar,500),
                new OracleParameter("value_", OracleType.Double,500),
                new OracleParameter("attr_", OracleType.NVarChar,4000)            
           };
        parmeters[0].Direction = ParameterDirection.Input;
        parmeters[1].Direction = ParameterDirection.Input;
        parmeters[2].Direction = ParameterDirection.InputOutput;
        parmeters[0].Value = name_;
        parmeters[1].Value = value_;
        parmeters[2].Value = attr_;
                   db.db_oracle.ExecuteNonQuery("client_sys.Set_Item_Value", parmeters);

        return parmeters[2].Value.ToString();
    }
    public  static string  GetOracleMsg(string msg_)
    {
        string result =  msg_.Replace("\n", ";").Replace("'", "\"");
       // BS_ORA
        if (GlobeAtt.GetValue("MSG_ORA") != "0")
        {
            if (msg_.IndexOf("ORA-") >= 0)
            {
                result = getStrByIndex(result, "ORA-", "ORA-");
                result = getStrByIndex(result, ":", ";");
                return  result.Trim();
            }
            else
            {
                return result;
            }
        }
        return result;
        
    }
    //   string log_sql = "pkg_a.saveQuerySql('" + GlobeAtt.A007_KEY + "', '" + a00201_key + "' , '" + data_sql.Replace("'", "''") + "','"+ main_key_value+"' ) ";

    public string saveQuerySql(string a00201_key, string data_sql, string main_key_value, string option)
    {

        OracleParameter[] parmeters =
           {
                new OracleParameter("User_Id_", OracleType.VarChar,500),
                new OracleParameter("A00201_Key_", OracleType.VarChar,500),
                new OracleParameter("Sql_", OracleType.LongVarChar,300000),
                new OracleParameter("Mainkey_", OracleType.VarChar,200),
                new OracleParameter("Option_", OracleType.VarChar,200)
           };
        parmeters[0].Direction = ParameterDirection.Input;
        parmeters[1].Direction = ParameterDirection.Input;
        parmeters[2].Direction = ParameterDirection.Input;
        parmeters[3].Direction = ParameterDirection.Input;
        parmeters[4].Direction = ParameterDirection.Input;
      
        parmeters[0].Value = GlobeAtt.A007_KEY;
        parmeters[1].Value = a00201_key;
        parmeters[2].Value = data_sql;
        parmeters[3].Value = main_key_value;
        parmeters[4].Value = option;

        db.db_oracle.ExecuteNonQuery("pkg_log.save_a00601", parmeters);
        return "1";
    }

    // PROCEDURE ITEMCHANGE__(column_id_ varchar2 , ROWLIST_ VARCHAR2,USER_ID_ VARCHAR2,A311_KEY_ VARCHAR2)
    public string ItemChange(string pkg_name, string column_id_, string MAINROWLIST_, string ROWLIST_, string user_id_)
    {

            OracleParameter[] parmeters =
           {
                new OracleParameter("COLUMN_ID_", OracleType.LongVarChar,500),
                new OracleParameter("MAINROWLIST_", OracleType.LongVarChar,30000),
                new OracleParameter("ROWLIST_", OracleType.LongVarChar,30000),
                new OracleParameter("USER_ID_", OracleType.NVarChar,200),
                new OracleParameter("OUTROWLIST_", OracleType.LongVarChar,30000)
           };
            parmeters[0].Direction = ParameterDirection.Input;
            parmeters[1].Direction = ParameterDirection.Input;
            parmeters[2].Direction = ParameterDirection.Input;
            parmeters[3].Direction = ParameterDirection.Input;
            parmeters[4].Direction = ParameterDirection.Output;
            string OUTROWLIST_ = "";
            parmeters[0].Value = column_id_;
            parmeters[1].Value = MAINROWLIST_;
            parmeters[2].Value = ROWLIST_;
            parmeters[3].Value = user_id_;
            parmeters[4].Value = OUTROWLIST_;

            db.db_oracle.ExecuteNonQuery(pkg_name + ".ITEMCHANGE__", parmeters);

            return parmeters[4].Value.ToString();

    
    }


    public string Get_Item_Value(string name_,  string attr_)
    {
        string sql = "select client_sys.Get_Item_Value('"+name_ + "','" + attr_.Replace("'","''") + "')  as c from dual";
        DataTable dt = new DataTable();
        dt = getDtBySql(sql);
        return dt.Rows[0][0].ToString();
    }


    public string getA022Name(string a022_id)
    {
     
        string sql = "Select t.* from a022 t where t.a022_id='" + a022_id + "'";

        DataTable dt = new DataTable();
        dt = getDtBySql(sql);
        string sql_ = dt.Rows[0]["a022_name"].ToString();
        try
        {
            sql_ = sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
            sql_ = sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            sql_ = sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
        }
        catch
        {
            sql_ = dt.Rows[0]["a022_name"].ToString();

        }
        return sql_;
    }
    public string getProcData(string sql, string table_id_)
    {
        string sql_ = sql;
        string exec_sql = "";
        try
        {
            sql_ = sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
            sql_ = sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            sql_ = sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
        }
        catch
        {
            sql_ = sql;
        }
        string LOG_KEY = "";
        string log_table = "A314";
        string str_sql = "Select s_" + log_table + ".nextval as c from dual";
        DataTable dt = new DataTable();
        int li_db = db.ExcuteDataTable(dt, str_sql, CommandType.Text);
        if (li_db < 0)
        {
            return "01" + BaseMsg.getMsg("M0003");
        }
        LOG_KEY = dt.Rows[0][0].ToString();
        sql_ = sql_.Replace("[" + log_table + "_KEY]", LOG_KEY);
        sql_ = sql_.Replace("[A311_KEY]", LOG_KEY);
        exec_sql = sql_;
        sql_ = sql_.Replace("'", "''");
       
        if (sql.Length > 3000)
        {
            if (sql_.Substring(2998, 1) == "'")
            {
                sql_ = sql_.Substring(0, 2997) + "..";
            }
            else
            {
                sql_ = sql_.Substring(0, 2998) + "..";
            }
        }
        if (GlobeAtt.BS_LOG_SQL != "1")
        {
            sql = "";
        }
        str_sql = "Insert into A314(A314_KEY,A314_ID,A314_NAME,STATE,ENTER_USER,ENTER_DATE,RES,table_objid,A014_ID,table_id)";
        str_sql = str_sql + " SELECT " + LOG_KEY + ",'" + GlobeAtt.A002_KEY + "','" + sql_ + "','0','" + GlobeAtt.A007_KEY + "',sysdate,'0','','','" + table_id_ + "' from dual";

        db.BeginTransaction();
        li_db = db.ExecuteNonQuery(str_sql, CommandType.Text);
        if (li_db < 0)
        {
            db.Rollback();
            return "-1" ;
        }
        db.Commit();

        db.BeginTransaction();

        li_db = db.ExecuteNonQuery(exec_sql, CommandType.Text);
        if (li_db < 0)
        {
            db.Rollback();
            return "-1";
        }    
        db.Commit();
        str_sql = "Select t.* from A314 t where t.A314_KEY=" + LOG_KEY;
        DataTable dt_log = new DataTable();
        li_db = db.ExcuteDataTable(dt_log, str_sql, CommandType.Text);
        if (li_db < 0 || dt_log.Rows.Count == 0 )
        {
            return "-1";
        }
        if (GlobeAtt.BS_LOG_A314 != "1")
        {
            sql = "delete from a314 t where t.a314_key=" + LOG_KEY;
            execSqlOnly(sql);
        }

        return dt_log.Rows[0]["RES"].ToString();
    
    }

    public DataTable getDtBySql(string sql)
    {   
        string sql_=sql;
        DataTable dt = new DataTable();
        try
        {
          
            sql_ = sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
            sql_ = sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            sql_ = sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);

           // DateTime ld = DateTime.Now;
            int li_db = db.ExcuteDataTable(dt, sql_, CommandType.Text);
           // double le = (DateTime.Now - ld).TotalSeconds;
           // SaveLog.Verification(le.ToString("0.000") + ":" + sql);
        }
        catch
        {
            sql_ = sql;
        }
       

        return dt;
    }
    /// <summary>
    /// 获取功能的属性

    /// </summary>
    /// <param name="a00201_key"></param>
    /// <returns></returns>
    public DataTable getA0130101(string a00201_key)
    {

        string sql = "Select PKG_SHOW.getA0130101(" + a00201_key + ",'" + GlobeAtt.A007_KEY + "') from dual";
        DataTable dt = new DataTable();
        int li_db = db.ExcuteDataTable(dt, sql, CommandType.Text);
        sql = dt.Rows[0][0].ToString();
        return getDtBySql(sql);
    }
     /// <summary>
    /// 获取列的属性

    /// </summary>
    /// <param name="a00201_key"></param>
    /// <returns></returns>
    public DataTable getA013010101(string a00201_key)
    {
        string sql = "Select PKG_SHOW.getA013010101('" + a00201_key + "','" + GlobeAtt.A007_KEY + "') from dual";
       // execSqlOnly("PKG_SHOW.pgetA013010101('" + a00201_key + "','" + GlobeAtt.A007_KEY + "')");

        DataTable dt = new DataTable();
        int li_db = db.ExcuteDataTable(dt, sql, CommandType.Text);
        sql = dt.Rows[0][0].ToString();
        DataTable dt_a013010101 = new DataTable();
        dt_a013010101 =   getDtBySql(sql);
        if (dt_a013010101.Rows.Count == 0)
        {
            execSqlOnly("PKG_SHOW.pgetA013010101('" + a00201_key + "','" + GlobeAtt.A007_KEY + "')");
            dt_a013010101 = getDtBySql(sql);
        }
        for (int i=0 ;i < dt_a013010101.Rows.Count;i++)
        {
             dt_a013010101.Rows[i]["COL_ENABLE"] = dt_a013010101.Rows[i]["EV"].ToString().Substring(0,1);
             dt_a013010101.Rows[i]["COL_VISIBLE"] = dt_a013010101.Rows[i]["EV"].ToString().Substring(1,1);
             dt_a013010101.Rows[i]["COL_NECESSARY"] = dt_a013010101.Rows[i]["EV"].ToString().Substring(2,1);
             if (GlobeAtt.LANGUAGE_ID != "CN")
             {
                 dt_a013010101.Rows[i]["COL_TEXT"] = dt_a013010101.Rows[i]["EN_COL_TEXT"];
             }
        }
        return dt_a013010101;
    }

    /// <summary>
    /// 获取查询的列属性

    /// </summary>
    /// <param name="a00201_key"></param>
    /// <returns></returns>
    public DataTable getQueryCondtion(string a00201_key)
    {
        string sql = "Select PKG_SHOW.getQueryCondtion('" + a00201_key + "','" + GlobeAtt.A007_KEY + "') from dual";
        DataTable dt = new DataTable();
        int li_db = db.ExcuteDataTable(dt, sql, CommandType.Text);
        sql = dt.Rows[0][0].ToString();
        DataTable dt_a013010101 = new DataTable();
        dt_a013010101 = getDtBySql(sql);

        for (int i = 0; i < dt_a013010101.Rows.Count; i++)
        {
            dt_a013010101.Rows[i]["COL_ENABLE"] = dt_a013010101.Rows[i]["EV"].ToString().Substring(0, 1);
            dt_a013010101.Rows[i]["COL_VISIBLE"] = dt_a013010101.Rows[i]["EV"].ToString().Substring(1, 1);
            dt_a013010101.Rows[i]["COL_NECESSARY"] = dt_a013010101.Rows[i]["EV"].ToString().Substring(2, 1);

        }
        return dt_a013010101;
    }

    /// <summary>
    /// 获取显示的sql语句
    /// </summary>
    /// <param name="a00201_key"></param>
    /// <returns></returns>
    public string getShowDataSql(string a00201_key)
    {
        DataTable dt_sql = new DataTable();
        dt_sql = getDtBySql("Select pkg_show.getshowdatasql('" + a00201_key + "','" + GlobeAtt.A007_KEY + "') as c from dual ");
       string showdatasql = dt_sql.Rows[0][0].ToString();
        return showdatasql;
    }

    /// <summary>
    /// 获取显示的sql语句
    /// </summary>
    /// <param name="a00201_key"></param>
    /// <returns></returns>
    public string getShowDataCountSql(string a00201_key)
    {
        DataTable dt_sql = new DataTable();
        dt_sql = getDtBySql("Select pkg_show.getShowDataCountSql('" + a00201_key + "','" + GlobeAtt.A007_KEY + "') as c from dual ");
        string showdatasql = dt_sql.Rows[0][0].ToString();
        return showdatasql;
    }


    public int  execSqlOnly(string sqlxml)
    {
        db.BeginTransaction();
        int li_db = db.ExecuteNonQuery(sqlxml, CommandType.Text);
        if (li_db < 0)
        {
            db.Rollback();
            return -1;
        }
        db.Commit();
        return 1;
    }
    public string execSqlList(string sqlxml, string user_id_, string menu_id_, string key_id)
    {
        string log_key = "";
        return execSqlList(sqlxml, user_id_, menu_id_, key_id, "SAVE", "", "","",ref log_key);
    }
    public string execSqlList(string sqlxml, string user_id_, string menu_id_, string key_id, string a014_id_)
    {
        string log_key="";
        return execSqlList(sqlxml, user_id_, menu_id_, key_id, a014_id_, "","", "",ref log_key);
    }
    public string execSqlList(string sqlxml, string user_id_, string menu_id_,string key_id,string a014_id_,string table_id_,string  main_col_v_ ,string SELECTEDROWLIST_ , ref string log_key__ )
    {
        string LOG_KEY = "";
        string log_table = "A311";
        string str_sql = "Select s_" + log_table + ".nextval as c from dual";
        DataTable dt = new DataTable();
        int li_db = db.ExcuteDataTable(dt, str_sql, CommandType.Text);
        if (li_db < 0)
        {
            return "01" + BaseMsg.getMsg("M0003");
        }
        try
        {
           // System.Xml.XmlDocument doc = new XmlDocument();
            string old_index= "--------";
          //  doc.LoadXml(sqlxml.Replace("[","--------"));
            string data_ = "";
         //   XmlNodeList rowsNode = doc.SelectNodes("/DATA/EXECSQL");
         //   int i = 0;
            string[] sqllist = Regex.Split(sqlxml, "<EXECSQL></EXECSQL>", RegexOptions.IgnoreCase);


               
                string sql;
               
                LOG_KEY = dt.Rows[0][0].ToString();
                log_key__ = LOG_KEY;
                sql = sqlxml.Replace("[" + log_table + "_KEY]", LOG_KEY);
                string oldsql = sql;
                sql = sql.Replace("'", "''");
                if (sql.Length > 3000)
                {
                    if (sql.Substring(2998, 1) == "'")
                    {
                        sql = sql.Substring(0, 2997) + "..";
                    }
                    else{
                        sql = sql.Substring(0, 2998) + "..";
                    }
                }
                if (GlobeAtt.BS_LOG_SQL != "1")
                {
                    sql = "";
                }
                str_sql = "Insert into A311(A311_KEY,A311_ID,A311_NAME,STATE,ENTER_USER,ENTER_DATE,RES,table_objid,A014_ID,table_id,A30001_ID,MAIN_KEY,BEGIN_TIME,END_TIME)";
                str_sql = str_sql + " SELECT " + LOG_KEY + ",'" + menu_id_ + "','" + sql + "','0','" + user_id_ + "',sysdate,'0','" + key_id + "','" + a014_id_ + "','" + table_id_ + "'," + GlobeAtt.A30001_KEY + ",'" + main_col_v_ + "',systimestamp,systimestamp from dual";
                //db.BeginTransaction();
                //li_db = db.ExecuteNonQuery(str_sql, CommandType.Text);
                //if (li_db < 0)
                //{
                //    db.Rollback();
                //    return "01" + BaseMsg.getMsg("M0004");
                //}
                //db.Commit();   
            
                OracleParameter[] parmeters =
               {
                    new OracleParameter("a311_key_", OracleType.Number),
                    new OracleParameter("a311_id_", OracleType.NVarChar,200),
                    new OracleParameter("a311_name_", OracleType.Clob),
                    new OracleParameter("user_id_", OracleType.NVarChar,200),
                    new OracleParameter("a30001_key_", OracleType.NVarChar,200),
                    new OracleParameter("table_id_", OracleType.NVarChar,200),
                    new OracleParameter("objid_", OracleType.NVarChar,200),
                    new OracleParameter("a014_id_", OracleType.NVarChar,200),
                    new OracleParameter("main_key_", OracleType.NVarChar,200),
                    new OracleParameter("Selected_", OracleType.NVarChar,4000),
               };
                parmeters[0].Direction = ParameterDirection.Input;
                parmeters[1].Direction = ParameterDirection.Input;
                parmeters[2].Direction = ParameterDirection.Input;
                parmeters[3].Direction = ParameterDirection.Input;
                parmeters[4].Direction = ParameterDirection.Input;
                parmeters[5].Direction = ParameterDirection.Input;
                parmeters[6].Direction = ParameterDirection.Input;
                parmeters[7].Direction = ParameterDirection.Input;
                parmeters[8].Direction = ParameterDirection.Input;
                parmeters[9].Direction = ParameterDirection.Input;
                parmeters[0].Value = LOG_KEY;
                parmeters[1].Value = menu_id_;
                parmeters[2].Value = oldsql;
                parmeters[3].Value = user_id_;
                parmeters[4].Value = GlobeAtt.A30001_KEY;
                parmeters[5].Value = table_id_;
                parmeters[6].Value = "";
                parmeters[7].Value = a014_id_;
                parmeters[8].Value = main_col_v_;
                parmeters[9].Value = SELECTEDROWLIST_;
                db.BeginTransaction();
                li_db = db.db_oracle.ExecuteNonQuery("pkg_log.save_a311", parmeters); //db.ExecuteNonQuery(str_sql, CommandType.Text);
                if (li_db < 0)
                {
                    db.Rollback();
                    return "01" + BaseMsg.getMsg("M0004");
                }
                db.Commit();
    

                db.BeginTransaction();
               for (int i =0 ;i < sqllist.Length;i++)
               {
                    str_sql = sqllist[i];
                    if (str_sql == null || str_sql.Length < 5)
                    {
                        continue;
                    }
                    str_sql = str_sql.Replace(old_index, "[");
                    if (str_sql.ToUpper().IndexOf("UPDATE ") == 0 || str_sql.ToUpper().IndexOf("INSERT ") == 0)
                    {                     
                    }
                    else
                    {
                        str_sql = str_sql.Replace("[" + log_table + "_KEY]", LOG_KEY);
                        str_sql = str_sql.Replace("[USER_ID]", user_id_);
                    }
                    try
                    {
                       
                        li_db = db.ExecuteNonQuery(str_sql, CommandType.Text);
                        if (li_db < 0)
                        {
                            db.Rollback();
                            return "00" + BaseMsg.getMsg("M0004");
                        }
                    }
                    catch (Exception ex)
                    {
                        db.Rollback();
                        string msg_ = ex.Message;
                        str_sql = "update A311 set state='-1', DESCRIPTION='" + msg_.Replace("'", "''") + "(" + db.db_oracle.GetDBConnection().ConnectionTimeout.ToString() + ")',END_TIME=systimestamp where a311_key=" + LOG_KEY;
                        db.BeginTransaction();
                        li_db = db.ExecuteNonQuery(str_sql.Replace("{", "'"), CommandType.Text);
                        if (li_db < 0)
                        {
                            db.Rollback();
                            return "01" + BaseMsg.getMsg("M0004");
                        }
                        db.Commit();
                        return "00" + GetOracleMsg(msg_);
                    }
                }
                db.Commit();
               //记录更新时间
                str_sql = "update A311 set  END_TIME=systimestamp where a311_key=" + LOG_KEY;
                db.BeginTransaction();
                li_db = db.ExecuteNonQuery(str_sql.Replace("{", "'"), CommandType.Text);
                if (li_db < 0)
                {
                    db.Rollback();
                    return "01" + BaseMsg.getMsg("M0004");
                }
                db.Commit();
                str_sql = "Select t.* from A311 t where t.A311_KEY=" + LOG_KEY;
                DataTable dt_log = new DataTable();
                li_db = db.ExcuteDataTable(dt_log, str_sql, CommandType.Text);
                if (li_db < 0)
                {
                    return "01" + BaseMsg.getMsg("M0004");
                }

                string ls_state = dt_log.Rows[0]["state"].ToString();

                if (ls_state == "0")
                {
                    return  usermsg.getMsgByMsgId("M00001", "");
                }
            //检测是否存在要后续操作动作
                if (ls_state == "2") 
                { //解析成功以后要处理的数据
                    str_sql = "Select t.* from A31101 t where t.A311_KEY=" + LOG_KEY  + " order by t.line_no";
                    DataTable dt_A31101 = new DataTable();
                    li_db = db.ExcuteDataTable(dt_A31101, str_sql, CommandType.Text);
                    if (li_db < 0)
                    {
                        return "01" + BaseMsg.getMsg("M0004");
                    }
                    for (int i = 0; i < dt_A31101.Rows.Count; i++)
                    {
                        string a014_id = dt_A31101.Rows[i]["A014_ID"].ToString();
                        if (a014_id == "CreateDir")
                        {
                            string dirpath = dt_A31101.Rows[i]["table_objid"].ToString();
                            string table_id = dt_A31101.Rows[i]["table_id"].ToString();
                            string CreateDir = HttpContext.Current.Request.MapPath("") + "\\" + table_id;
                            if (!System.IO.Directory.Exists(CreateDir))
                            {
                                System.IO.Directory.CreateDirectory(CreateDir);
                            }
                            //建立商家的目录
                            CreateDir = CreateDir + "\\" + dirpath;
                            if (!System.IO.Directory.Exists(CreateDir))
                            {
                                System.IO.Directory.CreateDirectory(CreateDir);
                            }                           
                        }
                        if (a014_id == "CreateFile")
                        {
                            string dirpath = dt_A31101.Rows[i]["table_objid"].ToString();
                            string table_id = dt_A31101.Rows[i]["table_id"].ToString();
                            string CreateFile = HttpContext.Current.Request.MapPath("") + "\\" + table_id;
                            if (!System.IO.Directory.Exists(CreateFile))
                            {
                                System.IO.Directory.CreateDirectory(CreateFile);
                            }
                            //建立商家的目录
                            CreateFile = CreateFile + "\\" + dirpath;
                            if (!System.IO.File.Exists(CreateFile))
                            {
                                System.IO.File.Delete(CreateFile);
                            }
                            String DESCRIPTION = dt_A31101.Rows[i]["table_id"].ToString();
                            try
                            {
                                FileStream file = new FileStream(CreateFile, FileMode.Append);
                                StreamWriter sw = new StreamWriter(file);
                                sw.WriteLine(DESCRIPTION);
                                sw.Close();
                            }
                            catch (IOException e)
                            {
                                Console.WriteLine(e.Message);
                            }
                            
                        }

                    }

                }
                return dt_log.Rows[0]["RES"].ToString();


        }
        catch(Exception ex )
        {
            db.Rollback();
            string msg_ = ex.Message;
            str_sql = "update A311 set DESCRIPTION='" + msg_.Replace("'", "''") + "',END_TIME=systimestamp  where a311_key=" + LOG_KEY;
            db.BeginTransaction();
            li_db = db.ExecuteNonQuery(str_sql.Replace("{", "'"), CommandType.Text);
            if (li_db < 0)
            {
                db.Rollback();
                return "01" + BaseMsg.getMsg("M0004");
            }
            db.Commit();

            return "00" + GetOracleMsg(msg_);
        }

        return usermsg.getMsgByMsgId("M00001", ""); ;
    }
    public string execSql(string sql, string user_id_, string menu_id_)
    {

        return execSql(sql, user_id_, menu_id_, "");
    }
/// <summary>

 

      /// 生成doc-pdf日志

       /// </summary>

       /// <paramname="item">操作项名称</param>

       /// <paramname="errorContent">错误信息</param>

       /// <paramname="FileName_Prefix">文件名前缀(加时间组合全名)</param>

       public  void SaveLogFile(string item, string errorContent, string FileName_)

       {

           StreamWriter sw = null;

           DateTime date = DateTime.Now;

           string FileName = string.Empty;

           try

           {

             

               #region 检测日志目录是否存在

               string forderPathStr = null;

               if (HttpContext.Current == null)
               {
                   forderPathStr = HttpRuntime.AppDomainAppPath +"/Logs";
               }
               else
               {

                   forderPathStr =HttpContext.Current.Server.MapPath("~/Logs");

               }

               if (!Directory.Exists(forderPathStr))
               {
                   Directory.CreateDirectory(forderPathStr);
               }

               FileName = forderPathStr +"\\"+ FileName_;
               if (!File.Exists(FileName))
               {
                   sw = File.CreateText(FileName);//不存在该文件，就创建并添加内容
               }
               else
               {
                   sw = File.AppendText(FileName);//日志文件已经存在，则向该文件追加内容

               }

               #endregion

               sw.WriteLine(item);
               sw.WriteLine(errorContent);//写入行
               sw.WriteLine("【Time】" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff"));
               sw.WriteLine("≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡");
               sw.Flush();
              }

           finally

           {

               if (sw != null)

                   sw.Close();

           }

       }
       public string get_scoket_xml(string ip_, string send_xml, ref Boolean   if_success)
       {

             string receivexml_ = "";
             if_success = true;
              Socket client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
              client.ReceiveTimeout = 10000;
              client.SendTimeout = 10000;
               string[] ipport = ip_.Split(':');

               IPEndPoint ie = new IPEndPoint(IPAddress.Parse(ipport[0]), int.Parse(ipport[1]));//服务器的IP和端口
               try
               {
                   client.Connect(ie);
               }
               catch( Exception ex )
               {
                   if_success = false;
                   return ex.Message; 
               }
               try
               {
                       
                   client.Send(Encoding.Default.GetBytes(send_xml));
                   byte[] data1 = new byte[102400];
                   int recv = client.Receive(data1);
                   receivexml_ = Encoding.Default.GetString(data1, 0, recv);                      
                                       
               }
               catch (Exception ex)
               {
                   if_success = false;
                   return ex.Message;
               }
               finally
               {
                   client.Close();
               }
               if_success = true;
               return receivexml_;       
       }


       public string execSql(string sql, string user_id_, string menu_id_, string a014_id_ )
       {
           string log_id = "";
           return execSql(sql, user_id_, menu_id_, a014_id_, "", "", "",ref  log_id);
       }
          public string execSql(string sql, string user_id_, string menu_id_, string a014_id_,string table_id_ , string objid_ , string DOMAINKEY_)
          {
             string log_id = "";
             return  execSql(sql,user_id_,menu_id_,a014_id_,table_id_,objid_,DOMAINKEY_,ref log_id);
          
          }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="A311_Key_"></param>
    /// <param name="Line_No_"></param>
    /// <param name="Sort_By_"></param>
    /// <param name="User_Id_"></param>
    /// <param name="Send_Data_"></param>
    /// <param name="Receive_Data_"></param>
    /// <param name="Table_Id_"></param>
    /// <param name="Objid_"></param>
    /// <param name="A014_Id_"></param>
    /// <param name="exec_type_">执行类型</param>
    /// <returns></returns>
          public string save_a31101(string A311_Key_,
                              int  Line_No_,
                              int  Sort_By_,
                              string User_Id_,
                              string Send_Data_,
                              string Receive_Data_,
                              string Table_Id_,
                              string Objid_,
                              string A014_Id_) 
          {
            try
             {
                  OracleParameter[] parmeters =
                   {
                        new OracleParameter("A311_Key_", OracleType.Number),
                        new OracleParameter("Line_No_", OracleType.NVarChar,200),
                        new OracleParameter("Sort_By_", OracleType.NVarChar,200000),
                        new OracleParameter("User_Id_", OracleType.NVarChar,200),
                        new OracleParameter("Send_Data_", OracleType.Clob),
                        new OracleParameter("Receive_Data_", OracleType.Clob),
                        new OracleParameter("Table_Id_", OracleType.LongVarChar,200),
                        new OracleParameter("Objid_", OracleType.LongVarChar,200),
                        new OracleParameter("A014_id_", OracleType.LongVarChar,200),
                   };

                parmeters[0].Direction = ParameterDirection.Input;
                parmeters[1].Direction = ParameterDirection.Input;
                parmeters[2].Direction = ParameterDirection.Input;
                parmeters[3].Direction = ParameterDirection.Input;
                parmeters[4].Direction = ParameterDirection.Input;
                parmeters[5].Direction = ParameterDirection.Input;
                parmeters[6].Direction = ParameterDirection.Input;
                parmeters[7].Direction = ParameterDirection.Input;
                parmeters[8].Direction = ParameterDirection.Input;
                parmeters[0].Value = A311_Key_;
                parmeters[1].Value = Line_No_;
                parmeters[2].Value = Sort_By_;
                parmeters[3].Value = User_Id_;
                parmeters[4].Value = Send_Data_;
                parmeters[5].Value = Receive_Data_;
                parmeters[6].Value = Table_Id_;
                parmeters[7].Value = Objid_;
                parmeters[8].Value = A014_Id_;
                db.BeginTransaction();
                int li_db = db.db_oracle.ExecuteNonQuery("pkg_log.save_a31101", parmeters); //db.ExecuteNonQuery(str_sql, CommandType.Text);
                if (li_db < 0)
                {
                    db.Rollback();
                    return "01" + BaseMsg.getMsg("M0004");
                }
                db.Commit();
                return "0";
            }
            catch (Exception ex)
            {
                db.Rollback();
                string msg_ = ex.Message;
                string str_sql = "update A311 set DESCRIPTION='" + msg_.Replace("'", "''") + "',END_TIME=systimestamp where a311_key=" + A311_Key_;
                db.BeginTransaction();
                int li_db = db.ExecuteNonQuery(str_sql.Replace("{", "'"), CommandType.Text);
                if (li_db < 0)
                {
                    db.Rollback();
                    return "01" + BaseMsg.getMsg("M0004");
                }
                db.Commit();

                return "00" + GetOracleMsg(msg_);
            }
     }
    /// <summary>
    /// 执行sql语句 并记录日志到日志表中
    /// </summary>
    /// <param name="sql"></param>
    /// <returns></returns>
     public string execSql(string sql, string user_id_, string menu_id_, string a014_id_,string table_id_ , string objid_ , string DOMAINKEY_,ref string log_id)
     {

        
        
            if (sql.Length < 10)
            {
                return "0";
            }
            string LOG_KEY = "";
            string log_table = "A311";
            string oldsql = sql;
            string str_sql = "Select s_" + log_table + ".nextval as c from dual";
            DataTable dt = new DataTable();
            int li_db = db.ExcuteDataTable(dt, str_sql, CommandType.Text);
            if (li_db < 0)
            {
                return    "01" + BaseMsg.getMsg("M0003");
            }
            try
            {
            LOG_KEY = dt.Rows[0][0].ToString();
            sql = sql.Replace("[" + log_table + "_KEY]", LOG_KEY);
            if (sql.Length > 4000)
            {
                sql = sql.Substring(0,3998) + "..";
            }
                log_id = LOG_KEY;
                str_sql = "Insert into A311(A311_KEY,A311_ID,A311_NAME,STATE,ENTER_USER,ENTER_DATE,RES,A014_ID,A30001_ID,table_id,TABLE_OBJID,MAIN_KEY,BEGIN_TIME,END_TIME)";
            str_sql = str_sql + " SELECT " + LOG_KEY + ",'" + menu_id_ + "','" + sql.Replace("'", "''") + "','0','" + user_id_ + "',sysdate,'0','"
                + a014_id_ + "'," + GlobeAtt.A30001_KEY + ",'" + table_id_ + "','" + objid_ + "','" + DOMAINKEY_ + "',systimestamp,systimestamp from dual";
         
           OracleParameter[] parmeters =
           {
                new OracleParameter("a311_key_", OracleType.Number),
                new OracleParameter("a311_id_", OracleType.LongVarChar,200),
                new OracleParameter("a311_name_", OracleType.LongVarChar,200000),
                new OracleParameter("user_id_", OracleType.NVarChar,200),
                new OracleParameter("a30001_key_", OracleType.LongVarChar,200),
                new OracleParameter("table_id_", OracleType.LongVarChar,200),
                new OracleParameter("objid_", OracleType.LongVarChar,200),
                new OracleParameter("a014_id_", OracleType.LongVarChar,200),
                new OracleParameter("main_key_", OracleType.LongVarChar,200),
           };
           parmeters[0].Direction = ParameterDirection.Input;
           parmeters[1].Direction = ParameterDirection.Input;
           parmeters[2].Direction = ParameterDirection.Input;
           parmeters[3].Direction = ParameterDirection.Input;
           parmeters[4].Direction = ParameterDirection.Input;
           parmeters[5].Direction = ParameterDirection.Input;
           parmeters[6].Direction = ParameterDirection.Input;
           parmeters[7].Direction = ParameterDirection.Input;
           parmeters[8].Direction = ParameterDirection.Input;

            parmeters[0].Value = LOG_KEY;
            parmeters[1].Value = menu_id_;
            parmeters[2].Value = oldsql;
            parmeters[3].Value = user_id_;
            parmeters[4].Value = GlobeAtt.A30001_KEY;
            parmeters[5].Value = table_id_;
            parmeters[6].Value = objid_;
            parmeters[7].Value = a014_id_;
            parmeters[8].Value = DOMAINKEY_;
           
             

            

            db.BeginTransaction();
            li_db = db.db_oracle.ExecuteNonQuery("pkg_log.save_a311", parmeters); //db.ExecuteNonQuery(str_sql, CommandType.Text);
            if (li_db < 0)
            {
                db.Rollback();
                return "01" + BaseMsg.getMsg("M0004");
            }
            db.Commit();
            if (sql.IndexOf("<A014>A014_ID=") != 0)
            {
                db.BeginTransaction();
                li_db = db.ExecuteNonQuery(sql.Replace("{", "'"), CommandType.Text);
                if (li_db < 0)
                {
                    db.Rollback();
                    return "01" + BaseMsg.getMsg("M0004");
                }
                db.Commit();
                //记录更新时间
                str_sql = "update A311 set  END_TIME=systimestamp where a311_key=" + LOG_KEY;
                db.BeginTransaction();
                li_db = db.ExecuteNonQuery(str_sql.Replace("{", "'"), CommandType.Text);
                if (li_db < 0)
                {
                    db.Rollback();
                    return "01" + BaseMsg.getMsg("M0004");
                }
                db.Commit();
            }
            str_sql = "Select t.* from A311 t where t.A311_KEY=" + LOG_KEY;
            DataTable dt_log = new DataTable();
            li_db = db.ExcuteDataTable(dt_log, str_sql, CommandType.Text);
            if (li_db < 0)
            {
                return "01" + BaseMsg.getMsg("M0004");
            }

            string ls_state = dt_log.Rows[0]["state"].ToString();

            if (ls_state == "0")
            {
                return "0";
            }

            return dt_log.Rows[0]["RES"].ToString();

        }
        catch (Exception ex)
        {
            db.Rollback();
            string msg_ = ex.Message;
            str_sql = "update A311 set DESCRIPTION='" + msg_.Replace("'", "''") + "',END_TIME=systimestamp where a311_key=" + LOG_KEY;
            db.BeginTransaction();
            li_db = db.ExecuteNonQuery(str_sql.Replace("{", "'"), CommandType.Text);
            if (li_db < 0)
            {
                db.Rollback();
                return "01" + BaseMsg.getMsg("M0004");
            }
            db.Commit();

            return "00" + GetOracleMsg(msg_);
        }
    
    }
    /// <summary>
    /// 把生成的xml转换为datatable
    /// 
    /// </summary>
    /// <param name="xml_data"></param>
    /// <returns></returns>
    public DataTable getDtByPkg(string xml_str)
    {
        DataTable dt = new DataTable();
        try
        {
            System.Xml.XmlDocument doc = new XmlDocument();
            doc.LoadXml(xml_str);
            string data_ = "";
            XmlNodeList rowsNode = doc.SelectNodes("/DATA/ROW");
            int i = 0;
            if (rowsNode != null)
            {

                foreach (XmlNode rowNode in rowsNode)
                {
                    if (i == 0)
                    {
                        for (int j = 0; j < rowNode.ChildNodes.Count; j++)
                        {

                            DataColumn dc = dt.Columns.Add();
                            dc.ColumnName = rowNode.ChildNodes[j].Name;
                        }


                    }
                    DataRow dr = dt.NewRow();

                    for (int j = 0; j < rowNode.ChildNodes.Count; j++)
                    {
                        dr[j] = rowNode.ChildNodes[j].InnerText;
                    }
                    dt.Rows.Add(dr);
                    i = i + 1;
                }

            }

        }
        catch
        {
            return dt;
        }
        return dt;

    }


/// <summary>
/// 把datatable 组成xml包

/// </summary>
/// <param name="dt_data"></param>
/// <returns></returns>
    public string setPkgStr(DataTable dt_data)
    { 
        /*把记录集组成xml数据包*/
        StringBuilder str_xml = new StringBuilder();
        str_xml.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?>");
        str_xml.Append("<DATA>");
        for (int i = 0; i < dt_data.Rows.Count; i++)
        {
            str_xml.Append("<ROW>");
            for (int j = 0; j < dt_data.Columns.Count; j++)
            { 
                string column_id = dt_data.Columns[j].ToString().ToUpper();
                string col_data = dt_data.Rows[i][column_id].ToString();
                col_data = col_data.Replace("&", ";;;");
                str_xml.Append("<" + column_id + ">" + col_data + "</" + column_id + ">");
            
            
            }
            str_xml.Append("</ROW>");
        }
        str_xml.Append("</DATA>");
     //   System.Xml.XmlDocument doc = new XmlDocument();
     //   doc.LoadXml(str_xml.ToString());
        return str_xml.ToString();
    }
/// <summary>
    ///  根据具体的节点内容查询在xml的行数

/// </summary>
/// <param name="xml_str"></param>
/// <param name="col">节点</param>
/// <param name="col_value_">节点的值</param>
/// <returns></returns>
    public int getColumnRow(string xml_str,string col , string col_value_)
    {
        System.Xml.XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml_str);
        string data_ = "";
        XmlNodeList rowsNode = doc.SelectNodes("/DATA/ROW/" + col);
        int i = 0;
        int result_ = -1;
        if (rowsNode != null)
        {
            foreach (XmlNode rowNode in rowsNode)
            {

                data_ = rowNode.InnerText;
                if (col_value_ == data_)
                {
                    result_ = i;
                    break;
                }
                //   return rowNode.InnerText;
                i = i + 1;
            }
        }
        return result_;    
    }


    /// <summary>
    /// 根据xml获取xml对应节点和列的值

    /// </summary>
    /// <param name="xml_str">原xml内容</param>
    /// <param name="row">第几行</param>
    /// <param name="col">列</param>
    /// <returns></returns>
    public string getXmlData(string xml_str, int  row, string col)
    {
        System.Xml.XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml_str);
        string data_ = "";
        XmlNodeList rowsNode = doc.SelectNodes("/DATA/ROW/" + col);
        int i = 0;
        if (rowsNode != null)
        {
            foreach (XmlNode rowNode in rowsNode)
            {
                if (i == row)
                {
                    data_ = rowNode.InnerText;
                    data_ = data_.Replace( ";;;","&");
                    break;
                }
             //   return rowNode.InnerText;
                i = i + 1;
            }
        }
        return  data_ ;
    }
    /// <summary>
    /// 获取客户端ip地址
    /// </summary>
    /// <returns></returns>
    public string getClientIp()
    {

        string str = "";
        //穿过代理服务器取远程用户真实IP地址：

        if (System.Web.HttpContext.Current.Request.ServerVariables["HTTP_VIA"] != null)
            str = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
        else
            str = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        return str;
    }

    /// <summary>
    /// 获取xml文件的行数

    /// </summary>
    /// <param name="xml_str"></param>
    /// <returns></returns>
    public int getRowCount(string xml_str)
    {
        System.Xml.XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml_str);
        int count = 0;
        XmlNodeList rowsNode = doc.SelectNodes("/DATA/ROW");
        return rowsNode.Count;

    
    }

    /// <summary>
    /// 获取当前地址栏的地址
    /// </summary>
    /// <returns></returns>
    public string GetIndexUrl()
    {
     
        return GlobeAtt.HTTP_URL;
    }

    /// <summary>
    /// 判断是否是number
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public bool IsNumeric(string value)
    {
        return Regex.IsMatch(value, @"^[+-]?\d*[.]?\d*$");
    }
    /// <summary>
    /// 判断是否是整数

    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public bool IsInt(string value)
    {
        return Regex.IsMatch(value, @"^[+-]?\d*$");
    }
    public bool IsUnsign(string value)
    {
        return Regex.IsMatch(value, @"^\d*[.]?\d*$");
    }

    public string getDublicToStr(double dbstr)
    {
        if (dbstr < 0)
        {
            return dbstr.ToString("0.####");
        }
        string a = dbstr.ToString();
        string[] b = a.Split('.');
        string f;
        if (b.Length > 1)
        {
            f = (dbstr - 0.5).ToString("#,##0") + "." + b[1];    //保證小數點後面相同

        }
        else
        {
            f = dbstr.ToString("#,##0");
        }
        return f;
    }

    public void CreateCookie(string CookieId, string key, string key_value )
    {
        CreateCookieValue(key, key_value, DateTime.Now + new TimeSpan(0, 1, 0, 0));
    }
    public string GetCookie(string CookieId, string key)
    {
        return  GetCookieValue(CookieId, key);
    }

    ///<summary>         ///創建cookie值     
    //////</summary>         ///<param name="cookieName">cookie名稱</param>     
    ///<param name="cookieValue">cookie值</param>       
    //////<param name="cookieTime">cookie有效時間</param>   
    private void CreateCookieValue(string cookieName,string cookieValue,DateTime cookieTime)  
    {          
        HttpCookie cookie = new HttpCookie(cookieName);   
        cookie.Value=cookieValue;        
        //DateTime dtNow = DateTime.Now ; 
        //TimeSpan tsMinute = cookieTime;    
        cookie.Expires = cookieTime;
        System.Web.HttpContext.Current.Response.Cookies.Add(cookie);    
    }      

    ///<summary>    
    //////創建cookie值

    ///</summary>      
    //////<param name="cookieName">cookie名稱</param>      
    ///<param name="cookieValue">cookie值</param>   
    //////<param name="subCookieName">子信息cookie名稱</param> 
    ///<param name="subCookieValue">子信息cookie值</param>     
    //////<param name="cookieTime">cookie有效時間</param>    
    private void CreateCookieValue(string cookieName,string cookieValue,string subCookieName,string subCookieValue,DateTime cookieTime)    
    {             
        HttpCookie cookie = new HttpCookie(cookieName);       
        cookie.Value=cookieValue;       

        cookie[subCookieName]=subCookieValue;     
        cookie.Expires = cookieTime;
        System.Web.HttpContext.Current.Response.Cookies.Add(cookie);       
    }       
    ///<summary>      
    //////取得cookie的值 
    ///</summary>    
    //////<param name="cookieName">cookie名稱</param>   
    ///<returns></returns>      
    ///
    private string GetCookieValue(string cookieName) 
    {    string cookieValue="";
         HttpCookie cookie = System.Web.HttpContext.Current.Request.Cookies[cookieName]; 
        if(null == cookie)        
        {                
            cookieValue=""; 
        }            
        else       
        {          
            cookieValue=cookie.Value;  
        }          
        return cookieValue;        
    }      
    ///<summary>    
              //////取得cookie的值    
    ///</summary>      
    //////<param name="cookieName">cookie名稱</param>  
    ///<param name="subCookieName">cookie子信息值</param>
    //////<returns></returns>       
    private string GetCookieValue(string cookieName,string subCookieName)   
    {              
        string cookieValue="";
        HttpCookie cookie = System.Web.HttpContext.Current.Request.Cookies[cookieName];       
        if(null == cookie)            
        {             
            cookieValue="";    
        }             
        else         
        {            
            cookieValue=cookie.Value;   
            cookieValue=cookieValue.Split('&')[1].ToString().Split('=')[1];   
        }           
        return cookieValue;      
    }     
    ///<summary>    
    //////刪除某個固定的cookie值[此方法一是在原有的cookie上再創建同樣的cookie值，但是時間是過期的時間]     
    ///</summary>        
    //////<param name="cookieName"></param>      
    private void RemoteCookieValue(string cookieName)   
    {           
        string dt="1900-01-01 12:00:00";        
        CreateCookieValue(cookieName,"",Convert.ToDateTime(dt)); 
    }     
   
    
  //  private void Page_Load(object sender, System.EventArgs e)  
   // {              // 在這裡放置使用者程式碼以初始化網頁     
  //      this.txt_UserID.Text=this.GetCookieValue("UserName","UserID");//取得用戶名     
  //      CreateCookieValue("UserName","UserName","UserID",this.txt_UserID.Text,DateTime.Now+new TimeSpan(0,1,0,0));
  //  }     
    /// <summary>
    /// 获取list的数据的显示
    /// </summary>
    /// <param name="bs_html"></param>
    /// <param name="datarow"></param>
    /// <param name="rownum"></param>
    /// <param name="?"></param>
    /// <param name="col_v"></param>
    /// <returns></returns>
    public string ShowListHtml(string bs_html, DataTable datarow, int rownum, string column_id_, string col_v)
    {

        string bs_html_ = bs_html;
        string column_id = column_id_;
        string col_data  =col_v;
        if (col_data == null)
        {
            col_data = "" ;
        }
        if (bs_html_ == "[" + column_id + "]")
        {
            return col_data;
        }
        bs_html_ = bs_html_.Replace("[" + column_id + "]", col_data);
        bs_html_ = bs_html_.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
        if (bs_html_.IndexOf("[") >=0 && bs_html_.IndexOf("]") >=0)
        {
            for (int i = 0; i < datarow.Columns.Count; i++)
            { 
                    column_id =  datarow.Columns[i].ColumnName.ToUpper();
                    col_data  =datarow.Rows[rownum][column_id].ToString();
                    if (col_data == null)
                    {
                        col_data = "" ;
                    }
                    bs_html_ = bs_html_.Replace("[" + column_id + "]", col_data);
                    if (bs_html_.IndexOf("[") >= 0 && bs_html_.IndexOf("]") >= 0)
                    { }
                    else
                    {
                        break;
                    }
            
            }
        }
        if (bs_html_.ToUpper().Trim().IndexOf("SELECT ") == 0)
        {
            DataTable dt_html = new DataTable();
            string bs_sql = bs_html_;
            db.db_oracle.ExcuteDataTable(dt_html, bs_sql, CommandType.Text);
            try
            {
                bs_html_ = dt_html.Rows[0][0].ToString();
            }
            catch
            {                
            }
        }
        return bs_html_;
    
    
    }
    //获取默认数据
    public string formatInitData(DataRow a013010101row)
    {
        try
        {
            string col_init = a013010101row["col_init"].ToString();
            if (col_init == "" || col_init == null)
            {
                return "";
            }
            DataTable dt_init = new DataTable();
            string col_init_sql;
            col_init_sql = col_init.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            col_init_sql = col_init_sql.Replace("[user_id]", GlobeAtt.A007_KEY);
            col_init_sql = col_init_sql.Replace("[MENU_ID]", GlobeAtt.A002_KEY);
            col_init_sql = col_init_sql.Replace("[user_name]", GlobeAtt.A007_NAME);
            col_init_sql = col_init_sql.Replace("[USER_NAME]", GlobeAtt.A007_NAME);
            col_init_sql = col_init_sql.Replace("GETDATE()", "sysdate");
            if (col_init_sql.IndexOf("FUN_") == 0)
            {
                col_init_sql = col_init_sql.Substring(4);
                col_init_sql = "Select " + col_init_sql + "  as c from dual ";
            }
            else
            {
                if (col_init_sql == "sysdate")
                {
                    col_init_sql = "Select " + col_init_sql + "  as c from dual ";
                }
                else
                {
                    col_init_sql = "Select '" + col_init_sql + "'  as c from dual ";
                }
            }
            db.ExcuteDataTable(dt_init, col_init_sql, CommandType.Text);
            return dt_init.Rows[0][0].ToString();
        }
        catch(Exception ex )
        {
            return "";
        }
    }
    public string ShowColumn(string option_, string a20001_key, DataRow a013010101row, string row, string p_v_, string showtype)
    { 
        return  ShowColumn( option_,  a20001_key,   a013010101row ,  row ,  p_v_, showtype,"");
    }
   

  public string ShowColumn(string option_, string a20001_key,  DataRow a013010101row , string row , string p_v_,string showtype,string form_init)
  {

        string col_edit = a013010101row["COL_EDIT"].ToString().ToLower();
        string a10001_key_ = a013010101row["A10001_KEY"].ToString();
        string col_visible = a013010101row["COL_VISIBLE"].ToString();
        string col_enable = a013010101row["COL_ENABLE"].ToString();
        string col_child = a013010101row["col_child"].ToString();
        string col_necessary = a013010101row["col_necessary"].ToString();
        Boolean if_itemchange = false;
        if (col_child.Length >= 1)
        {
            if_itemchange = true;
        }
        if (if_itemchange == false)
        {
            string CALC_FLAG = a013010101row["CALC_FLAG"].ToString();
            string FORMULA = a013010101row["FORMULA"].ToString();
            if (CALC_FLAG == "1")
            {
                if_itemchange = true;
            }
        }
        if (if_itemchange == false)
        {

            string SELECT_FLAG = a013010101row["SELECT_FLAG"].ToString();
            string TABLE_SELECT = a013010101row["TABLE_SELECT"].ToString();
            if (SELECT_FLAG == "1" && TABLE_SELECT.Length > 2)
            {
                if_itemchange = true;
            }
        }
        if (if_itemchange == true && a20001_key.Substring(0, 1) == "S")
        {
            col_enable = "0";
        }
        /*新增*/
        string v_ = p_v_;
        if (option_ == "I")
        {   /*获取默认数据*/
            /*获取菜单传入的col_init的数据*/
       
            if (v_ == "" || v_ == null)
            {
                string data_index = GlobeAtt.DATA_INDEX;
                string column_id = a013010101row["COLUMN_ID"].ToString();
                v_ = getStrByIndex( form_init, data_index + column_id + "|", data_index);
                if (v_ == "" || v_ == null)
                {
                    string col_init = a013010101row["col_init"].ToString();
                    /*把col_init转换为数据*/
                    if (col_init != "" && col_init != null)
                    {
                        DataTable dt_init = new DataTable();
                        string col_init_sql;
                        col_init_sql = col_init.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                        col_init_sql = col_init_sql.Replace("[user_id]", GlobeAtt.A007_KEY);
                        col_init_sql = col_init_sql.Replace("[MENU_ID]", GlobeAtt.A002_KEY);
                        col_init_sql = col_init_sql.Replace("[user_name]", GlobeAtt.A007_NAME);
                        col_init_sql = col_init_sql.Replace("[USER_NAME]", GlobeAtt.A007_NAME);
                        col_init_sql = col_init_sql.Replace("GETDATE()", "sysdate");
                        if (col_init_sql.IndexOf("FUN_") == 0)
                        {
                            col_init_sql = col_init_sql.Substring(4);
                            col_init_sql = "Select " + col_init_sql + "  as c from dual ";
                        }
                        else
                        {
                            if (col_init_sql == "sysdate")
                            {
                                col_init_sql = "Select " + col_init_sql + "  as c from dual ";
                            }
                            else
                            {
                                col_init_sql = "Select '" + col_init_sql + "'  as c from dual ";
                            }
                        }

                        db.ExcuteDataTable(dt_init, col_init_sql, CommandType.Text);

                        v_ = dt_init.Rows[0][0].ToString();

                    }
                }
            }
        
        }
        //转换日期格式
        if ((col_edit == "datelist" || col_edit == "datetimelist") && v_.Length > 10)
        {

            if (v_.IndexOf(".") > 0)
            {
                v_ = v_.Substring(0, 10) + " " + v_.Substring(11).Replace(".", ":");
            }
        
            DateTime dt = DateTime.Parse(v_);
            v_ = string.Format("{0:u}", dt);//2005-11-05 14:23:23Z
            if (col_edit == "datelist")
            {
                v_ = v_.Substring(0, 10);
            }
            else
            {
                v_ = v_.Substring(0, 19);
            }
            // col_value = col_value.Substring(0, 10);

        }
        v_ = v_.Replace("\"", "'");
        if (col_visible == "0")
        {
            return column_u_hidden(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, "0");            
        }
        if (showtype == "list")
        {
            if (v_ == null || v_ == "")
            {
                v_ = "&nbsp;";
            }
            return v_;
        
        }
         
 
        string  col_width =  "";
        col_width = a013010101row["BS_EDIT_WIDTH"].ToString();
        if (col_width == "" || col_width == null)
        {
            col_width = "80";
        }
        if (col_edit == "")
        {
            col_edit ="u_edit" ; 
        }
        if (col_enable == "0")
        {
            string bs_choose_sql = a013010101row["BS_CHOOSE_SQL"].ToString();
            if (bs_choose_sql.Length > 10)
            {
               
                col_width = a013010101row["BS_WIDTH"].ToString();
            }
        }

         col_edit  = col_edit.ToLower() ;
 
        
         string colhtml = "";
         if (col_edit == "u_edit" )
         {
             
             colhtml = column_u_edit(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (col_edit == "u_len" )
         {
             //小数点的精度
             string col_precision = a013010101row["col_precision"].ToString();
             colhtml = column_u_len(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable, col_precision);
         }
      
         if (col_edit == "u_alert")
         {
             string col_text = a013010101row["col_text"].ToString(); 
             colhtml = column_u_alert(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable, col_text );
         }
         if (col_edit == "u_password")
         {
             string column_id = a013010101row["column_id"].ToString();
             //解密
             v_ = DECRYPT_STR(v_,  column_id);
             colhtml = column_u_password(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }

         if (col_edit.IndexOf("u_text")  == 0)
         {
             colhtml = column_u_text(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable, col_edit.Replace("u_text",""));
         }
         if (col_edit.IndexOf("u_color") == 0)
         {
             colhtml = column_u_color(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (col_edit == "u_lower")
         {
             colhtml = column_u_lower(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (col_edit == "u_number" || col_edit == "u_thousands")
         {
             //小数点的精度
             string   col_precision = a013010101row["col_precision"].ToString();

             if (col_precision == null || col_precision == "")
                 {
                     col_precision = "9";
                 }
             int user_dec = int.Parse(GlobeAtt.GetValue("USER_DEC"));
             if (user_dec < int.Parse(col_precision))
             {
                 col_precision = user_dec.ToString();
             }

             colhtml = column_u_number(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable, col_precision);
         }
         if (col_edit == "u_upper")
         {
             colhtml = column_u_upper(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (col_edit == "checkbox")
         {
             colhtml = column_checkbox(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (col_edit.IndexOf("ddd_") == 0)
         {
             string select_sql = a013010101row["SELECT_SQL"].ToString();
             select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
             select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
             select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
             colhtml = column_ddd(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_enable, col_child, select_sql, col_width);
         }

         if (col_edit.IndexOf("rb_") == 0)
         {
             string select_sql = a013010101row["SELECT_SQL"].ToString();
             select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
             select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
             select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
             colhtml = column_rb(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_enable, col_child, select_sql);
         }

         if (col_edit.IndexOf("datelist") == 0 )
         {
             colhtml = column_u_datelist(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (col_edit == "file")
         {
             string col_mask = a013010101row["COL_MASK"].ToString();
             colhtml = column_file(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable, col_mask, a013010101row);

         }
         if (col_edit.IndexOf("datetimelist") == 0)
         {
             colhtml = column_u_datetimelist(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (col_enable == "1")
         {
             string bs_choose_sql = a013010101row["BS_CHOOSE_SQL"].ToString();
             if (bs_choose_sql.Length > 10  )
             {
                 colhtml += "<img  id=\"img_choose" + a20001_key + "_" + row + "_" + a10001_key_ + "\"  src=\"../images/choose.png\" style=\"width: 20px; height: 17px\"  onclick=\"showchoose(this)\"/>";

             }
         }
         if (col_edit.IndexOf("n") == 0)
         {
             colhtml = column_u_edit(a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_, col_width, col_enable);
         }
         if (showtype == "querydata")
         { 
                    string column_id = a013010101row["column_id"].ToString();
                    colhtml = colhtml.Replace("id=\"", "COLNAME=\"" + column_id + "\" id=\"");
         }
         if (col_necessary == "1")
         {
             colhtml = colhtml + BaseMsg.getMsg("M0022");
         }
         return  colhtml ;
}

    public string column_u_datelist(string id_, string name_, string value__, string col_width, string col_enable)
    {
        string value_ = value__;
        if (value_.Length > 10)
        {
            value_ = value__.Substring(0, 10);
        }
        string html_ = "<input  type=\"text\"  style=\"width:" + col_width + "px;\" name=\"" + name_ + "\"    id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"   onchange=\"input_change(this,'" + id_ + "')\"  onclick=\"selectDate_m(this)\" />";

        if (col_enable == "0")
        {
            html_ = "<input   readonly type=\"text\"  style=\"width:" + col_width + "px;" + enablefontcolor + "\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"    />";
    
        }
           // onchange="input_onchange(this,'')"  onclick="selectDate_m(this)"
        return html_;
    }

    public string column_file(string id_, string name_, string value__, string col_width, string col_enable, string col_mask_,DataRow dr )
    {
        string value_ = value__;
        string html_ = "<input  value=\"" + BaseMsg.getMsg("M0005") + "\" id=\"FILE_" + id_ + "\" type=\"button\"  class=\"filebtn\" onclick=\"loadfile('" + dr["TABLE_ID"].ToString() + "','" + dr["LINE_NO"].ToString() + "','" + id_ + "')\" />";
        if (col_enable == "0")
        {
            if (value_.Length > 0)
            {
                html_ = "<a href=\" " + GetIndexUrl() + "\\data\\import\\" + col_mask_ + "\\upload\\" + value__ + "\" target=\"_blank\">" + BaseMsg.getMsg("M0006") + "</a>";
                return html_;
            }
            return "";    
        }
        if (value_.Length > 0)
        {
            html_ = "<a href=\" " + GetIndexUrl() + "\\data\\import\\" + col_mask_ + "\\upload\\" + value__ + "\" target=\"_blank\">" + BaseMsg.getMsg("M0006") + "</a>" + html_; 
        }
        return html_;
    }


    public string column_u_datetimelist(string id_, string name_, string value__, string col_width, string col_enable)
    {
        string value_ = value__;

        string html_ = "<input  type=\"text\"  style=\"width:" + col_width + "px;\" name=\"" + name_ + "\"    id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"   onchange=\"input_change(this,'" + id_ + "')\"  onclick=\"selectDateTime_m(this)\" />";

        if (col_enable == "0")
        {
            html_ = "<input   readonly type=\"text\"  style=\"width:" + col_width + "px;" + enablefontcolor + "\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"     />";

        }
        // onchange="input_onchange(this,'')"  onclick="selectDate_m(this)"
        return html_;
    }
    public string column_u_hidden(string id_, string name_, string value_, string col_width)
    {
        string html_ = "<input  type=\"hidden\"  name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"/>";
        return html_;
    }

   // ='u_lower'  or lower(trim(lstr_a013010101.col_edit))='u_upper' )  then 
    public string  column_u_edit( string  id_ , string  name_ ,string  value_ ,string col_width, string col_enable)
    {
        string html_ = "<input  type=\"text\"  style=\"width:" + col_width + "px;\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  onchange=\"input_change(this,'"+id_+"')\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"   readonly style=\"width:" + col_width + "px;" + enablefontcolor + "\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  onchange=\"input_change(this,'" + id_ + "')\"/>";
    
        }
        return html_ ;    
    }
    public string column_u_len(string id_, string name_, string value_, string col_width, string col_enable,string col_len)
    {
        string html_ = "<input  type=\"text\"  style=\"width:" + col_width + "px;\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  onchange=\"input_change_(this,'" + id_ + "'," + col_len + ")\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"   readonly style=\"width:" + col_width + "px;" + enablefontcolor + "\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  onchange=\"input_change_(this,'" + id_ + "'," + col_len + ")\"/>";

        }
        return html_;
    }
    public string column_u_color(string id_, string name_, string value_, string col_width, string col_enable)
    {
        string html_ = "<input  type=\"text\"  style=\"width:" + col_width + "px;\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"   onchange=\"input_change(this,'" + id_ + "')\" onclick=\"color_change(this,'" + id_ + "')\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"   readonly style=\"width:" + col_width + "px;" + enablefontcolor + "\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  />";

        }
        return html_;
    }


    // ='u_lower'  or lower(trim(lstr_a013010101.col_edit))='u_upper' )  then 
    public string column_u_password(string id_, string name_, string value_, string col_width, string col_enable)
    {
        //显示解密  保存加密
        string html_ = "<input  type=\"password\"  style=\"width:" + col_width + "px;\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  onchange=\"input_change(this,'" + id_ + "')\"/>";
        
        if (col_enable == "0")
        {
            html_ = "<input  type=\"password\"   readonly style=\"width:" + col_width + "px;" + enablefontcolor + "\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  onchange=\"input_change(this,'" + id_ + "')\"/>";

        }
        return html_;
    }

    // ='u_lower'  or lower(trim(lstr_a013010101.col_edit))='u_upper' )  then 
    public string column_u_alert(string id_, string name_, string value_, string col_width, string col_enable, string col_text)
    {
        //弹出大文本的编辑框
        string html_ = "<input  type=\"text\"  readonly style=\"width:" + col_width + "px;\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\"  onclick=\"input_clicke(this,'" + id_ + "','" + col_text + "')\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"   readonly style=\"width:" + col_width + "px;" + enablefontcolor + "\" name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" />";

        }
        return html_;
    }


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
    /// <summary>
    /// des加密支付串
    /// </summary>
    /// <param name="v"></param>
    /// <param name="key"></param>
    /// <returns></returns>
    public string ENCRYPT_STR(string v, string key)
    {
        string en_v = "";
        try
        {
            DataTable dt_str = new DataTable();
            dt_str = getDtBySql("select pkg_a.ENCRYPT_KEY_MODE('" + v + "','" + key + "') as c  from   dual");
            en_v = dt_str.Rows[0][0].ToString();
        }
        catch
        {
            en_v = v;
        }

        return en_v;
    }

    /// <summary>
    /// 解密字符串
    /// </summary>
    /// <param name="v"></param>
    /// <param name="key"></param>
    /// <returns></returns>
    public string DECRYPT_STR(string v, string key)
    {
        string en_v = "";
        try
        {
            DataTable dt_str = new DataTable();
            dt_str = getDtBySql("select pkg_a.DECRYPT_KEY_MODE('" + v + "','" + key + "') as c  from   dual");
            en_v = dt_str.Rows[0][0].ToString();
        }
        catch
        {
            en_v = v;
        }

        return en_v;
    }


    public static MatchCollection getAllHyperLinks(String text, String s, string e)
    {
        try
        {
            Regex rg = new Regex("(?<=(" + s + "))[.\\s\\S]*?(?=(" + e + "))", RegexOptions.Multiline | RegexOptions.Singleline);
            MatchCollection matches = rg.Matches(text);
            return matches;
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    public string column_checkbox(string id_, string name_, string value_, string col_width, string col_enable)
    {
        string value__ = value_;
        if (value__ == null)
        {
            value__ = "0";
        }
        string html_ = "<input  type=\"hidden\"  name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value__ + "\"/>";
        if (value__ == "1")
        {
            if (col_enable == "0")
            {
                html_ += "<input id=\"CBX_" + id_ + "\" type=\"checkbox\"  disabled value=\"1\" checked  />";

            }
            else
            {
                html_ += "<input id=\"CBX_" + id_ + "\" type=\"checkbox\"  value=\"1\" checked  />";
       
            }
        }
        else
        {
            if (col_enable == "0")
            {
                html_ += "<input id=\"CBX_" + id_ + "\" type=\"checkbox\"  value=\"0\" disabled   />";
            }
            else
            {
                html_ += "<input id=\"CBX_" + id_ + "\" type=\"checkbox\"  value=\"0\"  />";
 
            }
        }

        return html_;
    }


    public string column_u_lower(string id_, string name_, string value_, string col_width, string col_enable)
    {
        string html_ = "<input  type=\"text\" style=\"text-transform:lowercase;width:" + col_width + "px;\"   name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"input_change(this,'" + id_ + "')\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"  readonly style=\"text-transform:lowercase;width:" + col_width + "px;" + enablefontcolor + "\"   name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"input_change(this,'" + id_ + "')\"/>";
     
        }
        return html_;
    }
    //动态列
    public string column_u_select(string id_, string name_, string value_, string col_width, string col_enable)
    {
        string html_ = "<input  type=\"text\" style=\"width:" + col_width + "px;\"   name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"input_change(this,'" + id_ + "')\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"  readonly style=\"width:" + col_width + "px;" + enablefontcolor + "\"   name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"input_change(this,'" + id_ + "')\"/>";

        }
        return html_;
    }

    public string column_u_number(string id_, string name_, string value_, string col_width, string col_enable, string col_precision)
    {
        string html_ = "<input  type=\"text\" style=\"text-transform:lowercase;width:" + col_width + "px;text-align:right;\"     id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"number_change(this,'" + id_ + "'," + col_precision + ")\" name=\"" + name_ + "\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"  readonly style=\"text-transform:lowercase;width:" + col_width + "px;text-align:right;" + enablefontcolor + "\"   name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"number_change(this,'" + id_ + "'," + col_precision + ")\"/>";

        }
        return html_;
    }
    public string column_u_text(string id_, string name_, string value_, string col_width, string col_enable,string rows)
    {
      //           <textarea id="txtf_Content" style="border:1px solid #ccc" cols="120" rows="6" onchange="document.getElementById('txtf_txtContent').value=this.value"  ></textarea>
        string html_ = "<textarea  style=\"width:" + col_width + "px;\"  rows=\"" + rows + "\"  name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"input_change(this,'" + id_ + "')\"/>" + value_ + "</textarea>";
        if (col_enable == "0")
        {
            html_ = "<textarea  style=\"width:" + col_width + "px;" + enablefontcolor + "\"  disabled  rows=\"" + rows + "\"  name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"input_change(this,'" + id_ + "')\"/>" + value_ + "</textarea>";
  
        }
        return html_;
    }

    public string column_u_upper(string id_, string name_, string value_, string col_width, string col_enable)
    {
        string html_ = "<input  type=\"text\"  style=\"text-transform:uppercase;width:" + col_width + "px;\"    name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" onchange=\"input_change(this,'" + id_ + "')\"/>";
        if (col_enable == "0")
        {
            html_ = "<input  type=\"text\"  readonly  style=\"text-transform:uppercase;width:" + col_width + "px;" + enablefontcolor + "\"    name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" />";

        }
        return html_;
    }

    /*下拉列表*/
    public string column_ddd(string id_, string name_, string value_, string col_enable,string col_child,string select_sql,string col_width)
  {
      string html_ = "<input  type=\"hidden\"  name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" />";
     System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
 
     if (col_enable == "0")
     {
         str_html.Append("<select  disabled  id=\"DDD_" + id_ + "\"  style=\"width:" + col_width + "px;\" >");
     }
     else
     {
         str_html.Append("<select  id=\"DDD_" + id_ + "\" onchange=\"ddd_onchange(this,'" + id_ + "','" + col_child + "')\" style=\"width:" + col_width + "px;\">");
     }

     str_html.Append(Environment.NewLine);
     //str_html.Append("<option  selected  value=\"\"></option>");
     DataTable dt = new DataTable();
     dt = getDtBySql(select_sql);

     for (int i = 0; i < dt.Rows.Count; i++)
     {
         if (dt.Rows[i][0].ToString() == value_)
         {
             str_html.Append("<option  selected  value=\"" + dt.Rows[i][0].ToString() + "\">");
         }
         else
         {
             str_html.Append("<option   value=\"" + dt.Rows[i][0].ToString() + "\">");
         }
         str_html.Append(dt.Rows[i][1].ToString());
         str_html.Append(" </option> ");

         str_html.Append(Environment.NewLine);

     }
     str_html.Append("</select>");
     str_html.Append(Environment.NewLine);
     //return str_html.ToString();

     return html_ + str_html.ToString();
  }


  /*下拉列表*/
  public string column_rb(string id_, string name_, string value_, string col_enable, string col_child, string select_sql)
  {
      string html_ = "<input  type=\"hidden\"  name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\" value=\"" + value_ + "\" />";
      System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
 

      str_html.Append(Environment.NewLine);
      DataTable dt = new DataTable();
      dt = getDtBySql(select_sql);

      for (int i = 0; i < dt.Rows.Count; i++)
      {

          if (col_enable == "0")
          {
              if (dt.Rows[i][0].ToString() == value_)
              {
                  str_html.Append("<input  disabled id=\"rb_" + id_ + i.ToString() + "\" checked  type=\"radio\"  name=\"rb_" + id_ + "\"  value=\"" + dt.Rows[i][0].ToString() + "\" onchange=\"rb_onchange(this,'" + id_ + "','" + dt.Rows[i][0].ToString() + "','" + col_child + "')\">" + dt.Rows[i][1].ToString()); //=\"" + dt.Rows[i][0].ToString() + "\">");
              }
              else
              {
                  str_html.Append("<input  disabled id=\"rb_" + id_ + i.ToString() + "\"   type=\"radio\"  name=\"rb_" + id_ + "\"  value=\"" + dt.Rows[i][0].ToString() + "\"  onchange=\"rb_onchange(this,'" + id_ + "','" + dt.Rows[i][0].ToString() + "','" + col_child + "')\">" + dt.Rows[i][1].ToString()); //=\"" + dt.Rows[i][0].ToString() + "\">");
              }

          }
          else
          {
              if (dt.Rows[i][0].ToString() == value_)
              {
                  str_html.Append("<input  id=\"rb_" + id_ + i.ToString() + "\" checked  type=\"radio\"  name=\"rb_" + id_ + "\"   value=\"" + dt.Rows[i][0].ToString() + "\"  onchange=\"rb_onchange(this,'" + id_ + "','" + dt.Rows[i][0].ToString() + "','" + col_child + "')\">" + dt.Rows[i][1].ToString()); //=\"" + dt.Rows[i][0].ToString() + "\">");
              }
              else
              {
                  str_html.Append("<input  id=\"rb_" + id_ + i.ToString() + "\"    type=\"radio\"  name=\"rb_" + id_ + "\"  value=\"" + dt.Rows[i][0].ToString() + "\"   onchange=\"rb_onchange(this,'" + id_ + "','" + dt.Rows[i][0].ToString() + "','" + col_child + "')\">" + dt.Rows[i][1].ToString()); //=\"" + dt.Rows[i][0].ToString() + "\">");
              }
          
          }

          str_html.Append(Environment.NewLine);

      }
      str_html.Append(Environment.NewLine);
      //return str_html.ToString();

      return html_ + str_html.ToString();
  }


    public string getShowCondition(string xml_data)
    { //根据传入的xml_data的 文件内容解析出 sql的条件

        System.Xml.XmlDocument doc = new XmlDocument();
        doc.LoadXml(xml_data);
        string data_ = "";
        XmlNodeList rowsNode = doc.SelectNodes("/DATA/CON");
        string con_all = "";
        if (rowsNode != null)
        {
            
            foreach (XmlNode rowNode in rowsNode)
            {
                string str_con = rowNode.InnerText;
                /*str_sql A10001_KEY=*/
                int pos = str_con.IndexOf("=");
                string A10001_KEY = str_con.Substring(0, pos);
                DataTable dt = new DataTable();
                dt = getDtBySql("Select t.* from A10001 t where a10001_key = " + A10001_KEY);
                string column_id = dt.Rows[0]["column_id"].ToString();
                string con_v = str_con.Substring(pos + 1);
                con_all +=   " AND  ("+column_id + " like '%" + con_v + "%' )";

            }
        }

        return con_all;
    
    }


    public string getRowHtml(string a00201_key,DataRow dr_data , DataTable dt_a013010101, string row_, string rowenable_,string rowkey,string option)
    {
        StringBuilder str_html_ = new StringBuilder();
        string rowid = a00201_key + "_" + row_;
        str_html_.Append(Environment.NewLine);
        if (rowenable_ == "1")
        {
            if (option == "I" || option == "M")
            {
                str_html_.Append("<td id=\"d" + rowid + "\"  class=\"rowdo\"><a  onclick=\"showdetail('" + a00201_key + "','" + rowkey + "','" + a00201_key + "_" + row_ + "')\"> "+ BaseMsg.getMsg("M0009")+"</a></td>");
            }
            else
            {
                str_html_.Append("<td id=\"d" + rowid + "\"  class=\"rowdo\"><a  onclick=\"showdetailv('" + a00201_key + "','" + rowkey + "','" + a00201_key + "_" + row_ + "')\">" + BaseMsg.getMsg("M0010") + "</a></td>");
  
            }
            str_html_.Append(Environment.NewLine);
        }
        string ls_hidden = "";
        for (int j = 0; j < dt_a013010101.Rows.Count; j++)
        {

            string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
            string col_value = dr_data[column_id].ToString();
            string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
            string A10001_KEY = dt_a013010101.Rows[j]["A10001_KEY"].ToString();
            string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
            string bs_width = dt_a013010101.Rows[j]["BS_WIDTH"].ToString();
            string bs_html =  dt_a013010101.Rows[j]["BS_HTML"].ToString(); //a013010101row["BS_HTML"].ToString();
            string col_enable = "1";

            if (option != "I" && option != "M")
            {
                dt_a013010101.Rows[j]["COL_ENABLE"] = "0";
            }
            col_enable = dt_a013010101.Rows[j]["COL_ENABLE"].ToString();
            string ls_showcolumn = ShowColumn(option, a00201_key, dt_a013010101.Rows[j], row_, col_value, "detail");
            if (col_visible == "1")
            {
                if (bs_html != "[" + column_id + "]" && bs_html != "" && bs_html != null)
                {
                    if (col_enable == "0")
                    {
                        dt_a013010101.Rows[j]["COL_VISIBLE"] = "0";
                        ls_showcolumn = ShowColumn(option, a00201_key, dt_a013010101.Rows[j], row_, col_value, "detail");
                        dt_a013010101.Rows[j]["COL_VISIBLE"] = "1";
                        bs_html = bs_html.Replace("[" + column_id + "]", col_value);
                        bs_html = bs_html.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                 
                        for (int i = 0; i < dt_a013010101.Rows.Count; i++)
                        {
                            string column_id_ = dt_a013010101.Rows[i]["COLUMN_ID"].ToString();
                            string col_data_ = dr_data[column_id_].ToString();
                            if (col_data_ == null)
                            {
                                col_data_ = "";
                            }
                            bs_html = bs_html.Replace("[" + column_id_ + "]", col_data_);
                            if (bs_html.IndexOf("[") >= 0 && bs_html.IndexOf("]") >= 0)
                            { }
                            else
                            {
                                break;
                            }
                        }
                        ls_showcolumn = ls_showcolumn + bs_html;
                        // str_html_.Append("<td id=\"d_" + rowid + "_" + A10001_KEY + "\" ondblclick=\"showhtml(this,'" + bs_html + "')\">" + ls_showcolumn + "</td>");
                    }
                }
            }

            if (col_visible == "1")
            {
                str_html_.Append("<td id=\"d_" + rowid + "_" + A10001_KEY + "\">" + ls_showcolumn + "</td>");
                str_html_.Append(Environment.NewLine);
            }
            else
            {
                ls_hidden += ls_showcolumn;
            }

        }

        StringBuilder row_html_ = new StringBuilder();

 
        row_html_.Append(Environment.NewLine);
        string check_box = "<input  type=\"checkbox\"  id=\"cbx_" + rowid + "\" value=\"0\" name=\"cbx_" + a00201_key + "\"/>";
        if (row_ == "[ROW]")
        {
            row_html_.Append("<td class=\"rownum\" id=\"rd" + rowid + "\">" + check_box + "[ROWNUM]" + ls_hidden + "</td>");
        }
        else
        { 
            row_html_.Append("<td class=\"rownum\" id=\"rd" + rowid + "\">" + check_box + row_.ToString() + ls_hidden + "</td>");
        }
        row_html_.Append(Environment.NewLine);



        
        return  row_html_.ToString() +  str_html_.ToString();
    }
    public string DataTable2Json(DataTable dt)
    {
        string jsonText = JsonConvert.SerializeObject(dt);
        
        return jsonText;
    }
    public string getJson(string jsonText, string pcol)
    {
        JObject o = JObject.Parse(@jsonText);

        JsonSerializer serializer = new JsonSerializer();
        Hashtable p = (Hashtable)serializer.Deserialize(new JTokenReader(o), typeof(Hashtable));

        if (p[pcol] == null)
        {
            return "";
        }
        else
        {
            return p[pcol].ToString();
        }
       
    }
    public DataTable getdtByJson(string jsonText)
    {

        JArray o = (JArray)JsonConvert.DeserializeObject(jsonText);
        DataTable dt = new DataTable();
       
          

        for (int i = 0; i < o.Count; i++)
        {
            int c = 0;



            if (i == 0)
            {
               

                 JTokenReader jsonReader = new JTokenReader(o[i]);
              
                while (jsonReader.Read())
                {
                    if (jsonReader.TokenType == JsonToken.PropertyName)
                    {
                        c = c + 1;
                        DataColumn dc = new DataColumn();
                        dc.ColumnName = jsonReader.Value.ToString();
                        dt.Columns.Add(dc);
                    }
                }
                jsonReader.Close();
                //o[0].SelectToken("");
            }

            DataRow dr = dt.NewRow();
            JTokenReader jsonReaderd = new JTokenReader(o[i]);
            c = 0;
            string column_id = "";
            while (jsonReaderd.Read())
            {
                if (jsonReaderd.TokenType == JsonToken.PropertyName)
                {
                    column_id = jsonReaderd.Value.ToString();
                    if (jsonReaderd.Read())
                    {
                        dr[column_id] = jsonReaderd.Value;
                    }
                }
             
            }
            dt.Rows.Add(dr);
 

        }

        return dt;
    }
    public string  getdtJsonV(string jsonText, int  row , string col)
    {

        JArray o = (JArray)JsonConvert.DeserializeObject(jsonText);
        return getJson(o[row].ToString(), col);
    }
    public int getdtJsonCount(string jsonText)
    {

        try
        {
            JArray o = (JArray)JsonConvert.DeserializeObject(jsonText);
            return o.Count;
        }
        catch (Exception ex)
        {
            return 0;
        }
    }
    public  string getQueryCondition(DataTable dt_a00201_ , string queryid)
    { 
        DataTable dt = new DataTable();//USER_ID, A00201_KEY, QUERY_ID
        dt = getDtBySql("Select t.col_name as  COLUMN_ID, t.COL_TYPE as COL_TYPE ,t.col_rela as CALC,t.col_value as VALUE,t.col_sort   from a006 t where t.user_id= '" + GlobeAtt.A007_KEY + "' and A00201_KEY='" + dt_a00201_.Rows[0]["A00201_KEY"].ToString() + "' and query_id='" + queryid + "' order by t.col_sort,t.enter_date,t.rowid");
        
        string con = "";
        string sort_str = "";
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string column_id = dt.Rows[i]["COLUMN_ID"].ToString();
            string col_type = dt.Rows[i]["COL_TYPE"].ToString();
            string CALC = dt.Rows[i]["CALC"].ToString();
            string bcala = dt.Rows[i]["CALC"].ToString();
        
        string SORT = dt.Rows[i]["col_sort"].ToString();
        if (SORT.Length > 0)
        {
            if (SORT.Length == 3)
            {
                if (SORT.Substring(2) == "A")
                {
                    sort_str += column_id + " ASC,";
                }
                if (SORT.Substring(2) == "D")
                {
                    sort_str += column_id + " DESC,";
                }
            }
            else
            {
                if (SORT == "A")
                {
                    sort_str += column_id + " ASC,";
                }
                if (SORT == "D")
                {
                    sort_str += column_id + " DESC,";
                }
            }
        }
   


            if (CALC == "" || CALC == null)
            {
                CALC = "LIKE";
            }
            string v = dt.Rows[i]["VALUE"].ToString();
            if (CALC == "NULL" || CALC == "NOT NULL")
            {
                con += " AND (" + column_id + " IS " + CALC + " ) ";
                continue;
            }
            if (v == null || v == "")
            {
                continue;
            }
            if (CALC == "SQL")
            {
                con += " AND (" + column_id + v + ") ";
                continue;
            }
           
            if (col_type == "datetime" || col_type == "date")
            {
                string[] vlist = v.Split(new char[1] { '|' });
                if (vlist.Length >= 2)
                {
                    string v_begin = vlist[0];
                    string v_end = vlist[1];
                    if (v_begin.Length > 5 || v_end.Length > 5)
                    {
                        if (v_begin.Length < 5)
                        {
                            v_begin = "2000-01-01";
                        }

                        if (v_end.Length < 5)
                        {
                            v_end = "3000-01-01";
                        }
                        if (v_begin.Length > 10)
                        {
                            v_begin = "to_date('" + v_begin + "','YYYY-MM-DD HH24:MI:SS')";
                        }
                        else
                        {
                            v_begin = "to_date('" + v_begin + "','YYYY-MM-DD')";
                        }
                        
                        if (v_end.Length > 10)
                        {
                            v_end = "to_date('" + v_end + "','YYYY-MM-DD HH24:MI:SS')";
                        }
                        else
                        {
                            v_end = "to_date('" + v_end + " 23:59:59','YYYY-MM-DD HH24:MI:SS')";
                         //   v_end = "to_date('" + v_end + "','YYYY-MM-DD')";
                        }
                        con += " AND ( " + column_id + ">=" + v_begin + " and " + column_id + " <= " + v_end + ")";
                    }
                }
            }
            else
            {

                if (CALC == "LIKE" || CALC == "IN" || CALC == "NOT LIKE" || CALC == "NOT IN")
                {
                    if (CALC == "LIKE" || CALC == "NOT LIKE")
                    {
                        if (GlobeAtt.GetValue("QUERY_LIKE") == "1")
                        {
                            if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                            {
                                    con += " AND  (to_char(" + column_id + ") " + CALC + " '%" + v.Replace("|", "") + "%')";
                            }
                            else
                            {
                                con += " AND  (" + column_id + " " + CALC + "  '%" + v.Replace("|", "") + "%')";
                            }
                        }
                        else
                        {
                            //if (v.IndexOf("%") < 0)
                            //{
                            //    //v = "%" + v + "%";
                            //    //查询不加%
                            //    v = v;
                            //}
                            if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                            {
                                if (bcala == "" || bcala == null)
                                {
                                    con += " AND  (" + column_id + "  = '" + v.Replace("|", "") + "')";
                                }
                                else
                                {
                                    con += " AND  (to_char(" + column_id + ") " + CALC + " '" + v.Replace("|", "") + "')";
                                }
                            }
                            else
                            {
                                con += " AND  (" + column_id + " " + CALC + "  '" + v.Replace("|", "") + "')";
                            }
                        
                        }

                    }
                    if (CALC == "IN" || CALC == "NOT IN")
                    {
                        string[] vlist = v.Split(new char[1] { '|' });
                        con += " AND  (" + column_id + " " + CALC  + " (";
                        for (int j = 0; j < vlist.Length; j++)
                        {

                            string[] vlistc = vlist[j].Split(new char[1] { ',' });
                            if (vlist[j].IndexOf(";") > 0)
                            {
                                vlistc = vlist[j].Split(new char[1] { ';' });
                            }
                            for (int k = 0; k < vlistc.Length; k++)
                            {
                                if (vlistc[k].Length > 0)
                                {
                                    con += "'" + vlistc[k] + "',";
                                }
                            }
                        }
                        con = con.Substring(0, con.Length - 1) + ") )";
                    }
                }
                else
                {
                    if (CALC == "BETWEEN")
                    {
                        string[] vlist = v.Split(new char[1] { '|' });
                        if (vlist.Length >= 2)
                        {

                            string v_begin = vlist[0];
                            string v_end = vlist[1];
                            if (v_begin.Length > 0 || v_end.Length > 0)
                            {
                                if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                                {
                                    if (v_begin == "")
                                    {
                                        v_begin = "-999999999999999";
                                    }
                                }
                                else
                                {
                                    v_begin = "'" + v_begin + "'";
                                }

                                if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                                {
                                    if (v_end == "")
                                    {
                                        v_end = "999999999999999";
                                    }

                                }
                                else
                                {
                                    v_end = "'" + v_end + "'";
                                }
                                con += " AND ( " + column_id + ">=" + v_begin + " and " + column_id + " <= " + v_end + ")";
                            }
                        }
                    }
                    else
                    {

                        con += " AND  (" + column_id + " " + CALC + " '" + v.Replace("|","") + "')";
                    }

                }

            }

        
        }

        if (sort_str != "" && sort_str.Length > 0)
        {
            con += " ORDER BY " + sort_str.Substring(0, sort_str.Length - 1);
        }
        return con;
    
    }
    
    


}
