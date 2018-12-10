<%@ Page Language="C#" AutoEventWireup="true" CodeFile="A013.aspx.cs" Inherits="ShowForm_A013" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>修改角色的权限</title>
    <script language=javascript>
    function selectchange()
    {
        select_obj  = document.getElementById("selecta013");
        v = select_obj.options[select_obj.selectedIndex].value;
        ifame = document.getElementById("child");
        ifame.src = "MainForm.aspx?dialog=1&option=M&A002KEY=2520&key="+ v  +"&A002ID=<%=A002ID %>&nodate=1&code=" +  Math.random() * 100000 +"" ;
    }
  
    </script>
</head>
<body style="font-size:9pt;font-family: 宋体; color: black;">
    <form id="form1" runat="server">
    角色
    <select id="selecta013" onchange="selectchange()">
    
        <%
            for (int i = 0; i < dt_a013.Rows.Count; i++)
            {
                string a013_name = dt_a013.Rows[i]["a013_name"].ToString();
                string a013_id = dt_a013.Rows[i]["a013_id"].ToString();
                string html_ = "<option value=\"" + a013_id + "\">" + a013_name  + "</option>";
                if (i == 0)
                {
                    html_ = "<option value=\"" + a013_id + "\" selected>" + a013_name + "</option>"; 
                }
                Response.Write(html_);
            }
         %>
    </select>    
    <div>
    
    <iframe id="child"  scrolling="auto" style="width:98%;height:600px;"  ></iframe>

    </div>
    <script language=javascript>
     selectchange()
    </script>
    </form>
</body>
</html>
