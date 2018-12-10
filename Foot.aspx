<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Foot.aspx.cs" Inherits="Foot" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>页脚</title>
    <script language=javascript src ="js/http.js"></script>
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <style type="text/css">

body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.STYLE1 {
	color: #fff;
	font-size: 16px;
}
.compamy{ font-size:16px; text-align:center; color:#fff; height:24px; line-height:24px;}

</style>
</head>
<script language=javascript>
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

</script>
 
<BODY> 


<form id="form1" runat="server">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td background="images/main_47.gif" style="height: 13px"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="29" height="24">
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="200"><span class="STYLE1">版本:1.0</span></td>
           
            <td width="auto" class="compamy">上海奕茂环境科技有限公司</td>
            <td width="100" nowrap="nowrap" class="STYLE1"><div  style="display:none" align="center"><img src="images/main_51.gif" width="12" height="12" /> 
             <a style="cursor:hand;"  onclick="showmsg()">消息</a>              
            </div></td>
          </tr>
        </table></td>
        <td width="14" ><!--<img src="images/main_49.gif" width="14" height="24" />--></td>
      </tr>
    </table></td>
  </tr>
</table>
</form>
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
        var x_ = screen.availWidth - w_  - 10;
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
        try
        {
        oPopup.show(x_, y_, w_ , h_);
        }
        catch(e)
        {        
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
    setTimeout("showmsg()", 1000);
</script>

</body>

</html>
