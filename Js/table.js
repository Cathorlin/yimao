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