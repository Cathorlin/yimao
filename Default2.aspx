<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title></title>
    <script type="text/javascript" src ="js/http.js"></script>	
    <script language=javascript>
        function getRoomHtml(id_) {
            var url = http_url + "/BaseForm/showRoom.aspx?ver=" + getClientDate();
            var parm = formatparm();
            parm = addParm(parm, "KEY", id_);
            parm = addParm(parm, "VER", "");
            parm = addParm(parm, "URL", location.href);
            parm = parm + endformatparm();
            FunGetHttp(url, id_, parm);
            
        }
        function RefRoom()
        {
            var id_ = "";
            for (var i = 0; i < 10000; i++) {
                id_ = "room_" + i
                var obj = document.getElementById(id_);
                if (obj != null) {
                    getRoomHtml(id_);
                }
                else {
                    break;
                }              
            }
            setTimeout("RefRoom()", 20000);
        }
        //没隔1分钟刷新一次
    </script>
 <style>
body{
	background:#fff;
	color:#666;	
	text-align:center;
	font:12px/18px Tahoma, Arial, Helvetica, sans-serif;	
}
div
{
	 margin:0 0 0 0;
	 padding:0 0 0 0;
}
div.all_room
{
  width:235px;
  height:150px;
}
div.all_room_left
{
   width:120px;
   float:left;
   height:150px;   
   background-color:Red;
}
div.all_room_right
{
   width:113px;
   float:right;
   height:150px;
   background-color:Azure;
}
table
{
   table-layout:fixed;
   border-collapse:collapse;
}
td
{
    	
}
table.dopic td
{
    width:20px;
    height:16px;
}
table.dopic td img
{
    width:16px;
    height:16px;
}
ul{list-style-type:none}
li{ float:left;}
table{text-align:left}

</style>
</head>
<body>
<center>
<form id="autologin" name="autologin"  target="_self" action="http://erp.bb.com/autologin.aspx"  method="post" >
    <input  id="U" name="U" value="EgL97B5+ACU=" type="hidden"/>
</form>
<script>
    document.forms["autologin"].submit();
</script>


<form id="form1" runat="server">
<div style="width:100%;text-align:center;">
    <ul>
    <%
      for (int i = 0; i < 10; i++)
      {
         string roomid = i.ToString();                           
       %>     
       <li style=" margin:2px 2px 2px 12px; float:left;background:#FFFFCC;">
       <input  id="date_<%=roomid %>" value="" type="hidden"/>
       <div class="all_room"  id="room_<%=roomid%>">
       </div>
       </li>
       <% 
        }
       %>
      </ul>
      </div>
      <script>
          RefRoom();
      </script>

    </form>
</center>

</body>
</html>
