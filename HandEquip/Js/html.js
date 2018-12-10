var menu_id = "";
var main_key = "";
var main_keyvalue = "";
var data_index = "";
var option = "";
var nowdetail_index = ""; //当前明细页签标识

var changeobjlist = new Array(); //存储修改对象
var delobjlist = new Array(); //存储删除对象
var addobjlist = new Array();//存储新增对象

// 退出登录
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

function Load_MainList(id_, url) {
   // document.getElementById("show_dtl").src=http_url + "" + url;
}

function Get_Attr_Bywindow() {

}

/*
用户页面加载
*/
function loadChildUrl(divid, url, parm) {
    var url = http_url + url + "?ver=" + getClientDate();
    FunGetHttp(url, divid, parm);
}

function load_iframe_url(id, menu_id, line_no,key) {
    var obj = $("#show_iframe_" + id);
    var src = "BaseForm/mainiframe.aspx?MENU_ID=" + menu_id + "&LINE_NO=" + line_no + "&KEY=" + key;
    obj[0].src = src;
}

function heq_itemchange(id) {
    savechangeobj(document.getElementById(id));
    var sp = id.split("_");
    var rowid = sp[1] + "_" + sp[2]+ "_" + sp[3];
    var rowlist_ = data_index + get_rowlist(rowid, id);
    var A00201KEY_ = sp[1] + "-" + sp[2];
    var parm = formatparm();
    //parm = addParm(parm, "MENU_ID", menu_id);
    parm = addParm(parm, "A00201KEY", A00201KEY_);
    parm = addParm(parm, "ROWID", rowid);
    parm = addParm(parm, "ROWLIST", rowlist_);
    parm = addParm(parm, "COLID", sp[4]);
    parm = parm + endformatparm();
    var url = http_url + "/HandEquip/BaseForm/itemchange.aspx?menu_id=" + menu_id + "&ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);
}



function get_rowlist(rowid_, collist_) {
    var col = collist_.split("_");
    var rowlist = "";
   // rowlist =  "MAIN_KEY|" + main_keyvalue + data_index;
    var line_no = "";
    var name = "TXT_" + rowid_;
    var objlist = $("[name='" + rowid_ + "']");
    for (var i = 0; i < objlist.length; i++) {
        line_no = objlist[i].id.substr(name.length + 1);
        var val_ = "";
        if (objlist[i].type == "text" || objlist[i].type=="hidden") {
            val_ = objlist[i].value;
        } else if (objlist[i].type == "checkbox") {
            if (objlist[i].checked=="true") {
                val_ = "1";
            } else {
                val_ = "0";
            }
        } else if (objlist[i].type=="select-one") {
            val_ = objlist[i].value; 
        } else { val_ = ""; }
        rowlist = rowlist + line_no + "|" + val_ + data_index;
    }
//    if (rowlist.length > 0) {
//        rowlist =data_index + rowlist;
//    }
    return rowlist;
}

function set_colvalue(id_, value_) {
    var obj_ = $("#TXT_" + id_);
    if (obj_[0] != null) {
        if (obj_[0].type == "text") {
            //val(value$("#TXT_" + id_)._);
            obj_[0].value = value_;
        } else if (obj_[0].type == "checkbox") {
            if (value_ == "0") {
                obj_[0].checked = false;
                obj_[0].value = "0";
            } else {
                obj_[0].checked = true;
                obj_[0].value = "1";
            }
        } else {
            obj_[0].value = value_;
        }
    }
}

function heq_new(id_) {
    var sp_id = id_.split('_');
    var parm = formatparm();
    parm = addParm(parm, "REQTYPE", "HEQ_NEW");
    parm = addParm(parm, "MENU_ID", menu_id);
    parm = addParm(parm, "A00201KEY", menu_id + "-" + sp_id[1]);
    parm = addParm(parm, "MAIN_KEY", main_key);
    parm = addParm(parm, "MAIN_KEY_VALUE", main_keyvalue);
    parm = parm + endformatparm();
    var url = http_url + "/HandEquip/BaseForm/myreq.aspx?ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);
}

