var ifreqdo = true;
var show_sysrb = "1";

var getHost = function (url) {
    var host = "null";
    if (typeof url == "undefined" || null == url) {
        url = window.location.href;
    }
    var regex = /.*\:\/\/([^\/]*).*/;
    var match = url.match(regex);
    if (typeof match != "undefined" && null != match) {
        host = match[1];
    }
    if (url.indexOf("https:") == 0) {
        return "https://" + host;
    }
    else {
        return "http://" + host;
    }
};
var http_url = getHost();

var onclickevent;

var xmlreq = 0;
var xmlreqend = 0;
var reqcount = 0;
var ifdiv_req = "0";
var allrepcount = 0;
function setReadyState2(ObjectID) {
    doreq = doreq + 1;

    var ID = document.getElementById(ObjectID);
    if (ID != null) {
        ID.innerHTML = "<img src='" + http_url + "/images/loading.gif'>... Submitting";
    }
    if (ObjectID == "div_req") {
        ifdiv_req = "1"
    }

}
function setReadyState3(ObjectID) {
    var ID = document.getElementById(ObjectID);
    if (ID != null) {
        ID.innerHTML = "<img src='" + http_url + "/images/loading.gif'>... Transmission";
    }
}
function setReadyStateOther(ObjectID) {
    var ID = document.getElementById(ObjectID);
    if (ID != null) {
        ID.innerHTML = "<img src='" + http_url + "/images/loading.gif'>Loading data, please wait...";
    }
}
function showlogin() {

    alert("请重新登录！");
    window.close();

}
///xml请求完成
var dateObj = new Date();
function setReadyState4(ObjectID, if_error, resptxt) {
    enddoreq = enddoreq + 1;
    allrepcount = allrepcount - 1;
    ifreqdo = false;
    remove_loading();
    if (if_error == true) {
        var ID = document.getElementById(ObjectID);
        if (ID != null) {
            ID.innerHTML = "获取内容错误，请检查输入是否正确";
        }
        else {
            alert("获取内容错误，请检查输入是否正确");
        }
        return;
    }
    if (resptxt.indexOf("showlogin()") == 0) {
        showlogin();
        return;
    }
    ///发送请求
    if (ObjectID == "div_req") {
        if (location.href.toLowerCase().indexOf("mainform.aspx") > 0) {
            setbtnenable('btn_save');
        }
        if (resptxt != "") {
            rbclose();
            //            try {
            //                resptxt = decodeURIComponent(resptxt);
            //            }
            //            catch (e) {
            //                resptxt = resptxt;
            //            }
            if (window.execScript) {
                window.execScript(resptxt, "JavaScript");
            } else {
                window.eval(resptxt);
            }
            remove_loading();

        }
        ifdiv_req = "0"
        return;
    }
    ///发送右键
    if (ObjectID == "rbdiv") { //生成的是右键的html
        // var ID = document.getElementById(ObjectID);
        //ID.innerHTML = resp;
        alertWin("", resptxt, String(eventrbx) + "px", String(eventrby) + "px", "200px", "auto", false);
        return;
    }
    ///发送明细编辑
    if (ObjectID == "alertdiv") { //生成的是右键的html
        // var ID = document.getElementById(ObjectID);
        //ID.innerHTML = resp;
        if (location.href.toLowerCase().indexOf("mainform.aspx") > 0) {
            var mainh = String($("#mainhead").width() * 0.8) + "px";
            alertWin("查看", resptxt, "100px", "100px", mainh, "auto", false);
        }
        else {
            alertWin("查看", resptxt, "100px", "100px", "80%", "auto", false);
        }
        return;
    }
    //获取高级查询
    if (ObjectID == "querydiv") { //生成的是右键的html
        // var ID = document.getElementById(ObjectID);
        //ID.innerHTML = resp;
        alertWin("请输入查询条件", resptxt, "0", "30", "650", "400", true);
        return;
    }

    if (ObjectID == "query_req") { //生成的是右键的html
        // var ID = document.getElementById(ObjectID);
        //ID.innerHTML = resp;
        if (resptxt != "") {
            if (window.execScript) {
                window.execScript(resptxt, "JavaScript");
            } else {
                window.eval(resptxt);
            }


        }
        return;

    }


    var ID = document.getElementById(ObjectID);
    if (ID != null) {

        ID.innerHTML = resptxt;
        // var dateObj1 = new Date();

    }
    if (ObjectID.indexOf("show_") == 0) {
        setTimeout("nextdo_attr('" + ObjectID + "')", 1);

    }
    if (ObjectID == "mainhead") {
        if (doreq == enddoreq) {
            showmaintab("", "");
            formatwidth(a002_key + "-0");
        }
        autoBeginSave();

    }
    if (ObjectID == "td_main_button") {
        setbtndisable('btn_save');
        autoBeginSave();
        get_mainquery();
    }
}
function nextdo_attr(ObjectID) {
    objhide("R" + ObjectID.substr(5) + "_[ROW]");
    if (doreq == enddoreq) {
        showmaintab(ObjectID.substr(5), "");
    }
    var v_ = getCfgValue("STYLE_1");
    $("[href]").css("color", v_);
    v_ = getCfgValue("STYLE_2");
    $("table.ShowTable tr.r0 td").css("color", v_);
    $("table.ShowTable tr.r1 td").css("color", v_);

}

