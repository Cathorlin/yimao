<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowDialog.aspx.cs" Inherits="ShowForm_ShowDialog" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>弹出窗口</title>

</head>
<body style="font-size:9pt;font-family: 宋体; color: black;">
    <form id="form1" runat="server">   
    <div>    
    <iframe id="child"  scrolling="auto" style="width:98%;height:600px;" src="<%=url %>"  ></iframe>
    </div>
    </form>
</body>
</html>
