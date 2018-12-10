<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MainPage.aspx.cs" Inherits="MainPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <title><%=BaseMsg.getMsg("M0061")%>-<%= GlobeAtt.A007_NAME  + "("+ GlobeAtt.A007_KEY+")" %></title>
    <link href="skin/css/base.css" rel="stylesheet" type="text/css">
    <link href="Css/UserMenu.css" rel="stylesheet" type="text/css">
    <script language=javascript src ="js/http.js"></script>
    <script type="text/javascript" src="js/jquery.min.js?ver=<%=GlobeAtt.GetValue("JSVER") %>"></script>
    <script language=javascript>
        var preFrameW = '190,834';
        var FrameHide = 0;
        var curStyle = 1;
        var totalItem = 9;
        var menuwidth = 0;
        function changeSel(itemnum) {
            curStyle = itemnum;
            for (i = 1; i <= totalItem; i++) {
                if (document.getElementById('item' + i)) document.getElementById('item' + i).className = 'item';
            }
            document.getElementById('item' + itemnum).className = 'itemsel';
        }
        var allheight = 0;
        function config_form() {
            var height = $(window).height()  ;
            allheight = height;
            $("form").height(height);
        }
        function set_mainleft(width_) {
            $("#main .mainleft").width(width_);
            var allwidth = $("#main").width();
            $("#main .mainright").width(allwidth - width_ );
            menuwidth = width_;
            var h = allheight - $("#top").height() - $("#foot").height();

            
            $("#main .mainleft").height(h);
            $("#main .mainright").height(h);
            $("#main #menu").height(h);
            $("#main #menu").width(width_);    
         }
        function changesize() {
            set_mainleft(menuwidth);
        }
        function get_menu() {
            var parm = formatparm();
            parm = addParm(parm, "A00201KEY", "");
            parm = addParm(parm, "REQID", "GET_MENU");
            parm = addParm(parm, "VER", "");
            parm = addParm(parm, "URL", location.href);
            parm = parm + endformatparm();
            url = "BaseForm/UserMenu.aspx?ver=" + getClientDate();
            FunGetHttp(url, "usermenu", parm);
        }
        var showmenuid = "0";

        function showchild(menu_id_, node_) {
            if (node_ == 1) {
                if (showmenuid != "0" && menu_id_ != showmenuid) {
                    document.getElementById("tr_" + showmenuid).style.display = "none";
                }

                showmenuid = menu_id_;
            }
            if (document.getElementById("tr_" + menu_id_).style.display == "") {
                document.getElementById("tr_" + menu_id_).style.display = "none";
            }
            else {
                document.getElementById("tr_" + menu_id_).style.display = "";
            }
             
         }
    </script>
<style>
#main
{
    width:100%;    
}
#main .mainleft
{
   
     height:500px;
      float:left;
}
#main .mainright
{
     background-color:Black;
     height:500px;
     float:right;
}
#foot
{
    width:100%;
    height:30px;    
}

#top .logininfo ,.logininfo a{
    color:#fff;
 }
#top .logininfo
{ 
  padding-right:10px;
  height:20px;
}
.tpa {
	color: #009933;
    text-align:left;
    float:right;
}
.tpa ul
{line-height:20px;
 float:left;
 padding-right:20px;  
}
.tpa ul li
{
   float:left;
   height:20px;
   padding: 0 0 0 2px; 
}
.tpa ul li.item
{
  margin-bottom:1px;
  width:82px;
  text-align:center;
  background:#004F87;
  border-left:1px solid #f00;
  border-right:1px solid #f00;
  border-top:1px solid #f00;
  height:20px;
  line-height:20px;
}
.tpa ul li.item
{
  margin-bottom:1px;
  width:82px;
  text-align:center;
  background:#004F87;
  border-left:1px solid #f00;
  border-right:1px solid #f00;
  border-top:1px solid #f00;
  height:18px;
  line-height:18px;
}
.tpa ul li.itemsel
{
  margin-bottom:1px;
  width:82px;
  text-align:center;
  background:#004F87;
  border-left:1px solid #f00;
  border-right:1px solid #f00;
  border-top:1px solid #f00;
  height:22px;
  line-height:22px;
}


.tpa ul li a:link,a:visited {
 text-decoration: underline;
}