var base_width = 1024;
var wid_pec = parseFloat(screen.width) / 1024;
function formatwidth(a00201_key_) {
    var v_ = getCfgValue("STYLE_3");
    var v1_ = getCfgValue("STYLE_4");

    var objs = document.getElementsByTagName("input");
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].id.indexOf("TXT_" + a00201_key_) == 0 && (objs[i].type == "text" || objs[i].type == "textarea")) {
            width_ = objs[i].style.width;
            if (objs[i].disabled == true || objs[i].getAttribute("readonly") == "readonly") {
                objs[i].style.color = v_;
            }
            else {
                objs[i].style.color = v1_;
            }
            objs[i].style.width = String(Math.round(parseFloat(width_) * wid_pec, 0)) + "px";
        }
    }
    objs = document.getElementsByTagName("select");
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].id.indexOf("DDD_" + a00201_key_) == 0) {
            width_ = objs[i].style.width;
            objs[i].style.width = String(Math.round(parseFloat(width_) * wid_pec, 0)) + "px";
        }

    }
    objs = document.getElementsByTagName("textarea");
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].id.indexOf("TXT_" + a00201_key_) == 0) {
            width_ = objs[i].style.width;
            if (objs[i].disabled == true) {
                objs[i].style.color = v_;

            }
            else {
                objs[i].style.color = v1_;
            }
            objs[i].style.width = String(Math.round(parseFloat(width_) * wid_pec * 0.8, 0)) + "px";
        }
    }
}

function loadLogin(divid) {
    var url = http_url + "/BaseForm/loginform.aspx?ver" + getClientDate();
    FunGetHttp(url, divid, "");

}
function objhide(id) {
    var obj = document.getElementById(id);
    if (obj != null) {
        obj.style.height = "1px";
    }
}
function loadquery(a00201_key__, query_id, divid) {
    //判断当前的页面是那个界面
    rbclose();
    if (divid == "td_main_button") {
        loaddetail(a002_key, a00201_key__, main_key, option, "1", "1", query_id);
    }
    if (divid == "show_" + a00201_key__) {
        //表示是查询明细
        loaddetail(a002_key, a00201_key__, main_key, option, "1", "1", query_id);

    }
    //alert(query_id + divid);
}
function FunGetHttp(url, ObjectID, parm) {
    if (ObjectID == "div_req" && ifdiv_req == "1") {
        return;
    }
    var xmlHttp;
    ifreqdo = true;
    if (window.ActiveXObject) //IE
    {
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");

    }
    else if (window.XMLHttpRequest) {
        xmlHttp = new XMLHttpRequest();
    }
    //  dateObj = new Date();    


    reqcount = reqcount + 1;
    ///////////////////////////////////////////////////////////////////////
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 2) {
            setReadyState2(ObjectID);
        }
        else if (xmlHttp.readyState == 3) {
            setReadyState3(ObjectID);
        }
        else if (xmlHttp.readyState == 4) {
            if (xmlHttp.status == 200) {
                var resp = trim(xmlHttp.responseText);
                setReadyState4(ObjectID, false, resp);
            }
            else {
                setReadyState4(ObjectID, true, "");
            }
        }
        else {
            setReadyStateOther(ObjectID);
        }
    }
    /////////////////////////////////////////////////////////////////////////
    show_loading();
    allrepcount = allrepcount + 1;
    if (parm == "" || parm == null) {
        xmlHttp.open("GET", url, true);
        xmlHttp.send(null);
    } else {
        xmlHttp.open("POST", url, true);
        xmlHttp.send(parm);
    }
}