function heq_save() {
    //自动检索页面操作
    $("#btn_save").attr("disabled", true);
    $("#btn_del").attr("disabled", true);
    var rowlist = "";
    var str_
    var v_flag = "";
    //检索新增
    for (var i = 0; i < addobjlist.length; i++) {
        //如果存在删除行，则不记录主档的添加
        v_flag = "0";
        var v_obj = addobjlist[i].toString().split('_');
        if (v_obj[1] == "0" && delobjlist.length>0) {
            v_flag = "1";
        }
        if (v_flag=="0") {
            //获取页面字段值，
            str_ = get_rowlist(addobjlist[i], "");
            str_ = "ROWID|" + addobjlist[i] + data_index + str_;
            str_ = "MAIN_KEY|" + main_keyvalue + data_index + str_;
            str_ = "OBJID|" + data_index + str_;
            str_ = "DOACTION|I" + data_index + str_;
            str_ = str_ + "<EXECSQL></EXECSQL>";
            rowlist = rowlist + str_;
        }
        
    }
    //检索修改
    var arr1_ = new Array();
    var arr2_ = new Array();
    for (var i = 0; i < changeobjlist.length; i++) {
        var id_ = changeobjlist[i].id.toString().split('_');
        var flag_ = "0";
        for (var j = 0; j < arr1_.length; j++) {
            if (arr1_[j]== changeobjlist[i].name ) {
                flag_ = "1";                
                arr2_[j] = id_[id_.length - 1] + "|" + changeobjlist[i].value + data_index;
                break;
            }
        }
        if (flag_ == "0") {
            var len = arr1_.length;
            arr1_[len] = changeobjlist[i].name;
            arr2_[len] = id_[id_.length - 1] + "|" + changeobjlist[i].value + data_index;
        }
    }
    
    for (var i = 0; i < arr1_.length; i++) {
        str_ = arr2_[i];
        str_ = "ROWID|" + arr1_[i] + data_index + str_;
        str_ = "MAIN_KEY|" + main_keyvalue + data_index + str_;
        var obj_ = document.getElementById(arr1_[i] + "_0")
        str_ = "OBJID|" + obj_.value + data_index + str_;
        str_ = "DOACTION|M" + data_index + str_;
        str_ = str_ + "<EXECSQL></EXECSQL>";
        rowlist = rowlist + str_;
    }
    //检索删除
    var selectdrowlist = "";
    for (var i = 0; i < delobjlist.length; i++) {
        selectdrowlist = selectdrowlist + delobjlist[i].value + ",";
        str_ = delobjlist[i].value;
        str_ = "ROWID|" + delobjlist[i].id.substring(4) + data_index + str_;
        str_ = "MAIN_KEY|" + main_keyvalue + data_index + str_;
        str_ = "OBJID|" + delobjlist[i].value + data_index + str_;
        str_ = "DOACTION|D" + data_index + str_;
        str_ = str_ + "<EXECSQL></EXECSQL>";
        rowlist = rowlist + str_;
    }

    
    var parm = formatparm();
    parm = addParm(parm, "REQTYPE", "HEQ_SAVE");
    parm = addParm(parm, "MENU_ID", menu_id);
    //parm = addParm(parm, "A00201KEY", menu_id + "-" + line);
    parm = addParm(parm, "MAIN_KEY", main_key);
    parm = addParm(parm, "MAIN_KEY_VALUE", main_keyvalue);
    parm = addParm(parm, "EXESQL", rowlist);
    parm = addParm(parm, "SELECTDROWLIST", selectdrowlist);
    parm = parm + endformatparm();
    var url = http_url + "/HandEquip/BaseForm/myreq.aspx?ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);
    //clearObjlist();
    $("#btn_save").attr("disabled", false);
    $("#btn_del").attr("disabled", false);
}

