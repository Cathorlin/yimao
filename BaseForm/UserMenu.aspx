<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserMenu.aspx.cs" Inherits="BaseForm_UserMenu" %>
<% string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;%>
<table width="100%" class="menuleftstyle" height="100%" border='0' cellspacing='0' cellpadding='0' >
<% dt_data = get_child_("00");
   for (int i = 0; i < dt_data.Rows.Count; i++)
   {
       string str_line = get_html_(dt_data.Rows[i], 1);
       Response.Write(str_line);
   }
%>  
</table>
<%
    /*打印菜单*/
    
    
    
    
%>