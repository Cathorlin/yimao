<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowA4030.aspx.cs" Inherits="ShowForm_ShowA4030" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8">
	<title>jQuery UI Draggable - Constrain movement</title>
	<link rel="stylesheet" href="../jquery-ui-1.10.3/themes/base/jquery.ui.all.css">
	<script src="../jquery-ui-1.10.3/jquery-1.9.1.js"></script>
	<script src="../jquery-ui-1.10.3/ui/jquery.ui.core.js"></script>
	<script src="../jquery-ui-1.10.3/ui/jquery.ui.widget.js"></script>
	<script src="../jquery-ui-1.10.3/ui/jquery.ui.mouse.js"></script>
	<script src="../jquery-ui-1.10.3/ui/jquery.ui.draggable.js"></script>
    <script src="../jquery-ui-1.10.3/ui/jquery.ui.button.js"></script>
    <script src="../jquery-ui-1.10.3/ui/jquery.ui.resizable.js"></script>
	<link rel="stylesheet" href="../jquery-ui-1.10.3/demos/demos.css">
        <% double main_width = double.Parse(dt_a403.Rows[0]["div_width"].ToString());
       double main_height = double.Parse(dt_a403.Rows[0]["div_height"].ToString()); %>
	<style>
	.draggable { width: 390px; height: 390px; padding: 0.5em; float: left; margin: 0 10px 10px 0; }

	#containment-wrapper { width:100%; border:2px solid #ccc; padding: 0px; }
	h3 { clear: left; }
	</style>
	<script>
	    $(function () {
            $("#containment-wrapper").height(<%=main_height %>);
	        $("input[type=submit], a, button")
			.button()
			.click(function (event) {
			    event.preventDefault();
			});
            var divlist =$("div[name=M<%=a403_id %>]") ;
            for (var i =0 ;i < divlist.length; i++)
            {
                $("#"+divlist[i].id).html($("#"+divlist[i].id).attr("width"));
                $("#"+divlist[i].id).width($("#"+divlist[i].id).attr("width"));
                $("#"+divlist[i].id).height($("#"+divlist[i].id).attr("height"));
                $("#"+divlist[i].id).draggable({ containment: "parent" });
                $("#"+divlist[i].id).resizable({ containment: "parent" });
            }


	    });
        
	    function show_newdiv(id_, context_) { 
           var drag = "<div id=\"" + id_ + "\" class=\"draggable ui-widget-content\">";
           drag += "<p>" + context_  + "</p>";
           drag += "</div>";
           $("#containment-wrapper").append(drag);
           $("#" + id_).draggable({ containment: "#containment-wrapper" });
           $("#" + id_).resizable({
               containment: "#containment-wrapper"
           });
           
        }
	</script>
</head>
<body>
    <form id="form1" runat="server">
    <button onclick="show_newdiv('d22','cccccccccc')">添加DIV</button>

<div id="containment-wrapper">
<%    
    for (int i = 0; i < dt_a40301.Rows.Count; i++)
    {
        string id_ = "M" + a403_id + "-" + dt_a40301.Rows[i]["line_no"].ToString();
        string width_ = (Math.Round( double.Parse(dt_a40301.Rows[i]["DIV_WIDTH"].ToString()) * double.Parse(dt_a403.Rows[0]["div_width"].ToString()) /100,0)).ToString();
        string height_ = (Math.Round(double.Parse(dt_a40301.Rows[i]["DIV_HEIGHT"].ToString()) * double.Parse(dt_a403.Rows[0]["DIV_HEIGHT"].ToString()) / 100, 0)).ToString(); // dt_a40301.Rows[i][""].ToString();
        string left_ = dt_a40301.Rows[i]["DIV_LEFT"].ToString();
        string top_ = dt_a40301.Rows[i]["DIV_TOP"].ToString();
        string div_html_ = dt_a40301.Rows[i]["SHOW_HTML"].ToString();
        div_html_ = div_html_.Replace("'", "\\'");
        string title_ = dt_a40301.Rows[i]["line_no"].ToString() + "-" + dt_a40301.Rows[i]["div_title"].ToString();
        string dojs = "<div id=\"" + id_ + "\" name=\"M" + a403_id + "\" width=\"" + width_ + "\" height=\"" + height_ + "\" class=\"draggable ui-widget-content\">";
               dojs  += "<p>I'm contained within the box</p>";		
               dojs  += "</div>";

        Response.Write(dojs);
        Response.Write(Environment.NewLine);
    }
 %>

	
</div>
</form>
</body>
</html>
