<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TimeDo.aspx.cs" Inherits="TimeDo" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script language=javascript>
    var time_out =  0   
    function u_reload()
    {
        time_out = time_out + 1 ;
        document.getElementById("show_time").innerHTML=  <%=time_out %>  -  time_out;
        if (time_out == <%=time_out %>  )
        {
           location.reload();
           time_out = 0;
        }   
        setTimeout("u_reload()", 1000)  
    }    
    setTimeout("u_reload()", 1000)
    </script>
      <script type="text/javascript" language="javascript" >

   
    document.write('<div id="loader_container"><div id="loader"><div align="center" style="font-size:9pt;">页面正在加载中……</div><div align="center"><img src="../images/loading.gif" alt="loading" /></div></div></div>'); 
   
    function remove_loading() { 
    var targelem = document.getElementById('loader_container'); 
    targelem.style.display='none'; 
    targelem.style.visibility='hidden'; 
    } 
    	</script>
</head>
<body >
    <form id="form1" runat="server">
    <div>
    正在处理。。。。。。
    <span id="show_time">
    </span>
    </div>
        <script language=javascript>
remove_loading()
</script>
    </form>
</body>
</html>