function scroll_x(obj_s) {
    var objx = document.getElementById(obj_s.id + "_x");
    if (objx != null) {
        objx.scrollLeft = obj_s.scrollLeft;

    }
    if (obj_s.id.indexOf("scroll0_") == 0) {
        var id = obj_s.id.replace("scroll0_", "scroll_");
    }
    else {
        var id = obj_s.id.replace("scroll_", "scroll0_");
    }
    var objy = document.getElementById(id);
    if (objy != null) {
        objy.scrollTop = obj_s.scrollTop;
    }


    //if (obj_s.id.indexOf("scroll_") == 0) {
    //     rbclose();
    //  }

}
/*创建一个右键的DIV*/
var eventrbx = 0;
var eventrby = 0;
var showsysrb = true;
function creatrbdiv(a00201_key_, objid_, rowidlist, option_) {
    showsysrb = false;
    try {
        if (onclickevent == undefined || onclickevent == null) {
            eventrbx = this.event.clientX;
            eventrby = this.event.clientY;
        }
        else {
            eventrbx = onclickevent.clientX;
            eventrby = onclickevent.clientY;
        }

    }
    catch (e) {

    }
    if (objid_ == "") {
        var obj = document.getElementById("objid_" + a00201_key_ + "_0");
        var v = "";
        if (obj != null) {
            v = obj.value;
        }
        showrbbutton(a00201_key_, v, "rbdiv", rowidlist, option_);
    }
    else {
        showrbbutton(a00201_key_, objid_, "rbdiv", rowidlist, option_);
    }
}
//弹出对话框
function alertshow(url, id, parm) {
    FunGetHttp(url, id, parm);
}

document.oncontextmenu = function (e) {
    if (showsysrb == true) {
        rbclose();
    }
    if (show_sysrb == "0") {
        showsysrb = false;
    }
    return showsysrb;
}



//获取打印列表
function loadPrintList(a00201_key__, key) {
    //打印列表

}


