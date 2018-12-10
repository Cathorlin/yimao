<%@ Page language="c#" Inherits="Custom.Default" CodeFile="Default.aspx.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title><%=Fun.db.db_oracle.data_source%>  - <%=BaseMsg.getMsg("M0062")%> (<%= GlobeAtt.A007_NAME %>) </title>
        <script src="js/jquery-1.9.1.js"></script>
<script language=javascript>
function  set_title(s_title)
{
    window.document.title = "<%=BaseMsg.getMsg("M0061")%> " + "-----" + s_title;
    var wid = document.body.clientHeight ;
}
function get_mainheight()
{
    //获取当前框架中间的高度
    
    var h = $("#btFrame").height();
    return  h;
}
function get_menuwidth()
{
    var w = $("#menu").width();
    return w ;
}

</script>
<meta http-equiv="Content-Type" content="text/html;charset=gb2312">
</head>

    <frameset rows="70,*,24" cols="*" frameborder="no" border="0" framespacing="0" style=" width:100%;">
      <frame src="top.aspx?code=<%=code %>" name="topFrame" id="topFrame" scrolling="no">
        <frameset cols="190,*" rows="*" name="btFrame"  id="btFrame" frameborder="NO" border="0" framespacing="0" >
            <frame src="MenuLeft.aspx?menu_id=0" noresize name="menu" id="menu"   scrolling="no"  >
            <frame src="main.aspx" noresize name="main"  id="main" scrolling="no"  width="90%" >
        </frameset>
      <frame src="foot.aspx?code=<%=code %>" name="footFrame" id="footFrame" scrolling="no"> 
    </frameset>
  


</html>





