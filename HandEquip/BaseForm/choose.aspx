<%@ Page Language="C#" AutoEventWireup="true" CodeFile="choose.aspx.cs" Inherits="HandEquip_BaseForm_choose" %>

<%
    string data_index = GlobeAtt.DATA_INDEX;
    string sql = string.Empty; ;
    string check_sql = string.Empty;
    string table_select = string.Empty;
    string col_exist=string.Empty;
    string calc_flag = string.Empty;
    string bs_select_sql = string.Empty;
    string bs_col_whither = string.Empty;
    string col_select = string.Empty;
    string exist_check_sql=string.Empty;

    //获取表现Sql
    for (int i = 0; i < dt_A10001.Rows.Count; i++)
    {
        if (dt_A10001.Rows[i]["line_no"].ToString() == col_line_no)
        {
            table_select = dt_A10001.Rows[i]["TABLE_SELECT"].ToString();
            col_exist = dt_A10001.Rows[i]["col_exist"].ToString().Trim();
            calc_flag = dt_A10001.Rows[i]["CALC_FLAG"].ToString();
            bs_col_whither = dt_A10001.Rows[i]["bs_col_whither"].ToString();
            col_select = dt_A10001.Rows[i]["col_select"].ToString();
            exist_check_sql=dt_A10001.Rows[i]["exist_check_sql"].ToString().Trim().ToUpper();
            if (exist_check_sql.IndexOf("AND")==0){
                exist_check_sql = exist_check_sql.Substring(3);
            }

            sql = dt_A10001.Rows[i]["bs_choose_sql"].ToString();//显示表选数据Sql
            if (sql =="")
            {
                sql = "select " + col_select + " from " + table_select + " t where " + exist_check_sql;
            }
            break;
        }
    }    
    //处理Sql中的替换参数
    sql = sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
    //替换页面当前行字段值
    for (int i = 0; i < dt_A10001.Rows.Count; i++)
    {
        int index = sql.IndexOf("[" + dt_A10001.Rows[i]["line_no"].ToString() + "]");
        if (index >= 0)
        {
            string value = Get_Item_Value(dt_A10001.Rows[i]["line_no"].ToString(), rowlist);
            sql = sql.Replace("[" + dt_A10001.Rows[i]["line_no"].ToString() + "]", value);

        }
        index = sql.IndexOf("[" + dt_A10001.Rows[i]["COLUMN_ID"].ToString() + "]");
        if (index >= 0)
        {
            string value = Get_Item_Value(dt_A10001.Rows[i]["line_no"].ToString(), rowlist);
            sql = sql.Replace("[" + dt_A10001.Rows[i]["COLUMN_ID"].ToString() + "]", value);

        }
    }
    //替换页面当前主档字段值

    //获取表选数据
    sql = "select a.* from (" + sql + ") a where rownum<=100";
    dt_choose = Fun.getDtBySql(sql);

    //获取表现视图是否存在库存件
    dt_table_select = Fun.getDtBySql("Select * From a10001 t Where t.table_id='" + table_select + "'");
    
%>
<table class="main_tb">
<thead>
<tr>
        <td class="main_tb_td" style="width: 40px;">
            选择
        </td>
        <% 
            for (int j = 0; j < dt_choose.Columns.Count; j++)
            {
                if (dt_table_select.Rows.Count > 0)
                {
                    string str_td = string.Empty;
                    for (int i = 0; i < dt_table_select.Rows.Count; i++)
                    {
                        if (dt_choose.Columns[j].ToString() == dt_table_select.Rows[i]["COLUMN_ID"].ToString())
                        {
                            //" + dt_table_select.Rows[i]["BS_EDIT_WIDTH"].ToString() + "
                            str_td = "<td class=\"main_tb_td\" style=\" width: " + dt_table_select.Rows[i]["BS_EDIT_WIDTH"].ToString() + "px;\">" + dt_table_select.Rows[i]["COL_TEXT"].ToString() + "</td>";
                            break;
                        }
                        else if (dt_choose.Columns[j].ToString() != dt_table_select.Rows[i]["COLUMN_ID"].ToString() && i == dt_table_select.Rows.Count - 1)
                        {
                            str_td = "<td class=\"main_tb_td\">" + dt_choose.Columns[j].ToString() + "</td>";
                            break;
                        }
                    }
        %>
        <%=str_td %>
        <%
                }
                else
                {
        %>
        <td class="main_tb_td">
            <%=dt_choose.Columns[j].ToString()%>
        </td>
        <%
            }
            }%>
    </tr>
</thead>
<tbody>
    
    <% 
        for (int i = 0; i < dt_choose.Rows.Count; i++)
        {
           string value_ = dt_choose.Rows[i][col_exist].ToString();
           // string s_ = "<input type=\"radio\" name=\"" + colid + "\" id=\"" + colid + "_" + i.ToString() + "\" onclick=\"javascript:choose_select(this," + value_ + "," + calc_flag + ");\" />";
    %>
    <tr>
        <td class="main_tb_td">
            <input type="radio" name="<%=colid %>" id="<%=colid + "_" + i.ToString() %>" onclick="javascript:choose_select('<%=colid %>','<%=value_ %>','<%=calc_flag %>');" />
        </td>
        <%
            for (int j = 0; j < dt_choose.Columns.Count; j++)
            {
        %>
        <td class="main_tb_td">
            <%=dt_choose.Rows[i][j].ToString() %>
        </td>
        <%
            }%>
    </tr>
    <%    
        } %>
        </tbody>
</table>
