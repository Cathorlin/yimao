<%@ Page Title="" Language="C#" MasterPageFile="~/HandEquip/handequip.master" AutoEventWireup="true"
    CodeFile="index.aspx.cs" Inherits="HandEquip_index" %>

<asp:Content ID="head1" ContentPlaceHolderID="head" runat="Server">
    <%-- <link href="<%=http_url %>/HandEquip/Css/index.css" type="text/css" rel="Stylesheet" />--%>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="head2" runat="Server">
   菜单-条码管理
</asp:Content>
<asp:Content ID="body2" ContentPlaceHolderID="body2" runat="server"><%=GlobeAtt.A007_NAME %></asp:Content>
<asp:Content ID="body1" ContentPlaceHolderID="body1" runat="Server">
    <%
        StringBuilder strhtml = new StringBuilder();
        //获取手持设备功能键

        if (dt_temp.Rows.Count > 0)
        {
            strhtml.Append("<ul id='ul_1'>");
            for (int i = 0; i < dt_temp.Rows.Count; i++)
            {
                //获取url,并替换
                string url = dt_temp.Rows[i]["BS_URL"].ToString();
                url = GlobeAtt.HTTP_URL + url;
                strhtml.Append("<li><a href='" + url + "'><div id='li_div_" + i + "' name='li_div' style=\"width:180px;\">" + dt_temp.Rows[i]["MENU_NAME"].ToString() + "</div></a></li>");
            }
            strhtml.Append("</ul>");
        }        
    %>
    <%=strhtml.ToString() %>
    <script language="javascript" type="text/javascript">
        $(function () {
            var obj = $("#li_div_0");
            $("#li_div_0").focus();
        });

    </script>
</asp:Content>