//获取右键
function showrbbutton(a00201_key__, key, divid, rowidlist, option_) {
    var url = http_url + "/BaseForm/MainRbutton.aspx?A00201KEY=" + a00201_key__ + "&KEY=" + key + "&ver=" + getClientDate();
    var parm = formatparm();
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "KEY", key);
    parm = addParm(parm, "OPTION", option_);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "ROWID", rowidlist);
    parm = addParm(parm, "ROWIDLIST", selectedrowidlist);
    parm = addParm(parm, "URL", location.href);
    var newbtn = "0";
    var obj_ = document.getElementById("btn_new_" + a002_key + "-0");
    if (obj_ != null) {
        if (obj_.disabled == false) {
            newbtn = "1";
        }
    }
    parm = addParm(parm, "NEWBTN", newbtn);
    //获取当前选中的标签  copya00201key
    if (copya00201key.indexOf(old_showtab + ",") >= 0) {
        parm = addParm(parm, "COPYA00201KEY", old_showtab);
    }
    else {
        parm = addParm(parm, "COPYA00201KEY", "");
    }

    parm = parm + endformatparm();
    FunGetHttp(url, divid, parm);
    xmlreq = xmlreq + 1;
}
//获取明细
function loaddetail(a002id, a00201_key__, key, option, ver, pagenum, queryid) {
    url = http_url + "/BaseForm/Detail.aspx?A00201KEY=" + a00201_key__ + "&KEY=" + key + "&option=" + option + "&A002ID=" + a002id + "&ver=" + getClientDate();
    var parm = formatparm();
    parm = addParm(parm, "A002ID", a002id);
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "KEY", key);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", ver);
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "PageNum", pagenum);
    parm = addParm(parm, "DIVID", "show_" + a00201_key__);
    parm = addParm(parm, "QUERYID", queryid);
    parm = parm + endformatparm();
    if ((option != "Q" && a00201_key__ == a002_key + "-0") || option == "T") {
        //    FunGetHttp(url, "showquery_" + a00201_key__, parm);

        FunGetHttp(url, "div_req", parm);
    }
    else {
        FunGetHttp(url, "show_" + a00201_key__, parm);
    }
    xmlreq = xmlreq + 1;
}

//获取主档右键
function loadmainbutton(a002id, a00201_key__, key, option, ver) {
    url = http_url + "/BaseForm/MainButton.aspx?A00201KEY=" + a00201_key__ + "&KEY=" + key + "&option=" + option + "&A002ID=" + a002id + "&ver=" + getClientDate();
    var parm = formatparm();
    parm = addParm(parm, "A002ID", a002id);
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "KEY", key);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", ver);
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "DIVID", "td_main_button");
    parm = addParm(parm, "HAVETREE", havetree);
    parm = parm + endformatparm();
    FunGetHttp(url, "td_main_button", parm);
    xmlreq = xmlreq + 1;
}
//获取主档
function loadmain(a002id, a00201_key__, key, option, ver) {
    url = http_url + "/BaseForm/Head.aspx?A00201KEY=" + a00201_key__ + "&KEY=" + key + "&option=" + option + "&A002ID=" + a002id + "&ver=" + getClientDate();
    var parm = formatparm();
    parm = addParm(parm, "A002ID", a002id);
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "KEY", key);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", ver);
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "DIVID", "mainhead");
    parm = parm + endformatparm();
    FunGetHttp(url, "mainhead", parm);
    xmlreq = xmlreq + 1;
}
//获取form
function loadform(a00201_key__, rowid, option) {
    url = http_url + "/BaseForm/Head.aspx?A00201KEY=" + a00201_key__ + "&ver=" + getClientDate();
    var parm = formatparm();
    parm = addParm(parm, "ROWID", rowid);
    var rowdata = getRowdata(rowid, "");
    parm = addParm(parm, "KEY", rowdata);
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", 1);
    parm = addParm(parm, "URL", location.href);
    parm = parm + endformatparm();
    FunGetHttp(url, "mainhead", parm);
    xmlreq = xmlreq + 1;
}
function formatparm() {
    return "<?xml version=\"1.0\" encoding=\"utf-8\" ?><DATA>";
}
function endformatparm() {
    return "</DATA>";
}
document.write("<div id=\"div_req\" style=\"display:none;\"></div>");
//发送请求
var reqstate = new Array();
function settrdisable(a014_id_) {
    var obj = document.getElementById("tr" + a014_id_);
    if (obj != null) {
        obj.className = "disable";
    }
}

