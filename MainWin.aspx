<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MainWin.aspx.cs" Inherits="MainWin" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >

<head >
    <title><%=Fun.db.db_oracle.data_source%>  - <%=BaseMsg.getMsg("M0062")%> (<%= GlobeAtt.A007_NAME %>)</title>
    <%
        string jqueryversoin =  "jquery-ui-1.10.3";   
         %>
        <script type="text/javascript" src ="js/http.js?ver=20130114"></script>	
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

        <link rel="stylesheet" href="ztree/css/demo.css" type="text/css">
	    <link rel="stylesheet" href="ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	    <script type="text/javascript" src="ztree/js/jquery.ztree.core-3.5.js"></script>
   <style>   
       
html,body,div,span,applet,object,iframe,blockquote,pre,abbr,acronym,address,big,cite,code,del,dfn,em,font,img,ins,kbd,p,q,s,samp,small,strike,strong,sub,sup,tt,var,dd,dl,dt,fieldset,form,label,legend,table,caption,tbody,tfoot,thead,tr,th,td,li,ul,button{border:0;margin:0;padding:0} 
body
{  font-size : 12px;
	font-family: Arial, "宋体" ,;
	color: #333;
	line-height: 18px;
	background-color:#FAFAFA;
}
#tabs ul{
	overflow:hidden;
	height:32px;
	line-height:32px;
}
#tabs ul li{
  margin:0 0 0 0;
  height:20px;
}

.clearer{ height:1px; overflow:hidden; margin-top:-1px; clear:both;}
	#tabs { margin-top: 1em; }
	#tabs li .ui-icon-close { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
	#add_tab { cursor: pointer; }
#wtop
{
 background-color:#1729e9;
 margin:0;
 height:45px;
 background-image:url(skin/images/frame/topbg.gif);
}
#wmain 
{
 
}
#wfoot
{
  margin:0;
  height:25px;
  background-image:url(skin/images/frame/topbg.gif);
}


#wcenter #wleft
{  
    float:left; 
    border : solid 0px  #CCCCFF;
    margin :2px  1px 2px 2px;
        
}
#wcenter #wright
{  
    float:right;    
    border : solid 0px  #CCCCFF;
    margin :2px  1px 2px 2px;  
}
span._m_
{
    font-size :12px;
	font-family: Arial, "宋体" ,;
	font-weight:300;
    }
</style>
</head>
<body  onresize ="changesize()">
<div id="wmain">
<div id="wtop">
<div style="float:left;width:20%;height:44px; " id="topleft">
   <a><img src="skin/images/frame/logo.gif" height="40" width="183" /></a>
</div>
  <div style=" float:left;width:80%; text-align:right;" id="topright"  >
  <div  class="logininfo">
   您好：<span class="username"><%=GlobeAtt.A007_NAME%>[<%=GlobeAtt.A007_KEY %>]</span>，欢迎使用系统！
        	[<a href="javascript:logout();"  >注销退出</a>]&nbsp;
  </div>
  </div>
</div>

<div class="clearer"></div>

<div id="wcenter">
<table style="table-layout:fixed;" id="wtable"  >
<tr>
<td id="tdleft">
<div  id="wleft" >
<ul id="treeDemo" class="ztree"></ul>


</div>
</td>
<td id="tdright">
<div  id="wright">
<div id="tabs" style=" margin:0;padding:0; ">
	<ul>
	<span class="ui-icon ui-icon-circle-triangle-e"  onclick="tabsgo(1)" style="float:right;margin: 5px 4px;"></span>
	<span class="ui-icon ui-icon-circle-triangle-w" onclick="tabsgo(0)" style="float:right;margin: 5px 4px;"></span>
    <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active" tabid="0"><a href="#room_all">总类</a></li>
    </ul>
    <div id="room_all">
    111
    </div>
</div>

</div>
</td>
</tr>
</table>
</div>
<div class="clearer"></div>
<div id="wfoot">

