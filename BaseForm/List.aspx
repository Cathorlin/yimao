<%@ Page Language="C#" AutoEventWireup="true" CodeFile="List.aspx.cs" Inherits="BaseForm_List" %>


<% 
    Response.Write("<table>");
    for (int r = 0; r < dt_data.Rows.Count; r++)
    {
        Response.Write("<tr>");    
        for (int c = 0; c < dt_data.Columns.Count; c++)
        {
            string v = dt_data.Rows[r][c].ToString();
            Response.Write("<td>"+v+"</td>");
        
        }
        Response.Write("</tr>");   
    }
    Response.Write("</table>");
   %>
