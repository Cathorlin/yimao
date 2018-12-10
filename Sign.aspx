<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Sign.aspx.cs" Inherits="Sign" %>

<!DOCTYPE html >

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>签到</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta name="format-detection" content="email=no">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="x5-orientation" content="portrait">
    <link href="Css/Sign.css" rel="stylesheet" type="text/css" />
    <script src="Js/jquery-1.4.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        function check() {

            var Empno = document.getElementById("EmpNo").value;

            if(Empno==""||Empno==null){

              alert("卡号或手机号不能为空！！");
              return;
            }
        }
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
   <div class="container">
    <div class="div-left">
       <label>会员签到</label>
    </div>
    <div class="div-right">
    
      <label>签到课程</label>
       <option>1</option>
       <option>2</option>
       <option>3</option>
       </select>
    </div>

   
</div>
 <div class="ShowList">
       <table>
          <tr>
            <td>卡号(手机号)</td>
            <td><asp:TextBox ID="EmpNo" runat="server"></asp:TextBox></td>
            <td><asp:Button ID="btn" runat="server" Text="签到"  OnClientClick="check()" onclick="btn_Click" /></td>
          </tr>
       </table>
    </div>
   
    <div class="ShowDetails">
    
       <table  border="0" width="100%" cellpadding="0" cellspacing="0" >
          <tr>
            <td>会员卡号</td>
            <td>会员名</td>
            <td>日期</td>
            <td>卡类型</td>
            <td>课时</td>
           
          </tr>

           <%for (int i = 0; i < date.Rows.Count;i++ )
             {

                 Card_no = date.Rows[i]["CARD_NO"].ToString();
                 name = date.Rows[i]["M001_NAME"].ToString();
                 Validate = date.Rows[i]["BILL_DATE"].ToString();
                 Card_Type = date.Rows[i]["CARD_TYPE"].ToString();
                 qty = date.Rows[i]["QTY"].ToString();
                 

              %>

          
          <tr>
             <td><%=Card_no%></td>
             <td><%=name%></td>
             <td><%=Validate%></td>
             <td><%=Card_Type%></td>
             <td><%=qty%></td>
             
          </tr>
             <%} %>
       </table>
    </div>
    </form>
</body>
</html>