</div>
</div>
<script language="javascript">
    var menuw = 210; 
    function changesize() {
        var winh = $(window).height();
        if (winh  < 600) {
            winh = 600;
        }
        var toph = $("#wtop").height();
        var footh = $("#wfoot").height();
        var mainh = winh - toph - footh - 2;
        $("#wcenter").height(mainh);
        $("#wleft").height(mainh - 7);
        $("#wright").height(mainh - 7);
        var winw = $(window).width();
        if (winw < 1024) {
            winw = 1024;
            $("#wcenter").width(winw);
        }
        $("#wtop").width(winw);
        $("#wfoot").width(winw);
        $("#tdleft").width(menuw);
        $("#tdright").width(winw - menuw - 18);
        $("#wleft").width(menuw);
        $("#wright").width(winw - menuw - 20);
                

        $("#treeDemo").height($("#wleft").height() - 15);
        $("#treeDemo").width($("#wleft").width() -10);
        $("#treeDemo").css("margin", "0");
    }
    function tabsgo (lr)
     {
	
	    if (lr)
	    {
		    if($("#tabs ul li:visible:last").offset().top>30)//防止全部被隐藏
			    $("#tabs ul li:visible:eq(1)").hide();//eq(0)为所有分类，永不隐藏
	
	    }
	    else
	    $("#tabs ul li:hidden:last").show();
    }	
    function showmenu(menu_id,menu_name)
    {
        //alert(menu_name);
        addTab(menu_id,menu_name,"jump.aspx?menu_id=" + menu_id +"-0" );
       // mainframe.addtab(menu_id+"-0", menu_name);
    }
    var setting = {
        check: {
            enable: true
        },

        data: {
            simpleData: {
                enable: true
            },
            key: {
            title:"title"//1 json中要有一个key是 title就可以了
            }
        },
        view: {
                showTitle : true,// 2 这个开关也要打开，默认是关闭的
				nameIsHTML: true
        },
        callback: {
            onNodeCreated: onNodeCreated
        }
    };
