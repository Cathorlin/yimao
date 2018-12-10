<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PurchaseList.aspx.cs" Inherits="PurchaseList" %>

<!DOCTYPE html >

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>采购申请列表</title>
   
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta name="format-detection" content="email=no">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="x5-orientation" content="portrait">
    <link href="Css/PurchaseList.css" rel="stylesheet" type="text/css" />
    <script src="Js/jquery-1.4.1.min.js" type="text/javascript"></script>

     <script type="text/javascript">

         function CheckQty() {


           
             var purchase_no = document.getElementById("PurchaseNo").value;
             var purchase_name = document.getElementById("Purchaser").value;
             var timer = document.getElementById("timer").value;



             if (purchase_no == "" || purchase_no == null) {

                 alert("申请号不能为空!!");
                 return;

             }

             if (purchase_name == "" || purchase_name == null) {


                 alert("申请人不能为空");
                 return;
             }
             
            
             if (timer == "" || timer == null) {

                 alert("请选择日期！");
                 return;
             }
          

         };


    </script>
</head>
<body>
    <form id="form1" runat="server" method="post">
   
     
<div class="ShowList">
       <table>
          <tr>
            <td>申请号:</td>
            <td><asp:TextBox ID="PurchaseNo" runat="server"></asp:TextBox></td>
            <td>申请人:</td>
            <td><asp:TextBox ID="Purchaser" runat="server"></asp:TextBox></td>
          </tr>
           <tr>
         
            <td>状&nbsp;&nbsp;&nbsp;&nbsp;态:</td>
            <td><select class="DropList">
               <option selected="selected">1</option>
               <option>2</option>
               <option>3</option>
             </select></td>
              <td>日&nbsp;&nbsp;&nbsp;&nbsp;期:</td>
            <td><input type="date" id="timer" readonly="readonly" /></td>
          </tr>
       </table>
    </div>
    <div class="bottom_btn">
           <asp:Button ID="btn"  runat="server" Text="查询"  OnClientClick="CheckQty()" />
    </div>
   
    <div class="ShowDetails">
    
       <table  border="0" width="100%" cellpadding="0" cellspacing="0" >
          <tr>
            <td>申请号</td>
            <td>状态</td>
            <td>申请人</td>
            <td>申请人姓名</td>
            <td>创建日期</td>
           
          </tr>

     

          
       
       </table>
    </div>
    </form>
</body>
</html>
