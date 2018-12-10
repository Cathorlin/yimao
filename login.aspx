<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login"  EnableViewState ="false"%>
<%@ Register Src="BaseForm/Head.ascx" TagName="Head" TagPrefix="uc1"  %>
<%@ Register Src="BaseForm/Foot.ascx" TagName="Foot" TagPrefix="uc2"  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title><%--<%=BaseMsg.getMsg("M0061")%> --%>IM-Environment--Login</title>
    <script type="text/javascript" src ="js/http.js?ver=20130114"></script>	
    <script type="text/javascript" src ="js/BasePage.js?ver=20130114"></script>	
    <link href="css/head.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery.min.js?ver=20130114"></script>
    
</head>
<body >
    <form id="form1" runat="server">
        <uc1:Head id="Head1" runat="server">
        </uc1:Head>
        <div id="showlogin" >
        </div>
         <uc2:Foot ID="Foot1" runat="server" />
    </form>
    <script language=javascript>    
        loadLogin("showlogin");
    </script>
    
</body>
</html>
