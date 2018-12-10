<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MainForm.aspx.cs" Inherits="ShowForm_MainForm"    EnableViewState ="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head >
<%string jsver = GlobeAtt.GetValue("JSVER");
  string jqueryversoin = http_url + "jquery-ui-1.10.3";       
%>
  <title><%=title_%>---<%=key %></title>
  <script language=javascript src ="<%=http_url %>js/BasePage.js?ver=<%=jsver %>"></script>	
  <script type="text/javascript" src ="<%=http_url %>js/SlectColor.js?ver=<%=jsver %>"></script>	
  <script language=javascript src ="<%=http_url %>js/rbutton.js?ver=<%=jsver %>"></script>	
  <script src ="<%=http_url %>showform/MainForm.js?ver=1<%=jsver %>" type="text/javascript"> </script>	
  <link rel="stylesheet" href="<%=jqueryversoin %>/themes/base/jquery.ui.all.css">
  <script src="<%=jqueryversoin %>/jquery-1.9.1.js"></script>
  <script src="<%=jqueryversoin %>/ui/jquery.ui.core.js"></script>
  <script src="<%=jqueryversoin %>/ui/jquery.ui.widget.js"></script>
  <script src="<%=jqueryversoin %>/ui/jquery.ui.mouse.js"></script>
  <script src="<%=jqueryversoin %>/ui/jquery.ui.draggable.js"></script>
  <script src="<%=jqueryversoin %>/ui/jquery.ui.position.js"></script>
  <script src="<%=jqueryversoin %>./ui/jquery.ui.resizable.js"></script>
  <script src="<%=jqueryversoin %>/ui/jquery.ui.button.js"></script>
  <script src="<%=jqueryversoin %>/ui/jquery.ui.dialog.js"></script>
  <link rel="stylesheet" href="<%=jqueryversoin %>/demos/demos.css">
  <script language=javascript src ="<%=http_url %>js/option.js?ver=<%=jsver %>"></script>
  <script type="text/javascript" src="<%=http_url %>js/BaseQuery.js?ver=<%=jsver %>"></script>
  <script src ="<%=http_url %>js/http.js?ver=<%=jsver %>1" language="javascript" type="text/javascript"></script>
  <script language="JavaScript" type="text/javascript" src="<%=http_url %>js/WebCalendar.js?ver=<%=jsver %>"></script> 
  <script language="JavaScript" type="text/javascript" src="<%=http_url %>js/Calendar.js?ver=<%=jsver %>"></script>  
  <link   href ="<%=http_url%>Css/BasePage.css?ver=12<%=jsver%>"  rel="stylesheet"  type="text/css" />

 <script>
     document.write('<div id="loader_container"><div id="loader"><div align="center" style="font-size:9pt;">页面正在加载中……</div><div align="center"><img src="../images/loading.gif" alt="loading" /></div></div></div>');
     if_showDialog = '<%=dialog%>';
     a002_key = '<%=a002_key %>';
     data_index = "<%=GlobeAtt.DATA_INDEX %>";
     option = "<%=option %>";
     main_key = "<%=key %>";
     main_key_value = "<%=key %>";
     ISAVE = "<%=ISAVE %>";
     show_sysrb = '<%=GlobeAtt.GetValue("SHOW_SYS_RB") %>';
   </script>
