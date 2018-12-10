<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Class_Record.aspx.cs" Inherits="Class_Record" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>上课记录</title>
     <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta name="format-detection" content="email=no">
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="x5-orientation" content="portrait">
    <link href="Css/Record.css" rel="stylesheet" type="text/css" />
    <script src="Js/jquery-1.4.1.min.js" type="text/javascript"></script>

    <script type="text/javascript">

        function check() {

            var Card_no = document.getElementById("EmpNo").value;

            if (Card_no == "" || Card_no == null) {

                alert("卡号不能为空!!!");
                return;
            }

        }
       
    </script>
</head>
<body>
    <form id="form1" runat="server">
    
 <div class="ShowList">
       <table>
          <tr>
            <td>卡号</td>
            <td><asp:TextBox ID="EmpNo" runat="server"></asp:TextBox></td>
            <td><asp:Button ID="btn" runat="server" Text="查询" OnClientClick="check()" onclick="btn_Click" /></td>
          </tr>
       </table>
    </div>
  <div class="cboth"></div>


 <div class="content">
    <div class="left">
    <label>卡&nbsp;&nbsp;类&nbsp;&nbsp;型</label>
     <input type="text" id="Type" name="Type" value="<%=Card_Type %>"readonly="readonly"   />
    </div>

    <div class="right">
   <label>使&nbsp;&nbsp;用&nbsp;&nbsp;量</label>
    <input type="text" id="Used" name="Used" value="<%=used %>" readonly="readonly" />
    
    </div>
   
    <div class="cboth"></div>
    
   
      <div class="left">
    <label>数&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;量</label>
  <input type="text" id="Count" name="Count"  value="<%=num %>" readonly="readonly"/>
    </div>

    <div class="right">
 
   <label>余&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;额</label>
   <input type="text" id="Balance" name="Balance" value="<%=balance %>" readonly="readonly" />
    </div>

      <div class="left">
    <label>开始日期</label>
  <input type="text" id="Beg_Time" name="Beg_Time"  value="<%=beg_date %>" readonly="readonly"/>
    </div>

    <div class="right">
 
     <label>结束日期</label>
    <input type="text" id="End_Time" name="End_Time" value="<%=end_date %>" readonly="readonly" />
    </div>

    </div>
    <div class="cboth"></div>
   <div class="container">
    <div class="div-left">
       <label>上课记录</label>
    </div>
</div>
    <div class="ShowDetails">
    
        
         <table  border="0" width="100%" cellpadding="0" cellspacing="0" >
            <tr>
           
            <td>上课日期</td>
            <td>课时</td>
          </tr>
          <%for (int i = 0; i < date.Rows.Count; i++) {

               
                QTY = date.Rows[i]["QTY"].ToString();
                Validate = DateTime.Parse( date.Rows[i]["BILL_DATE"].ToString()).ToString("yyyy/MM/dd");
        
          %>

          <tr>
           
              <td><%=Validate %></td>
              <td><%=QTY %></td>
         </tr>
      
         <%} %>
       

        

       
       </table>
    </div>
    </form>
</body>
</html>
