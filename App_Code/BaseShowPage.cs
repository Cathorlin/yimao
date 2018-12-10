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
///BaseShowPage 的摘要说明
/// </summary>
public class BaseShowPage : Page
{
    public BaseFun Fun = new BaseFun();
    public string user_id = string.Empty; //用户key
    public string A30001_KEY = string.Empty;//日志KEY   
    /*
     获取当前的地址
    */
    public string http_url = string.Empty;
    public DataTable dt_temp = new DataTable();
    public BaseShowPage()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        http_url = Fun.GetIndexUrl();
      
    }
    protected void PageBase_Load(object sender, System.EventArgs e)
    {
        try
        {
            user_id = Session["USER_ID"].ToString();
        }
        catch
        {
            user_id = "";
        }
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        this.Load += new System.EventHandler(PageBase_Load); 
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