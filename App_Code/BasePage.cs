using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Base;
using System.Text.RegularExpressions;
using System.Xml;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;// ://localhost/Bin/Newtonsoft.Json.dll.refresh
/// <summary>
/// Class1 的摘要说明
/// </summary>
public class BasePage:Page
{
     public BaseFun Fun = new BaseFun();
     public string A007_KEY = string.Empty; //用户key
     public string A30001_KEY = string.Empty;//日志KEY    
     public DataTable dt_a002 = new DataTable();
     public string dialog = "";
    /*
     获取当前的地址
     */
    public string http_url = string.Empty;

    public BasePage()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        http_url = Fun.GetIndexUrl();
     
    }

    public void PageBase_Load(object sender, System.EventArgs e)
    {
        /*生成Ajax*/
       // Ajax.Utility.RegisterTypeForAjax(typeof(BasePage));
       
        try
        {
            A007_KEY = GlobeAtt.A007_KEY;
            A30001_KEY = GlobeAtt.A30001_KEY;
        }
        catch
        {
            A007_KEY = "";
            A30001_KEY = "";
        }
        dialog = Request.QueryString["dialog"] == null ? "0" : Request.QueryString["dialog"].ToString();//不需要日期控件
    
        if (A007_KEY == "")
        {
            string linkcode = Request.QueryString["linkcode"] == null ? "" : Request.QueryString["linkcode"].ToString();


            if (linkcode.Length > 5)
            {
                if (linkcode.IndexOf("userid") == 0)
                { 
                    //自动登录
                    string user = linkcode.Replace("userid", "");
                    if (user != "" && user != null)
                    {
                        BaseLogin BLogin = new BaseLogin("0", user, "", "0");
                        string ls_login = BLogin.checkUserLogin();
                        if (ls_login.IndexOf("02") != 0)
                        {
                            Session["LINK_P_URL"] = Request.Url;
                        }
                    }
                    else
                    {
                        Session["LINK_P_URL"] = Request.Url;
                    }
                }
                else
                {
                    /*解析UCODE 包含用户信息*/
                    string sql = "Select pkg_user.checklogin('" + linkcode + "') as c from dual";
                    DataTable dt_a306 = new DataTable();
                    dt_a306 = Fun.getDtBySql(sql);

                    string a306_id = dt_a306.Rows[0][0].ToString();
                    if (a306_id != "" && a306_id != null)
                    {
                        Session["LINK_A306"] = a306_id;
                        sql = "Select t.* from A306 t where a306_id='" + a306_id + "'";
                        DataTable dt_user = new DataTable();
                        dt_user = Fun.getDtBySql(sql);
                        string user = dt_user.Rows[0]["rec_a007"].ToString();
                        if (user != "" && user != null)
                        {
                            BaseLogin BLogin = new BaseLogin("0", user, "", "0");
                            string ls_login = BLogin.checkUserLogin();
                            if (ls_login.IndexOf("02") != 0)
                            {
                                Session["LINK_P_URL"] = Request.Url;
                            }
                        }
                        else
                        {
                            Session["LINK_P_URL"] = Request.Url;
                        }
                    }
                }
               
            }
            try
            {
                A007_KEY = GlobeAtt.A007_KEY;
                A30001_KEY = GlobeAtt.A30001_KEY;
            }
            catch
            {
                A007_KEY = "";
                A30001_KEY = "";
            }
        }

        if (A007_KEY == "" && Request.Path.ToUpper().IndexOf("LOGIN.ASPX") < 0  )
        {
            Response.Write("<script>parent.parent.location.href='" + GlobeAtt.HTTP_URL + "\\login.aspx?code=0'</script>");
        }
   }
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        //this.Load += new System.EventHandler(PageBase_Load); 
        this.Error += new System.EventHandler(PageBase_Error);
        this.Unload += new System.EventHandler(PageBase_Unload);

    }

    protected void PageBase_Unload(object sender, System.EventArgs e)
    {
            Fun.db.db_oracle.GetDBConnection().Dispose();
            dt_a002.Dispose();
        
    }
    //错误处理 
    protected void PageBase_Error(object sender, System.EventArgs e)
    {
        string errMsg = string.Empty;
        Exception currentError = HttpContext.Current.Server.GetLastError();
        errMsg += "<h1>系统错误：</h1><hr/>系统发生错误， " +
        "该信息已被系统记录，请稍后重试或与管理员联系。<br/>" +
        "错误地址： " + Request.Url.ToString() + "<br/>" +
        "错误信息： " + currentError.Message.ToString() + "<hr/>" +
        "<b>Stack Trace:</b><br/>" + currentError.ToString();
        HttpContext.Current.Response.Write(errMsg);
        Server.ClearError();
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getMsg(string msg_id)
    {
        return BaseMsg.getMsg(msg_id);
    }

    /// <summary>
    /// 获取列的在列属性的xml中得行号
    /// </summary>
    /// <param name="a00201_key_"></param>
    /// <param name="a10001_key_"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getColumnRow(string a00201_key_, string col_, string col_key_)
    {
        string xml_data = "";
        string result = "-1";
        try
        {
            xml_data = HttpContext.Current.Session["A013010101_" + a00201_key_].ToString();
            result = Fun.getColumnRow(xml_data, col_.ToUpper(), col_key_).ToString();
        }
        catch
        {
            return "-1";
        }
        return result;
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string doA00204(string key__ , string menu_id__ ,string line_no__ )
    { 

        /*获取要处理的sql*/
        string e_sql = "select pkg_show.getRb_ExecSql('"+menu_id__+"',"+line_no__+",'"+ key__ +"','"+  GlobeAtt.A007_KEY+"') as c from dual ";
        DataTable dt_sql = new DataTable();
        dt_sql = Fun.getDtBySql(e_sql);
        return Fun.execSql(dt_sql.Rows[0][0].ToString(), GlobeAtt.A007_KEY, menu_id__ + "_" + line_no__.ToString());
        
    }
    /// <summary>
    /// 执行审批
    /// </summary>
    /// <param name="key__"></param>
    /// <param name="menu_id__"></param>
    /// <param name="sp_tg"> 0 通过 1 不通过</param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string userdosp(string key__, string table_id__, string sp_tg, string des_, string a332_id__)
    {

        /*获取要处理的sql*/
        try
        {
            string e_sql = "pkg_a.change_a33201('" + table_id__ + "','" + key__ + "','" + GlobeAtt.A007_KEY + "','" + sp_tg + "','" + des_.Replace("'", "''") + "','[A311_KEY]'," + a332_id__ + ")";
            e_sql = Fun.execSql(e_sql, GlobeAtt.A007_KEY, GlobeAtt.A002_KEY + "_" + a332_id__, "A332_ID=" + a332_id__);
        if (e_sql != "0")
        {
            return e_sql;
        }

        }
        catch(Exception ex)
        {
            return "00" + ex.Message;
        }
        return "00操作成功";
   }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string DoA014Query(string a014_id_, string objid_, string table____)
    {

        string sql_ = objid_;
        string[] sqllist = Regex.Split(objid_, "<V></V>", RegexOptions.IgnoreCase);
        string e_sqllist ="";
        for (int i = 0; i < sqllist.Length; i++)
        {
            string str_sql = sqllist[i];
            if (str_sql == null || str_sql.Length < 5)
            {
                continue;
            }
            /*获取要处理的sql*/
            try
            {
                string e_sql = "pkg_a.doa014('" + a014_id_ + "','" + table____ + "','" + str_sql + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";
                e_sqllist += "begin " +  e_sql +";end;";
                e_sql = Fun.execSql(e_sql, GlobeAtt.A007_KEY, GlobeAtt.A002_KEY, "A014_ID=" + a014_id_);
                if (e_sql != "0")
                {
                    return e_sql;
                }

            }
            catch (Exception ex)
            {
                return "00" + ex.Message;
            }
            
        }
        //    public string execSqlList(string sqlxml, string user_id_, string menu_id_,string key_id,string a014_id_)
        Fun.execSqlList(e_sqllist, GlobeAtt.A007_KEY, GlobeAtt.A002_KEY, "[A311_KEY]", a014_id_);
        return "00" + BaseMsg.getMsg("M0018"); ;
    }
    /*执行a014_id*/
  

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string DoA014(string a014_id_, string objid_, string table____)
    {
        /*获取要处理的sql*/
        try
        {
            string e_sql = "pkg_a.doa014('" + a014_id_ + "','" + table____ + "','" + objid_ + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";
            e_sql = Fun.execSql(e_sql, GlobeAtt.A007_KEY, GlobeAtt.A002_KEY , "A014_ID=" +  a014_id_);
            if (e_sql != "0")
            {
                return e_sql;
            }

        }
        catch (Exception ex)
        {
            return "00" + ex.Message;
        }
        return "00操作成功";
   
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string dolistA00204(string key__, string menu_id__, string line_no__)
    {

        /*获取要处理的sql*/
        int rowcount = Fun.getRowCount(key__);
        System.Text.StringBuilder str_sql = new System.Text.StringBuilder("");//抬头html
        string sql_list = "";
        for(int i= 0;i< rowcount ;i++)
        {
            string  data = Fun.getXmlData(key__,i,"PARM");
            string e_sql = "select pkg_show.getRb_ExecSql('" + menu_id__ + "'," + line_no__ + ",'" + data + "','" + GlobeAtt.A007_KEY + "') as c from dual ";

 
         
            DataTable dt_sql = new DataTable();
            dt_sql = Fun.getDtBySql(e_sql);
            e_sql = Fun.execSql(dt_sql.Rows[0][0].ToString(), GlobeAtt.A007_KEY, menu_id__ + "_" + line_no__);
             if (e_sql != "0")
            {
                return e_sql;
            }
            /*  

               e_sql = dt_sql.Rows[0][0].ToString();
               e_sql = e_sql.Replace(" end;", "");
               e_sql = e_sql.Replace(" end", "");
               e_sql = e_sql.Replace(";end;", ";");
               e_sql = e_sql.Replace(";end", ";");
               e_sql = e_sql.Replace("begin ", "");

  
           
            if (e_sql.Substring(e_sql.Length - 1, 1) != ";")
            {
                e_sql = e_sql + ";";
            }
            str_sql.Append(e_sql );
            str_sql.Append(Environment.NewLine);
            */
          
        }
      //  return "00" + str_sql.ToString();
        return "01操作成功！";//刷新页面
    
    }


   // function do_proc(key_,menu_id_, line_no_)


    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public DataTable  getDtByXML(string xml_)
    {
        return Fun.getDtByPkg(xml_);
    }
    /// <summary>
    /// 根据a006的主键获取where语句
    /// </summary>
    /// <param name="a006_key"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getCondition(string a006_key, string xml_)
    {
        DataTable dt = new DataTable();
        string a006_xml = xml_;
 
        if (xml_.Length < 30)
        {
            DataTable dt_a00201_ = new DataTable();
            dt_a00201_ = Fun.getDtBySql("Select t.* from A00201_v01 t where a00201_key='" + xml_ + "'");
           // DataTable dt_a006 = new DataTable();
            dt = Fun.getDtBySql("Select t.col_name as  COLUMN_ID, t.COL_TYPE as COL_TYPE ,t.col_rela as CALC,t.col_value as VALUE,t.col_sort as SORT  from a006 t where t.user_id= '" + GlobeAtt.A007_KEY + "' and menu_id='" + dt_a00201_.Rows[0]["menu_id"].ToString() + "' and query_id='" + a006_key + "' order by t.rowid");
           // a006_xml = dt_a006.Rows[0]["QUERY_XML"].ToString();
        }
        else
        {
            dt = Fun.getDtByPkg(a006_xml);
        }
        string con = "";
        string sort_str = "";
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            string column_id = dt.Rows[i]["COLUMN_ID"].ToString();
            string col_type = dt.Rows[i]["COL_TYPE"].ToString();
            string CALC = dt.Rows[i]["CALC"].ToString();
            try
            {
                string SORT = dt.Rows[i]["SORT"].ToString();
                if (SORT =="A")
                {
                    sort_str +=  column_id  +" ASC,";
                }
                if (SORT =="D")
                {
                    sort_str += column_id + " DESC,";
                }

            }
            catch
            {
                sort_str += "";
            }


            if (CALC == "" || CALC == null)
            {
                CALC = "LIKE";
            }
            string v = dt.Rows[i]["VALUE"].ToString();
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
                            v_end = "to_date('" + v_end + "','YYYY-MM-DD')";
                        }
                        con += " AND ( " + column_id + ">=" + v_begin + " and " + column_id + " <= " + v_end + ")";
                    }
                }
            }
            else
            {

                if (CALC == "LIKE" || CALC == "IN" || CALC == "NOT LIKE")
                {
                    if (CALC == "LIKE" || CALC == "NOT LIKE")
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
                    if (CALC == "IN")
                    {
                        string[] vlist = v.Split(new char[1] { '|' });
                        con += " AND  (" + column_id + " IN (";
                        for (int j = 0; j < vlist.Length; j++)
                        {
                            if (vlist[j].Length > 0)
                            {
                                con += "'" + vlist[j] + "',";
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

    /// <summary>
    /// 获取列的属性值
    /// </summary>
    /// <param name="a00201_key_"></param>
    /// <param name="row_"></param>
    /// <param name="att_"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getColumnAtt(string a00201_key_, int row_, string att_)
    {
        string xml_data = "";
        string result = "";
        try
        {
            xml_data = HttpContext.Current.Session["A013010101_" + a00201_key_].ToString();
            result = Fun.getXmlData(xml_data, row_, att_.ToUpper());
        }
        catch
        {
            return "";
        }
        return result;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public DataTable getA013010101(string a00201_key_)
    {
        DataTable dt_ = new DataTable();
        dt_ = Fun.getA013010101(a00201_key_); 
        return dt_;
    }


    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string execsql(string sql)
    {
        return Fun.execSql(sql, GlobeAtt.A007_KEY, GlobeAtt.A002_KEY);
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getRowHTML(string a00201_key_,  int row_, string option)
    {
        string showdatasql = Fun.getShowDataSql(a00201_key_);
        DataTable  dt_0 = Fun.getDtBySql(showdatasql + " AND 1 = 2");
        DataRow dr = dt_0.NewRow();
        dt_0.Rows.Add(dr);
        string rowhtml = Fun.getRowHtml(a00201_key_, dt_0.Rows[0], getA013010101(a00201_key_), "[ROW]", "1", "0", option);
        return rowhtml;


    }



    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string doXml(string sqlxml,string key_)
    {
        return Fun.execSqlList(sqlxml, GlobeAtt.A007_KEY, GlobeAtt.A002_KEY , key_);
    }
    /// <summary>
    /// 检查有没有变更
    /// </summary>
    /// <param name="key_"></param>
    /// <param name="a002_key__"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string checkA309(string key_, string a002_key__)
    {
        string sql_ = "select t.* from A309 t where t.a002_id='" + a002_key__ + "' and key_id='" + key_ + "' and STATUS='0'";
        DataTable dt_a309 = new DataTable();
        dt_a309 = Fun.getDtBySql(sql_);
        if (dt_a309.Rows.Count > 0)
        {
            return "00" + getMsg("M0016");
        }
        return "1";
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string doA309(string sqlxml, string key_, string a002_key__,string reason_ )
    {
        string sql_ = "select s_a309.nextval as c from dual ";
        DataTable dt_id = new DataTable();
        dt_id = Fun.getDtBySql(sql_);
        string a309_id = dt_id.Rows[0][0].ToString();
        //判断有没有生效的变更
        dt_id.Dispose();

        sql_ = "insert into A309(a309_id,A309_NAME,KEY_ID,REASON,DESCRIPTION,ENTER_USER,ENTER_DATE,STATUS,A002_ID,EXEC_SQL)";
        sql_ += " Values (" + a309_id + ",'" + a002_key__ + "-变更','" + key_ + "','" + reason_.Replace("'", "''") + "',null,'" + GlobeAtt.A007_KEY + "',sysdate,'0','" + a002_key__ + "','" + sqlxml.Replace("'", "''") + "')";
        try
        {
            int li_db = Fun.execSqlOnly(sql_);
            if (li_db < 0)
            {
                return "00" + getMsg("M0017");
            }
        }
        catch( Exception ex )
        {
            return  "00" +  ex.Message;
        }
        return "01";
    }


    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getMenuKey(string a002_key)
    {
        try
        {
            DataTable dt = new DataTable();
            dt = Fun.getDtBySql("select pkg_a.getTableKey('" + a002_key + "') as c from dual ");
            return dt.Rows[0][0].ToString();
        }
        catch
        {
            return "-1";
        }
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getKeyLineNo(string a00201_key_, string key_id)
    {
        try
        {
            DataTable dt = new DataTable();
            dt = Fun.getDtBySql("select pkg_a.getKeyLineNo('" + a00201_key_ + "','" + key_id + "') as c from dual ");
            return dt.Rows[0][0].ToString();
        }
        catch
        {
            return "-1";
        }
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string saveData(string a00201_key_, string data_)
    {
        string xml_data = "";
        string result = "-1";
        try
        {
            xml_data = HttpContext.Current.Session["A013010101_" + a00201_key_].ToString();
            
        }
        catch
        {
            return "-1";
        }
        return result;
    }



    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getShowCondition(string a00201_key_ , string xml_data)
    {
        try
        {
            string con = Fun.getShowCondition(xml_data);
            HttpContext.Current.Session["IF_JUMP"] = "0";
            HttpContext.Current.Session["CON_" + a00201_key_] = con;
            HttpContext.Current.Session["currentpage_" + a00201_key_] = "1";
            return "01";
        }
        catch(Exception ex )
        {
            return "00" + ex.Message;
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string showPageNum(string a00201_key_, string pagenum)
    {
        try
        {
            HttpContext.Current.Session["IF_JUMP"] = "0";
            HttpContext.Current.Session["currentpage_" + a00201_key_] = pagenum;
            return "01";
        }
        catch (Exception ex)
        {
            return "00" + ex.Message;
        }
    
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getSession(string key)
    {
        string session_d = "";
        try
        {
            session_d = Session[key].ToString();
        }
        catch
        {
            session_d = "";
        }
        return session_d;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string setSession(string key, string v)
    {
        string session_d = v;
        try
        {
            Session[key] = v;
        }
        catch
        {
            Session[key] = "";
            session_d = "";
        }
        return session_d;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SaveA006(string  A00201_KEY_,string query_id, string QUERY_XML)
    {
       // <?xml version="1.0" encoding="utf-8" ?><DATA><ROW><A10001_KEY>COL22</A10001_KEY><COLUMN_ID>COL22</COLUMN_ID><COL_TYPE>varchar</COL_TYPE><CALC></CALC><VALUE>6261|</VALUE>COL22</ROW></DATA>
           string sql = "Select  s_a006.nextval as c from dual ";
         DataTable dt_key = new DataTable();
         dt_key = Fun.getDtBySql(sql);
         string a006_key = dt_key.Rows[0][0].ToString();
         // USER_ID, QUERY_ID, TABLE_ID, MENU_ID where user_id='" + A007_KEY + "' AND menu_id  ='" + menu_id + "'and table_id='"+ table_id +"' and query_id='" + query_id +"'" ;
          // sql_insert = sql_insert + " Select " + a006_key + ",'" + query_id + "','" + GlobeAtt.A007_KEY + "',sysdate," + GlobeAtt.A007_KEY + "," + A00201_KEY_ + ",'" + QUERY_XML.Replace("'", "''") + "' from dual ";
         int rows = Fun.getRowCount(QUERY_XML); 
        DataTable dt_a00201_ =  new DataTable();
        sql ="Select t.* from A00201_V01 t where a00201_key='" +A00201_KEY_  +"'";
          dt_a00201_ =  Fun.getDtBySql(sql);
          string sql_insert = "delete from  a006 where USER_ID='" + GlobeAtt.A007_KEY + "' and  query_id = '";
          sql_insert += query_id + "' and  TABLE_ID='" + dt_a00201_.Rows[0]["table_id"].ToString() + "' and menu_id='" + dt_a00201_.Rows[0]["menu_id"].ToString() + "'";// Insert into A006(  A006_KEY ,query_id,enter_user,enter_date,A007_KEY,A00201_KEY,QUERY_XML)";
  
          Fun.db.BeginTransaction();
          int li_db = Fun.db.ExecuteNonQuery(sql_insert, CommandType.Text);
          if (li_db < 0)
          {
              Fun.db.Rollback();
              return "-1";
          }
          Fun.db.Commit();   
         for (int i = 0; i < rows; i++)
         {
             string column_id = Fun.getXmlData(QUERY_XML, i, "COLUMN_ID");
             string COL_TYPE = Fun.getXmlData(QUERY_XML, i, "COL_TYPE");
             string CALC = Fun.getXmlData(QUERY_XML, i, "CALC");
             string VALUE = Fun.getXmlData(QUERY_XML, i, "VALUE").Replace("'","''");
             string sort = Fun.getXmlData(QUERY_XML, i, "SORT");
             sql_insert = "Insert into A006(MENU_ID,user_id,table_id,query_id,col_name,col_rela,col_value,enter_user,enter_date,RESULTROW,COL_TYPE,COL_SORT,A00201_KEY)" ;
             sql_insert += "Values('" + dt_a00201_.Rows[0]["menu_id"].ToString() + "','" + GlobeAtt.A007_KEY + "','" + dt_a00201_.Rows[0]["table_id"].ToString() + "','" + query_id + "','" + column_id + "','" + CALC + "','" + VALUE + "','" + GlobeAtt.A007_KEY + "',sysdate,10000,'" + COL_TYPE + "','" + sort + "','" + A00201_KEY_ + "')";
             Fun.db.BeginTransaction(); 
             li_db = Fun.db.ExecuteNonQuery(sql_insert, CommandType.Text);
             if (li_db < 0)
             {
                 Fun.db.Rollback();
                 return "-1";
             }
             Fun.db.Commit();  
            
         }
         
         return query_id;
    }


    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public DataTable getDtBySql(string sql)
    {
        DataTable v = new DataTable();
        v = Fun.getDtBySql(sql.Replace("\"", "'"));
        return v;
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public String getDataIndex()
    {

        return GlobeAtt.DATA_INDEX;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public String getPData(string a00201_key___,string pnum)
    {
        string v = "";
        try
        {
            string jsonText = Session["J_" + a00201_key___].ToString();
            v = Fun.getJson(jsonText, pnum);
            return v;
        }
        catch( Exception ex ) {
            v = "";
        }
        return v;
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public DataTable getdtData(string a00201_key___, string pnum)
    {
        DataTable dt_v =  new DataTable();
        try
        {
            string jsonText_ = Session["J_" + a00201_key___].ToString();
            string jsonText = Fun.getJson(jsonText_, pnum);
            dt_v = Fun.getdtByJson(jsonText);
            return dt_v;
        }
        catch (Exception ex)
        {
            
        }
        return dt_v;
    }


    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public DataTable getMsgdt()
    {
        DataTable dt = new DataTable();
        string sql = Fun.getA022Name("BS_MSG");
        sql = sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
        sql = sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);        
        return Fun.getDtBySql(sql);
    }




    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string getStrBySql(string sql)
    {
        try
        {
            DataTable dt = new DataTable();
            dt = Fun.getDtBySql(sql.Replace("\"","'"));
            string v_ = "";
            if (dt.Rows.Count == 0)
            {
                return "";
            }
            else
            {

                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    v_ += dt.Rows[0][i].ToString() + "<V></V>";

                }
            }
            return v_;
        }
        catch
        {
            return "";
        }
    }

    /*把数据导出到xls*/
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string savefile(string a00201_key_)
    {
        DataTable dt_main = new DataTable();
        dt_main = Fun.getDtBySql("Select t.* from A002_v01 t where a002_key='" + a00201_key_ + "'");
        string getdatasql_ = HttpContext.Current.Session["QUERY_" + a00201_key_].ToString();
        DataTable dt_data = new DataTable();
        DataTable dt_show = new DataTable();
        string sql = " ";
        dt_show = Fun.getA013010101(a00201_key_);
        dt_data = Fun.getDtBySql(getdatasql_);
        string ls_xls="";
        string uploadfilepath = HttpContext.Current.Request.MapPath("..\\data\\Blank.xls");
        string model_file = uploadfilepath;
        string table_id__ = dt_main.Rows[0]["table_id"].ToString();
        if (System.IO.File.Exists(uploadfilepath) == true)
        {

            string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath); // Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath);
            uploadfilepath = "..\\temp";
            string vpsh = uploadfilepath + "\\" + table_id__ + "\\" + filename;
            string psh = HttpContext.Current.Request.MapPath(vpsh);
            if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(psh)))
            {
                System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(psh));
            }
    
            ls_xls = Fun.GetIndexUrl() + "/temp/" + table_id__ + "/" + filename;


            string outfilename = HttpContext.Current.Request.MapPath("..\\temp\\" + table_id__ + "\\" + filename);
            string[] column_id_ = new string[250];
            string[] col_text_ = new string[250];
            string[] remove_col = new string[250];
            int col_num = 0;
            int remove_num = 0;
            string[] Removecol= new string[250];
            for (int j = 0; j < dt_show.Rows.Count; j++)
            {
                string col_text = dt_show.Rows[j]["col_text"].ToString();
                string column_id = dt_show.Rows[j]["column_id"].ToString().ToUpper();
                string col_visible = dt_show.Rows[j]["col_visible"].ToString();
                
                if (col_visible !="1" )
                {
                    continue;
                }
                for (int c = 0; c < dt_data.Columns.Count; c++)
                {
                    if (dt_data.Columns[c].ColumnName == column_id)
                    {
                        dt_data.Columns[c].Caption = col_text;
                        break;
                    }
                }
              
                column_id_[col_num] = column_id;
                col_text_[col_num] = col_text;
                col_num = col_num + 1;
            }
            for (int c = 0; c < dt_data.Columns.Count; c++)
            {
                string column_id = dt_data.Columns[c].ColumnName.ToUpper();
                string col_visible ="0";
                for (int j = 0; j < col_num; j++)
                {
                    if (column_id == column_id_[j])
                    {
                        col_visible = "1";
                        break;
                    }
                }
                if (col_visible != "1")
                {
                    remove_col[remove_num] = column_id;
                    remove_num = remove_num + 1;
                    continue;
                }
            }
            for(int i= 0 ;i < remove_num; i++)
            {

                dt_data.Columns.Remove(remove_col[i]);
            }

            ExcelFunc exc = new ExcelFunc();
            //exc.SaveExcel(dt_data, model_file, outfilename);
            exc.WriteExeclByColumns(dt_data, column_id_, col_text_, model_file, outfilename);


        }
          







        return ls_xls;
    }
}