function checktr(a014_id_) {
    var obj = document.getElementById("tr" + a014_id_);
    if (obj != null) {
        if (obj.className == "disable") {
            return false;
        }
        else {
            return true;
        }
    }
    return false;
}
var confirm_m = false;
function showReq(a00201_key__, reqid, rowlist, show_use) {
    xmlreq = xmlreq + 1;
    var rowid = new Array();
    var parm = formatparm();
    var rowdata = "";

    if (reqid.indexOf("A014") == 0) {


        var a014_id = reqid.substr(4);
        if (checktr(a014_id) == false) {
            return;
        }
        if (show_use != undefined && show_use != "1" && show_use.length > 1) {

            if (show_use.indexOf("MSG") == 0) {
                rbclose();
                alert(show_use.substr(3));
                return;
            }
            if (confirm(show_use) == false) {
                rbclose();
                return;
            }
        }
        //按钮不可用
        settrdisable(a014_id);
    }


    if (reqid == "CopyBill") {
        //alert(rowlist);
        var keylist = rowlist.split(",");
        var if_b = false;
        var j = 0;
        for (var i = 0; i < keylist.length; i++) {
            if (keylist[i] != "") {
                var beginrow = parseInt(document.getElementById("beginrow_" + keylist[i]).value);
                for (var r = beginrow + 1; r < 10000; r++) {
                    var trrow = document.getElementById("objid_" + keylist[i] + "_" + String(r));
                    if (trrow != null) {
                        if_b = true;
                        rowid[j] = keylist[i] + "_" + String(r);
                        j = j + 1;
                    }
                    else {
                        if (if_b == true) {
                            break;
                        }
                    }
                }
            }
        }
    }
    else {
        rowid = rowlist.split(",");
    }


    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", reqid);
    parm = addParm(parm, "MAINKEY", main_key);
    var srow = "";
    try {
        srow = selectedrowlist
    }
    catch (e) {
        srow = "";
    }
    parm = addParm(parm, "SELECTEDROWLIST", srow);
    parm = parm + "<ROWDATA>";
    for (var i = 0; i < rowid.length; i++) {
        if (rowid[i] != "") {
            rowdata = getRowdata(rowid[i], "");
            parm = parm + "<ROW>";
            parm = addParm(parm, "ROWID", rowid[i]);
            parm = addParm(parm, "KEY", rowdata);
            parm = parm + "</ROW>";
        }
    }
    parm = parm + "</ROWDATA>";

    parm = parm + endformatparm();
    url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key__ + "&ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

}
function getRowdata(rowid, collist) {
    var objs = document.getElementsByName(rowid);
    var rowlist = "";
    var objid = document.getElementById("objid_" + rowid);
    if (objid == null) {
        rowlist = "OBJID|" + data_index;
    }
    else {
        rowlist = "OBJID|" + objid.value + data_index;
    }
    var objversion = document.getElementById("objversion_" + rowid);
    if (objversion == null) {
        rowlist = rowlist + "OBJVERSION|" + data_index;
    }
    else {
        rowlist = rowlist + "OBJVERSION|" + objversion.value + data_index;
    }

    var rowid_ = "TXT_" + rowid;
    var bslist_ = ',' + document.getElementById("bslist_" + rowid.split("_")[0]).value;
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].id.indexOf(rowid_) == 0) {
            var line_no = objs[i].id.substr(rowid_.length + 1);
            if (bslist_.indexOf(',' + line_no + ',') >= 0) {
                if (collist.length > 1) {
                    if (collist.indexOf("[" + line_no + "]") >= 0) {
                        rowlist += line_no + "|" + objs[i].value + data_index;
                    }
                }
                else {
                    rowlist += line_no + "|" + objs[i].value + data_index;
                }
            }
        }
    }
    return rowlist;
}
function trim(str) {
    return str.replace('/(^\s*)(\s*$)/g', '');
}

function addParm(parm__, id, value) {

    var parm_ = parm__ + "<" + id + ">" + value + "</" + id + ">";
    return parm_;
}

function getClientDate() {
    var a = new Date();
    var y = a.getYear().toString();
    var m = a.getMonth().toString();
    var d = a.getDay().toString();
    var h = a.getHours().toString();
    var x = a.getMinutes().toString();
    var s = a.getSeconds().toString();
    var ms = a.getMilliseconds().toString();
    var code = y + m + d + h + x + s + ms;
    return code;
}

