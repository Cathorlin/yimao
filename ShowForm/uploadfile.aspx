<%@ Page Language="C#" AutoEventWireup="true" CodeFile="uploadfile.aspx.cs" Inherits="ShowForm_uploadfile" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>上传文件</title>
</head>
<body   style="margin:0"  scroll=yes>
    <form id="form1" runat="server">
        <iframe id="child" src="<%=url.Replace("uploadfile.aspx","uploadfilechild.aspx") %>" scrolling="auto" style="width:100%;height:400px;"      ></iframe>

    </form>
</body>
</html>