</head>
<body scroll="auto"  class="bodystyle" id="mainbody" > 
<p>
<object classid="clsid:46E4B248-8A41-45C5-B896-738ED44C1587" id="SynCardOcx1" codeBase="SynCardOcx.CAB#version=1,0,0,1" width="0" height="0" >
</object>
</p>
 <%
    //显示数
   
    if (dt_a00212.Rows.Count > 0)
    {
        Tab_Width = dt_a00212.Rows[0]["TREE_WIDTH"].ToString();
    }
    if (Tab_Width == null)
    {
        Tab_Width = "0";
    }

   %>
 <form id="form1" runat="server" EnableViewState="false">
 <div style="width:100%; display:none;">
    <div id="mainlink" style="width:100%;height:0px;">    
    </div>
    <div id="mainbtn" style="width:100%;height:0px;">   
    </div>
 </div>


  <table width="100%"  style="table-layout:fixed;" border="0" align="center" cellpadding="0" cellspacing="0" id="tmain">
    <tr id="tr_1">
    <td style="margin-left:5px;" height="30">
      <table width="100%"  style="table-layout:fixed" border="0" align="center" cellspacing="0" cellpadding="0">
      <% if (dt_a00211.Rows.Count > 0)
        {
            StringBuilder str_head = new StringBuilder();           
            str_head.Append("<tr id=\"trlink\">");
            str_head.Append("<td width=\"15\" id=\"td_link\"></td>");
            str_head.Append("<td width=\"98%\" style=\"text-align:center;\" >");
            str_head.Append("<div class=\"headlink\">");
            str_head.Append("<ul>");
            int  licount = 0;
            for(int i= 0 ; i < dt_a00211.Rows.Count;i++)
            {
                string show_sql = dt_a00211.Rows[i]["show_sql"].ToString();
                show_sql = show_sql.Replace("[MAIN_KEY]", key);
                show_sql = show_sql.Replace("[HTTP_URL]",  GlobeAtt.HTTP_URL);
                show_sql = show_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                dt_temp = Fun.getDtBySql(show_sql);
                for (int j = 0; j < dt_temp.Rows.Count; j++)
                { 
                    string LINK_URL = dt_temp.Rows[j]["LINK_URL"].ToString();
                    string LINK_NAME = dt_temp.Rows[j]["LINK_NAME"].ToString();
                    string LINK_CURR = dt_temp.Rows[j]["LINK_CURR"].ToString();
                    if (LINK_CURR != "1")
                    {
                        licount = licount + 1;
                        str_head.Append("<li>");
                    }
                    else
                    {
                        str_head.Append("<li class=\"curr\">");
                    }
                  
                   str_head.Append("<a href=\""+ LINK_URL +"\">"+ LINK_NAME+ "</a>");
                   str_head.Append("</li>");
                     
                }
            }

            str_head.Append("</ul>");
            str_head.Append("</div>");            
            str_head.Append("</td>");
            str_head.Append("<td width=\"14\"></td>");
            str_head.Append("</tr>");
            if (licount > 0) {
                Response.Write(str_head.ToString());
            }
         } %>
      <tr>
        <td width="15"  height="30"></td>
        <td width="98%" style="text-align:center;" >
        <div id="td_main_button">                    
        </div>
        </td>
        <td width="14"></td>
      </tr>
      </table>
    </td>
    </tr>    
    <tr>
    <td >
     <table width="100%"  style="table-layout:fixed" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="9">&nbsp;</td>
        <td>
        <table width="100%"  style="table-layout:fixed" border="0" cellspacing="0" cellpadding="0"> 
        <tr id="tr_main">
        <td id="td_main">
         <div id="mainhead" >    
         </div>
        </td>
        </tr>
        <tr id="tr_2">
        <td>
        <table width="100%">
        <tr id="tr_button">
        <td>
        </td>
        <td height="29" style="text-align:center;">
        <div id="tabsJ">
        <ul>  
    <%  for (int i = 0; i < dt_detail.Rows.Count; i++)
        {
            string a00201_key__ = dt_detail.Rows[i]["a00201_key"].ToString();

            string tab_name = dt_detail.Rows[i]["tab_name"].ToString();
            if (GlobeAtt.LANGUAGE_ID == "EN")
            {
                tab_name = dt_detail.Rows[i]["en_tab_name"].ToString();
            }
    %>    <li   id="tab_<%=a00201_key__ %>">
        <a><span onclick="showtab('<%=a00201_key__ %>')">

        <input  type="hidden" id="load_<%=a00201_key__ %>" value="<%=if_showall %>" title="loaddetail('<%=dt_main.Rows[0]["menu_id"].ToString() %>','<%=a00201_key__ %>','<%=key %>','<%=option %>','<%=ver %>','1','');"/> <%=tab_name%> </span> </a> 
    </li>
    <%     } %>
    </ul>
