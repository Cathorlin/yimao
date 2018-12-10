<%@ Page Language="C#" AutoEventWireup="true" CodeFile="top.aspx.cs" Inherits="top" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <title>top</title>
    <link href="skin/css/base.css" rel="stylesheet" type="text/css">
    <script type="text/javascript" src="<%=http_url %>/js/http.js"></script>
    <script type="text/javascript" src="<%=http_url %>/js/jquery-1.9.1.js"></script>
    <script language="JavaScript">
        function logout() {
            if (confirm("您确定要退出吗？")) {
                var parm = formatparm();
                parm = addParm(parm, "REQID", "LOGINOUT");
                parm = addParm(parm, "DIVID", "LOGINOUT");
                parm = parm + endformatparm();
                url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
                FunGetHttp(url, "div_req", parm);

            }

        }
        var msgoPopup;
        function ShowMsgDiv(msg_) {
            var w = 300;
            var h = 200;
            var strhtml = "<table width=\"280px\"><tr><td width=\"" + String(w - 100) + "px\" height=\"" + String(h - 50) + "px\">" + msg_ + "</td></tr></table>";

            show_html(w, h, strhtml)

        }
        //ShowMsgDiv("wooododddd");
        function show_html(w_, h_, html_) {
            if (msgoPopup != null) {
                msgoPopup.hide();
            }
            else {
                msgoPopup = window.createPopup();
            }
            msgoPopup = window.createPopup();

            var x_ = (screen.availWidth - w_) / 2;
            var y_ = (screen.availHeight - h_) / 2;
            var str = "<DIV style='BORDER-RIGHT: #455690 1px solid; BORDER-TOP: #a6b4cf 1px solid; Z-INDEX: 99999; LEFT: 0px; BORDER-LEFT: #a6b4cf 1px solid; WIDTH: " + w_ + "px; BORDER-BOTTOM: #455690 1px solid; POSITION: absolute; TOP: 0px; HEIGHT: " + h_ + "px; BACKGROUND-COLOR: #c9d3f3'>"
            str += "<TABLE style='BORDER-TOP: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid' cellSpacing=0 cellPadding=0 width='" + String(w_ - 10) + "px' bgColor=#cfdef4 border=0>"
            str += "<TR>"
            str += "<TD style='FONT-SIZE: 12px;COLOR: #0f2c8c' width='" + String(w_ - 45 - 10) + "px' height='24px'></TD>"
            str += "<TD style='PADDING-LEFT: 4px; FONT-WEIGHT: normal; FONT-SIZE: 12px; COLOR: #1f336b; PADDING-TOP: 4px' vAlign=center width='30px'>消息</TD>"
            str += "<TD style='PADDING-RIGHT: 2px; PADDING-TOP: 2px' vAlign=center align=right width=\"15px\">"
            str += "<SPAN title=关闭 style='FONT-WEIGHT: bold; FONT-SIZE: 12px; CURSOR: hand; COLOR: red; MARGIN-RIGHT: 4px' id='btnSysClose'>×</SPAN></TD>"
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
            msgoPopup.document.body.innerHTML = str;
            try {
                msgoPopup.show(x_, y_, w_, h_);
            }
            catch (e) {
            }
            var btClose = msgoPopup.document.getElementById("btnSysClose");
            btClose.onclick = function () {
                msgoPopup.hide();
            }
        }

        //设置当前的登录是否有效
        function checklogin() {
            var parm = formatparm();
            parm = addParm(parm, "REQID", "IFLOGIN");
            parm = addParm(parm, "DIVID", "IFLOGIN");
            parm = parm + endformatparm();
            url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
            FunGetHttp(url, "div_req", parm);

        }


        setTimeout("checklogin()", 1000);
        function showtree() {
            parent.leftFrame.showtree()
        }
        function showmsg() {
            parent.mainFrame.showmsg();

        }
        function showmenu(menu_id) {
            parent.menu.showHide("items" + menu_id);

        }

    </script>
    <script language='javascript'>
        var preFrameW = '190,834';
        var FrameHide = 0;
        var curStyle = 1;
        var totalItem = 9;
        function ChangeMenu(way) {
            if (way != 0)
                return;
            var addwidth = 10;
            var fcol = top.document.all.btFrame.cols;
            if (way == 1) addwidth = 10;
            else if (way == -1) addwidth = -10;
            else if (way == 0) {
                if (FrameHide == 0) {
                    preFrameW = top.document.all.btFrame.cols;
                    top.document.all.btFrame.cols = '0,*';
                    FrameHide = 1;
                    return;
                } else {
                    top.document.all.btFrame.cols = preFrameW;
                    FrameHide = 0;
                    return;
                }
            }
            fcols = fcol.split(',');
            fcols[0] = parseInt(fcols[0]) + addwidth;
            top.document.all.btFrame.cols = fcols[0] + ',*';
        }

        //var wid = screen.width;
        //var cols = "0,*,0";
        //if (wid < 1024) {
        //    var v = (wid - 1024) / 2;
        //    cols = String(v) + ",*," + String(v);
        //}
        //top.document.all.allFrame.cols = cols;

        function mv(selobj, moveout, itemnum) {
            if (itemnum == curStyle) return false;
            if (moveout == 'm') selobj.className = 'itemsel';
            if (moveout == 'o') selobj.className = 'item';
            return true;
        }

        function changeSel(itemnum) {
            curStyle = itemnum;
            for (i = 1; i <= totalItem; i++) {
                if (document.getElementById('item' + i)) document.getElementById('item' + i).className = 'item';
            }
            document.getElementById('item' + itemnum).className = 'itemsel';
        }

    </script>
     <style>
        body {
            padding: 0px;
            margin: 0px;
            height: 51px;
        }

        #tpa {
            color: #009933;
            margin: 0px;
            padding: 0px;
            float: right;
            padding-right: 10px;
        }

            #tpa dd {
                margin: 0px;
                padding: 0px;
                float: left;
                margin-right: 2px;
            }

                #tpa dd.ditem {
                    margin-right: 8px;
                }

                #tpa dd.img {
                    padding-top: 6px;
                }

        div.item {
            text-align: center;
            /*background:url(skin/images/frame/topitembg.gif) 0px 3px no-repeat;*/
            width: 82px;
            height: 26px;
            line-height: 28px;
            margin-bottom: 1px;
        }

        .itemsel {
            margin-bottom: 1px;
            width: 82px;
            text-align: center;
            background: #004F87;
            border-left: 1px solid #f00;
            border-right: 1px solid #f00;
            border-top: 1px solid #f00;
            height: 26px;
            line-height: 28px;
        }

        *html .itemsel {
            height: 26px;
            line-height: 26px;
        }

        a:link, a:visited {
            text-decoration: underline;
        }

        .item a:link, .item a:visited {
            font-size: 12px;
            color: #ffffff;
            text-decoration: none;
            font-weight: bold;
        }

        .itemsel a:hover {
            color: #ffffff;
            font-weight: bold;
            border-bottom: 2px solid #E9FC65;
        }

        .itemsel a:link, .itemsel a:visited {
            font-size: 12px;
            color: #ffffff;
            text-decoration: none;
            font-weight: bold;
        }

        .itemsel a:hover {
            color: #ffffff;
            border-bottom: 2px solid #f00;
        }

        .rmain {
            padding-left: 10px;
        }

        #tpa dd.img, #tpa dd.img a, .logininfo, .logininfo a {
            color: #fff;
        }

        .username {
            padding-right: 20px;
        }

        .exit {
            font-size: 15px;
            border: 1px solid #808080;
            padding: 3px 0;
            display: inline-block;
            min-width: 30px;
            min-height: 10px;
            text-align: center;
            text-decoration: none !important;
            padding: 4px 9px;
            border-radius: 3px;
            -moz-border-radius: 3px;
            box-shadow: inset 0px 0px 2px #fff;
            -o-box-shadow: inset 0px 0px 2px #fff;
            -webkit-box-shadow: inset 0px 0px 2px #fff;
            -moz-box-shadow: inset 0px 0px 2px #fff;
            color: #ffffff !important;
            border: 1px solid #ddd;
            background-image: -moz-linear-gradient(#aed60c, #45922d);
            background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#45922d), to(#aed60c));
            background-image: -webkit-linear-gradient(#aed60c,#45922d);
            background-image: -o-linear-gradient(#aed60c, #45922d);
            text-shadow: 1px 1px 1px #fdbcc7;
            background: -ms-linear-gradient(top,#aed60c,#45922d);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#aed60c,endColorstr=#45922d,GradientType=0);
            background: linear-gradient(top,#aed60c,#45922d);
            background-color: #59b92d;
        }

            .exit:hover {
                border: 1px solid #ddd;
              background-image: -moz-linear-gradient(#45922d, #aed60c);
            background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#aed60c), to(#45922d));
            background-image: -webkit-linear-gradient(#45922d,#aed60c);
            background-image: -o-linear-gradient(#45922d,#aed60c );
            text-shadow: 1px 1px 1px #fdbcc7;
            background: -ms-linear-gradient(top,#45922d,#aed60c);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#45922d,endColorstr=#aed60c,GradientType=0);
            background: linear-gradient(top,#45922d,#aed60c);
            background-color: #59b92d;
            }

            .exit:active {
                border: 1px solid #ab3e4b;
            }
    </style>
</head>
<body bgcolor='#1729e9'>
    <form runat="server">
    <table width="100%" height="80px" border="0" cellpadding="0" cellspacing="0" style="background-color: #009ada">
        <tr>
            <td width='20%' height="80px" valign="middle">
                <img style="padding-left: 20px;position:absolute;top:1px;height:60px" src="skin/images/frame/ymhj_logo.png" />
            </td>
            <td width='80%' align="right" valign="middle">
<div style="float:left;width:70%">
<embed type="application/x-shockwave-flash" src="images/top_banner.swf" height="80" width="100%" wmode="transparent">
</embed></div>
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
       <td valign="middle" style="font-size: 20px; font-weight: 800; color: #fff;letter-spacing:5px;" colspan="2"></td>
                            <td valign="middle" align="right" width="80%" class="logininfo" height="16px" style="padding-right: 10px; line-height: 16px; font-size: 14px;" colspan="2"><span class="username" style="line-height:23px; display:inline-table;position:absolute; top:16px;right:70px;">用户：<%=GlobeAtt.A007_NAME%></span>
                                <%--   	[<a href="" target="_blank">修改密码</a>]--%>
                                <%--<a href="javascript:logout();" class="exit">退出</a>--%>
                                <img style="right:10px;cursor:hand;top:10px;position:absolute;z-index:99999" onclick="javascript:logout();" src="skin/images/frame/exit.png"  alt="exit"/>
                            </td>
                    
                    </tr>
                    <tr>
                        <td>
                            <div id="show_sysmsg">
                            </div>
                        </td>
                        <td align="right" height="20" class="rmain">
                            <dl id="tpa" style="display:none">
                                <dd class='img'>
                                    <a href="javascript:ChangeMenu(-1);">
                                        <img vspace="5" src="skin/images/frame/arrl.gif" border="0" width="5" height="8"
                                            alt="缩小左框架" title="缩小左框架" /></a></dd>
                                <dd class='img'>
                                    <a href="javascript:ChangeMenu(0);">
                                        <img vspace="3" src="skin/images/frame/arrfc.gif" border="0" width="12" height="12"
                                            alt="显示/隐藏左框架" title="显示/隐藏左框架" /></a></dd>
                                <dd class='img' style="margin-right: 10px;">
                                    <a href="javascript:ChangeMenu(1);">
                                        <img vspace="5" src="skin/images/frame/arrr.gif" border="0" width="5" height="8"
                                            alt="增大左框架" title="增大左框架" /></a></dd>
                                <%--<dd><div class='itemsel' id='item1' onMouseMove="mv(this,'move',1);" onMouseOut="mv(this,'o',1);"><a href="javascript:showmenu('0')" onclick="changeSel(1)" >主菜单</a></div></dd>
                                --%>
                                <%for (int i = 0; i < dt.Rows.Count; i++)
                                  {
                                      string num = (i + 2).ToString();
                                      string name = dt.Rows[i]["show_name"].ToString();
                                      string menu_id = dt.Rows[i]["menu_id"].ToString();
                                %>
                                <dd>
                                    <div class='item' id='item<%= num %>' onmousemove="mv(this,'m',<%=num %>);" onmouseout="mv(this,'o',<%=num %>);">
                                        <a href="javascript:showmenu('<%=menu_id %>')" onclick="changeSel(<%=num %>)">
                                            <%=name %></a></div>
                                </dd>
                                <%} %>
                            </dl>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