var bgObj;
var msgObj;
var msgObjold;
var bgObjold
function HTMLEncode(html) {
    var temp = document.createElement("div");
    (temp.textContent != null) ? (temp.textContent = html) : (temp.innerText = html);
    var output = temp.innerHTML;
    temp = null;
    return output;
}




function alertWin(title, msg, px, py, pw, ph, ifcenter) {
    if (bgObj != null) {
        msgObjold = msgObj;
        bgObjold = bgObj;
        bgObj = null;
        msgObj = null;
    }
    try {
        msg = decodeURIComponent(msg);
    }
    catch (e) {
        msg = msg;
    }
    var titleheight = "8px"; // 提示窗口标题高度
    if (title != "") {
        titleheight = "0px";
    }
    var bordercolor = "#666699"; // 提示窗口的边框颜色 
    var titlecolor = "#FFFFFF"; // 提示窗口的标题颜色 
    var titlebgcolor = "#666699"; // 提示窗口的标题背景色
    var bgcolor = "#FFFFFF"; // 提示内容的背景色
    var iWidth = document.documentElement.clientWidth;
    var iHeight = document.documentElement.clientHeight;
    iHeight = Math.max(document.body.clientHeight, iHeight);
    iWidth = Math.max(document.body.clientWidth, iWidth);
    bgObj = document.createElement("div");
    bgObj.id = "bgdiv";
    bgObj.style.cssText = "position:absolute;left:0px;top:0px;width:" + iWidth + "px;height:" + Math.max(document.body.clientHeight, iHeight) + "px;filter:Alpha(Opacity=30);opacity:0.3;background-color:#000000;z-index:101;";
    document.body.appendChild(bgObj);
    msgObj = document.createElement("div");
    if (ifcenter == false) {
        msgObj.style.cssText = "position:absolute;font:11px '宋体';top:" + py + ";left:" + px + ";width:" + pw + ";height:" + ph + ";text-align:center;border:1px solid " + bordercolor + ";background-color:" + bgcolor + ";padding:1px;line-height:22px;z-index:102;";
    }
    else {

        if (py == 0) {
            msgObj.style.cssText = "position:absolute;font:11px '宋体';top:" + (iHeight - ph) / 2 + "px;left:" + (iWidth - pw) / 2 + "px;width:" + pw + "px;height:" + ph + "px;text-align:center;border:1px solid " + bordercolor + ";background-color:" + bgcolor + ";padding:1px;line-height:22px;z-index:102;overflow:auto;";
        }
        else {
            msgObj.style.cssText = "position:absolute;font:11px '宋体';top:" + py + "px;left:" + (iWidth - pw) / 2 + "px;width:" + pw + "px;height:" + ph + "px;text-align:center;border:1px solid " + bordercolor + ";background-color:" + bgcolor + ";padding:1px;line-height:22px;z-index:102;overflow:auto;";

        }
    }

    document.body.appendChild(msgObj);
    msgObj.id = "rbdiv";
    var table = document.createElement("table");
    msgObj.appendChild(table);
    table.style.cssText = "margin:0px;border:0px;padding:0px;";
    table.cellSpacing = 0;
    if (title != "") {
        var tr = table.insertRow(-1);

        var titleBar = tr.insertCell(-1);
        titleBar.style.cssText = "width:auto;height:" + titleheight + ";text-align:left;padding:3px;margin:0px;font:bold 13px '宋体';color:" + titlecolor + ";border:1px solid " + bordercolor + ";cursor:move;background-color:" + titlebgcolor;
        titleBar.style.paddingLeft = "1px";
        titleBar.innerHTML = title;
        titleBar.id = "alerttitle";
        var moveX = 0;
        var moveY = 0;
        var moveTop = 0;
        var moveLeft = 0;
        var moveable = false;
        var docMouseMoveEvent = document.onmousemove;
        var docMouseUpEvent = document.onmouseup

        titleBar.onmousedown = function () {
            var evt = getEvent();
            moveable = true;
            moveX = evt.clientX;
            moveY = evt.clientY;
            moveTop = parseInt(msgObj.style.top);
            moveLeft = parseInt(msgObj.style.left);

            document.onmousemove = function () {
                if (moveable) {
                    var evt = getEvent();
                    var x = moveLeft + evt.clientX - moveX;
                    var y = moveTop + evt.clientY - moveY;
                    if (x > 0 && (x + w < iWidth) && y > 0 && (y + h < iHeight)) {
                        msgObj.style.left = x + "px";
                        msgObj.style.top = y + "px";
                    }
                }
            };
            document.onmouseup = function () {
                if (moveable) {
                    document.onmousemove = docMouseMoveEvent;
                    document.onmouseup = docMouseUpEvent;
                    moveable = false;
                    moveX = 0;
                    moveY = 0;
                    moveTop = 0;
                    moveLeft = 0;
                }
            };
        }

        var closeBtn = tr.insertCell(-1);
        closeBtn.style.cssText = "height:12px;text-align:right;cursor:pointer; padding:2px;background-color:" + titlebgcolor;
        closeBtn.innerHTML = "<span style='font-size:10pt; color:" + titlecolor + ";'>×</span>";
        closeBtn.onclick = function () {
            rbclose();
        }
    }

    var msgBox = table.insertRow(-1).insertCell(-1);
    msgBox.style.cssText = "font:10pt '宋体';";
    msgBox.colSpan = 2;
    msgBox.innerHTML = msg;

    var h = $("#rbdiv").height();
    var w = $("#rbdiv").width();
    var x = parseFloat(msgObj.style.left);
    var y = parseFloat(msgObj.style.top);
    var bodyheight = iHeight;
    var bodywidth = iWidth;
    if (h + y > bodyheight) {
        msgObj.style.top = String(y - h) + "px";
        y = y - h;
    }
    if (y < 0) {
        msgObj.style.top = 0;
        if (h > bodyheight) {
            msgObj.style.height = bodyheight + "px";
        }
        msgObj.style.overflow = "auto";
    }
    if (w + x >= bodywidth - 30) {
        msgObj.style.left = String(bodywidth - 100 - w) + "px";
    }

    // 获得事件Event对象，用于兼容IE和FireFox
    function getEvent() {
        return window.event || arguments.callee.caller.arguments[0];
    }
}
var doreq = 0;
var enddoreq = 0;
function rbclose() {
    try {
        if (queryobj != null && queryobj.style.disabled == true) {
            queryobj.style.disabled = false;
        }
    }
    catch (e) {
    }
    try {
        document.body.removeChild(bgObj);
        document.body.removeChild(msgObj);
        bgObj = bgObjold;
        msgObj = msgObjold;
    }
    catch (e) {
        // alert(e.Message);
    }
}
function remove_loading() {
    try {
        var targelem = document.getElementById('loader_container');
        targelem.style.display = 'none';
        targelem.style.visibility = 'hidden';
    }
    catch (e)
{ }
}
function show_loading() {

    var targelem = document.getElementById('loader_container');
    if (targelem != null) {
        targelem.style.display = '';
        targelem.style.visibility = 'visible';
    }

}

function loadjscssfile(filename, filetype) {
    if (filetype == "js") { //判断文件类型 
        var fileref = document.createElement("script"); //创建标签 
        fileref.setAttribute("type", "text/javascript"); //定义属性type的值为text/javascript 
        fileref.setAttribute("src", filename); //文件的地址 
    }
    else if (filetype == "css") { //判断文件类型 
        var fileref = document.createElement("link");
        fileref.setAttribute("rel", "stylesheet");
        fileref.setAttribute("type", "text/css");
        fileref.setAttribute("href", filename);
    }

    if (typeof fileref != "undefined") {
        document.getElementsByTagName("head")[0].appendChild(fileref)
    }
}  