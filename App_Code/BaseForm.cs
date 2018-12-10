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
/// <summary>
/// BaseForm 的摘要说明
/// </summary>
public class BaseForm : Page
{
    public BaseFun Fun = new BaseFun();
    public string a00201_key = "";
    public DataTable dt_a00201 = new DataTable();
    public DataTable dt_a013010101 = new DataTable();
    public DataTable dt_data = new DataTable();
    public DataTable dt_temp = new DataTable();
    public string showdatasql = string.Empty;
    public string getShowDataCountSql = string.Empty;
    public string json = "";
    public string RequestXml = "";
    public string DIVID = "";
    public string QUERYID = "";
    public string RequestURL = "";
    
	public BaseForm()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}
    public void PageBase_Load(object sender, System.EventArgs e)
    {
        if (GlobeAtt.A007_KEY == "")
        {
            Response.Write("showlogin();");
            return;
        }

      
         try
        {
            Stream RequestStream = Request.InputStream;
            StreamReader RequestStreamReader = new StreamReader(RequestStream);
            RequestXml = RequestStreamReader.ReadToEnd();
            RequestStream.Close();

            a00201_key = BaseFun.getAllHyperLinks(RequestXml, "<A00201KEY>", "</A00201KEY>")[0].Value;
            try
            {
                RequestURL = BaseFun.getAllHyperLinks(RequestXml, "<URL>", "</URL>")[0].Value;
            }
            catch
            {
                RequestURL = "";
            }

        }
        catch ( Exception ex)
        {
            a00201_key = "-1";
            return;
        }

       // a00201_key = Request.QueryString["A00201KEY"] == null ? "-1" : Request.QueryString["A00201KEY"].ToString();
        if (a00201_key == "-1")
        { 
            return ;
        }
    
        try
        {
            json = Session["JSON_" + a00201_key].ToString();
        }
        catch
        {
            json = "";
        }
        if (GlobeAtt.SYS_MODE == "K")
        {
            json = "";
        }
        if (json == "")
        {
            Hashtable ht = new Hashtable();
            dt_a013010101 = Fun.getA013010101(a00201_key);
            dt_a00201 = Fun.getDtBySql("Select t.* from A00201_V01 t where a00201_key = '" + a00201_key + "' order by  line_no  ");
            //列属性
            ht.Add("P1", Fun.DataTable2Json(dt_a013010101));
            //菜单属性
            ht.Add("P2", Fun.DataTable2Json(dt_a00201));
            //数据检测属性
            if (dt_a00201.Rows[0]["IF_MAIN"].ToString() == "1")
            {
                ht.Add("P3", Fun.DataTable2Json(Fun.getDtBySql("select t.* from A00210_V01 t  where menu_id ='" + dt_a00201.Rows[0]["MENU_ID"].ToString() + "' and   rb_type='C'")));
                ht.Add("P4", Fun.DataTable2Json(Fun.getDtBySql("select t.* from A00210_V01 t  where menu_id ='" + dt_a00201.Rows[0]["MENU_ID"].ToString() + "' and   rb_type='U'")));
                ht.Add("P9", Fun.DataTable2Json(Fun.getDtBySql("select t.* from A00201_V01 t  where menu_id ='" + dt_a00201.Rows[0]["MENU_ID"].ToString() + "' order by line_no")));
   
            }
            //右键属性
            ht.Add("P5", Fun.DataTable2Json(Fun.getDtBySql("select t.*   from a00201_v02 t  where a00201_key ='" + a00201_key + "' order by sort_by")));
            //查询数据的SQL
            showdatasql = Fun.getShowDataSql(a00201_key);
            ht.Add("P6", showdatasql);
             //查询数据数量的SQL
            getShowDataCountSql = Fun.getShowDataCountSql(a00201_key);
            ht.Add("P7", getShowDataCountSql);
            //打印列表
            if (dt_a00201.Rows[0]["if_main"].ToString() == "1")
            {
                ht.Add("P8", Fun.DataTable2Json(Fun.getDtBySql("select t.*   from A00205 t  where menu_id ='" + dt_a00201.Rows[0]["menu_id"].ToString() + "' order by sort_by")));
            }
            else
            {   ht.Add("P8", "");
            }
            string form_init = dt_a00201.Rows[0]["FORM_INIT"].ToString();

            ht.Add("P10", form_init);
            string jsonText = JsonConvert.SerializeObject(ht);
            Session["JSON_" + a00201_key] = jsonText;
            json = jsonText;
        }
        else
        {
            dt_a013010101 = Fun.getdtByJson(Fun.getJson(json, "P1"));
            dt_a00201 = Fun.getdtByJson(Fun.getJson(json, "P2"));
            showdatasql = Fun.getJson(json, "P6");
            getShowDataCountSql = Fun.getJson(json, "P7");
        }
      
        try
        {
            QUERYID = BaseFun.getAllHyperLinks(RequestXml, "<QUERYID>", "</QUERYID>")[0].Value;

        }
        catch
        {
            QUERYID = "";
        }
        string condition = "";

        if (QUERYID != "")
        {
            condition = Fun.getQueryCondition(dt_a00201, QUERYID);
            int pos = condition.IndexOf("ORDER BY");
            string str_order = "";
            if (pos > 0)
            {
                str_order = condition.Substring(pos);
                condition = condition.Substring(0, pos - 1);

            }

            showdatasql = showdatasql + condition + "  "  + str_order;   
            getShowDataCountSql = getShowDataCountSql + condition ;
        }
        string url = "";
        try
        {
            url = BaseFun.getAllHyperLinks(RequestXml, "<URL>", "</URL>")[0].Value;
        }
        catch
        {
            url = "";
        }
        if (url.IndexOf("?") > 0)
        { 
            
            int pos = url.IndexOf("?");
            url = url.Substring(pos + 1);
            string[] data_ = url.Split('&');
            for (int i = 0; i < data_.Length; i++)
            {
                 string[] data1_ = data_[i].Split('=');               
                 showdatasql = showdatasql.Replace("[REQUEST_" + data1_[0] + "]",data1_[1]);
                 getShowDataCountSql = getShowDataCountSql.Replace("[REQUEST_" + data1_[0] + "]", data1_[1]);
            }

        }

 
    }
    /// <summary>
    /// 查询的时候 按显示查询数据
    /// </summary>
    /// <param name="dt_a013010101"></param>
    /// <returns></returns>
    public string replace_getShowDataSql(DataTable dt_a013010101, string showdatasql_, string u_select_sql___, string option_)
    { 
        //根据列的信息获取sql
        string cols_name = "";
        string sql_ = showdatasql_;
        if (option_ == "Q" || option_ == "V")
        {
            for (int i = 0; i < dt_a013010101.Rows.Count; i++)
            {
                string IFQUERYSHOW = dt_a013010101.Rows[i]["IFQUERYSHOW"].ToString().ToLower();
                string column_id = dt_a013010101.Rows[i]["column_id"].ToString();
                string col01 = dt_a013010101.Rows[i]["col01"].ToString();
                //动态列添加sql
                if (col01 == "1")
                {
                    continue;
                }

                if (IFQUERYSHOW == "1")
                {
                    cols_name = cols_name + column_id + ",";
                }

            }
        }
        else
        {
            if (u_select_sql___ == "" || u_select_sql___  == null)
            {
                return sql_;
            }
            for (int i = 0; i < dt_a013010101.Rows.Count; i++)
            {
                string IFQUERYSHOW = dt_a013010101.Rows[i]["IFQUERYSHOW"].ToString().ToLower();
                string column_id = dt_a013010101.Rows[i]["column_id"].ToString();
                string col01 = dt_a013010101.Rows[i]["col01"].ToString();
                //动态列添加sql
                if (col01 == "1")
                {
                    continue;
                }
                cols_name = cols_name + column_id + ",";
            }
        
        }
        cols_name = cols_name + u_select_sql___;
        
      //  cols_name = cols_name.Substring(0, cols_name.Length - 1);
        if (dt_a00201.Rows[0]["tbl_type"].ToString().ToUpper() == "V")
        {
            cols_name = cols_name + " OBJID ";
        }
        else
        {
            cols_name = cols_name.Substring(0,cols_name.Length -1);
        }

        sql_ = sql_.Replace("t.*", cols_name);
        return sql_;
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
       // this.Load += new System.EventHandler(PageBase_Load); 
        this.Error += new System.EventHandler(PageBase_Error);
        this.Unload += new System.EventHandler(PageBase_Unload);
    }

    protected void PageBase_Unload(object sender, System.EventArgs e)
    {
        Fun.db.db_oracle.GetDBConnection().Dispose();
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

}