</div> 
         </td>
        <td>        
        </td>
        </tr>
        </table>   
        </td>
        </tr>
        <tr id="tr_detail">
        <td id="td_detail" >
          <% 
              string showtab__ = "0";
              for (int i = 0; i < dt_detail.Rows.Count; i++)
         {
              string a00201_key__ = dt_detail.Rows[i]["a00201_key"].ToString();
              if ( i ==0)
              {
                  showtab__ = a00201_key__;
              }
          
                if (showtab == a00201_key__)
                {
                    showtab__ = showtab;
                }
         %>
          <div id="show_<%=a00201_key__ %>" style="display:none;"></div>
             <%
         }%>  
        </td>    
        </tr> 
        </table>
           <% if (dt_detail.Rows.Count > 0 ) { 
           %>
           <script language=javascript>
               showtab('<% =showtab__ %>')
           </script>
           <%} %>                 
        </td>
        <td width="9">&nbsp;</td>
        </tr>   
      </table>
    </td>
    </tr>
    <tr>
    <td height="9">
    <table width="100%"  style="table-layout:fixed;" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="15" height="9"></td>
        <td>
        </td>
        <td width="14"></td>
      </tr>
    </table>
    </td>
    </tr>
    </table>
    <div id="alertdiv" class="white_content"></div>
    <div id="fade" class="black_overlay"></div>
   
</form>

<script type="text/javascript">
     remove_loading();
     Tab_Width = <%=Tab_Width %>;
     <%    
     if(int.Parse(Tab_Width) > 0 )
     {%>
        Show_mainTree('<%=Tab_Width %>','<%=key %>');   
        $("#mainhead").width($("#mainhead").width() -  Tab_Width);  
        $("#td_main_button").width($("#td_main_button").width() -  Tab_Width);  
        $("#tabsJ").width($("#tabsJ").width() -  Tab_Width);   
   <%}
    
    %>
     <%
        if (ITREE == "0")
        {
        %>
        havetree = "1";
      <%}
      %>


     loadmain("<%=dt_main.Rows[0]["menu_id"].ToString() %>","<%=dt_main.Rows[0]["A00201_KEY"].ToString() %>","<%=key %>","<%=option %>","<%=ver %>");
     loadmainbutton("<%=dt_main.Rows[0]["menu_id"].ToString() %>","<%=dt_main.Rows[0]["A00201_KEY"].ToString() %>","<%=key %>","<%=option %>","<%=ver %>");
<%  for (int i = 0; i < dt_detail.Rows.Count; i++)
    {
         string a00201_key__ = dt_detail.Rows[i]["a00201_key"].ToString();
         string if_copy = dt_detail.Rows[i]["if_copy"].ToString();
    %>
    <%if (if_copy == "1"){
    %> copya00201key += '<%=a00201_key__%>,';
  <%}
    if (if_showall == "1")
    {
   %>
      loaddetail("<%=dt_main.Rows[0]["menu_id"].ToString() %>","<%=a00201_key__ %>","<%=key %>","<%=option %>","<%=ver %>","1","");
        
  <%}
 }   
%>  
ifshowend  = true;
if(<%=dt_a002.Rows[0]["MENU_ID"].ToString()%>!="1301" ){
<%=dt_a002.Rows[0]["DOJS"].ToString()%>  
}
<% if (dt_a002.Rows[0]["TABLE_ID"].ToString() == "A_NULLMAIN")
{

%>
        $("#tr_main").hide();
        $("#tr_1").hide();
       
        
  <% if (dt_detail.Rows.Count == 1 )
{%>
     $("#tr_button").hide();
<%} %>
<%} %>
</script>

  <script language="JavaScript1.2">
  if(<%=dt_a002.Rows[0]["MENU_ID"].ToString()%>=="1301"  ){
  <%=dt_a002.Rows[0]["DOJS"].ToString()%> 
   }
        
    </script>

</body>
</html>
