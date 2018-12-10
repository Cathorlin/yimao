<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ModifyForm.aspx.cs" Inherits="Config_ModifyForm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title><%=table_id___ %>列宽调整<%=a00201_key %></title>
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script type="text/javascript" src="../js/BasePage.js"></script>
<style type="text/css">
.TableView{ margin:0 auto;table-layout:fixed; border:#CCC solid 1px; line-height:23px; text-align:center;
  border-collapse:collapse;width:100%;}
.TableView th{ border:#CCC solid 1px;background:url('../images/datagrid_title_bg.png') repeat-x;}
.TableView td{ border:#CCC solid 1px;}
  .TableView td,.TableView th{height:25px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;word-break:keep-all;text-align:center;font-size:12px;}
</style>

<script type="text/javascript">

  (function($) {
  //用正则表达式判断jQuery的版本
  if (/1\.(0|1|2)\.(0|1|2|3|4|5)/.test($.fn.jquery) || /^1.1/.test($.fn.jquery)) {
  alert('movedTh 需要 jQuery v1.2.6 以后版本支持! 你正使用的是 v' + $.fn.jquery);
  return;
  }
  me = null;
  var ps = 3;
  $.fn.movedTh = function() {
  me = $(this).children("table").css("margin-left", "0");
  var target = null;
  var tempStr = "";
  var i = 0;
    
  $(me).find("tr:first").find("th").each(function() {
  tempStr = '<div id="mydiv' + i + '"onmousedown="$().mousedone.movedown(event,this)" style="position:absolute;width:20px;height:25px;z-index:99px;cursor:e-resize;overflow:hidden;" ></div>';
  var div = {};
  $(this).html($(this).html() + tempStr);
  var divOffset = $(this).parent().offset();
  var offset = $(this).offset();
  var pos = offset.left + $(this).width() + 6 - divOffset.left;
  $("#mydiv" + i).css("left", pos - 10).css("top", (offset.top + 2)); ;
  i++;
  }); //end each
  } //end moveTh
  $.fn.mousedone = {
  movedown: function(e, obj) {
  var d = document;
  var e = window.event || e;
  var myX = e.clientX || e.pageX;
  obj.mouseDownX = myX;
  obj.pareneTdW = $(obj).parent().width(); //obj.parentElement.offsetWidth;
  obj.pareneTableW = me.width();
  if (obj.setCapture) {
  obj.setCapture();
  } else if (window.captureEvents) {
  window.captureEvents(Event.MOUSEMOVE | Event.MOUSEUP);
  }
  d.onmousemove = function(e) {
  var dragData = obj;
  var event = window.event || e;
  if (!dragData.mouseDownX) return false;
  var newWidth = dragData.pareneTdW * 1 + (event.clientX || event.pageX) * 1 - dragData.mouseDownX;
  if (newWidth > 0) {
  $(obj).parent().width(newWidth);
  me.width(dragData.pareneTableW * 1 + (event.clientX || event.pageX) * 1 - dragData.mouseDownX);
  var k = 0;
  me.find("tr:first").find("th").each(function() {
  var divOffset = $(this).parent().offset();
  var offset = $(this).offset();
  var pos = offset.left + $(this).width() + 6 - divOffset.left;
  $("#mydiv" + k).css("left", pos - 10);
  k++;
  }) //end each
  } //end if
  };
  d.onmouseup = function(e) {
  var dragData = obj;
  if (dragData.setCapture) {
  dragData.releaseCapture();
  } else if (window.captureEvents) {
  window.releaseEvents(e.MOUSEMOVE | e.MOUSEUP);
  }
  dragData.mouseDownX = 0;
  }
  }
} //end mousedone
  $(window).resize(function() {
  setTimeout(function() {
  var target = null;
  var tempStr = "";
  var i = 0;
  $(me).find("tr:first").find("th").each(function() {
  tempStr = '<div id="mydiv' + i + '"onmousedown="$().mousedone.movedown(event,this)" ></div>';
  var div = {};
  $(this).html($(this).html() + tempStr);
  var divOffset = $(this).parent().offset();
  var offset = $(this).offset();
  var pos = offset.left + $(this).width() - (2 + divOffset.left);
  $("#mydiv" + i).addClass("resizeDivClass");
  $("#mydiv" + i).css("left", pos);
  i++;
  }); //end each
  }, 10);
  });
  })(jQuery)
</script>
    <script type="text/javascript">
function getCols(a, b) {
	b = typeof b === "string" ? document.getElementById(b) : b;
	var c = "";
	c += '<tr><th style="font-size:12px;text-align:center;font-weight:bold;line-height: 23px;';
	c += 'border: 1px solid #77ABF2;height: 25px;white-space: nowrap;background-color:#AEAEAE;">';
	c += b.rows[0].cells[a].innerHTML + "</th></tr>";
	for (var d = 1; d < b.rows.length; d++) c += "<tr><td>" + b.rows[d].cells[a].innerHTML + "</td></tr>";
	return c
}
function getTable(a) {
	for (; a.tagName.toLowerCase() != "table";) a = a.parentElement;
	return a
}
function swapCol(a, b, c) {
	c = typeof c === "string" ? document.getElementById(c) : c;
	for (var d = 0; d < c.rows.length; d++) SwapNode(c.rows[d].cells[a], c.rows[d].cells[b])
}
function createDiv(a, b) {
	var c = document.createElement("div");
	c.className = a;
	c.style.cssText += "border:1px dashed #003F87;background:#FFFFFF;color:#DC8331;overflow:hidden;";
	c.style.cssText += "zIndex:10000;position:absolute;opacity: 0.7;filter:Alpha(opacity=70);font-size:12px;";
	c.style.cssText += "width:" + b.clientWidth + "px;";
	return c
}
function removeDiv(a) {
	$("." + a).remove()
}
function getThEl() {
	var a = getEvent();
	a = document.elementFromPoint(a.clientX, a.clientY);
	if (a.tagName.toLowerCase() == "th") return a
}
function getObjPos(a) {
	var b = y = 0;
	if (a.getBoundingClientRect) {
		a = a.getBoundingClientRect();
		b = a.left + Math.max(document.documentElement.scrollLeft, document.body.scrollLeft) - document.documentElement.clientLeft;
		y = a.top + Math.max(document.documentElement.scrollTop, document.body.scrollTop) - document.documentElement.clientTop
	} else for (; a != document.body;) {
		b += a.offsetLeft;
		y += a.offsetTop;
		a = a.offsetParent
	}
	return {
		x: b,
		y: y
	}
}
function getCurPos() {
	var a = getEvent();
	return a.pageX ? {
		x: a.pageX,
		y: a.pageY
	}: {
		x: a.clientX + document.documentElement.scrollLeft - document.documentElement.clientLeft,
		y: a.clientY + document.documentElement.scrollTop - document.documentElement.clientTop
	}
}
function startSwap() {
	var a = getThEl();
	if (typeof a != "undefined") {
		var b = createDiv("tmpdiv", a);
		document.body.appendChild(b);
		b.style.width = a.clientWidth;
		b.style.height = getTable(a).clientHeight;
		b.innerHTML = '<table class="Shadow">' + getCols(a.cellIndex, getTable(a)) + "</table>";
		b.style.left = getObjPos(a).x + "px";
		b.style.top = getObjPos(a).y + "px";
		b.style.display = "block";
		var c = true,
		d = getCurPos().x,
		f = getCurPos().y,
		g = getObjPos(b).x,
		h = getObjPos(b).y;
		b.onmousemove = function() {
			if (c) {
				b.style.cssText += "cursor:move;";
				b.style.left =
				getCurPos().x - d + g + "px";
				b.style.top = getCurPos().y - f + h + "px"
			}
		};
		b.onmouseup = function() {
			c = false;
			b.style.display = "none";
			var e = getThEl();
			if (typeof e !== "undefined") {
				swapCol(a.cellIndex, e.cellIndex, getTable(e));
				removeDiv("tmpdiv")
			}
		};
		b.onmouseout = function() {
			c = false;
			b.style.display = "none"
		}
	}
}
function addEvent(a, b, c, d) {
	a.addEventListener ? a.addEventListener(b, c, d) : a.attachEvent("on" + b, c)
}
function removeEvent(a, b, c, d) {
	a.removeEventListener ? a.removeEventListener(b, c, d) : a.detachEvent("on" + b, c)
}
function SwapNode(a, b) {
	if (a != b) {
		var c = a.cloneNode(1),
		d = a.parentNode;
		b = d.replaceChild(c, b);
		d.replaceChild(b, a);
		d.replaceChild(a, c)
	}
}
function getEvent() {
	if (document.all) return window.event;
	for (func = getEvent.caller; func != null;) {
		var a = func.arguments[0];
		if (a) if (a.constructor == Event || a.constructor == MouseEvent || typeof a == "object" && a.preventDefault && a.stopPropagation) return a;
		func = func.caller
	}
	return null
};
 
 
    </script>

<script type="text/javascript">
  $().ready(function() {
  $("#div1").movedTh();
  });
function changecolumnx(table_id,column_id_,type_)
{
    var  str_v ="pkg_a.save_a10001('<%=a00201_key %>','"+widthall+"','"+ xall +"')";
 

}  
function Button1_onclick() {
   var tr =  $("th");
   var str_v ="";
  // alert(tr.length);
  //  str_v +=   sql__ + "<EXECSQL></EXECSQL>"   ;
  var widthall ="";
  var xall="";
   for(var i=0;i < tr.length;i++ )
   {

        var wid = $("#" + tr[i].id).width();
        var x=  $("#" + tr[i].id).offset().left;
        var column_id =  tr[i].id.replace("th_","");
        widthall = widthall + column_id + "=" + wid +"|";
        xall = xall + column_id + "=" + x +"|";

   }
      str_v ="pkg_a.save_a10001('<%=a00201_key %>','"+widthall+"','"+ xall +"','[USER_ID]')";
   
   var res = BasePage.doXml(str_v,"ModifyForm").value ;
    if (res.indexOf(getMsg("M0008"))  >= 0)
    {
        alert(getMsg("M0007"));
        location.reload();      
    }     
    else
    {
        alert(res);
        return ;
    }
   return;

}

</script>
 <style type="text/css">
        body {
            overflow: auto;
        }
        .Shadow {
            color: #FC8331;
            width: 100%;
            padding: 3px;
            font-family: Arial, "瀹嬩綋";
            font-size: 12px;
            font-weight: normal;
            line-height: 22px;
            border-collapse: collapse;
            border-right: 1px solid #0000;
            border-top: 1px solid #0000;
            border-left: 1px solid #0000;
            border-bottom: 1px solid #0000;
        }
        .Grid {
            background-color: #ffffff;
            padding: 3px;
            font-family: Arial, "瀹嬩綋";
            font-size: 12px;
            font-weight: normal;
            line-height: 22px;
            color: #494949;
            text-decoration: none;
            border-collapse: collapse;
            border-right: 1px solid #2A8CBF;
            border-top: 1px solid #2A8CBF;
            border-left: 1px solid #2A8CBF;
            border-bottom: 1px solid #2A8CBF;
        }
        .GridHeader {
            font-family: Arial, "瀹嬩綋";
            font-size: 12px;
            font-weight: bold;
            line-height: 23px;
            border: 1px solid #77ABF2;
            height: 25px;
            text-decoration: none;
            text-align: center;
            white-space: nowrap;
            color: #000000;
        }
    </style>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <input id="Button1" type="button" value="保存宽度" language="javascript" onclick="return Button1_onclick()" />
<div id="div1">
  <table class="TableView"  >
  <thead class="GridHeader">
  <tr>
  <%
      for (int i = 0; i < dt_a10001.Rows.Count; i++)
      {
        string col_text = dt_a10001.Rows[i]["COL_TEXT"].ToString();
        string bs_width = dt_a10001.Rows[i]["bs_width"].ToString();    
        string column_id = dt_a10001.Rows[i]["column_id"].ToString();
    
        if (bs_width =="" || bs_width == null)
        {
            bs_width = "80"; 
        }
        string col_visible = dt_a10001.Rows[i]["COL_VISIBLE"].ToString();
        if (col_visible != "1")
        {
            continue;
        }
  %>     <th  width="<%=bs_width %>px" id="th_<%= column_id%>"><span><%=col_text %></span></th>
  <%   }
   %>
  </tr>
  </thead>
  <tbody>

    <tr style="display:none;">
    <%
        string old_column_id = "";
        string next_column_id = "";
        for (int i = 0; i < dt_a10001.Rows.Count; i++)
        {
            string col_text = dt_a10001.Rows[i]["COL_TEXT"].ToString();
            string bs_width = dt_a10001.Rows[i]["bs_width"].ToString();
            string column_id = dt_a10001.Rows[i]["column_id"].ToString();
            string table_id = dt_a10001.Rows[i]["table_id"].ToString();
            if (bs_width == "" || bs_width == null)
            {
                bs_width = "80";
            }
            string col_visible = dt_a10001.Rows[i]["COL_VISIBLE"].ToString();
            if (col_visible != "1")
            {
                continue;
            }
           
     %>      
        <td> 
        <% if ( i > 0){
                //列右移动
         %>            
          <a href="#" onclick="changecolumnx('<%=table_id %>','<%=column_id %>','-1')" ><<</a> 
          <%} %>
          <% if (i < dt_a10001.Rows.Count - 1)
             { %>  
          <a href="#" onclick="changecolumnx('<%=table_id %>','<%=column_id %>','1')" > >></a>
          <%} %>
        </td>
      <% 
        
          old_column_id = column_id;
        }
    %> 
    </tr>
 
  
  
  <%
      for (int r = 0; r < dt_data.Rows.Count; r++)
      {
      %>
       <tr>
       <%   for (int i = 0; i < dt_a10001.Rows.Count; i++)
          {
              string column_id = dt_a10001.Rows[i]["column_id"].ToString();
              string col_data = dt_data.Rows[r][column_id].ToString();
              string col_visible = dt_a10001.Rows[i]["COL_VISIBLE"].ToString();
              if (col_visible != "1")
              {
                  continue;
              }
       %>       
         <td ><%=col_data %></td>
        <%  }
      
       %>
        </tr>
       <%
      }
  
   %>
  </tbody>
  </table>
    </div>
     </div>
      <script type="text/javascript">
        (function() {
			var a = document.getElementsByTagName("th");
			for (var b = 0; b < a.length; b++) {
				addEvent(a[b], "mousedown", startSwap)
			}
		})();
    </script>

    </form>
</body>
</html>
