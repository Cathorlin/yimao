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

/// <summary>
/// Login 的摘要说明

/// 登录的代码

/// </summary>
public class BaseLogin
{
   // db20120229 db = new db20120229();
    private string _user_id = "";//登录输入的用户名称

    private string _pass_word = "";//登录输入的用户密码

    private string _comp_no = "";//登录输入的用户密码

    private BaseMsg usermsg = new BaseMsg();
    private BaseFun fun = new BaseFun();
    private string _if_check__ = "1";//登录输入的用户密码

    public BaseLogin(string  comp_no_ ,string user_id_, string pass_word_, string if_checkpass)
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        _user_id = user_id_;
        _pass_word = pass_word_;
        _comp_no = comp_no_;
        _if_check__ = if_checkpass;
    }
/// <summary>
/// 检测用户登录

/// </summary>
/// <returns>0 成功</returns>
    public string checkUserLogin( )
    {
        try
        {
            //  in varchar2,  user_id_ in varchar2,
            //   pass_word_ in varchar2 ,user_ip_  in varchar2
            string clientip = fun.getClientIp();

            string sql = "Select PKG_User.checkUserLogin('" + _comp_no + "','" + _user_id + "','" + _pass_word.Replace("'", "''") + "','" + clientip + "','" + _if_check__ + "') as c from dual ";
            DataTable dt = new DataTable();
            int li_db = fun.db.ExcuteDataTable(dt, sql, CommandType.Text);
            if (li_db < 0)
            {
                return "01执行校验失败！";
            }
            int li_res = int.Parse(dt.Rows[0][0].ToString());
            if (li_res < 0)
            {
                return usermsg.getMsgByMsgId("100001", "");
            }
            /*登录成功以后执行写日志和写事务*/

            DataTable dt_key = new DataTable();
            sql = "select s_a300.nextval  as c  from dual ";
            li_db = fun.db.ExcuteDataTable(dt_key, sql, CommandType.Text);
            if (li_db < 0)
            {
                return "01执行校验失败！";
            }
            sql = "Select  a022_name  from a022 t where  a022_id='CHECK_MAC_NAME' ";

            string CHECK_MAC_NAME = "1";
            DataTable dt_a = new DataTable();
            dt_a = fun.getDtBySql(sql);
            if (dt_a.Rows.Count > 0)
            {
                CHECK_MAC_NAME = dt_a.Rows[0][0].ToString();
                if (CHECK_MAC_NAME != "1")
                {
                    CHECK_MAC_NAME = "0";
                }
            }
            if (CHECK_MAC_NAME == "1")
            {

                try
                {
                    System.Net.IPHostEntry hostInfo = System.Net.Dns.GetHostByAddress(clientip);

                    sql = "PKG_User.UserLogin('" + _user_id + "','" + clientip + "'," + dt_key.Rows[0][0].ToString() + ",'" + hostInfo.HostName + "','WEB','" + _comp_no + "')";
                }
                catch
                {
                    sql = "PKG_User.UserLogin('" + _user_id + "','" + clientip + "'," + dt_key.Rows[0][0].ToString() + ",'" + clientip + "','WEB','" + _comp_no + "')";

                }
            }
            else
            {
                sql = "PKG_User.UserLogin('" + _user_id + "','" + clientip + "'," + dt_key.Rows[0][0].ToString() + ",'" + clientip + "','WEB','" + _comp_no + "')";

            }
            string res = fun.execSql(sql, _user_id, "login");
            if (res != "0")
            {

                return res;
            }
            /*初始化 把用户数据 记录到session中*/
        
            if (GlobeAtt.A007_KEY != "")
            {
                if (_user_id != GlobeAtt.A007_KEY)
                {
                    HttpContext.Current.Session.Clear();
                }
            }

            //用户属性
            HttpContext.Current.Session["USER_ID"] = _user_id;
            HttpContext.Current.Session["A007_KEY"] = _user_id;
            HttpContext.Current.Session["A30001_KEY"] = dt_key.Rows[0][0].ToString();

            DataTable dt_a007 = new DataTable();
            sql = "Select t.* from A007_v01 t where a007_id= '" + _user_id + "'";
            li_db = fun.db.ExcuteDataTable(dt_a007, sql, CommandType.Text);
            if (li_db < 0)
            {
                return "01执行校验失败！";
            }
            HttpContext.Current.Session["A007_NAME"] = dt_a007.Rows[0]["A007_NAME"].ToString();

            HttpContext.Current.Session["LANGUAGE_ID"] = dt_a007.Rows[0]["LANGUAGE_ID"].ToString();


            DataTable dt_dataindex = new DataTable();
            dt_dataindex = fun.getDtBySql("select f_get_data_index() as c  from dual ");
            string v = dt_dataindex.Rows[0][0].ToString();
            dt_dataindex.Dispose();
            HttpContext.Current.Session["DATA_INDEX"] = v;

            DataTable dt_config = new DataTable();

            sql = "Select pkg_show.getSysConfig('" + _user_id + "') as c from dual ";

            DataTable dt_temp = new DataTable();
            dt_temp = fun.getDtBySql(sql);

            sql = dt_temp.Rows[0][0].ToString();


            dt_config = fun.getDtBySql(sql);


            for (int i = 0; i < dt_config.Columns.Count; i++)
            {

                string column_id = dt_config.Columns[i].ColumnName.ToUpper();
                HttpContext.Current.Session["CFG_" + column_id] = dt_config.Rows[0][i].ToString();

            }
            string ls_cfg = fun.DataTable2Json(dt_config);
            HttpContext.Current.Session["CFG"] = ls_cfg;


            DataTable dt_a022 = new DataTable();
            sql = "Select t.* from A022 t ";
            dt_a022 = fun.getDtBySql(sql);
            for (int i = 0; i < dt_a022.Rows.Count; i++)
            {
                string a022_id = dt_a022.Rows[i]["A022_ID"].ToString();
                string a002_name = dt_a022.Rows[i]["A022_NAME"].ToString();
                a002_name = a002_name.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                a002_name = a002_name.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                string if_exec = dt_a022.Rows[i]["if_exec"].ToString();
                if (if_exec == "1")
                {
                    DataTable dt_exec = new DataTable();
                    dt_exec = fun.getDtBySql(a002_name);
                    a002_name = dt_exec.Rows[0][0].ToString();
                }
                HttpContext.Current.Session[a022_id.ToUpper()] = a002_name;            
            }
            try
            {
                string LINK_A007_ID = HttpContext.Current.Session["LINK_A007_ID"].ToString();
                if (LINK_A007_ID != _user_id)
                {
                    HttpContext.Current.Session["LINK_P_URL"] = "";
                }
            }
            catch
            {
                HttpContext.Current.Session["LINK_P_URL"] = "";
            }
                /* = fun.getA022Name("QueryList_PageRow");
                 HttpContext.Current.Session["QueryList_MaxRow"] = fun.getA022Name("QueryList_MaxRow");
                 HttpContext.Current.Session["DetailRowS"] = fun.getA022Name("DetailRowS");
                 HttpContext.Current.Session["BS_LOG_SQL"] = fun.getA022Name("BS_LOG_SQL");
                 HttpContext.Current.Session["BS_LOG_A314"] = fun.getA022Name("BS_LOG_A314");
                 HttpContext.Current.Session["SYS_MODE"] = fun.getA022Name("SYS_MODE");
                 HttpContext.Current.Session["BS_LOG_SELECTSQL"] = fun.getA022Name("BS_LOG_SELECTSQL");
                 HttpContext.Current.Session["QUERY_LIKE"] = fun.getA022Name("QUERY_LIKE");
                 */
                //HttpContext.Current.Session["A007"] = fun.setPkSYS_MODEgStr(dt_a007);


                //DataTable dt_a00701 = new DataTable();
                //sql = "Select t.* from A00701 t  where a007_key= " + li_res.ToString();
                //li_db = fun.db.ExcuteDataTable(dt_a00701, sql, CommandType.Text);
                //if (li_db < 0)
                //{
                //    return "01执行校验失败！";
                //}

                //HttpContext.Current.Session["A013"] = fun.setPkgStr(dt_a00701);



                ///*登录的日志信息*/
                //DataTable dt_a30001 = new DataTable();
                //sql = "Select t.* from A30001 t where a30001_key= " + dt_key.Rows[0][0].ToString();
                //li_db = fun.db.ExcuteDataTable(dt_a30001, sql, CommandType.Text);
                //if (li_db < 0)
                //{
                //    return "01执行校验失败！";
                //}
                //HttpContext.Current.Session["A30001"] = fun.setPkgStr(dt_a007);


                return "02[HTTP_URL]/default.aspx";
        }
        catch (Exception ex )
        {
            return "00" + ex.Message.Replace("\n", ";").Replace("'", "\"") ;
        }
            
    }


}
