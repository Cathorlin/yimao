<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Purchase.aspx.cs" Inherits="Purchase" %>

<!DOCTYPE html >

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>采购申请</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta name="format-detection" content="email=no">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="x5-orientation" content="portrait">
    <link href="Css/Purchase.css" rel="stylesheet" type="text/css" />
    
   
    <script src="Js/jquery-1.4.1.min.js" type="text/javascript"></script>

    <script type="text/javascript">

        function CheckQty(){


            var qty = document.getElementById("Qty").value;
            var purchase_no = document.getElementById("PurchaseNo").value;
            var purchase_name = document.getElementById("Purchaser").value;



            if (purchase_no == "" || purchase_no == null) {

                alert("申请号不能为空!!");
                return;

            }

            if (purchase_name == "" || purchase_name == null) {


                alert("申请人不能为空");
                return;
            }

            if (qty==null||qty==""){

             alert("数量不能为空！！");
             return;
         }

        };

        function onlyNum() {
            if (!(event.keyCode == 46) && !(event.keyCode == 8) && !(event.keyCode == 37) && !(event.keyCode == 39))
                if (!((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105)))
                    event.returnValue = false;
        }


    
    </script>
    </head>
<body>
    <form id="form1" runat="server">
    
 <div class="ShowList">
       <table>
          <tr>
            <td>申请号:</td>
            <td><asp:TextBox ID="PurchaseNo" runat="server"></asp:TextBox></td>
            <td>申请人:</td>
            <td><asp:TextBox ID="Purchaser" runat="server"></asp:TextBox></td>
          </tr>
           <tr>
            <td>部&nbsp;&nbsp;&nbsp;&nbsp;门:</td>
            <td><asp:TextBox ID="Depart" runat="server"></asp:TextBox></td>
            <td>状&nbsp;&nbsp;&nbsp;&nbsp;态:</td>
            <td><select class="DropList">
               <option selected="selected">1</option>
               <option>2</option>
               <option>3</option>
             </select></td>
          </tr>
           <tr>
            <td>日&nbsp;&nbsp;&nbsp;&nbsp;期:</td>
            <td><input type="date" id="timer" name="timer" readonly="readonly"  /></td>
            
       </table>
    </div>
   
    <div class="ShowDetails">
    
       <table  border="0" width="100%" cellpadding="0" cellspacing="0" >
          <tr>
            <td>物料号</td>
           <td> &nbsp;<asp:TextBox ID="Masterial_No" runat="server"></asp:TextBox>&nbsp;</td>
            <td >
           <input type="radio" id="Apply" name="Apply" runat="server"/><label>增加物料号</label>
            </td>
          </tr>
          <tr>
           <td>物料名称</td>
            <td colspan="2"><asp:TextBox ID="Masterial_Name" runat="server"></asp:TextBox></td>
          </tr>
           <tr>
           <td>数量</td>
            <td colspan="2"> <asp:TextBox ID="Qty"   MaxLength="4" onkeydown="onlyNum()" style="ime-mode:Disabled" runat="server"></asp:TextBox></td>
          </tr>

          <tr>
           <td>描述</td>
            <td colspan="2"><asp:TextBox ID="Description" runat="server"></asp:TextBox></td>
          </tr>
          
       </table>
       <div class="bottom_btn">
         <asp:Button ID="Add_Line"  runat="server" Text="增加行" />
          <asp:Button ID="btn"  runat="server" Text="提交"  OnClientClick="CheckQty()" />
        
       </div>

    </div>
    </div>
    </form>
</body>
</html>
