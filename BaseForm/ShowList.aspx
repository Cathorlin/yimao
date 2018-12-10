<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowList.aspx.cs" Inherits="BaseForm_ShowList" %>
<%//根据发送的XML的内容生成需要的表格
    string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
    string GROUPCOL =  BaseFun.getAllHyperLinks(RequestXml, "<GROUPCOL>", "</GROUPCOL>")[0].Value;
    string SUMCOL =  BaseFun.getAllHyperLinks(RequestXml, "<SUMCOL>", "</SUMCOL>")[0].Value;
    string CONCOL =  BaseFun.getAllHyperLinks(RequestXml, "<CONCOL>", "</CONCOL>")[0].Value;
    string a404_id = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
    string table_id = BaseFun.getAllHyperLinks(RequestXml, "<TABLE_ID>", "</TABLE_ID>")[0].Value;
    string treenum = "0"; //(int.Parse(BaseFun.getAllHyperLinks(RequestXml, "<TREENUM>", "</TREENUM>")[0].Value) + 1).ToString();//第几层
    int MAXROW = int.Parse(BaseFun.getAllHyperLinks(RequestXml, "<MAXROW>", "</MAXROW>")[0].Value);//最大行号
    string sql_  = "Select pkg_a404_api.get_group_sql('"+a404_id+"', '"+ GROUPCOL+"','"+ SUMCOL +"','"+ CONCOL.Replace("'","''") +"','"+ GlobeAtt.A007_KEY+"') as c  from dual ";
    dt_temp = Fun.getDtBySql(sql_);

    sql_ = dt_temp.Rows[0][0].ToString();

  // Response.Write("$(\"#" + DIVID + "\").html(\"" + sql_ + "\")");
  // return;
    StringBuilder str_html = new StringBuilder();
    dt_temp = Fun.getDtBySql(sql_);

    dt_a10001 = Fun.getDtBySql("Select t.* from A40401_V01 t where  A404_id='" + a404_id + "' order by t.line_no");
    int all_width = 1200 - (int.Parse(treenum ) - 1) * 12;
    str_html.Append("<tr>");
    int bs_width = 50;
    str_html.Append("<td style='width:" + bs_width.ToString()+ "px;'>");
    str_html.Append("&nbsp;");
    str_html.Append("</td>");
    int cols = dt_temp.Columns.Count + 1;
 
    GROUPCOL = "," + GROUPCOL;
    StringBuilder str_group = new StringBuilder();
    StringBuilder str_sum = new StringBuilder();
    StringBuilder allsum_html = new StringBuilder();

    
    int groupcount = 1;
    //合计列
    //allsum_html.Append("<tr>");
    //allsum_html.Append("<td>");
    //allsum_html.Append("合计");
    //allsum_html.Append("</td>");
    for (int i = 0; i < dt_temp.Columns.Count; i++)
    {
        string colname = dt_temp.Columns[i].ColumnName.ToUpper();  
        for (int j = 0; j < dt_a10001.Rows.Count; j++)
        {
            if (dt_a10001.Rows[j]["column_id"].ToString() == colname)
            {
                bs_width = bs_width + int.Parse(dt_a10001.Rows[j]["bs_width"].ToString());
                //先固定分组列
                if (GROUPCOL.IndexOf("," + colname + ",") >= 0)
                {
                    str_group.Append("<td style='width:" + dt_a10001.Rows[j]["bs_width"].ToString() + "px;'>" + dt_a10001.Rows[j]["col_text"].ToString() + "</td>");
                    groupcount = groupcount + 1;

                }
                else
                {
                    allsum_html.Append("<td>");
                    allsum_html.Append("[" + colname + "]");
                    //初始化合计数据
                    dt_a10001.Rows[j]["COL10"] = "0";
                    allsum_html.Append("</td>");
                    str_sum.Append("<td style='width:" + dt_a10001.Rows[j]["bs_width"].ToString() + "px;'>" + dt_a10001.Rows[j]["col_text"].ToString() + "</td>");

                }
                break;
            }
        }        
       
    }
   
    
    str_html.Append(str_group.ToString());
    str_html.Append(str_sum.ToString());
    
    str_html.Append("</tr>");
    for (int r = 0; r < dt_temp.Rows.Count; r++)
    {
        string rid = (MAXROW + r).ToString();
        StringBuilder str_group_row = new StringBuilder();
        StringBuilder str_sum_row = new StringBuilder();
        string rowstr_ = "";
        for (int i = 0; i < dt_temp.Columns.Count; i++)
        {
            string colname = dt_temp.Columns[i].ColumnName.ToUpper();
            if (GROUPCOL.IndexOf("," + colname + ",") >= 0)
            {
                str_group_row.Append("<td>" + dt_temp.Rows[r][i].ToString() + "</td>");

            }
            else
            {
                //把数值格式化
                string dv = dt_temp.Rows[r][i].ToString();
                for (int j = 0; j < dt_a10001.Rows.Count; j++)
                {
                    if (dt_a10001.Rows[j]["column_id"].ToString() == colname)
                    {

                        string col10 = dt_a10001.Rows[j]["col10"].ToString();
                        
                      
                        col10 = (double.Parse(col10) + double.Parse(dv)).ToString();
                        dv = double.Parse(dv).ToString("C" + dt_a10001.Rows[j]["col01"].ToString());
                        dt_a10001.Rows[j]["col10"] = col10;
                        break;
                    }
                }


                str_sum_row.Append("<td>" + dv.Replace("￥","") + "</td>");

            }
            rowstr_ = rowstr_ + dt_temp.Columns[i].ColumnName.ToUpper() + "|" + dt_temp.Rows[r][i].ToString() + GlobeAtt.DATA_INDEX;

        }

        
        str_html.Append("<tr>");
        str_html.Append("<td>");
        str_html.Append("<nobr><img src='"+ GlobeAtt.HTTP_URL +"/images/pic7.gif'  id='btn_" + rid + "' onclick=\"show_child('" + rowstr_ + "'," + rid + ")\"/>");
        str_html.Append("<img src='" + GlobeAtt.HTTP_URL + "/images/ico04.gif' style='display:none;'  id='btn1_" + rid + "' onclick=\"show_hide_child(this," + rid + ")\"/></nobr>");
        str_html.Append("</td>");
        str_html.Append(str_group_row.ToString());
        str_html.Append(str_sum_row.ToString());
      //  str_html.Append("</tr>");
       // str_html.Append("<tr id='r_" + rid + "' style='display:none;'><td colspan=" + cols.ToString() + " style='width:" + bs_width.ToString() + "px;'><div style='margin-left:10px;overflow:auto;' id='d_" + rid + "' treenum='" + treenum + "'></div></td></tr>");
        
    }
    string sumhtml = "<tr>";
    if (groupcount > 1)
    {
        sumhtml += "<td colspan=" + groupcount.ToString() + " align='right'>合计:</td>";

    }
    else
    {
        sumhtml += "<td align='right'>合计:</td>";
    }
    sumhtml += allsum_html.ToString();
    sumhtml += "</tr>";
    for (int j = 0; j < dt_a10001.Rows.Count; j++)
    {
        string colname = dt_a10001.Rows[j]["column_id"].ToString();
        if (sumhtml.IndexOf("[" + colname + "]") > 0)
        {
            string dv = double.Parse(dt_a10001.Rows[j]["col10"].ToString()).ToString("C" + dt_a10001.Rows[j]["col01"].ToString()).Replace("￥", "");
            sumhtml = sumhtml.Replace("[" + colname + "]", dv);
        }  
    }

    str_html.Append(sumhtml);
    
    string h = "<div id='s" + DIVID + "' style='width:500px;overflow:scroll;'><table style='table-layout:fixed;width:" + (bs_width + 2).ToString() + "px;'>";
       h += str_html.ToString().Replace("\"", "\\\"");
       h += "</table></div>";

    Response.Write("MAXROW= MAXROW  + " + dt_temp.Rows.Count.ToString() +";");
    Response.Write("$(\"#" + DIVID + "\").html(\"" + h + "\");$(\"#s" + DIVID + "\").width($('#main').width() - 20);$(\"#s" + DIVID + "\").height($(window).height() - 100 );");

   // Response.Write("$(\"#" + DIVID + "\").html(\"" + str_html.ToString().Replace("\"","\\\"") + "\")");
%>
