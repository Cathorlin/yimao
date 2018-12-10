<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="EXAM_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <meta name="classification" content="" /><meta name="author" content="" />
    <meta name="copyright" content="" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="Content-Language" content="zh-CN" />
    <meta http-equiv="pragma" content="no-cache" />
    <meta name="keywords" content="" />
    <meta name="description" content=" " />
    <script src ="<%=http_url %>/js/http.js?ver=" language="javascript" type="text/javascript"></script>
    <script src ="<%=http_url %>/js/jquery-1.4.1.min.js" language="javascript" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css"  href="<%=http_url %>/EXAM/Css/basetest.css" />
    <link rel="stylesheet" type="text/css" href="<%=http_url %>/EXAM/Css/testing.css" />
    <link href="<%=http_url %>/EXAM/Css/ymPrompt.css" rel="stylesheet" type="text/css" />
    <link href="<%=http_url %>/EXAM/Css/test.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">

    <div id="body">
    <div id="head"></div>
    <div id="main"></div>
    <div id="foot"></div>
    </div>

    </form>
    <script language=javascript>
        data_index = "<%=GlobeAtt.DATA_INDEX %>";
        function login(user_id, pass) {
            var parm = formatparm();
            parm = addParm(parm, "KEY",""); //题目
            parm = addParm(parm, "VER", "");
            parm = addParm(parm, "CODE", ""); //考试            
            parm = addParm(parm, "URL", location.href);
            parm = addParm(parm, "REQID", "CHECKLOGIN");
            parm = addParm(parm, "USERID",user_id); //值
            parm = addParm(parm, "PASS", pass); //值
            parm = parm + endformatparm();
            url = http_url + "/BaseForm/head.aspx?KEY=" + user_id + "&ver=" + getClientDate();
            FunGetHttp("Mydo.aspx?ver=" + getClientDate(), "div_req", parm);    
            
        }
        login("500001", "1");
        FunGetHttp("head.aspx?ver=" + getClientDate(), "head", "");
        FunGetHttp("main.aspx?ver=" +  getClientDate(), "main", "");
        FunGetHttp("foot.aspx", "foot", "");
        
        function dtControl(id, type) {
            return;
        }
        function selectitemv(liobj) {
            var vlist = liobj.id.split("_");
            var cobj = document.getElementsByName("lia_" + vlist[1]);
            for (var c = 0; c < cobj.length; c++) {
                var vvlist = cobj[c].id.split("_");
                if (vvlist[2] == vlist[2]) {
                    cobj[c].style.color = "red";
                }
                else {
                    cobj[c].style.color = "black";
                }
            }
            var parm = formatparm();
            var Q103ID = document.getElementById("v_Q103ID").value;
            parm = addParm(parm, "KEY", vlist[1]); //题目
            parm = addParm(parm, "VER", "");
            parm = addParm(parm, "Q103ID", Q103ID); //考试            
            parm = addParm(parm, "URL", location.href);
            parm = addParm(parm, "REQID", "DOLINE");
            parm = addParm(parm, "MAINKEY", vlist[2]); //值
            parm = parm + endformatparm();
            url = http_url + "/BaseForm/head.aspx?KEY=" + vlist[1] + "&ver=" + getClientDate();
            FunGetHttp("Mydo.aspx?ver=" + getClientDate(), "div_req", parm);
            document.getElementById("li_xt_" + vlist[1]).className = "mark_ans_do_1";
            
                      
        }
        function ctrolScroll_new(id) {
            var vlist = id.split("_");
            var vp = getElementPos("xt_" + vlist[2])
            var targetOffset = vp.y - 65;
            $('html,body').animate({
                scrollTop: targetOffset
            }, 1000);
        }
        function settotalItemsView1() {
            var tcount = $("#tcount").val();
            var ucount = $("#ucount").val(); //已回答

            var str = "已做 <span class=\"green\">" + ucount + "</span> 题 / 共 <span class=\"green\">" + tcount + "</span> 题    &nbsp;&nbsp;剩余 <span class=\"green\">" + String(tcount - ucount) + "</span> 题未作答";

           $("#totalItemsView1").html(str);
         }
        function ExamSubmit() {
            settotalItemsView1();
        }
        function TimeStop() {

        }
        function getElementPos(elementId) {

            var ua = navigator.userAgent.toLowerCase();

            var isOpera = (ua.indexOf('opera') != -1);

            var isIE = (ua.indexOf('msie') != -1 && !isOpera); // not opera spoof    

            var el = document.getElementById(elementId);

            if (el.parentNode === null || el.style.display == 'none') {

                return false;

            }

            var parent = null;

            var pos = [];

            var box;

            if (el.getBoundingClientRect) //IE    
            {

                box = el.getBoundingClientRect();

                var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);

                var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);

                return {

                    x: box.left + scrollLeft,

                    y: box.top + scrollTop

                };

            }

            else

                if (document.getBoxObjectFor) // gecko        
                {

                    box = document.getBoxObjectFor(el);

                    var borderLeft = (el.style.borderLeftWidth) ? parseInt(el.style.borderLeftWidth) : 0;

                    var borderTop = (el.style.borderTopWidth) ? parseInt(el.style.borderTopWidth) : 0;

                    pos = [box.x - borderLeft, box.y - borderTop];

                }

                else // safari & opera        
                {

                    pos = [el.offsetLeft, el.offsetTop];

                    parent = el.offsetParent;

                    if (parent != el) {

                        while (parent) {

                            pos[0] += parent.offsetLeft;

                            pos[1] += parent.offsetTop;

                            parent = parent.offsetParent;

                        }

                    }

                    if (ua.indexOf('opera') != -1 || (ua.indexOf('safari') != -1 && el.style.position == 'absolute')) {

                        pos[0] -= document.body.offsetLeft;

                        pos[1] -= document.body.offsetTop;

                    }

                }

            if (el.parentNode) {

                parent = el.parentNode;

            }

            else {

                parent = null;

            }

            while (parent && parent.tagName != 'BODY' && parent.tagName != 'HTML') { // account for any scrolled 



                ancestors

                pos[0] -= parent.scrollLeft;

                pos[1] -= parent.scrollTop;

                if (parent.parentNode) {

                    parent = parent.parentNode;

                }

                else {

                    parent = null;

                }

            }

            return {

                x: pos[0],

                y: pos[1]

            };

        } 
    </script>
</body>

</html>
