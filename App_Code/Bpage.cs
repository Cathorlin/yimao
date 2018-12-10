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
using Base;
/// <summary>

/// <summary>
///Bpage 的摘要说明
///显示列的页面
/// </summary>
public class Bpage : Page
{
    public string  if_show_or_edit = "1";//是显示 还是编辑 0 显示 1 编辑
    public Bpage()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        this.Load += new System.EventHandler(PageBase_Load); 
        this.Error += new System.EventHandler(PageBase_Error);
        this.Unload += new System.EventHandler(PageBase_Unload);
    }
    protected void PageBase_Load(object sender, System.EventArgs e)
    {
        /*生成Ajax*/
        Ajax.Utility.RegisterTypeForAjax(typeof(Bpage));
    }
    protected void PageBase_Unload(object sender, System.EventArgs e)
    {
        
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
    public string GetId(string divid,string itype)
    {
        //在配置表中插入一条记录 返回 主键
        Oracle db = new Oracle();
        try
        {
            string sql = "Select  to_char(Systimestamp, 'ff')  as c  From dual ";
            DataTable dt_id = new DataTable();
            db.ExcuteDataTable(dt_id, sql, CommandType.Text);


            //执行insert into 把数据写入表中
            
            return dt_id.Rows[0][0].ToString();
        }
        catch (Exception ex)
        {
            return "-1";
        }
        finally
        {
            db.GetDBConnection().Dispose();
        }
    }
    /// <summary>
    /// 把文本数据写入配置表
    /// </summary>
    /// <param name="divid"></param>
    /// <param name="id"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SaveTextPic(string divid, string id,string txetorpic, string v )
    {
         Oracle db = new Oracle();
     
        //在配置表中插入一条记录 返回 主键
        try
        {
      
            string sql = "update m01502 set '' where  m015_key= ";
            db.BeginTransaction();
            db.ExecuteNonQuery(sql, CommandType.Text);
            db.Commit();

            //执行insert into 把数据写入表中
            return "1";
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
        finally
        {
            db.GetDBConnection().Dispose();
        }
    }

    

    /// <summary>
    /// 获取HTML
    /// </summary>
    /// <param name="itype"></param>
    /// <param name="divid"></param>
    /// <param name="if_show_or_edit"></param>
    /// <param name="ipic"></param>
    /// <param name="itext"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetHtml(string itype, string divid, string id,string if_show_or_edit, string ipic, string itext)
    {
        /*  itype
        *  img  图片
        *  text 文字
        *  img_text0 上图下文字
        *  img_text1 左图右文字
        *  img_text2 上文字下图
        *  img_text3 左图右文字
        */
        StringBuilder str_tr = new StringBuilder();
        string pichtml = "<img  id=\"" + divid + "_spic_" + id + "\" src=\"" + ipic + "\"/>";

        string texthtml = "<div class=\"stext\" id=\"" + divid + "_stext_" + id + "\">" + itext + "</div>";
        if (if_show_or_edit == "1")
        {
            pichtml = "<table width=\"98%\"><tr><td>" + pichtml + "<td></tr><tr><td><input id=\"" + divid + "_dpic_" + id + "\" type=\"button\" value=\"上传\" onclick=\"javascript:selectpic('" + divid + "'," + id + ",this)\"/></td></tr></table>";
        
            texthtml = "<table width=\"98%\"><tr><td>" + texthtml + "<textarea  id=\"" + divid + "_etext_" + id + "\" style=\"display:none;width:100%;\">" + itext + "</textarea><td><td><input id=\"" + divid + "_dtext_" + id + "\" onclick=\"javascript:edittext('" + divid + "'," + id + ",this)\" type=\"button\" value=\"编辑\"/></td></tr></table>";
 
        }
        str_tr.Append("<div>");
        //图片
        if (itype == "img")
        {
            str_tr.Append(pichtml);
        }
        //文字  
        else
        {
            if (itype == "text")
            {
                str_tr.Append(texthtml);
            }
            else
            {
                str_tr.Append("<table>");
                if (itype == "img_text0" || itype == "img_text2")
                {    //上图下文字
                    str_tr.Append("<tr>");
                    str_tr.Append("<td>");
                    //获取图片路径
                    if (itype == "img_text0")
                    {
                        str_tr.Append(pichtml);
                    }
                    else
                    {
                        str_tr.Append(texthtml);
                    }
                    str_tr.Append("</td>");
                    str_tr.Append("</tr>");
                    str_tr.Append("<tr>");
                    str_tr.Append("<td>");
                    //获取文字内容
                    if (itype == "img_text0")
                    {
                        str_tr.Append(texthtml);
                    }
                    else
                    {
                        str_tr.Append(pichtml);
                    }
                    str_tr.Append("</td>");
                    str_tr.Append("</tr>");

                }
                if (itype == "img_text1" || itype == "img_text3")
                {    //左图右文字
                    str_tr.Append("<tr>");
                    str_tr.Append("<td>");
                    //获取图片路径
                    if (itype == "img_text1")
                    {
                        str_tr.Append(pichtml);
                    }
                    else
                    {
                        str_tr.Append(texthtml);
                    }
                    str_tr.Append("</td>");
                    str_tr.Append("<td>");
                    //获取文字内容
                    if (itype == "img_text1")
                    {
                        str_tr.Append(texthtml);
                    }
                    else
                    {
                        str_tr.Append(pichtml);
                    }
                    str_tr.Append("</td>");
                    str_tr.Append("</tr>");
                }

                str_tr.Append("</table>");
            }
        }
        str_tr.Append("</div>");
        str_tr.Append(Environment.NewLine);
        return str_tr.ToString();
    }

}