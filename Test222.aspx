<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test222.aspx.cs" Inherits="Test222" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <style>
.button-normal
{
border:groove 1px #ffffff;
border-bottom:groove 1px #666666;
border-right:groove 1px #666666;
background-image:url(button-bg03.gif);
background-repeat:repeat-x;
background-color:Transparent;
height:20px;
event:expression(
onmouseover = function(){
this.style.backgroundColor='red'
},
onmouseout = function(){
this.style.backgroundColor='#ffffff'
}
)
}
</style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
<input type=button value="click me" class="button-normal">
    </div>
    </form>
</body>
</html>
