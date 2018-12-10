<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MLeft.aspx.cs" Inherits="MLeft" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>menu</title>
<link rel="stylesheet" href="skin/css/base.css" type="text/css" />
<link rel="stylesheet" href="skin/css/menu.css" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script language='javascript'>var curopenItem = '1';</script>
<script language="javascript" type="text/javascript" src="skin/js/frame/menu.js"></script>
<SCRIPT language=JavaScript>
var old_idt="";
var old_idstr ="";
function tupian(idt){
    var nametu="xiaotu"+idt;
    var tp = document.getElementById(nametu);
    tp.src="../images/ico05.gif";//图片ico04为白色的正方形
	if (idt != old_idt)
	{
	  var tp2=document.getElementById('xiaotu'+old_idt);
	  if(tp2!=undefined)
	    {tp2.src="../images/ico06.gif";}//图片ico06为蓝色的正方形 
	    old_idt = idt;
	 }
	/*
	for(var i=1;i<30;i++)
	{
	  
	  var nametu2="xiaotu"+i;
	  if(i!=idt*1)
	  {
	    var tp2=document.getElementById('xiaotu'+i);
		if(tp2!=undefined)
	    {tp2.src="../images/ico06.gif";}//图片ico06为蓝色的正方形
	  }
	}
	*/
}

function list(idstr){
	var name1="subtree"+idstr;
	var name2="img"+idstr;
	var objectobj=document.all(name1);
	var imgobj=document.all(name2);
	


	if (old_idstr == idstr)
	{
	    if(objectobj.style.display=="none")
            {
                objectobj.style.display="";
	            imgobj.src="../images/ico03.gif";


            }
            else
            {
            	objectobj.style.display="none";
	          	imgobj.src="../images/ico04.gif";
                
            }	
	    		
	    old_idstr =idstr; 
	}
	else
	{   
		objectobj.style.display="";
		imgobj.src="../images/ico03.gif";
	    var name3="img"+old_idstr;
			var name="subtree"+old_idstr;
			var o=document.all(name);
			if(o!=undefined){
			
					o.style.display="none";
				var image=document.all(name3);
				//alert(image);
				image.src="../images/ico04.gif";
			
			}
	
	
	}

    old_idstr =idstr; 
}
function showmenu(menu_id,menu_name)
{
    parent.main.addtab(menu_id, menu_name);
}
function showchild(menu_id) {

    var t = document.getElementById("tr_" + menu_id);

    if (t != null) {
        
        if (t.style.display == "") {
            t.style.display = "none";
        }
        else {
            t.style.display = "";
        }
    }
}
function myheight() {
    return  document.documentElement.clientHeight;
}
function setmainh() {
    try
    {
     parent.main.setH();
    }catch(e) {
    
    }
}

function showtree()
{
    obj = document.getElementById("div_tree" );
    if ( obj.style.display =="")
    {
        obj.style.display ="none";
    }
    else
    {
        obj.style.display =""
    }
    obj = document.getElementById("table_tree" );
    if ( obj.style.display =="")
    {
        obj.style.display ="none";
    }
    else
    {
         obj.style.display ="";
    }
}
</SCRIPT>
</head>
<body scroll="auto" class="bodystyle" >
<form runat=server>
<table width="100%" class="menuleftstyle" height="100%" border='0' cellspacing='0' cellpadding='0' >
<% dt_child = get_child_("00");
   for (int i = 0; i < dt_child.Rows.Count; i++)
   {
       string str_line = get_html_(dt_child.Rows[i], 1);
       Response.Write(str_line);
   }
%>  
</table>
</form>
</body>

<script>
    setmainh();
</script>
</html>

