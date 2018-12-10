var menuList = new Array();

var tabList = new Array();

var nameList = new Array();

var urlList = new Array();

var currentab = 0;

var myheight = 0;

var BS_TABS = 16;

var p_i = new Array();

p_i[0] = -1;

p_i[1] = -1;

var cfg;

function getmyheight() {
    try {
        myheight = parent.menu.myheight();
    } catch (e) {
        myheight = 0;
    }
    myheight = myheight - document.getElementById("header").scrollHeight - 1;
    return myheight;
}

function getPframeWidth() {
    return $("#divmain").width();
}
function getframeWidth() {
    return $("#showdiv").width();
}
function getframeheight() {
    return $("#showdiv").height();
}

function allwidth() {
    return $("#divmain").width();
}

function ResTabName() {
    for (var i = 0; i < menuList.length; i++) {
        if (menuList[i] == "0") {
            document.getElementById("tab_" + i).innerHTML = "<a><span></span></a>";
        } else {
            document.getElementById("tab_" + i).innerHTML = '<a title="' + menu_name + '"><span>' + menu_name + '<b class="close_menu" onclick="closetab_( ' + i + ')" onmousemove="mv(this,\'m\')" onmouseout="mv(this,\'o\')">&nbsp; X </b></span></a>';
        }
    }
}

function setH() {
    try {
        var obj = document.getElementById("showdiv");
        var hei = getmyheight();
        obj.style.height = hei + "px";
        var objs = document.getElementsByTagName("iframe");
        for (var i = 0; i < objs.length; i++) {
            objs[i].style.height = hei + "px";
        }
    } catch (e) { }
}
function show_tree(width_) {
    document.getElementById("mleft").style.width = width_;
    var rwidth = allwidth() - width_ - 2;
    document.getElementById("mright").style.width = rwidth;
    document.getElementById("showdiv").style.width = rwidth;
}
function ShowChildUrl(obj, url) {
    if (url == null || url=="" ) {
        return;
    }
    var tt = obj;
    var url_ = url;

    url_ = url_.replace("[HTTP_URL]", http_url);

    var pos = url_.toLowerCase().indexOf("&itree=");
    if (pos > 0) {
        var r = url_.substr(pos + 6);
        pos1 = r.indexOf("&");
        if (pos1 > 0) {
            r = r.substr(pos1 + 1);
            url_ = url_.substr(0, pos) + "&itree=0&" + r;
        }
        else {
            url_ = url_.substr(0, pos) + "&itree=0";
        }
    }
    else {
        url_ = url_ + "&itree=0";
    }   

    while (tt = tt.parentElement) {
        var m_id = tt.getAttribute("m_id");
        if (m_id != null && m_id != "") {
            //alert(m_id);
            var frm = document.getElementById(m_id);
            if (frm != null) {
                if (frm.src != url_) {
                    frm.src = url_;
                }
            }
            break;
        }
    }
}
var url_showquery = new Array();
function set_query_html_(url,html_) {
    //当前的地址
    var ilist = document.getElementsByTagName("iframe");
    for (var i = 0; i < ilist.length; i++) {
        if (ilist[i].contentWindow.location.href == url) {
            var m_num = ilist[i].getAttribute("m_num");
            url_showquery[m_num] = html_;
            break;
        }
    }

}
//获取查询的html
function get_query_html_(url) {
    //当前的地址
    var ilist = document.getElementsByTagName("iframe");
    for (var i = 0; i < ilist.length; i++) {
        if (ilist[i].contentWindow.location.href == url) {
            var m_num = ilist[i].getAttribute("m_num");
             return url_showquery[m_num];
            break;
        }
    }
}
function clear_query_html_(url) {
    var ilist = document.getElementsByTagName("iframe");
    for (var i = 0; i < ilist.length; i++) {
        if (ilist[i].contentWindow.location.href == url) {
            var m_num = ilist[i].getAttribute("m_num");
            url_showquery[m_num] = "";
            break;
        }
    }
}

