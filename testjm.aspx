<%@ Page Language="C#" AutoEventWireup="true" CodeFile="testjm.aspx.cs" Inherits="testjm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <% string strdata = "12345679";
       string strkey = "12345678";
    %>
    V:<%=strdata%>
      <br />  
    KEY:<%=strkey%>
    <%--<%=DES.DESEncrypt(strdata, strkey)%>--%>
    <br />    
    CBC-PKCS7 :<%=DES.DESEncrypt(strdata, strkey,System.Security.Cryptography.CipherMode.CBC, System.Security.Cryptography.PaddingMode.PKCS7, true)%>
    <br />    
    CBC-Zeros :<%=DES.DESEncrypt(strdata, strkey,System.Security.Cryptography.CipherMode.CBC, System.Security.Cryptography.PaddingMode.Zeros, true)%>
    <br />
    CBC-ISO10126 :<%=DES.DESEncrypt(strdata, strkey,System.Security.Cryptography.CipherMode.CBC, System.Security.Cryptography.PaddingMode.ISO10126, true)%>
    <br />
    CBC-ANSIX923 :<%=DES.DESEncrypt(strdata, strkey,System.Security.Cryptography.CipherMode.CBC, System.Security.Cryptography.PaddingMode.ANSIX923, true)%>
    <br />    
    ECB-PKCS7 :<%=DES.DESEncrypt(strdata, strkey,System.Security.Cryptography.CipherMode.ECB, System.Security.Cryptography.PaddingMode.PKCS7, true)%>
    <br />    
    ECB-Zeros :<%=DES.DESEncrypt(strdata, strkey, System.Security.Cryptography.CipherMode.ECB, System.Security.Cryptography.PaddingMode.Zeros, true)%>
    <br />
    ECB-ISO10126 :<%=DES.DESEncrypt(strdata, strkey, System.Security.Cryptography.CipherMode.ECB, System.Security.Cryptography.PaddingMode.ISO10126, true)%>
    <br />
    ECB-ANSIX923 :<%=DES.DESEncrypt(strdata, strkey, System.Security.Cryptography.CipherMode.ECB, System.Security.Cryptography.PaddingMode.ANSIX923, true)%>
    <br />
    CFB-PKCS7 :<%=DES.DESEncrypt(strdata, strkey, System.Security.Cryptography.CipherMode.CFB, System.Security.Cryptography.PaddingMode.PKCS7, true)%>
    <br />
    CFB-Zeros :<%=DES.DESEncrypt(strdata, strkey, System.Security.Cryptography.CipherMode.CFB, System.Security.Cryptography.PaddingMode.Zeros, true)%>
    <br />
    CFB-ISO10126 :<%=DES.DESEncrypt(strdata, strkey, System.Security.Cryptography.CipherMode.CFB, System.Security.Cryptography.PaddingMode.ISO10126, true)%>
    <br />
    CFB-ANSIX923 :<%=DES.DESEncrypt(strdata, strkey, System.Security.Cryptography.CipherMode.CFB, System.Security.Cryptography.PaddingMode.ANSIX923, true)%>
    </div>
    </form>
</body>
</html>
