<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TreeShowList.aspx.cs" Inherits="ShowForm_TreeShowList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../js/jquery-1.9.1.js"></script>
    <style>
    body,html {
    margin:0;
    width:100%;
    }
    div.maind {
    border:1px solid  red;
    text-align:center;
    width:100%;
    }
    table
    {
       width:100%; table-layout:fixed; 
       border-collapse:collapse;       
    }
    table.maint
    {
        width:100%; table-layout:fixed;
    }
    table.maint tr.t0 td 
    {
        text-align:left;
    }
    div.showdiv
    {
         border-top: solid 1px red;   
    }
    div.maindiv
    {
        border-top: solid 1px red;   
         
    }
    img.arrow_img
    {
       width:35px; height:19px;
       float:left;     
         
    }
    img.arrow_img_s
    {
        width:20px; height:18px;
        float:left;
        
    }
    div.shows
    {  float:left;
       margin: 0 0 0 0px;    
       height:30px; 
       
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
    <div  class="maind" >
    <%
        
        string mainsql = "Select '[SUPP_LINE_KEY]-[SUPP_TYPE]' as c From dual  t  ";
        //获取行的显示HTML
        
        string childsql = "select t.Supp_Line_Key,(case  '[SUPP_TYPE]' when '1' then '0' else '1' end ) as supp_type  from BL_SHOP_ORDER_V01 t Where t.line_key ='[SUPP_LINE_KEY]' AND T.supp_type='[SUPP_TYPE]' ";
        string child_sql_ = "select t.Supp_Line_Key,(case  '[SUPP_TYPE]' when '1' then '0' else '1' end ) as supp_type from BL_SHOP_ORDER_V01 t Where t.line_key ='B58202-2-1-0-110101099027' AND T.supp_type='0' ";
        string main_exec_sql_ = "Select t.line_key,t.part_no  From BL_SHOP_ORDER_V02 t where t.line_key ='B58202-2-1-0-110101099027'";
        //B58202-2-1-0-110101099027'  ";
        dt_main = Fun.getDtBySql(child_sql_);
        string html_ = get_child_html(mainsql, childsql, dt_main.Rows[0],main_exec_sql_, child_sql_, 0,"");
        Response.Write(html_);
    %>

    <script language=javascript>
        $("img.arrow_img").click(function () {
            var pid = this.id.substring(1);
            var show_ = $("#tr" + pid).attr("show");
            if (show_ == "1") {
                $("#tr" + pid).hide();
                $("#tr" + pid).attr("show", "0");
                $("#S" + pid).css("color", "red");
                this.src = "../images/ico_folder.gif";
            }
            else {
                $("#tr" + pid).show();
                $("#tr" + pid).attr("show", "1");
                $("#S" + pid).css("color", "black");
                this.src = "../images/ico_folder_open_fst.gif";
            }
        }
        )
        
    
    </script>
   </div>
    </form>
</body>
</html>