//刷新
function ref_tree(url, html_, parm, a002_key_) {
    var ilist = document.getElementsByTagName("iframe");
    for (var i = 0; i < ilist.length; i++) {
        if (ilist[i].contentWindow.location.href == url) {
            var m_id = ilist[i].getAttribute("m_id");
            var m_name = ilist[i].getAttribute("m_name");
            var sdiv = document.getElementById("tree_" + m_id);
            if (sdiv != null) {
                var a002key = sdiv.getAttribute("A002KEY");
                if (a002_key_ == a002key) {
                    FunGetHttp(html_, sdiv.id, parm);
                }
            }            
            break;
        }
    }
}
function Set_tree(width_, html_, url, parm,a002_key_) {
    if (url != "") {
        var msg;
        try {
            msg = decodeURIComponent(html_);
        }
        catch (e) {
            msg = html_;
        }
         var ilist = document.getElementsByTagName("iframe");
         for (var i = 0; i < ilist.length; i++) {

             if (ilist[i].contentWindow.location.href == url) {
                 if (width_ > 0) {
                     var m_id = ilist[i].getAttribute("m_id");
                     var m_name = ilist[i].getAttribute("m_name");
                     var sdiv = document.getElementById("tree_" + m_id);
                     if (sdiv != null) {
                         FunGetHttp(html_, sdiv.id, parm);
                         //第一次载入树 记录初始信息
                         sdiv.setAttribute("mwidth", width_);
                         sdiv.setAttribute("A002KEY", a002_key_);                         
                     }
                     show__(m_id, m_name);
                 }
                 else {
                     show_tree(width_);
                 }

                 break;
             }
         }

   
      
    }
    else
    {
    show_tree(width_);
    }
}

function closetab_(num_) {
    var oldtabid = tabList[num_];
    for (var i = 0; i < menuList.length - 1; i++) {
        if (i >= num_) {
            menuList[i] = menuList[i + 1];
            nameList[i] = nameList[i + 1];
            tabList[i] = tabList[i + 1];
            if (menuList[i] == "0") {
                var obj_li = document.getElementById("tab_" + i);
                obj_li.innerHTML = "<a><span></span></a>";
                obj_li.style.display = "none";
            } else {
                var obj_li = document.getElementById("tab_" + i);
                document.getElementById("tab_" + i).innerHTML = '<a title="' + nameList[i] + '"><span>' + nameList[i] + '<b class="close_menu" onclick="closetab_( ' + i + ')" onmousemove="mv(this,\'m\')" onmouseout="mv(this,\'o\')">&nbsp; X </b></span></a>';
                obj_li.style.display = "";
            }
        }
    }
    old_frame = document.getElementById(oldtabid);
    if (old_frame != null) {
        old_frame.style.display = "none";
        old_frame.src = "";
    }
    menuList[menuList.length - 1] = "0";
    tabList[menuList.length - 1] = "";
    var obj = document.getElementById("tab_" + String(menuList.length - 1));
    obj.innerHTML = "<a><span></span></a>";
    obj.style.display = "none";
    var showi = -1;
    if (old_showtab == num_) {
        old_showtab = -1;
    }
    for (var i = 0; i < menuList.length; i++) {
        if (menuList[i] != "0") {
            if (p_i[0] != -1) {
                var obj_li = document.getElementById("tab_" + p_i[0]);
                if (obj_li.style.display == "") {
                    showtab(p_i[0]);
                    showi = p_i[0];
                    break;
                }
            }
            showi = i;
        }
    }
    showtab(showi);
    setH();
}

function closetab() {
    var iframe = document.getElementById("show_" + old_showtab);
    iframe.src = "";
    document.getElementById("tab_" + old_showtab).innerHTML = "<a><span></span></a>";
    document.getElementById("tab_" + old_showtab).style.display = "none";
    menuList[old_showtab] = "0";
    for (var i = 0; i < menuList.length; i++) {
        if (menuList[i] != "0") {
            showtab(i);
            break;
        }
    }
}

