<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default4.aspx.cs" Inherits="Default4" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

 
    <title>xxxxx</title>
    <style type="text/css">
      
      *{ padding:0; margin:0;}
      .top_div{ width:100%; height:100px; background-color:#ccc;}
      .left_div{ width:200px; height:100px;  background-color:Red; position:absolute; left:0; top:100px;}
      .middle_div{ height:100px; margin:0 300px 0 200px; background-color:Aqua;}
      .right_div{ width:300px; height:100px;  background-color:Black; position:absolute; right:0; top:100px;}
    </style>

</head>
<body>
    <form id="form1" runat="server">
    <div class="top_div"></div>
     <div class="left_div"></div>
     <div class="middle_div"></div>
     <div class="right_div"></div>
    </form>
    </body>
</html>
