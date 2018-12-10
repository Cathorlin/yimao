<%@ Page Language="C#" AutoEventWireup="true" CodeFile="maindetail.aspx.cs" Inherits="HandEquip_iframe_mainiframe" %>

<%
    if (line_no == "0" || line_no == "")
    {
        return;
    }
    //获取表字段              
    int tab_width = 0;
    string sql = string.Empty;
    StringBuilder strtabhead = new StringBuilder();
    StringBuilder strhtml = new StringBuilder();

    strhtml.Append("<td class='dtl_tb_td' style=\"width:30px;\"><input type='checkbox\' id='cbx_" + menu_id + "_" + line_no + "' onclick=\"selectdetailall(this);\" /></td>");
    tab_width = tab_width + 30;
    for (int i = 0; i < dt_a10001.Rows.Count; i++)
    {
        if (dt_a10001.Rows[i]["SYS_VISIBLE"].ToString() == "0")
        {
            strhtml.Append("<td class='dtl_tb_td' style=\"display:none;width:" + dt_a10001.Rows[i]["BS_EDIT_WIDTH"].ToString() + "px;\">" + dt_a10001.Rows[i]["COL_TEXT"].ToString() + "</td>");
        }
        else
        {
            strhtml.Append("<td class='dtl_tb_td' style=\"width:" + dt_a10001.Rows[i]["BS_EDIT_WIDTH"].ToString() + "px; \">" + dt_a10001.Rows[i]["COL_TEXT"].ToString() + "</td>");
            tab_width = tab_width + Int32.Parse(dt_a10001.Rows[i]["BS_EDIT_WIDTH"].ToString());
        }
    }

    strtabhead.Append("<table class=\"dtl_tb\" cellspacing=\"0\" style=\" width:" + tab_width.ToString() + "px;\"><thead><tr>");
    strtabhead.Append(strhtml.ToString());
    strtabhead.Append("</tr></thead><tbody>");
%>
<%--  <%=strhtml.ToString() %>
            <% Response.Flush(); %>--%>
<%
    //循环数据值
    strhtml.Clear();
    for (int i = 0; i < dt_temp.Rows.Count; i++)
    {
        strhtml.Append("<tr id='tr_" + menu_id + "_" + line_no + "_" + i.ToString() + "'>");
        strhtml.Append("<td class='dtl_tb_td'><input type='checkbox' name='cbx_" + menu_id + "_" + line_no + "' id='cbx_" + menu_id + "_" + line_no + "_" + i.ToString() + "' value=\"" + dt_temp.Rows[i]["OBJID"].ToString() + "\" /></td>");
        for (int j = 0; j < dt_a10001.Rows.Count; j++)
        {
            string column_id = dt_a10001.Rows[j]["COLUMN_ID"].ToString();
            if (column_id == "OBJID")
            {
                strhtml.Append("<input type='hidden' id='" + menu_id + "_" + line_no + "_" + i.ToString() + "_0' value ='" + dt_temp.Rows[i][column_id].ToString() + "'/>");
            }
            if (dt_a10001.Rows[j]["SYS_VISIBLE"].ToString() == "0" || column_id == "OBJID")
            {
                strhtml.Append("<td class='dtl_tb_td' style=\"display:none;\">" + dt_temp.Rows[i][column_id].ToString() + "</td>");
            }
            else
            {
                string col_edit = dt_a10001.Rows[j]["COL_EDIT"].ToString();
                if (col_edit == "checkbox")
                {
                    if (dt_temp.Rows[i][j].ToString() == "1")
                    {
                        strhtml.Append("<td class='dtl_tb_td'><input type=\"checkbox\" checked='true' disabled=\"false\"/></td>");
                    }
                    else
                    {
                        strhtml.Append("<td class='dtl_tb_td'><input type=\"checkbox\" disabled=\"false\" /></td>");
                    }
                }
                else
                {
                    strhtml.Append("<td class='dtl_tb_td'>" + dt_temp.Rows[i][column_id].ToString() + "</td>");
                }
            }
        }
        strhtml.Append("</tr>");
    }

    strtabhead.Append(strhtml.ToString());
    strtabhead.Append("</tbody></table>");
    Response.Write(strtabhead.ToString());
%>
<% Response.Flush(); %>