.tpa ul li.item a:link, .item a:visited {
	font-size: 12px;
	color: #ffffff;
	text-decoration: none;
	font-weight: bold;
}

.tpa ul li.itemsel a:hover {
	color: #ffffff;
	font-weight: bold;
	border-bottom:2px solid #E9FC65;
}

.tpa ul li.itemsel a:link, .itemsel a:visited {
	font-size: 12px;
	color: #ffffff;
	text-decoration: none;
	font-weight: bold;
}

.tpa ul li.itemsel a:hover {
	color: #ffffff;
	border-bottom:2px solid #f00;
}  
    
    
    
</style>
</head>
<body style="margin:0;overflow:visible;" onresize="changesize()" scroll="no" > 
<div id="form" style="width:100%; margin:0; text-align:center;overflow-x:visible;overflow-y:visible;"> 
<div id="top"  style='background-color:#1729e9;margin:0;height:45px;background-image:url(skin/images/frame/topbg.gif);'>
<div style="float:left;width:20%;height:44px; " id="topleft">
   <a><img src="skin/images/frame/logo.gif" height="40" width="183" /></a>
</div>
<div style=" float:left;width:80%; text-align:right;" id="topright"  >
<div  class="logininfo">
 您好：<span class="username"><%=GlobeAtt.A007_NAME%>[<%=GlobeAtt.A007_KEY %>]</span>，欢迎使用系统！
        	[<a href="javascript:logout();"  >注销退出</a>]&nbsp;
</div>
<div class="tpa">
<ul>
		<%for (int i = 0; i < dt.Rows.Count; i++)
        {
            string num = (i + 2).ToString();
            string name = dt.Rows[i]["show_name"].ToString();
            string menu_id = dt.Rows[i]["menu_id"].ToString();
            string classname = "item";
            if (i == 0)
            {
                classname = "itemsel";
            }
        %>
         <li id="item<%= num %>" class="<%=classname %>">
          <a   onclick="changeSel(<%=num %>)" ><%=name %></a>
         </li>
         <%} %>

<li>
<a href="javascript:ChangeMenu(-1);">
<img vspace="5" src="skin/images/frame/arrl.gif" border="0" width="5" height="8" alt="缩小左框架"  title="缩小左框架" />
</a>
</li>
<li>
<a href="javascript:ChangeMenu(0);">
<img vspace="3" src="skin/images/frame/arrfc.gif" border="0" width="12" height="12" alt="显示/隐藏左框架" title="显示/隐藏左框架" />
</a>
</li>
<li><a href="javascript:ChangeMenu(1);">
<img vspace="5" src="skin/images/frame/arrr.gif" border="0" width="5" height="8" alt="增大左框架" title="增大左框架" />
</a>
</li>   
</ul>   
</div>
</div>
</div>
<div id="main">
<div class="mainleft" style="overflow:auto;" id="usermenu">
</div>
<div class="mainright">
</div>
</div>
<div id="foot">
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td background="images/main_47.gif" style="height: 13px"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="29" height="24"></td>
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="369"><span class="STYLE1">版本</span></td>
            <td width="814" class="STYLE1">&nbsp;</td>
            <td width="185" nowrap="nowrap" class="STYLE1"><div align="center"><img src="images/main_51.gif" width="12" height="12" /> 
             <a style="cursor:hand;"  onclick="showmsg()">消息</a>              
            </div></td>
          </tr>
        </table></td>
        <td width="14" ><!--<img src="images/main_49.gif" width="14" height="24" />--></td>
      </tr>
    </table></td>
  </tr>
</table>
</div>
</div>  
<script language=javascript>
    config_form();
    set_mainleft(200);
    get_menu();
