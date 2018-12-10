using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class BaseForm_BaseTree : BaseForm
{
    public DataTable dt_allchild = new DataTable();
    public int treeid = 0;
    public string TREEID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
    }

    public string Get_Tree_Json(string title_, string child_sql_, string parm_, int treenode, string id_, string showchild, string child_type)
    {
        StringBuilder str_treehtml = new StringBuilder();

        if (treenode > 100)
        {
            return "";
        }
        string data_index = GlobeAtt.DATA_INDEX;
        DataTable dt_child = new DataTable();
        string p_child_sql_ = child_sql_;
        p_child_sql_ = p_child_sql_.Replace("[TREENODE]", treenode.ToString());
        if (child_type == "ALL")
        {


            string leftparm_ = parm_;
            int pos = leftparm_.IndexOf(data_index);
            int vcount = 0;
            string rowkey = "";
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
                if (col == "ROWKEY")
                {
                    rowkey = v;
                }
                p_child_sql_ = p_child_sql_.Replace("[" + col + "]", v);
                leftparm_ = leftparm_.Substring(pos + 1);
                pos = leftparm_.IndexOf(data_index);
            }
            if (treenode == 0)
            {
                dt_allchild = Fun.getDtBySql(p_child_sql_);
            }
            //过滤明细 获取parent_rowkey 的数据
            dt_child = dt_allchild.Clone();
            dt_child.Clear();
            int[] deli = new int[dt_allchild.Rows.Count];
            for (int i = 0; i < dt_allchild.Rows.Count; i++)
            {
                if (dt_allchild.Rows[i]["parent_rowkey"].ToString() == rowkey)
                {
                    dt_child.ImportRow(dt_allchild.Rows[i]);
                    deli[i] = 1;
                }
            }
            for (int i = deli.Length - 1; i >= 0; i--)
            {
                if (deli[i] == 1)
                {
                    dt_allchild.Rows.Remove(dt_allchild.Rows[i]);
                }
            }
        }
        else
        {
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
        }
        //用记录集的方式取数据
        treeid = treeid + 1;
        int pid = treeid;
        string open_true = "";
        if (showchild == "1")
        {
            open_true = ",open:true";
        }

        string str_json_ = "N" + TREEID + ".push({id:" + treeid.ToString() + ", pId:" + id_ + ", name:\"" + title_.Replace("\"", "\\\"").Replace(Environment.NewLine,"") + "\"" + open_true + "});";
        if (id_ == "0")
        {
            str_json_ = "N" + TREEID + ".push({id:" + treeid.ToString() + ", pId: -1, name:\"" + title_.Replace("\"", "\\\"").Replace(Environment.NewLine, "") + "\"" + open_true + "});";
        }
        str_json_ += Environment.NewLine;
        str_treehtml.Append(str_json_);
        for (int i = 0; i < dt_child.Rows.Count; i++)
        {
            string titile = dt_child.Rows[i][0].ToString();//显示BOM标题
            string child_sql = dt_child.Rows[i][1].ToString();//替代明细的数据 sql

            child_sql = child_sql.Replace("[USER_ID]", GlobeAtt.A007_NAME);
            child_sql = child_sql.Replace("[MENU_ID]", GlobeAtt.A002_KEY);
            string show_child = "0";
            string childparm = "";
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
            }


            string id__ = i.ToString();
            if (i >= 9)
            {
                System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
                byte[] byteArray = new byte[] { (byte)(48 + i) };
                id__ = asciiEncoding.GetString(byteArray);

            }

            str_treehtml.Append(Get_Tree_Json(titile, child_sql_, childparm, treenode + 1, pid.ToString(), show_child, child_type));
        }
    
      


        return str_treehtml.ToString();
    }

    public string Get_Tree_Html(string title_, string child_sql_, string parm_, int treenode, string id_, string showchild, string child_type)
    {
        StringBuilder str_treehtml = new StringBuilder();

        if (treenode > 100)
        {
            return "";
        }
        str_treehtml.Append("<table style=\"table-layout:fixed;margin-left:"+(2*treenode).ToString() +  "px;\">");
        
        string data_index = GlobeAtt.DATA_INDEX;
        DataTable dt_child = new DataTable();
        string p_child_sql_ = child_sql_;
        p_child_sql_ = p_child_sql_.Replace("[TREENODE]", treenode.ToString());
        if (child_type == "ALL")
        {
         

                string leftparm_ = parm_;
                int pos = leftparm_.IndexOf(data_index);
                int vcount = 0;
                string rowkey ="";
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
                    if (col == "ROWKEY")
                    {
                        rowkey = v ;
                    }
                    p_child_sql_ = p_child_sql_.Replace("[" + col + "]", v);
                    leftparm_ = leftparm_.Substring(pos + 1);
                    pos = leftparm_.IndexOf(data_index);
                }   
            if (treenode == 0)
            {
                dt_allchild = Fun.getDtBySql(p_child_sql_);
            }
            //过滤明细 获取parent_rowkey 的数据
            dt_child = dt_allchild.Clone();
            dt_child.Clear();
            int[] deli = new int[dt_allchild.Rows.Count];
            for (int i = 0; i < dt_allchild.Rows.Count; i++)
            {
                if (dt_allchild.Rows[i]["parent_rowkey"].ToString() == rowkey)
                {
                    dt_child.ImportRow(dt_allchild.Rows[i]);
                    deli[i] = 1;
                }
            }
            for (int i = deli.Length - 1; i >= 0; i--)
            {
                if (deli[i] == 1)
                {
                    dt_allchild.Rows.Remove(dt_allchild.Rows[i]);
                }
            }
        }
        else
        {
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
        }
        //用记录集的方式取数据
       
 

        if (dt_child.Rows.Count == 0)
        {
            str_treehtml.Append("<tr>");
            str_treehtml.Append(Environment.NewLine);
            //显示标题
            str_treehtml.Append("<td width=\"100%\" >");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("<div>");
            str_treehtml.Append(Environment.NewLine);
            //str_treehtml.Append(title_);
            //<img style=\"width:30px;height:15px;cursor:hand;margin-left:2px;\"  src=\"..//images//child.gif\"/>
            str_treehtml.Append("<table><tr><td style=\"margin-top:2px;\"></td>");
            str_treehtml.Append("<td><table><tr><td><img style=\"width:30px;height:15px;cursor:hand;margin-left:2px;\"  src=\"..//images//child.gif\"/></td><td><div style=\"margin-left:0px;\">" + title_ + "</div></td></tr></table></td></tr></table>");
        }
        else
        {
            str_treehtml.Append("<tr>");
            str_treehtml.Append(Environment.NewLine);

            str_treehtml.Append("<td  width=\"100%\"  style=\"vertical-align:middle;\">");
            str_treehtml.Append(Environment.NewLine);
            str_treehtml.Append("<div style=\"color:red;vertical-align:middle;\">");
            str_treehtml.Append(Environment.NewLine);
            if (showchild == "1")
            {
                str_treehtml.Append("<table><tr><td style=\"margin-top:3px;\"><img style=\"width:30px;height:15px;cursor:hand;\" id=\"" + id_ + "\" onclick=\"showchild(this)\" src=\"..//images//opened.gif\"/></td>");
            }
            else
            {
                str_treehtml.Append("<table><tr><td style=\"margin-top:3px;\"><img style=\"width:30px;height:15px;cursor:hand;\" id=\"" + id_ + "\" onclick=\"showchild(this)\" src=\"..//images//closed.gif\"/></td>");
  
            }
            str_treehtml.Append("<td><div style=\"margin-left:0px;\">" + title_ + "</div></td></tr></table>");
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
                string child_sql = dt_child.Rows[i][1].ToString();//替代明细的数据 sql

                child_sql = child_sql.Replace("[USER_ID]", GlobeAtt.A007_NAME);
                child_sql = child_sql.Replace("[MENU_ID]", GlobeAtt.A002_KEY);
                
                string show_child = "0";
                string childparm = "";
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
                      childparm =childparm +  column_name + "|" + data_ + data_index;
                }


                string id__ = i.ToString();
                    if (i >= 9)
                    {
                        System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
                        byte[] byteArray = new byte[] { (byte)(48 + i) };
                        id__ = asciiEncoding.GetString(byteArray);

                    }

                    str_treehtml.Append(Get_Tree_Html(titile, child_sql_, childparm, treenode + 1, id_ + id__, show_child,child_type));
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