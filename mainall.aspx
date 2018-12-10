<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mainall.aspx.cs" Inherits="mainall" %>
<%@ Register Src="BaseForm/Head.ascx" TagName="Head" TagPrefix="uc1"  %>
<%@ Register Src="BaseForm/Foot.ascx" TagName="Foot" TagPrefix="uc2"  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title>全景图</title>
    <script type="text/javascript" src ="js/http.js?ver=20130114"></script>	
    <script type="text/javascript" src ="js/BasePage.js?ver=20130114"></script>	
    <link href="css/head.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js?ver=20130114"></script>
    <script>
        
    </script>
    <style>
li.pic
{
  width:210px;
  margin: 0 0 10px 20px;
  float:left;
  list-style-type: none; 

}
.img
{
    width:208px;
    height:116px;
    border :#000 1px solid; 

 }
</style>
</head>
<center>
<body>
<uc1:Head id="Head1" runat="server">
</uc1:Head>
<div style="width:800px; margin-top:20px;">
<ul>

<%
  string[]  str_url=  new string[9];
  str_url[0] = "index.htm";
  str_url[1] = "http://oa.bb.com";
  str_url[2] = "http://bms.bb.com";
  str_url[3] = "mainundo.aspx";
  str_url[4] = "http://erp.bb.com/index.htm";
  str_url[5] = "mainundo.aspx";
  str_url[6] = "mainundo.aspx";
  str_url[7] = "mainundo.aspx";
  str_url[8] = "t.bb.com";
  for (int i = 0; i < str_url.Length; i++)
  { 
  %>
 <li class="pic">
    <a href="<%=str_url[i] %>" target="_blank"><img  class="img" src="images/main<%=(i + 1).ToString() %>.jpg"/> </a>
 </li> 
  <%} %>
 </ul>
</div>
<uc2:Foot ID="Foot1" runat="server" />
</body>
</center>
</html>
