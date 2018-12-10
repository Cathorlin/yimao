<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowRoom.aspx.cs" Inherits="BaseForm_ShowRoom" %>
<%
    int i = 0;
    string roomid = i.ToString();
    string pic_ = "images/0000.JPG";
    string roomname = "100" + i.ToString() + "会议室";
    string roomuser = "Admin";
    string name = "讨论会";
    string des = "测试会议内容";
    string times_ = DateTime.Now.ToString("yy/MM/dd HH:mm");
    times_ = times_ + DateTime.Now.AddHours(4).ToString("-HH:mm");
  
%>
<div class="all_room_left">
<table>
<tr><td><img width="126px" height="80px" src="<%=pic_ %>"/> </td></tr>
<tr><td align=left>
<table class="dopic">
<tr>
<td><a><img src="images/311.gif" /></a></td>
<td><a><img src="images/311.gif"/></a></td>
<td><a><img src="images/311.gif" /></a></td>
<td><a><img src="images/311.gif" /></a></td>
<td><a><img src="images/311.gif" /></a></td>
</tr>
</table>            
</td>
</tr>
<tr>
<td height="30px">      
<table>
<tr><td><%=roomname%> </td></tr>
<tr><td><%=times_%></td> </tr>
</table>
</td>
</tr>
</table>
</div>
<div class="all_room_right">
<table width="120px">
<tr><td><%=roomuser %></td></tr>
<tr><td><%=name %></td></tr>
<tr><td><%=des%></td></tr>
</table>
</div>