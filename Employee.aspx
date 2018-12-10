<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Employee.aspx.cs" Inherits="Employee"  EnableEventValidation="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Js/jquery-1.4.1.min.js" type="text/javascript"></script>
    <link href="Css/Employee.css" rel="stylesheet" type="text/css" />
     <script type="text/javascript">
         function confirm() {
             var wl_begin = $("#EmpNo").val();
             if (wl_begin == "") {
                 alert("会员编号不能为空！");
                 return
             }
             var wl_end = $("#iphone").val();
             if (wl_end == "") {
                 alert("手机号不能为空！");
                 return


             }
             $("#form1").submit();
         }
    </script>

  
</head>
<body>
    <form id="form1" runat="server" method="post">
    <div>
    <div id="top">
        <fieldset class="WrapBorder">
            <legend class="title-info">签到</legend>
            <table id="tab">
                <tr id="row-one">
                    <td class="left-font">
                        会员编号：
                    </td>
                    <td class="right-font">
                      <asp:TextBox ID="EmpNo" runat="server" ></asp:TextBox>
                    </td>
                    <td class="left-font">
                        课程：
                    </td>
                    <td class="right-font">
                    <select class="DropList" style="width:100px;"> 
                    <option>1</option>
                    <option>2</option>
                    <option>3</option>
                    </select>
                 </td>
                </tr>
                <tr class="bottom_jl">
                    <td class="left-font">
                        手机号：
                    </td>
                    <td class="right-font">
                        <asp:TextBox ID="iphone" runat="server" ></asp:TextBox>
                    </td>
                      
                    <td class="right-font">
                        <asp:Button ID="btn" runat="server" Text="签到"  onclick="btn_Click"  />
                    </td>
                </tr>
               
                
            
            </table>


         
        </fieldset>

        <fieldset class="WrapBorder1">
         <legend class="title-info">签到人员详情信息</legend>
             <div class="Show">
                  <table  border="0" cellpadding="3" cellspacing="1" bgcolor="#c1c1c1">
                 
                        <tr bgcolor="#FFFFFF"> 
                        <td>会员编号</td>
                        <td>姓名</td>
                        <td>手机号</td>
                         <td>性别</td>
                        <td>生日</td>
                        <td>卡号</td>
                       

                        </tr>
                        <tr class="oddList">
                        <td><%=EmpId %></td>
                        <td><%=name %></td>
                        <td><%=mobile_no %></td>
                         <td><%=sex %></td>
                        <td><%=time1 %></td>
                        <td><%=Card_no %></td>
                        </tr>
                      
                   
                  </table>
            </div>
         </fieldset>
    </div>
    </div>
    </form>
</body>
</html>
