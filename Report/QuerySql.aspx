<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QuerySql.aspx.cs" Inherits="Report_QuerySql" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
    <title>无标题页</title>
     <link href="../css/basePage.css"  rel="stylesheet"  type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="width:100%;  margin-top:5px;" id="div_flow">
        <table   class="ShowTable"  width="100px;"    >
        <tr class="tr_ShowTableHead">
        <td style="width:30px;">
        #
       </td>
        <%
            string html_ = "";
            int all_width = 30;
            for (int i = 0; i < dt_data.Columns.Count; i++)
            { 
         %>       
                
          <%}
         %>
        <td style="width:18px;"></td>
        <%
        all_width =all_width + 18  ;
         %>
</tr>
</table>
        </div>
        <div>
        <asp:GridView ID="GridView1" runat="server"  CssClass="ShowTable" CellPadding="1" CellSpacing="1" Width="10000px">
            <RowStyle  CssClass="r0" />
            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <HeaderStyle  CssClass="tr_ShowTableHead" />
            <AlternatingRowStyle CssClass="r1" />
        </asp:GridView>
        </div>
    </form>
</body>
</html>
