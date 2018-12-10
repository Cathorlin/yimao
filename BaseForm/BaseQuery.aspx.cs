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
using System.Text;
#region
/// <summary>
/// 高级查询条件 弹出页面
/// </summary>
/// 
public partial class BaseForm_BaseQuery : BaseForm
{
    protected void Page_Load(object sender, EventArgs e)
    {
         base.PageBase_Load(sender, e);

    }

    public string get_tree_html(string mainsql_, string childsql_, string tree_width_,string onclick_)
    {
        
        StringBuilder str_html = new StringBuilder();
        if (mainsql_ == "" || mainsql_ == null)
        {
            return "";
        }
        DataTable dt_main = new DataTable();
        dt_main = Fun.getDtBySql(mainsql_);
        if (dt_main.Rows.Count == 0)
        {
            return "";
        }
        string parm_ = "";
        string title = "";
        string id_ = "0";
        for (int j = 0; j < dt_main.Rows.Count; j++)
        {
            string show_child = "0";
            parm_ = "";
            for (int c = 1; c < dt_main.Columns.Count; c++)
            {
                string column_id = dt_main.Columns[c].ColumnName.ToUpper();
                string col_data = dt_main.Rows[j][c].ToString();
                if (col_data == null)
                {
                    col_data = "";
                }
                if (column_id == "SHOWCHILD")
                {
                    show_child = col_data;
                }
                parm_ = parm_ + column_id + "|" + col_data + GlobeAtt.DATA_INDEX;
            }
            //显示标题
            title = dt_main.Rows[j][0].ToString();
            if (childsql_.Length > 5)
            {
                id_ = (int.Parse(id_) + 1).ToString();
                string html_ = Get_Tree_Html(title, "", childsql_, parm_, 0, "tr" + id_, show_child, onclick_);
                str_html.Append("<div style=\"margin:0px 0 0 5px;width:" + tree_width_ + "px; \">");
                str_html.Append(html_);
                str_html.Append("</div>");
            }
        }       
        return str_html.ToString();
    }
    public string Get_Tree_Html(string title_,  string treecon_, string child_sql_, string parm_, int treenode, string id_, string showchild, string onclick_)
    {
        StringBuilder str_treehtml = new StringBuilder();

        if (treenode > 100)
        {
            return "";
        }
        str_treehtml.Append("<table style=\"table-layout:fixed;margin-left:" + (2 * treenode).ToString() + "px;border:inset  0px red;\">");
        string on_click = "";
        if (treecon_.Length > 3)
        {
            on_click = onclick_.Replace("[ONCLICK]", treecon_.Replace("'", "\\'"));
        }

        string data_index = GlobeAtt.DATA_INDEX;
        DataTable dt_child = new DataTable();
        string p_child_sql_ = child_sql_;
        p_child_sql_ = p_child_sql_.Replace("[TREENODE]", treenode.ToString());
        if (p_child_sql_.Length > 0)
        {
            //吧参数写入 到 child_sql_ 中
            string leftparm_ = parm_;
            int pos = leftparm_.IndexOf(data_index);
            int vcount = 0;
            while (pos > 0)
            {
                string vv = leftparm_.Substring(0, pos);
                int pos1 = vv.IndexOf("|");
                string col = vv.Substring(0, pos1);
                string v = vv.Substring(pos1 + 1);
                if (v != "")
                {
                    vcount = vcount + 1;
                }
                p_child_sql_ = p_child_sql_.Replace("[" + col + "]", v);
                leftparm_ = leftparm_.Substring(pos + 1);
                pos = leftparm_.IndexOf(data_index);
            }
            if (vcount > 0)
            {
                dt_child = Fun.getDtBySql(p_child_sql_);
            }
        }
       
        if (dt_child.Rows.Count == 0)
        {
            str_treehtml.Append("<tr  style=\"border:inset  0px red;\">");
            str_treehtml.Append(Environment.NewLine);
            //显示标题
            str_treehtml.Append("<td width=\"100%\" style=\"border:inset  0px red;\" >");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("<div>");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("<table style=\"width:100%;border:inset  0px red;\"><tr><td width=\"30px\"><img style=\"width:30px;height:15px;cursor:hand;margin-left:2px;float:left;\"  src=\"..//images//child.gif\"/></td>");
            str_treehtml.Append("<td width=\"300px\"><div style=\"margin-left:0px;float:left;\" " + on_click + " >" + title_ + "</div></td></tr></table>");
        }
        else
        {
            str_treehtml.Append("<tr style=\"border:inset  0px red;\" >");
            str_treehtml.Append(Environment.NewLine);

            str_treehtml.Append("<td  width=\"100%\"  style=\"vertical-align:middle;border:inset  0px red;\">");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("<div style=\"color:red;vertical-align:middle;border:inset  0px red;\">");
            str_treehtml.Append(Environment.NewLine);

            str_treehtml.Append("<table style=\"width:100%;border:inset  0px red;\"><tr><td width=\"30px\" >");
            if (showchild == "1")
            {
                str_treehtml.Append("<div><img id=\"" + id_ + "\" style=\"width:30px;height:15px;cursor:hand;margin-left:2px;float:left;\"  src=\"..//images//opened.gif\" onclick=\"showchild(this)\"/></div>");
            }
            else
            {
                str_treehtml.Append("<div><img id=\"" + id_ + "\" style=\"width:30px;height:15px;cursor:hand;margin-left:2px;float:left;\"  src=\"..//images//closed.gif\" onclick=\"showchild(this)\"/></div>");
   
            }
            str_treehtml.Append("</td>");
            str_treehtml.Append("<td width=\"300px\"><div style=\"margin-left:0px;float:left;\" " + on_click + ">" + title_ + "</div></td></tr></table>");

            //if (showchild == "1")
            //{
            //    str_treehtml.Append("<table style=\"border:inset  0px red;\"><tr style=\"border:inset  0px red;\" ><td style=\"margin-top:3px;border:inset  0px red;\"><img style=\"width:30px;height:15px;cursor:hand;\" id=\"" + id_ + "\" onclick=\"showchild(this)\" src=\"..//images//opened.gif\"/></td>");
            //}
            //else
            //{
            //    str_treehtml.Append("<table style=\"border:inset  0px red;\" ><tr style=\"border:inset  0px red;\" ><td style=\"margin-top:3px;border:inset  0px red;\"><img style=\"width:30px;height:15px;cursor:hand;\" id=\"" + id_ + "\" onclick=\"showchild(this)\" src=\"..//images//closed.gif\"/></td>");

            //}
            //str_treehtml.Append("<td style=\"border:inset  1px red;text-align:left;\"><div style=\"margin-left:0px;\">" + title_ + "</div></td></tr></table>");
        }

        str_treehtml.Append("</div>");
        str_treehtml.Append(Environment.NewLine);
        str_treehtml.Append("</td>");
        str_treehtml.Append(Environment.NewLine);
        str_treehtml.Append("</tr>");
        str_treehtml.Append(Environment.NewLine);
        if (dt_child.Rows.Count > 0)
        {

            if (showchild == "1")
            {
                str_treehtml.Append("<tr  id=\"" + id_ + "_s\" style=\"display:;\">");
            }
            else
            {
                str_treehtml.Append("<tr  id=\"" + id_ + "_s\" style=\"display:none;\">");
            }
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("<td>");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("<div>");
            str_treehtml.Append(Environment.NewLine);
            for (int i = 0; i < dt_child.Rows.Count; i++)
            {
                string titile = dt_child.Rows[i][0].ToString();//显示BOM标题
                //string child_sql = dt_child.Rows[i][1].ToString();//替代明细的数据 sql

                //child_sql = child_sql.Replace("[USER_ID]", GlobeAtt.A007_NAME);
                //child_sql = child_sql.Replace("[MENU_ID]", GlobeAtt.A002_KEY);

                string show_child = "0";
                string childparm = "";
                string treecon__ = "";
                for (int c = 1; c < dt_child.Columns.Count; c++)
                {
                    string column_name = dt_child.Columns[c].ColumnName.ToUpper();

                    string data_ = dt_child.Rows[i][c].ToString();
                    if (column_name == "SHOWCHILD")
                    {
                        show_child = data_;
                    }
                    if (data_ == null)
                        data_ = "";
                    childparm = childparm + column_name + "|" + data_ + data_index;
                    if (column_name.ToUpper() == "TREECON")
                    {
                        treecon__ = data_;
                    }
                }


                string id__ = i.ToString();
                if (i >= 9)
                {
                    System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
                    byte[] byteArray = new byte[] { (byte)(48 + i) };
                    id__ = asciiEncoding.GetString(byteArray);

                }

                //传入条件
                str_treehtml.Append(Get_Tree_Html(titile, treecon__, child_sql_, childparm, treenode + 1, id_ + id__, show_child, onclick_));
            }
            str_treehtml.Append("</div>");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("</td>");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("</tr>");
            str_treehtml.Append(Environment.NewLine);
        }
        str_treehtml.Append("</table>");

        return str_treehtml.ToString();
    }
}
#endregion