function ifshow(num_) {
    var obj = document.getElementById("tab_" + num_);
    if (obj.style.display == "none") {
        return false;
    }
    return true;
}

function showtaburl(url, menu_id) {
    if (url == "") {
        return "";
    }
    var ilist = document.getElementsByTagName("iframe");
    var lb_exist = false;
    var showframe;
    for (var i = 0; i < ilist.length; i++) {
        var li_ = document.getElementById("tab_" + ilist[i].id);
        var menu_id___ = li_.getAttribute("m_id");
        var menu_name___ = li_.getAttribute("m_name");
        if (menu_name___ == menu_id) {
            if (ilist[i].src.indexOf(url) >= 0) {
                lb_exist = true;
                show__(menu_id___, menu_name___);
                break;
            }
        }
    }
    if (lb_exist == false) {
        addtaburl(getClientDate(), menu_id, url);
    }
}

function addtab(menu_id, menu_name) {
    addtaburl(menu_id, menu_name, "jump.aspx?menu_id=" + menu_id);
}

function addtaburl(menu_id, menu_name, url) {
    Set_tree(0, '', '', '');
    CreateTab(url, "t" + menu_id, menu_name);
    return;
    var num = -1;
    for (var i = 0; i < menuList.length; i++) {
        if (menuList[i] == menu_id) {
            num = i;
            break;
        }
    }
    if (num > -1) {
        showtab(num);
        var new_frame = document.getElementById(tabList[num]);
        new_frame.src = url;
        return;
    }
    var if_do = "0";
    for (var i = 0; i < menuList.length; i++) {
        if (menuList[i] == "0") {
            menuList[i] = menu_id;
            nameList[i] = menu_name;
            for (var j = 0; j < menuList.length; j++) {
                var ifuse = "0";
                for (var k = 0; k < tabList.length; k++) {
                    if (tabList[k] == "show_" + j) {
                        ifuse = "1";
                        break;
                    }
                }
                if (ifuse == "0") {
                    document.getElementById("tab_" + i).innerHTML = '<a title="' + nameList[i] + '"><span>' + nameList[i] + '<b class="close_menu" onclick="closetab_( ' + i + ')" onmousemove="mv(this,\'m\')" onmouseout="mv(this,\'o\')">&nbsp; X </b></span></a>';
                    document.getElementById("tab_" + i).style.display = "";
                    document.getElementById("show_" + j).src = url;
                    tabList[i] = "show_" + j;
                    urlList[i] = url;
                    showtab(i);
                    if (p_i[1] != i) {
                        p_i[0] = p_i[1];
                        p_i[1] = i;
                    }
                    if_do = "1";
                    break;
                }
            }
            break;
        }
    }
    setH();
    if (if_do == "0") {
        alert("您打开的窗口过多！");
    }
}

var old_showtab = -1;