//执行保存按钮后执行返回结果
function heq_doNext(v) {
    var result_ = "";
    var msg = v;
    var type;
    var value;
    var pos = msg.indexOf(data_index);
    if (pos >= 0) {
        while (pos >= 0) {
            var msg1 = msg.substring(0, pos);
            var pos1 = msg1.indexOf("|");
            type = msg1.substring(0, pos1);
            value = msg1.substring(pos1 + 1);
            if (type == "03") {
                result_ = result_ + "alert('" + value + "');";
            } else if (type == "11") {
                result_ = result_ + value;
            } else {
                result_ = result_ + "alert('" + msg1 + "');";
            }

            msg = msg.substring(pos + 1);
            pos = msg.indexOf(data_index);
        }
    } else {
        type = msg.substring(0, 2);
        value = msg.substring(2);
        if (type == "00") {
            result_ = result_ + "alert('" + value + "');";
        } else {
            result_ = result_ + "alert('" + msg + "');";
        }
    }
    eval(result_);
    //eval("alert('a');alert('b');");
}

function heq_delrow() {
    $("#btn_save").attr("disabled", true);
    $("#btn_del").attr("disabled", true);
    var obj = $("input[type='checkbox'][name='cbx_" + menu_id + "_" + nowdetail_index + "']:checked");
    for (var i = 0; i < obj.length; i++) {       
        savedelobj(obj[i]);
        $("#tr_" + obj[i].id.substring(4)).hide();
    }
    if (delobjlist.length>0) {
        heq_save();
    }
    $("#btn_save").attr("disabled", false);
    $("#btn_del").attr("disabled", false);
}


function savechangeobj(obj) {
    var isadd = "0";
    var flag_ = "0";
    //判断新增对象是否存在
    for (var i = 0; i < addobjlist.length; i++) {
        if (obj.id.indexOf(addobjlist[i]) >= 0) {
            isadd = "1";
            break;
        }
    }
    if (isadd=="0") {
        for (var i = 0; i < changeobjlist.length; i++) {
            if (changeobjlist[i].id == obj.id) {
                flag_ = "1";
                break;
            }
        }
        var len = changeobjlist.length;
        if (flag_ == "0") {
            changeobjlist[len] = obj;
        }
    }
    
}

function savedelobj(obj) {
    var flag_ = "0";
    for (var i = 0; i < delobjlist.length; i++) {
        if (delobjlist[i].id == obj.id) {
            flag_ = "1";
            break;
        }
    }
    var len = delobjlist.length;
    if (flag_ == "0") {
        delobjlist[len] = obj;
    }
}

function saveaddobj(obj) {
    var flag_ = "0";
    for (var i = 0; i < addobjlist.length; i++) {
        if (addobjlist[i] == obj) {
            flag_ = "1";
            break;
        }
    }
    var len = addobjlist.length;
    if (flag_ == "0") {
        addobjlist[len] = obj;
    }
}

function clearObjlist() {
    changeobjlist.splice(0, changeobjlist.length);
    delobjlist.splice(0, delobjlist.length);

}

function select_detaillist(id_) {
    var flag = id_.split('_');
    if (flag[2] == nowdetail_index) {
        return;
    }
    var div_id = id_.replace("btn_","div_");
    //alert(id_);
    document.getElementById("div_detail_" + nowdetail_index).style.display = "none";
    document.getElementById(div_id).style.display = "";
    nowdetail_index = flag[2];
    loaddetaillist(flag[2], menu_id, main_keyvalue);
}

function loaddetaillist(id_, menu_id_, key_) {
    if (id_ == "0" || id_=="") {
        return;
    }
    var parm = formatparm();
    parm = addParm(parm, "MENU_ID", menu_id_);
    parm = addParm(parm, "LINE_NO", id_);
    parm = addParm(parm, "KEY", key_);
    parm = parm + endformatparm();
    var url = "/HandEquip/BaseForm/maindetail.aspx";
    loadChildUrl("div_detail_" + id_, url, parm);
}


