<%@ Page Title="" Language="C#" MasterPageFile="~/HandEquip/handequip.master" AutoEventWireup="true"
    CodeFile="main.aspx.cs" Inherits="HandEquip_main" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        menu_id = "<%=menu_id %>";
        option = "<%=option %>";
        main_key = "<%=main_key %>";
        main_keyvalue = "<%=main_keyvalue %>";
        document.write('<div id="loader_container"><div style=" height:40%;"></div><div id="loader"><div align="center" style="font-size:9pt;">页面正在加载中……</div><div align="center"><img src="../images/loading.gif" alt="loading" /></div></div></div>');
    </script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="head2" runat="Server">
    <%=dt_a002.Rows[0]["menu_name"].ToString() %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body2" runat="Server"><%=GlobeAtt.A007_NAME %></asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="body1" runat="Server">
    <%//主档字段 %>
    <div id="div_main"></div>
    <%//按钮&明细页签按钮 %>
    <div id="div_btn"></div>
    <%//表选div %>
   <%-- <div id="div_choose" style="width: 99%; height: 98%; border: 1px solid #AACAEE;
        position: absolute; left: 0px; top: 0px; background-color:White; display:none; z-index:9999;">
        <div style="width: 100%; height: 98%;  z-index:1; left: 0px; top: 0px;">
        <div style="height: 20px; width: 100%; background-color:Background; color:White;"><div style=" float:left;">请输入查询条件</div><img class="img_choose" src="../images/close.gif" onclick="javascript:$('#div_choose').hide();" style="float: right; vertical-align:top;" /></div>
        <div id="div_choose_v" style="overflow: auto; width: 100%; height: 90%; border-top: 1px solid #AACAEE;"></div>
        </div>
        <iframe style="position:absolute;left: 0px; top: 0px; width: 100%; height: 200px; z-index:-1; border:0px; display:block; filter:alpha(opacity=0);"></iframe>
    </div>--%>
    <script type="text/javascript" language="javascript">
        loadmainform(menu_id, main_keyvalue, option);
        loadmainbtn(menu_id, main_keyvalue, option);     
        // $(function(){
         <%=dt_a002.Rows[0]["DOJS"].ToString() %>
      //  });        
    </script>
</asp:Content>