var dataMaker = function(count) {
var nodes = [], pId = -1,
min = 10, max = 90, level = 0, curLevel = [], prevLevel = [], levelCount,
i = 0,j,k,l,m;
            <%
             for(int i=0 ; i < dt_all.Rows.Count;i++)
             {
                 string menu_id=  dt_all.Rows[i]["MENU_ID"].ToString();
                 string menu_name_ =  dt_all.Rows[i]["MENU_NAME"].ToString();
                 string parent_id = dt_all.Rows[i]["parent_id"].ToString();
                 string LAST_LEVEL = dt_all.Rows[i]["LAST_LEVEL"].ToString();
                 string Useable =  dt_all.Rows[i]["Useable"].ToString();
                 string menu_name = "<span class=_m_>"+menu_name_+"</span>";

                 if ( Useable == "1")
                 {
                 if (parent_id =="00")
                 {
                    parent_id = "-1";
                 }
                 if (LAST_LEVEL == "1")
                 {
          %>
var n = {id:<%=menu_id %>, pId:<%=parent_id %>, name:"<%=menu_name %>",title:"<%=menu_id %>|<%=menu_name_ %>",click:"showmenu('<%=menu_id %>','<%=menu_name %>');"};
                <%
                 }
                 else
                 {
                 %>
 var n = {id:<%=menu_id %>, pId:<%=parent_id %>, name:"<%=menu_name %>",title:"<%=menu_id %>|<%=menu_name_ %>"};        
                 <%
                 }
             %>
nodes.push(n);curLevel.push(n);prevLevel = curLevel;curLevel = [];level++;   
            <% }           
               }
             %>          
return nodes;
}
 
		var ruler = {
			doc: null,
			ruler: null,
			cursor: null,
			minCount: 5000,
			count: 5000,
			stepCount:500,
			minWidth: 30,
			maxWidth: 215,
			init: function() {
				ruler.doc = $(document);
				ruler.ruler = $("#ruler");
				ruler.cursor = $("#cursor");
				if (ruler.ruler) {
					ruler.ruler.bind("mousedown", ruler.onMouseDown);					
				}
			},
			onMouseDown: function(e) {
				ruler.drawRuler(e, true);
				ruler.doc.bind("mousemove", ruler.onMouseMove);
				ruler.doc.bind("mouseup", ruler.onMouseUp);
				ruler.doc.bind("selectstart", ruler.onSelect);
				$("body").css("cursor", "pointer");
			},
			onMouseMove: function(e) {
				ruler.drawRuler(e);
				return false;
			},
			onMouseUp: function(e) {
				$("body").css("cursor", "auto");
				ruler.doc.unbind("mousemove", ruler.onMouseMove);
				ruler.doc.unbind("mouseup", ruler.onMouseUp);
				ruler.doc.unbind("selectstart", ruler.onSelect);
				ruler.drawRuler(e);
			},
			onSelect: function (e) {
				return false;
			},
			getCount: function(end) {
				var start = ruler.ruler.offset().left+1;
				var c = Math.max((end - start), ruler.minWidth);
				c = Math.min(c, ruler.maxWidth);
				return {width:c, count:(c - ruler.minWidth)*ruler.stepCount + ruler.minCount};
			},
			drawRuler: function(e, animate) {
				var c = ruler.getCount(e.clientX);
				ruler.cursor.stop();
				if ($.browser.msie || !animate) {
					ruler.cursor.css({width:c.width});
				} else {
					ruler.cursor.animate({width:c.width}, {duration: "fast",easing: "swing", complete:null});
				}
				ruler.count = c.count;
				ruler.cursor.text(c.count);
			}
		}
		var showNodeCount = 0;
		function onNodeCreated(event, treeId, treeNode) {
			showNodeCount++;
		}
 
		function createTree () {
			var zNodes = dataMaker(ruler.count);
			showNodeCount = 0;
			$("#treeDemo").empty();
			setting.check.enable = $("#showChk").attr("checked");
			var time1 = new Date();
			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			var time2 = new Date();
		}
  


        var tabs = $( "#tabs" ).tabs({  
    
        });
        var tabCounter = 1;
        // actual addTab function: adds new tab using the input from the form above
        function selectedtab(tabnum)
        {
            var li_list =  $("#tabs ul li");
            for(var i=0 ;i < li_list.length;i++)
            {
               if (li_list[i].attributes("tabid").value == tabnum)
               {
                 tabs.tabs( "option", "active", i); 
                 break;
               }
            }        
        }
		function addTab(tabTitle , tabContent,taburl) {            
			var label = tabContent || "Tab " + tabCounter;
			id = "tabs-" + tabCounter;
			li = $("<li tabid="+ tabCounter +" taburl="+taburl+"><a href='#"+id+"'>"+label+"</a> <span class='ui-icon ui-icon-close' role='presentation'>Remove Tab</span></li>");
			tabContentHtml = tabContent || "Tab " + tabCounter + " content.";
            tabContentHtml = "<iframe ID=\"testIframe\" class=\"testIframe\" FRAMEBORDER=0  SCROLLING=AUTO width=\"100%\"  height=\"600px\" src=\"http://www.baidu.com\" ></iframe>";
			tabContentHtml = "<iframe ID=\"testIframe\" name=\"testIframe\" height=\"600px\"></iframe>";
            tabs.find( ".ui-tabs-nav" ).append( li );
           
			tabs.append("<div id='" + id + "'></div>" );

			tabs.tabs( "refresh" );                      
            selectedtab(tabCounter);
			tabCounter++;
           

            var showframe ;
            try {
                showframe = document.createElement('<iframe frameborder="0"   width="100%"  style="margin:0 0 0 0;border:solid 1px  #add9c0;"></iframe>');
            } catch (e) {
                showframe = document.createElement("iframe");
            } 
             showframe.id = "f" + id 
             showframe.src = taburl;


             var div_ = document.getElementById(id);
             div_.appendChild(showframe);
             $("#"+ id ).height( $("#wright").height() - 68);
             $("#"+ id).css("margin", "0 0 0 0 ");
             $("#f"+ id ).height( $("#wright").height() - 68);
             $("#f"+ id).css("margin", "0");
         

		}

        $(document).ready(function () {
		    //  $.fn.zTree.init($("#treeDemo"), setting, zNodes);
		    ruler.init("ruler");
		    createTree();
		    changesize(); 
            tabs.delegate( "span.ui-icon-close", "click", function() {
			var panelId = $( this ).closest( "li" ).remove().attr( "aria-controls" );
			$( "#" + panelId ).remove();
			tabs.tabs( "refresh" );
		    });

		    tabs.bind( "keyup", function( event ) {
			    if ( event.altKey && event.keyCode === $.ui.keyCode.BACKSPACE ) {
				    var panelId = tabs.find( ".ui-tabs-active" ).remove().attr( "aria-controls" );
				    $( "#" + panelId ).remove();
				    tabs.tabs( "refresh" );
			    }
		    });       
				
		});
    

</script>
</body>
</html>