function selectdetailall(obj) {
    alert(obj.id);
    if (obj.checked == "true") {
        alert($("input[type='checkbox'][name^='" + obj.id + "']").length); //.attr("checked", true);
        //$("input[type='checkbox'][name='cbx_" + menu_id + "_" + nowdetail_index + "']:checked");
    }
}

function loadmainform(menu_id_, key_,option_) {
    var parm = formatparm();
    parm = addParm(parm, "MENU_ID", menu_id_);
    parm = addParm(parm, "KEY", key_);
    parm = addParm(parm, "OPTION", option_);
    parm = parm + endformatparm();
    var url = "/HandEquip/BaseForm/main.aspx";
    //loadChildUrl("div_main", url, parm);
    loadChildUrl("div_req", url, parm);
    if (option == "I") {
        saveaddobj(menu_id + "_0_0");
    }
}

function loadmainbtn(menu_id_, key_, option_) {
    var parm = formatparm();
    parm = addParm(parm, "MENU_ID", menu_id_);
    parm = addParm(parm, "KEY", key_);
    parm = addParm(parm, "OPTION", option_);
    parm = parm + endformatparm();
    var url = "/HandEquip/BaseForm/mainbutton.aspx";
    //loadChildUrl("div_btn", url, parm);
    loadChildUrl("div_req", url, parm);
}

function show_choose(id_) {
    var gg = document.getElementById("div_main");
    var div_ = document.getElementById("div_choose");
    if (div_ != null) {
        var pobj_ = div_.parentNode.removeChild(div_);
    }
    div_ = document.createElement("div");
    div_.id = "div_choose";
    div_.style.top = 0 + "px";
    div_.style.left = 0 + "px";
    div_.style.height = 230 + "px";
    div_.style.width =  220 +"px";
    div_.style.position = "absolute";
    div_.innerHTML = "<div style=\"width: 100%; height: 98%;  z-index:1; left: 0px; top: 0px;\">"+
        "<div style=\"height: 20px; width: 100%; background-color:Background; color:White;\"><div style=\" float:left;\">请输入查询条件</div><img class=\"img_choose\" src=\"../images/close.gif\" onclick=\"javascript:$('#div_choose').hide();\" style=\"float: right; vertical-align:top;\" /></div>" +
        "<div id=\"div_choose_v\" style=\"overflow: auto; width: 100%; height: 90%; border-top: 1px solid #AACAEE;\"></div>" +
        "</div>" +
        "<iframe style=\"position:absolute;left: 0px; top: 0px; width: 100%; height: 200px; z-index:-1; border:0px; display:block; filter:alpha(opacity=0);\"></iframe>";
    gg.appendChild(div_);


    /*$("#div_choose").show();*/
    showallselect();
    var sp_id = id_.split('_');
    var rowlist_ = data_index + get_rowlist(sp_id[1] + "_" + sp_id[2] + "_" + sp_id[3], id_);
    var mainrowlist_ = data_index + get_rowlist(sp_id[1] + "_0_0", id_);
    var parm = formatparm();
    parm = addParm(parm, "MENU_ID", sp_id[1]);
    parm = addParm(parm, "LINE_NO", sp_id[2]);
    parm = addParm(parm, "ROW_LINE_NO", sp_id[3]);
    parm = addParm(parm, "COL_LINE_NO", sp_id[4]);
    parm = addParm(parm, "COLID", id_.replace("IMG_", "TXT_"));
    parm = addParm(parm, "ROWLIST", rowlist_);
    parm = addParm(parm, "MAINROWLIST", mainrowlist_);
    parm = parm + endformatparm();
    var url = "/HandEquip/BaseForm/choose.aspx";
    //loadChildUrl("div_choose_v", url, parm);
    loadChildUrl("div_choose_v", url, parm);
}

function choose_select(id_, v_, calc_flag_) {
    //$("#div_choose").hide();
    $("#" + id_).val(v_);
    heq_itemchange(id_)
    var div_ = document.getElementById("div_choose");
    div_.parentNode.removeChild(div_)
}

function showallselect() {
    $("select[tagname='select']").show();
}