function CreateTab(url, menu_id, menu_name) {
    var ilist = document.getElementsByTagName("iframe");
    var lb_exist = false;
    var showframe;
    if (ilist.length >= BS_TABS) {
        alert("打开的窗口过多！");
        return;
    }
    for (var i = 0; i < ilist.length; i++) {
        if (ilist[i].id == menu_id) {
            lb_exist = true;
            var menu_id___ = ilist[i].getAttribute("m_id");
            var menu_name___ = ilist[i].getAttribute("m_name");
            show__(menu_id___, menu_name___);
        } else {
            obj = document.getElementById("tab_" + ilist[i].id);
            if (obj != null) {
                obj.className = "";
            }
            ilist[i].style.display = "none";
     
        }
    }
    if (lb_exist == false) {
        try {
            showframe = document.createElement('<iframe frameborder="0" ></iframe>');
        } catch (e) {
            showframe = document.createElement("iframe");
        }
        showframe.name = menu_id;
        showframe.id = menu_id;
        showframe.src = url;
        showframe.style.width = $("#showdiv").width();
        showframe.style.height = $("#showdiv").height();
        showframe.scrolling = "no";
        showframe.style.border = "0";
        showframe.setAttribute("m_id", menu_id);
        showframe.setAttribute("m_name", menu_name);
        //记录编码
        showframe.setAttribute("m_num", url_showquery.length);
        var div_ = document.getElementById("showdiv");
        div_.appendChild(showframe);
        var li_ = document.createElement("li");
        li_.id = "tab_" + menu_id;
        li_.setAttribute("menu_id", show_menu_id); //上个编码
        li_.setAttribute("menu_name", show_menu_name);
        li_.setAttribute("m_name", menu_name);
        li_.setAttribute("m_id", menu_id);
        //记录查询
        li_.setAttribute("m_num", url_showquery.length);
        url_showquery[url_showquery.length] = "";

        li_.className = "hover";
        var showname = menu_name;
        li_.innerHTML = '<div id="w_' + menu_id + '" menu_id="' + menu_id + '" menu_name ="' + menu_name + '" shortname="' + menu_name + '"><a title="' + menu_name + '" alt="' + menu_name + '" onclick="show__(\'' + menu_id + "','" + menu_name + "')\"><span>" + showname + '<b class="close_m" onclick="closeshow__(\'' + menu_id + "','" + menu_name + '\')" mousemove="mv(this,\'m\')" onmouseout="mv(this,\'o\')" title="关闭">&nbsp; X </b></a></div>';
        
        var ultab = document.getElementById("ultab");
        ultab.appendChild(li_);
              
        var stree = document.getElementById("showtree");
        var mObj = document.createElement("div");
        mObj.id = "tree_" + menu_id;
        mObj.style.overflow = "auto";
        try
        {
          mObj.style.height = $("#showdiv").height() - 12;
        }
        catch(e)
        {
        
        }
        
        mObj.setAttribute("m_name", menu_name);
        mObj.setAttribute("m_id", menu_id);
        mObj.setAttribute("m_width", "0");
        mObj.innerHTML = "";
        stree.appendChild(mObj);
        show_menu_id = menu_id;
        show_menu_name = menu_name;
        setwidth();

    }
}

var show_menu_id = "";

var show_menu_name = "";

function closeshow__(menu_id, menu_name) {
    var ilist = document.getElementsByTagName("iframe");
    var lb_exist = false;
    for (var i = 0; i < ilist.length; i++) {
        var menu_id___ = ilist[i].getAttribute("m_id");
        var menu_name___ = ilist[i].getAttribute("m_name");
        if (menu_id___ == menu_id && menu_name___ == menu_name) {
            lb_exist = true;
            ilist[i].style.display = "";
            var div_ = document.getElementById("showdiv");
            div_.removeChild(ilist[i]);
            var ultab = document.getElementById("ultab");
            var li_ = document.getElementById("tab_" + menu_id);
            var menu_id___ = li_.getAttribute("menu_id");
            var menu_name___ = li_.getAttribute("menu_name");
            ultab.removeChild(li_);

            var sdiv_ = document.getElementById("showtree");
            var tree_div = document.getElementById("tree_" + menu_id);
            sdiv_.removeChild(tree_div);

            show__(menu_id___, menu_name___);
            break;
        }
    }
}

var dec = 100;

