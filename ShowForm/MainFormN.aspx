<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MainFormN.aspx.cs" Inherits="ShowForm_MainFormN" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<% string jqueryversoin = "../jquery-ui-1.10.3";    %>
    <title></title>
        <script type="text/javascript" src ="../js/http.js?ver=20130114"></script>	
        <link rel="stylesheet" href="<% =jqueryversoin %>/themes/base/jquery.ui.all.css">
	    <link rel="stylesheet" href="<% =jqueryversoin %>/demos/demos.css">
        <script src="<%=jqueryversoin %>/jquery-1.9.1.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.core.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.widget.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.mouse.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.draggable.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.position.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.resizable.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.button.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.dialog.js"></script>
        <script src="<%=jqueryversoin %>/ui/jquery.ui.tabs.js"></script>
        <link rel="stylesheet" href="../ztree/css/demo.css" type="text/css">
	    <link rel="stylesheet" href="../ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	    <script type="text/javascript" src="../ztree/js/jquery.ztree.core-3.5.js"></script>
        <style>
        #main
        {
                width:100%;
                height:400px;
                         
        }
        
        </style>
</head>
<body>
<div id="main">
<div id="dtree">
    <ul id="treeDemo" class="ztree"></ul>
</div>
<div id="dmain">
    <iframe src="<%= mainformurl %>" width="100%" height="400px"></iframe>
</div>
</div>

<script>
        
    
    </script>
</body>
</html>
