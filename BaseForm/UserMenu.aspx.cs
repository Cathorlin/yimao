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

public partial class BaseForm_UserMenu : System.Web.UI.Page
{
    public string RequestXml = string.Empty;
    public DataTable dt_data = new DataTable();
    public DataTable dt_all = new DataTable();
    public BaseFun Fun = new BaseFun();
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Stream RequestStream = Request.InputStream;
            StreamReader RequestStreamReader = new StreamReader(RequestStream);
            RequestXml = RequestStreamReader.ReadToEnd();
            RequestStream.Close();
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }


    }
    public DataTable get_child_(string menu_id_)
    {

        DataTable dt__ = new DataTable();
        string sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where t.parent_id='" + menu_id_;
        sql += "' And active ='1' and pkg_a.getUserMenu(t.menu_id,'" + GlobeAtt.A007_KEY + "'," + GlobeAtt.A30001_KEY + ") = '1' order by  PARENT_ID ,sort_by,menu_id";
        dt__ = Fun.getDtBySql(sql);
        return dt__;
        //DataRow[] rows = dt_all.Select("PARENT_ID='" + menu_id_ + "'", "sort_by asc,menu_id asc");
        //DataTable dt_ = dt_all.Clone();
        //dt_.Clear();
        //foreach (DataRow row in rows)
        //{
        //    dt_.ImportRow(row);
        //    dt_all.Rows.Remove(row);
        //}
        
        //return dt_;
    }
    public string get_li_html_(DataRow dr_menu, int node_)
    {
         StringBuilder str_html_ = new StringBuilder();
        DataTable dt_menu_child = new DataTable();
        string menu_id_ = dr_menu["menu_id"].ToString();
        string last_level = dr_menu["LAST_LEVEL"].ToString();
        if (last_level != "1")
        {
            dt_menu_child = get_child_(menu_id_);
        }
        str_html_.Append("<li class=\"menu"+node_+"\">");
        str_html_.Append(Environment.NewLine);
        string menu_name = dr_menu["show_name"].ToString();
        str_html_.Append("<a title=\"" + menu_id_ + "|" + menu_name + "\"");
        if (dt_menu_child.Rows.Count > 0)
        {
            str_html_.Append(" onclick=\"showchild('" + menu_id_ + "')\">");
        }
        else
        {
            str_html_.Append(">");
        }
        //打印描述

        str_html_.Append(Environment.NewLine);
        str_html_.Append("</a>");
        str_html_.Append(Environment.NewLine);
        str_html_.Append("</li>");
        return str_html_.ToString();
    }

    public string get_html_(DataRow dr_menu, int node_)
    {
        StringBuilder str_html_ = new StringBuilder();
        DataTable dt_menu_child = new DataTable();
        string menu_id_ = dr_menu["menu_id"].ToString();
        string last_level = dr_menu["LAST_LEVEL"].ToString();
        if (last_level != "1")
        {
            dt_menu_child = get_child_(menu_id_);
        }
        if (node_ == 1)
        {
            if (dt_menu_child.Rows.Count > 0)
            {
                str_html_.Append("<tr><td align=left class=\"ftd\" onclick=\"showchild('" + menu_id_ + "','" + node_.ToString() + "')\">");
            }
            else
            {
                str_html_.Append("<tr><td align=left class=\"ftd\" >");
            }
        }
        else
        {
            if (dt_menu_child.Rows.Count > 0)
            {
                str_html_.Append("<tr><td align=left class=\"ttd\" onclick=\"showchild('" + menu_id_ + "','" + node_.ToString() + "')\">");
            }
            else
            {
                str_html_.Append("<tr><td align=left class=\"itd\">");
            }
        }

        str_html_.Append(Environment.NewLine);
        str_html_.Append("<div nowrap  class=\"di\">");
        string menu_name = dr_menu["show_name"].ToString();
        str_html_.Append("<a title=\"" + menu_id_ + "|" + menu_name + "\"");

        if (last_level == "1")
        {
            str_html_.Append(" href=\"javascript:showmenu('" + menu_id_ + "-0','" + menu_name + "')\"");
        }

        str_html_.Append(">");
        //title="<%=a002_key___%>|<%=menu_name___ %>"  "  
        // str_html_.Append("");
        str_html_.Append("<nobr>" + menu_name + "</nobr></a></div>");
        str_html_.Append(Environment.NewLine);
        str_html_.Append("</td></tr>");
        str_html_.Append(Environment.NewLine);

        if (dt_menu_child.Rows.Count > 0 && last_level != "1")
        {
            str_html_.Append("<tr id=\"tr_" + menu_id_ + "\" style=\"display:none;\"><td class=\"mtd\" align=left>");
            str_html_.Append(Environment.NewLine);
            StringBuilder str_child_ = new StringBuilder();
            str_child_.Append("<div><table  style=\"margin:0 0 0 5px;\">");
            str_html_.Append(Environment.NewLine);
            for (int i = 0; i < dt_menu_child.Rows.Count; i++)
            {
                string str_line = get_html_(dt_menu_child.Rows[i], node_ + 1);
                str_child_.Append(str_line);
            }
            str_child_.Append("</table></div>");
            str_html_.Append(Environment.NewLine);
            str_html_.Append(str_child_.ToString());
            str_html_.Append(Environment.NewLine);
            str_html_.Append("</td></tr>");
            str_html_.Append(Environment.NewLine);
        }



        return str_html_.ToString();
    }

}