<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MainButton.aspx.cs" Inherits="BaseForm_MainButton" %>

<nobr>
<%
    string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
    string if_main = dt_a00201.Rows[0]["if_main"].ToString();
    //明细
   
%> 
<%if (option == "M")
  { %>
<div id="showquery_<%=a00201_key %>" style="float:left;"></div>

 
<%if (RequestURL.IndexOf("&rbchild=1") <= 0)
 {%>
     <input id="QUERY<%=a00201_key %>" type="button" class="btn blue" value="<%=BaseMsg.getMsg("M0012") %>"  onclick="QueryData('<%=a00201_key %>','<%=DIVID %>')"/>
<%}
  }%>
<input id="btn_hidden" class="btn blue" type="button" value="<%=BaseMsg.getMsg("M0038")%>"  onclick="showmian()"/>
<%   Response.Write(dt_a00204.Rows[0][0].ToString());
    string HAVETREE = BaseFun.getAllHyperLinks(RequestXml, "<HAVETREE>", "</HAVETREE>")[0].Value;
%>

<input id="btn_reload" class="btn blue" type="button" value="<%=BaseMsg.getMsg("M0039")%>"  onclick="javascript:location.reload()"/>
<% if (HAVETREE=="1")
   {  %>
<input id="btn_reloadtree" class="btn blue" type="button" value="<%=BaseMsg.getMsg("M0043")%>"  onclick="javascript:reload_tree()"/>
<%} %>
</nobr>