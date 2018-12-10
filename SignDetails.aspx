<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SignDetails.aspx.cs" Inherits="SignDetails" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>签到详情</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta name="format-detection" content="email=no">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="x5-orientation" content="portrait">
    <link href="Css/SignDetails.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" action="SignDetails.aspx">
   <div class="content">
    <div class="left">
    <label>卡&nbsp;&nbsp;&nbsp;&nbsp;号</label>
   <asp:TextBox ID="CardNo" name="CardNo" runat="server" ></asp:TextBox> 
    </div>

    <div class="right">
 
    <label>会员名</label>
     <asp:TextBox ID="EmpName" name="EmpName" runat="server" ></asp:TextBox> 
    </div>
    </div>
    <div class="cboth"></div>
    <div  class="TopFire">
     <div class="left">
    <label>有效期</label>
   <asp:TextBox ID="ValidDate" name="ValidDate" runat="server"  ></asp:TextBox>
    </div>

    <div class="right">
 
     <label>签到课</label>
     <asp:TextBox ID="Sign" name="Sign" runat="server" ></asp:TextBox>
    </div>
    </div>
    <div class="cboth"></div>
    <div class="ContentCenter">
         <table cellpadding="0" cellspacing="0" width="100%">
            <tr>
              <td>卡号(手机号)
             
              <asp:TextBox ID="Card" name="Card" ReadOnly="true" runat="server"></asp:TextBox>
              
              <td>
               <asp:Button ID="btn" runat="server" Text="确定"  />
              </td>
            </tr>
            
         </table>
    </div>
    </form>
</body>
</html>
