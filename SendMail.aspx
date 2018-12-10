<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SendMail.aspx.cs" Inherits="SendMail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>发送邮件</title>
    <script language=javascript>
    
    //设置当前的登录是否有效

    function urlreload() 
    {
          location.reload();
    }
    setTimeout("urlreload()",<%=FROM_EMAIL_TIMES%>000);
    </script>
</head>
<body>
    <form id="form1" runat="server">
   
    <div>
     <%=ls_Date%>   &nbsp;正在发生邮件。。。。。。。。。。</div>
    <asp:TextBox ID="TextBox1" runat="server" Height="269px" TextMode="MultiLine" 
        Width="705px"></asp:TextBox>
    </form>
</body>
</html>