function setwidth() {
    var ilist = document.getElementsByTagName("iframe");
    var w = 50;
    for (var i = 0; i < ilist.length; i++) {
        var obj = document.getElementById("w_" + ilist[i].id);
        var menu_id = obj.getAttribute("menu_id");
        var menu_name = obj.getAttribute("menu_name");
        obj.innerHTML = '<a title="' + menu_name + '" alt="' + menu_name + '" onclick="show__(\'' + menu_id + "','" + menu_name + "')\"><span>" + menu_name + '<b class="close_m" onclick="closeshow__(\'' + menu_id + "','" + menu_name + '\')" mousemove="mv(this,\'m\')" onmouseout="mv(this,\'o\')" title="关闭">&nbsp; X </b></a>';
        w = w + $("#w_" + ilist[i].id).width() + 5;
        if (menu_id == show_menu_id) {
        
            var sdiv = document.getElementById("tree_" + menu_id);
            mwidth = sdiv.getAttribute("mwidth");
            if (mwidth == null) {
                mwidth = "0";
            }
            show_tree(mwidth);
            var v = ilist[i].contentWindow.set_width_;
            if (v != null) {
                ilist[i].contentWindow.set_width_();
            }
      
        }

    }
    var allw = getPframeWidth();
    if (w > allw) {
        var vper = String(allw / ilist.length);
        var c = (vper - 30) / 20;
        for (var i = 0; i < ilist.length; i++) {
            var obj = document.getElementById("w_" + ilist[i].id);
            var menu_id = obj.getAttribute("menu_id");
            var menu_name = obj.getAttribute("menu_name");
            var shortname = obj.getAttribute("shortname");
            var thisshortname = shortname;
            if (c <= 0) {
                thisshortname = menu_name.substring(0, 1) + "..";
            } else {
                if (c == 0) {
                    c = 1;
                }
                if (menu_name.length > c) {
                    thisshortname = menu_name.substring(0, c);
                } else {
                    thisshortname = menu_name.substring(0, c);
                }
            }
            obj.setAttribute("shortname", thisshortname);
            obj.innerHTML = '<a title="' + menu_name + '" alt="' + menu_name + '" onclick="show__(\'' + menu_id + "','" + menu_name + "')\"><span>" + thisshortname + '<b class="close_m" onclick="closeshow__(\'' + menu_id + "','" + menu_name + '\')" mousemove="mv(this,\'m\')" onmouseout="mv(this,\'o\')" title="关闭">&nbsp; X </b></a>';
        }
    }
}

function show__(menu_id, menu_name) {
    var ilist = document.getElementsByTagName("iframe");
    var lb_exist = false;
    var w = 0;
    var lb_tree = false;
    for (var i = 0; i < ilist.length; i++) {
        if (ilist[i].id == menu_id) {
            lb_exist = true;
            ilist[i].style.display = "";
            document.getElementById("tab_" + menu_id).className = "hover";
            show_menu_id = menu_id;
            show_menu_name = menu_name;
            showobj = document.getElementById("tree_" + menu_id);
            if (showobj != null) {
                mwidth = showobj.getAttribute("mwidth");
                if (mwidth == null) {
                    mwidth = "0";
                }
                show_tree(mwidth);
                if (mwidth != "0") {
                    showobj.style.display = "";
                }
            }
        }
        else
        {
            obj = document.getElementById("tab_" + ilist[i].id);
            if (obj != null) {
                obj.className = "";
            }
            ilist[i].style.display = "none";
            showobj = document.getElementById("tree_" + ilist[i].id);
            if (showobj != null) {
                showobj.style.display = "none";
            }
        }
    }


    if (lb_exist == false && ilist.length > 0) {
        ilist[ilist.length - 1].style.display = "";
        var mid = ilist[ilist.length - 1].id;
        obj = document.getElementById("tab_" + mid);
        if (obj != null) {
            document.getElementById("tab_" + mid).className = "hover";
            show_menu_id = obj.getAttribute("menu_id");
            show_menu_name = obj.getAttribute("menu_name");
        }
    }
    setwidth();
}

function showtab(num) {
    if (old_showtab >= 0) {
        var old_frame = document.getElementById(tabList[old_showtab]);
        if (old_frame != null) {
            old_frame.style.display = "none";
            document.getElementById("tab_" + old_showtab).className = "";
        }
    }
    var new_frame = document.getElementById(tabList[num]);
    if (new_frame != null) {
        new_frame.style.display = "";
        document.getElementById("tab_" + num).className = "hover";
    }
    old_showtab = num;
    currentab = num;
}

function mv(obj, moveout) {
    if (moveout == "m") obj.className = "close_m";
    if (moveout == "o") obj.className = "close_o";
    return true;
}

function GetCfg(id_) {
    var v = new Function("return cfg[0]." + id_)();
    return v;
}