<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Head.ascx.cs" Inherits="BaseForm_Head" %>
<div id="home_top">  
 <div class="top_nav">       
  <div class="left"  style="font-weight:bold">IM-Environment
  <img height="25" align="absmiddle" width="16" style="padding-top: 2px;" src="<%= GlobeAtt.HTTP_URL %>/images/top_bg_xian.gif">
  </div>   
 <%--<div class="right">  
 <%if (GlobeAtt.LANGUAGE_ID == "CN")
   {
      %>
    <div  style=" float:left;margin-top :10px;">
     <a   href="javascript:void(0);" onclick="javascript:setLanguage('CN')" style="text-decoration:none;" > 中文 </a>   
    </div>  
    <div style=" float:left; margin-left:20px; margin-top :10px;">
     <a href="javascript:void(0);" onclick="javascript:setLanguage('EN')"  style="text-decoration:none;" > English </a>   
    </div> 
    <%
     }
   else
   { 
   %>
    <div  style=" float:left;margin-top :10px;">
     <a  href="javascript:void(0);" onclick="javascript:setLanguage('CN')"  style="text-decoration:none;">中文</a>   
    </div>  
    <div style=" float:left; margin-left:20px; margin-top :10px;">
     <a  href="javascript:void(0);" onclick="javascript:setLanguage('EN')"  style="text-decoration:none;">English </a>   
    </div> 
   <%} %>       
  </div> --%>

  </div>

</div>