</script>
<script language=javascript>
    var oPopup;
    function showusermsg(w_, h_, html_, count_) {
        if (count_ == 0) {
            return;
        }
        if (oPopup != null) {
            oPopup.hide();
        }
        else {
            oPopup = window.createPopup();
        }
        oPopup = window.createPopup();
        var x_ = screen.availWidth - w_ - 10;
        var y_ = screen.availHeight - h_ - 40;
        var str = "<DIV style='BORDER-RIGHT: #455690 1px solid; BORDER-TOP: #a6b4cf 1px solid; Z-INDEX: 99999; LEFT: 0px; BORDER-LEFT: #a6b4cf 1px solid; WIDTH: " + w_ + "px; BORDER-BOTTOM: #455690 1px solid; POSITION: absolute; TOP: 0px; HEIGHT: " + h_ + "px; BACKGROUND-COLOR: #c9d3f3'>"
        str += "<TABLE style='BORDER-TOP: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid' cellSpacing=0 cellPadding=0 width='100%' bgColor=#cfdef4 border=0>"
        str += "<TR>"
        str += "<TD style='FONT-SIZE: 12px;COLOR: #0f2c8c' width=30 height=24></TD>"
        str += "<TD style='PADDING-LEFT: 4px; FONT-WEIGHT: normal; FONT-SIZE: 12px; COLOR: #1f336b; PADDING-TOP: 4px' vAlign=center width='100%'>消息</TD>"
        str += "<TD style='PADDING-RIGHT: 2px; PADDING-TOP: 2px' vAlign=center align=right width=19>"
        str += "<SPAN title=关闭 style='FONT-WEIGHT: bold; FONT-SIZE: 12px; CURSOR: hand; COLOR: red; MARGIN-RIGHT: 4px' id='btSysClose'>×</SPAN></TD>"
        str += "</TR>"
        str += "<TR>"
        str += "<TD style='PADDING-RIGHT: 1px;PADDING-BOTTOM: 1px' colSpan=3 height='" + (h_ - 28) + "px'>"
        str += "<DIV style='BORDER-RIGHT: #b9c9ef 1px solid; PADDING-RIGHT: 8px; BORDER-TOP: #728eb8 1px solid; PADDING-LEFT: 8px; FONT-SIZE: 12px; PADDING-BOTTOM: 8px; BORDER-LEFT: #728eb8 1px solid; WIDTH: 100%; COLOR: #1f336b; PADDING-TOP:0px; BORDER-BOTTOM: #b9c9ef 1px solid; HEIGHT: 100%'>"
        str += html_;
        str += "</DIV>"
        str += "</TD>"
        str += "</TR>"
        str += "</TABLE>"
        str += "</DIV>"
        oPopup.document.body.innerHTML = str;
        try {
            oPopup.show(x_, y_, w_, h_);
        }
        catch (e) {
        }
        var btClose = oPopup.document.getElementById("btSysClose");
        btClose.onclick = function () {
            oPopup.hide();
        }
        var btRec = oPopup.document.getElementsByName("btRec");
        for (var i = 0; i < btRec.length; i++) {
            btRec[i].onclick = function () {
                var id = this.id.substr(5);
                var parm = formatparm();
                parm = addParm(parm, "REQID", "RECMSG");
                parm = addParm(parm, "DIVID", "RECMSG");
                parm = addParm(parm, "KEY", id);
                parm = parm + endformatparm();
                url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
                FunGetHttp(url, "div_req", parm);
            }
        }
        var btlink = oPopup.document.getElementsByName("btlink");
        for (var i = 0; i < btlink.length; i++) {
            btlink[i].onclick = function () {
                var id = this.id.substr(6);
                var parm = formatparm();
                parm = addParm(parm, "REQID", "RECMSG");
                parm = addParm(parm, "DIVID", "RECMSG");
                parm = addParm(parm, "KEY", id);
                parm = parm + endformatparm();
                url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
                FunGetHttp(url, "div_req", parm);
                var href_ = this.href;
                showtaburl(this.href, '消息');
                oPopup.hide();

            }
        }


    }
    function hidediv(id) {
        if (oPopup != null) {
            var tdobj = oPopup.document.getElementById("rec" + id);
            if (tdobj != null) {
                tdobj.style.display = "none";
            }
        }
    }
    function  showmsg() {
    var parm = formatparm();
    parm = addParm(parm, "REQID", "SHOWMSG");
    parm = addParm(parm, "DIVID", "SHOWMSG");
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);
    setTimeout("showmsg()", <%=BS_MSG_TIME %>);
    return ;
    }

    function showtaburl(url,menu_id)
    {
        parent.main.showtaburl(url,menu_id);    
    }
    setTimeout("showmsg()", 1000);
</script>

</body>
</html>
