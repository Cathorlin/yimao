<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="lubang_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<script type="text/javascript">
    function phhui() {
        document.getElementById("TextBox1").value = form1.fileupload1.value;
    } 
</script> 
</head> 
<body> 
    <form id="form1" runat="server"> 
        <asp:FileUpload ID="fileupload1" runat="server" /> 
        <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox> 
        <input id="Button1" type="button" value="button" onclick="fileupload1.click();" /> 
    </form> 
</body> 

</html>
