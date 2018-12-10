// 页面的定义全局的参数 

/*
当前页面的状态


I 新增
M 修改
V 查看
*/
var option = "I";
var ISAVE = "0"; //新增就能保存
/*解析 ajax 返回的值*/

/*
00 表示直接用页面的alert来报消息 页面不做任何动作
01 页面的alert来报消息，并且刷新当前页面 
02 直接跳转页面
03 打开新页面
*/

/*
当前修改的控件列表

.navigator li a{float:left;display:block;height:35px;line-height:35px; padding:0 15px; color:White;font-size:15px; font-weight:700;}
.navigator li a:hover{background: -webkit-gradient(linear, left top, left bottom, from(#438900), to(#9cd400));
*/
var lwidth = 300;
var changeobjList = new Array();
var A00201_LIST = new Array();
var main_height = 120;
var main_key_value = "-1";
var input_main_key_value = "-1";
var rowList = new Array();
var mainrowheight = 20;
var a002_key = "";
var main_table_height = 0;
var a007_key = "";
var a30001_key = "";
var a013010101 = new Array(); //表的列属性
var IFA309 = "0";
var if_showDialog = "0";
var after_sql = new Array();
var check_sql = new Array();
var data_index = "";
var win_Width = window.screen.availWidth - window.screenLeft;
var win_Height = window.screen.availHeight - window.screenTop;
var copya00201key = "";
var if_changeitem = "0";
var ifshowend = false;
var havetree = "0"; //树
var selectedrowlist = ""; //选中的行
var selectedrowidlist = ""; //选中的行
function pageInit() {

}
function showchild(obj) {
    var objs = document.getElementById(obj.id + "_s");
    if (objs != null) {
        if (objs.style.display == "") {
            objs.style.display = "none";
            obj.src = "../images//closed.gif";
        }
        else {
            objs.style.display = "";
            obj.src = "../images//opened.gif";
        }
    }
}
function getlineno(a00201_key_, main_key__) {
    var a00201_ = new Array();
    for (var i = 0; i < A00201_LIST.length; i++) {
        if (A00201_LIST[i][0] == a00201_key_) {
            /*如果没有赋值*/
            a00201_ = A00201_LIST[i];
            if (a00201_[1] == 0) {
                v = BasePage.getKeyLineNo(a00201_key_, main_key__).value;
                a00201_[1] = v;
            }
            a00201_[2] = parseFloat(a00201_[2]) + parseFloat(1);
            A00201_LIST[i] = a00201_;
            break;
        }
    }
    return parseFloat(a00201_[2]) + parseFloat(a00201_[1]);
}
function clearlineno() {
    for (var i = 0; i < A00201_LIST.length; i++) {
        a00201_ = A00201_LIST[i];
        a00201_[1] = 0;
        a00201_[2] = 0;
        A00201_LIST[i] = a00201_;
    }
}

//把TXT_ inpur 的id传入 设置  rowList 的变化为1
function setRowChange(obj_) {

    return;
    for (var i = 0; i < rowList.length; i++) {
        var row = rowList[i];
        if (row[0] == obj_.name) {
            row[3] = "1"; //设置列变化


            rowList[i] = row;
            break;
        }
    }
}
function show_vCode(id, if_show) {
    document.getElementById(id).style.display = "";
    if (if_show == "1") {
        document.getElementById(id).src = http_url + "/VerifyCode.aspx?ver=" + +getClientDate();
    }
}
function userlogin() {

    document.getElementById("txt_error").style.visibility = "hidden";
    document.getElementById("user_ness").style.visibility = "hidden";
    document.getElementById("pass_ness").style.visibility = "hidden";
    var number = Math.random() * 100000;
    var user_; var pass_;
    var m002id_ = "0";
    obj_user = document.getElementById("user");
    if (trim(obj_user.value) == "") {
        document.getElementById("txt_error").innerHTML = "*请输入账户名";
        document.getElementById("txt_error").style.visibility = "visible"; obj_user.focus(); return false
    }
    else {
        user_ = trim(obj_user.value);
        document.getElementById("txt_error").style.visibility = "hidden"
    }
    obj_pass = document.getElementById("pass");
    if (obj_pass.value == "") {
        document.getElementById("txt_error").innerHTML = "*请输入密码";
        document.getElementById("txt_error").style.visibility = "visible";
        obj_pass.focus(); return false
    }
    else {
        pass_ = obj_pass.value;
        document.getElementById("txt_error").style.visibility = "hidden";
    }
    obj_vc = document.getElementById("txtVerifyCode");
    //           var vc_; if (trim(obj_vc.value) == "") {
    //            document.getElementById("txt_error").innerHTML = "*请输入验证码";
    //            document.getElementById("txt_error").style.visibility = "visible";
    //            obj_vc.focus();
    //            return false
    //        }
    CheckUserLogin(obj_vc.value, user_, pass_);
}
function setLoginError(msg_) {
    document.getElementById("txt_error").innerHTML = msg_;
    document.getElementById("txt_error").style.visibility = "visible";
}
function CheckUserLogin(verifycode, user_, pass) {
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "CHECKLOGIN");
    parm = addParm(parm, "CODE", verifycode);
    parm = addParm(parm, "USERID", user_);
    parm = addParm(parm, "PASS", pass);

    var obj_type = document.getElementById("ltype"); //wp
    var ltype = "2";
    if (obj_type != null) {
        ltype = obj_type.value;
    }
    parm = addParm(parm, "LTYPE", ltype);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

}
function setLanguage(lang_id) {
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "SET_LANGUAGE");
    parm = addParm(parm, "LANGUAGE_ID", lang_id);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

}
var session_temp = "";
document.write("<input id='session_temp' type='hidden' v='' ");
function get_session(id_) {
    var tt = '--||';
    session_temp = tt;
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "GET_SESSION");
    parm = addParm(parm, "NAME", id_);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);
    setTimeout("get_session_('" + tt + "')", 100);
}
function get_session_(tt_) {
    if (session_temp != tt_) {
        document.getElementById("session_temp").value = session_temp;
    }
    else {
        setTimeout("get_session_('" + tt_ + "')", 100);
    }
}


function setshowchild(obj_, a00201_key__) {
    if (obj_.value == "0") {
        obj_.value = "1";
    }
    else {
        obj_.value = "0";
    }
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "SET_SESSION");
    parm = addParm(parm, "NAME", "SHOWCHILD_" + a00201_key__);
    parm = addParm(parm, "VALUE", obj_.value);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

}
function doNext(v) {
    /**/

    var v_type = v.substr(0, 2);
    var v_msg = v.substring(2);
    v_msg = v_msg.replace("[HTTP_URL]", http_url);
    if (v_type == "00") {
        alert(v_msg);
    }
    if (v_type == "04") {
        //关闭当前窗口， 打开新窗口
        // window.open(v_msg, "_self", "status=no,toolbar=no,menubar=no");
        var tmp = window.open("about:blank", "", "status=no,toolbar=no,menubar=no")
        tmp.moveTo(0, 0)
        tmp.resizeTo(screen.width, screen.height - 30)
        tmp.focus()
        tmp.location = v_msg

        window.close();
    }

    if (v_type == "01" || v_type == "05" || v_type == "06") {
        //报信息
        if (v_type == "05") {
            if (v_msg.length > 1) {
                alert(v_msg);
            }
        }
        url = location.href;
        if (option == "Q") {
            var pos = url.toLowerCase().indexOf("&query=");
            if (pos <= 0) {
                url = url + "&QUERY=1";
            }
        }
        else {
            if (old_showtab != "0") {
                var pos = url.toLowerCase().indexOf("&showtab=");
                if (pos > 0) {
                    var r = url.substr(pos + 9);
                    pos1 = r.indexOf("&");
                    if (pos1 > 0) {
                        r = r.substr(pos1 + 1);
                        url = url.substr(0, pos) + "&showtab=" + old_showtab + "&" + r;
                    }
                    else {
                        url = url.substr(0, pos) + "&showtab=" + old_showtab;
                    }
                }
                else {
                    url = url + "&showtab=" + old_showtab;
                }
            }
        }
        var pos = url.toLowerCase().indexOf("&code=");
        if (pos > 0) {
            var r = url.substr(pos + 6);
            pos1 = r.indexOf("&");
            if (pos1 > 0) {
                r = r.substr(pos1 + 1);
                url = url.substr(0, pos) + "&code=" + getClientDate() + "&" + r;
            }
            else {
                url = url.substr(0, pos) + "&code=" + getClientDate();
            }
        }
        else {
            url = url + "&code=" + getClientDate();
        }



        //06 执行刷新当前页面 打开新界面
        if (v_type == "06") {
            try {
                pos = v_msg.indexOf(",");

                showtaburl(v_msg.substr(0, pos), v_msg.substr(pos + 1));
            }
            catch (e) {

            }
        }
        location.href = url;
    }
    if (v_type == "02") {
        location.href = v_msg;
    }
    if (v_type == "03") {
        alert(v_msg);
    }
    if (v_type == "08") {
        if (window.execScript) {
            window.execScript(v_msg, "JavaScript");
        } else {
            window.eval(v_msg);
        } 
    }


}
function formatxml() {
    return "<?xml version=\"1.0\" encoding=\"utf-8\" ?><DATA>";
}
function endformatxml() {
    return "</DATA>";
}
var A00201LIST = "";
/*获取页面数据*/

function getDataFromForm(key_) {

    var str_v = formatxml();
    for (var i = 0; i < 100000; i++) {
        var rowid = key_ + "_" + String(i);
        var objs = document.getElementsByName(rowid);
        if (objs.length <= 0) {
            break;
        }
        str_v += "<" + key_ + ">";
        for (var j = 0; j < objs.length; j++) {
            var d_obj = objs[j];
            var a10001_key = d_obj.id.replace("TXT_" + rowid + "_", "");
            /*
            TXT_210_1_1
            */
            var colrowid = BasePage.getColumnRow(key_, "A10001_KEY", a10001_key).value;
            /*获取必填性*/
            var col_nessary = BasePage.getColumnAtt(key_, colrowid, "sys_necessary").value;
            var column_id = BasePage.getColumnAtt(key_, colrowid, "column_id").value;
            // alert(column_id +"=" +   d_obj.value)

            str_v += "<" + a10001_key + ">" + d_obj.value + "</" + a10001_key + ">";
        }
        str_v += "</" + key_ + ">";
    }


    str_v += endformatxml();

    alert(str_v);
}

function CheckData(num) {
    var row = rowList[num]; //获取行的属性


    if (num > 0) {
        if (row[3] == "0") //当前行没有变化
        {
            return;
        }
    }

    key_ = row[0];

    var objs = document.getElementsByName(row[0]);
    /*检测必填*/

    var str_v = formatxml();
    str_v += "<A" + key_ + ">";


    var main_key = row[5];
    var table_key = row[6];

    var table_id_ = row[8];
    var insertsql_col = "Insert Into " + table_id_ + "(";
    var insertsql_value = "select ";
    var updatesql = "Update " + table_id_ + " Set ";
    var deletesql = "Delete from " + table_id_;
    var a20001_key = "";
    var rowdata = "";
    a20001_key = key_.split("_")[0];
    var objid_obj_ = document.getElementById("objid_" + key_);
    if (objid_obj_ == null) {
        rowdata = "OBJID|" + data_index;
    }
    else {
        rowdata = "OBJID|" + objid_obj_.value + data_index;

    }
    var a = get_a013010101(a20001_key);
    var dt = a[1];
    if (row[2] == "I" || row[2] == "M") {

        // rowdata += column_id + "|" + v + data_index  ; 
        for (var j = 0; j < objs.length; j++) {
            var d_obj = objs[j];
            var a10001_key = d_obj.id.replace("TXT_" + key_ + "_", "");
            /*
            TXT_210_1_1
            */

            for (var r = 0; r < dt.Rows.length; r++) {
                var a10001_key_ = dt.Rows[r]["A10001_KEY"];
                //      alert(a10001_key)
                if (a10001_key == a10001_key_) {
                    var col_nessary = dt.Rows[r]["SYS_NECESSARY"];
                    var column_id = dt.Rows[r]["COLUMN_ID"];
                    var col_visible = dt.Rows[r]["COL_VISIBLE"];
                    var col_enable = dt.Rows[r]["COL_ENABLE"];

                    if (col_nessary == "1" && d_obj.value == "" && column_id != main_key && column_id != "LINE_NO" && column_id != "SORT_BY") {
                        col_text = dt.Rows[r]["COL_TEXT"];
                        if (col_visible == "1" && col_enable == "1") {
                            alert(col_text + getMsg("M0001"));
                            if (d_obj.type == "text") {
                                d_obj.style.backgroundColor = "#72f89d";
                                //d_obj.focus();
                            }
                            return -1;
                        }
                        //return -1 ;
                    }

                    var v = d_obj.value;
                    var if_change = false;
                    if (check_change(d_obj.id) == true) {
                        if_change = true;
                    }

                    if (column_id != "ENTER_USER" && column_id != "ENTER_DATE" &&
                               column_id != "MODI_USER" && column_id != "MODI_DATE" &&
                               column_id != "LOCK_USER" && column_id != "DATA_LOCK" &&
                               column_id != main_key && column_id != "SORT_BY" &&
                               column_id != "LINE_NO") {
                        var col_type = dt.Rows[r]["COL_TYPE"];
                        if (col_type == "") {
                            col_type = "char";
                        }

                        if (if_change == true) {
                            rowdata += column_id + "|" + v + data_index;

                        }
                        v = formatColumnData(col_type, v);
                        if (v != "null") {
                            insertsql_col += column_id + ",";
                            insertsql_value += v + ",";
                        }

                        if (if_change == true) {
                            updatesql += column_id + "=" + v + ",";

                        }

                    }
                    else {
                        /*主键*/
                        if (column_id == main_key) {
                            insertsql_col += column_id + ",";
                            insertsql_value += "'[MAIN_KEY]',";

                            if (v != main_key_value) {
                                updatesql += column_id + "='" + v + "',";

                            }

                            if (v != "" && v != "0") {
                                input_main_key_value = v;
                            }
                            rowdata += column_id + "|" + input_main_key_value + data_index;

                        }
                        else {
                            if (column_id == "ENTER_DATE") {
                                insertsql_col += column_id + ",";
                                insertsql_value += "sysdate,";
                            }
                            if (column_id == "SORT_BY") {
                                if (num > 0) {
                                    insertsql_col += column_id + ",";
                                    insertsql_value += "[SORT_BY],";
                                }
                                else {
                                    insertsql_col += column_id + ",";
                                    if (v == "") {
                                        v = "999999";
                                    }
                                    insertsql_value += "'" + v + "',";
                                    updatesql += column_id + "='" + v + "',";
                                }

                            }
                            if (column_id == "LINE_NO") {
                                if (num > 0) {
                                    insertsql_col += column_id + ",";
                                    insertsql_value += "[LINE_NO],";
                                }
                                else {
                                    insertsql_col += column_id + ",";
                                    insertsql_value += v + ",";
                                    updatesql += column_id + "='" + v + "',";
                                }

                            }
                            if (column_id == "ENTER_USER") {
                                insertsql_col += column_id + ",";
                                insertsql_value += "'" + a007_key + "',";
                            }
                            if (column_id == "MODI_USER") {
                                updatesql += column_id + "='" + a007_key + "',";
                            }
                            if (column_id == "MODI_DATE") {
                                updatesql += column_id + "=sysdate,";
                            }
                        }

                    }


                    break;
                }

            }



            str_v += "<A" + a10001_key + ">" + d_obj.value + "</A" + a10001_key + ">";
        }

        str_v += "</A" + key_ + ">";
        str_v += endformatxml();
        row[4] = rowdata;

    }
    /*执行检测的sql*/
    dt = a[5];
    for (var r = 0; r < dt.Rows.length; r++) {
        sql_ = dt.Rows[r]["COL10"];
        sql_ = replaceAll(sql_, "[rowList]", "///rowList///");
        sql_ = replaceAll(sql_, "{rowList}", "///rowList///");
        sql_ = replaceAll(sql_, "[rowlist]", "///rowList///");
        sql_ = replaceAll(sql_, "{rowlist}", "///rowList///");
        sql_ = replaceAll(sql_, "[A311_KEY]", "///A311_KEY///");
        sql_ = format_data(sql_, row[0]);
        sql_ = replaceAll(sql_, "///rowList///", row[4]);
        sql_ = replaceAll(sql_, "///A311_KEY///", "[A311_KEY]");
        check_sql[check_sql.length] = sql_;
    }



    var insertsql = insertsql_col.substr(0, insertsql_col.length - 1) + ")";
    insertsql_value = insertsql_value.substr(0, insertsql_value.length - 1);
    insertsql = insertsql + insertsql_value + " from dual ";
    updatesql = updatesql.substr(0, updatesql.length - 1) + row[9];


    deletesql = deletesql + row[9];
    if (row[2] == "I") {
        row[7] = insertsql;
    }

    if (row[2] == "M") {
        row[7] = updatesql;

    }
    if (row[2] == "D") {
        row[7] = deletesql;

    }
    if (a[7] != "T") {
        row[7] = "";
    }

    dt = a[6];
    for (var r = 0; r < dt.Rows.length; r++) {
        sql_ = dt.Rows[r]["COL10"];
        sql_ = replaceAll(sql_, "[rowList]", "///rowList///");
        sql_ = replaceAll(sql_, "{rowList}", "///rowList///");
        sql_ = replaceAll(sql_, "[rowlist]", "///rowList///");
        sql_ = replaceAll(sql_, "{rowlist}", "///rowList///");
        sql_ = replaceAll(sql_, "[A311_KEY]", "///A311_KEY///");
        sql_ = format_data(sql_, row[0]);
        sql_ = replaceAll(sql_, "///rowList///", row[4]);
        sql_ = replaceAll(sql_, "///A311_KEY///", "[A311_KEY]");
        after_sql[after_sql.length] = sql_;
    }
    rowList[num] = row;

    return 1;
}

/*检测数据有没有变化*/
function check_change(col_id) {
    var lb_change = false;
    for (var i = 0; i < changeobjList.length; i++) {
        if (changeobjList[i].id == col_id) {
            lb_change = true;
            break;
        }

    }
    return lb_change;

}


/*格式化*/
function formatColumnData(col_type, col_v) {
    if (col_v == "") {
        return "null";
    }
    var v = col_v;
    if (col_type == "char" || col_type == "varchar" || col_type == "text" || col_type == "varchar2") {
        v = "'" + replaceAll(col_v, "'", "''") + "'";
    }

    if (col_type == "int" || col_type == "decimal" || col_type == "number" || col_type == "numeric") {
        v = replaceAll(col_v, "'", "''");
    }
    if (col_type == "datetime" || col_type == "date") {
        v = "to_date('" + col_v + "','YYYY-MM-DD HH24:MI:SS')";
    }
    // col_v = replaceAll(col_v,'[',"××");
    return v;

}
function replaceAll(oldStr, findStr, repStr) {
    var srchNdx = 0;
    var newStr = "";
    if (oldStr == "" || oldStr == null) {
        return "";
    }
    while (oldStr.indexOf(findStr, srchNdx) != -1) {
        newStr += oldStr.substring(srchNdx, oldStr.indexOf(findStr, srchNdx));
        newStr += repStr;
        srchNdx = (oldStr.indexOf(findStr, srchNdx) + findStr.length);
    }
    newStr += oldStr.substring(srchNdx, oldStr.length);
    return newStr;
}
/*
显示列 根据   行 列


f_id   210_1_1  _210_1  A20001_KEY + row  +  A10001_KEY
option_  操作类型 
v_  当前列的值   
*/
function ShowColumn(option_, a20001_key, row, a10001_key, v_) {
    var colrowid = BasePage.getColumnRow(a20001_key, "A10001_KEY", a10001_key).value;
    if (colrowid == "-1") {
        colrowid = BasePage.getColumnRow(a20001_key, "COLUMN_ID", a10001_key).value;
    }
    var col_edit = BasePage.getColumnAtt(a20001_key, colrowid, "col_edit").value; //获取列的编辑方式
    var a10001_key_ = BasePage.getColumnAtt(a20001_key, colrowid, "A10001_KEY").value; //获取列的编辑方式
    if (col_edit == "") {
        col_edit = "u_edit";
    }
    col_edit = col_edit.toLowerCase();

    var colhtml = "";
    colhtml = column_u_edit("TXT_" + a20001_key + "_" + row + "_" + a10001_key_, a20001_key + "_" + row, v_);
    return colhtml;
}


function column_u_edit(id_, name_, value_) {
    var html_ = "<input  type=\"text\"  name=\"" + name_ + "\"  id=\"TXT_" + id_ + "\"/>";
    return html_;
}

function checkbox_onclick(cbx_obj, id_) {
    if (cbx_obj.value == "") {
        cbx_obj.value = "0";
    }

    if (cbx_obj.value == "1") {
        cbx_obj.value = "0";
    }
    else {
        cbx_obj.value = "1";
    }
    var obj = document.getElementById("TXT_" + id_);

    if (obj != null) {
        obj.value = cbx_obj.value;
        input_change(obj, id_);
    }

}
function datechange(obj) {
    //2011-01-01 10:22:22
    if (obj.value.length == 16) {
        obj.value = obj.value + ":00";
    }
    input_change(obj, obj.id.substr(4));
}
function input_clicke(obj_, id_, name) {
    var v = document.getElementById("TXT_" + id_).value;
    var html_ = "<table class=\"ShowTable\"><tr class=\"h\"><td>" + name + "</td></tr>";
    html_ += "<tr class=\"d\"><td><textarea id=\"div_" + id_ + "\" style=\"text-align:left; width:295px; height:200px;\">";
    html_ += v + "</textarea></td></tr><tr class=\"trbtn\"><td><div  class=\"d_bottom\">";
    html_ += "<input class=\"btn\" type=button value=\"确定\" onclick=\"SetItem('" + id_ + "', document.getElementById('div_" + id_ + "').value);rbclose();\"/>";
    html_ += "<input class=\"btn\" type=button value=\"取消\" onclick=\"rbclose()\"/></td></tr></table>";
    showsysrb = false;
    eventrbx = onclickevent.clientX;
    eventrby = onclickevent.clientY;
    alertWin("", html_, String(eventrbx) + "px", String(eventrby) + "px", "300px", "auto", false);
    setbtnenable("btn_save");
    document.getElementById('div_' + id_).focus();
}
//新增可以保存
function autoBeginSave() {
    //
    if (option == "I" && ISAVE == "1") {
        //设置可以保存
        var rowid_ = a002_key + "-0_0";
        var objs = document.getElementsByName(rowid_);
        for (var i = 0; i < objs.length; i++) {
            if (objs[i].id.indexOf("TXT_" + rowid_) == 0) {
                var line_no = objs[i].id.substr(rowid_.length + 1 + 4);
                input_change(objs[i], rowid_ + "_" + line_no)
                break;
            }
        }

    }
}
//数值发生变化的时候
function number_change(obj_, id_, col_len) {
    //吧数据格式化成现有的小数格式
    var v = toDecimal(obj_.value, col_len);
    obj_.value = v;
    input_change(obj_, id_);
}
function toDecimal(x, pos) {
    var f = parseFloat(x);
    if (isNaN(f)) {
        return '';
    }

    f = Math.round(x * Math.pow(10, pos)) / Math.pow(10, pos);
    return f;
}
//rb_onchange 选择
function rb_onchange(obj_, id_, v_, col_child_) {
    var txtobj = document.getElementById("TXT_" + id_);
    txtobj.value = v_;
    input_change(txtobj, id_);
}


//带长度限制的输入
function input_change_(obj_, id_, len_) {
    if (len_ > 0 && obj_.value.length > len_) {
        obj_.value = obj_.value.substr(0, len_);
    }
    input_change(obj_, id_);
}
//TXT_ 修改的记录修改的记录
function input_change(obj_, id_) {
    if (id_.substr(0, 1) == 'S') {
        //表示是当前页面的修改
        SetItem(id_.substr(1), obj_.value);
    }
    if (obj_.getAttribute("COLNAME") != null) {
        //记录信息
        var vlist = id_.split("_");
        var rownum = vlist[0] + "_" + vlist[1];
        QuerySaveChangeObj(obj_);

        var cbx_obj = document.getElementById("cbx_" + rownum);
        cbx_obj.checked = true;
        document.getElementById("R" + rownum).className = "r2";
        try {
            document.getElementById("L" + rownum).className = "r2";
        }
        catch (e) {

        }
    }
    else {

        setbtnenable('btn_save');
        SaveChangeObj(obj_);
        try {
            obj_.style.color = "red";
        }
        catch (e) {

        }
        if (obj_.value == "") {
            return;
        }
        itemchange(id_);
    }

}
function setfocus(id_) {
    try {
        document.getElementById(id).focus();
    }
    catch (e) {

    }
}
function checkifitemchange(id_) {
    try {
        var vlist = id_.split("_");
        var item = ',' + document.getElementById("itemchange_" + vlist[0]).value;
        if (item.indexOf(',' + vlist[2] + ',') >= 0) {
            return true;
        }
        return false;
    }
    catch (e) {
        return false;
    }

}

function itemchange(id_) {

    setbtnenable('btn_save');
    if_changeitem = "1";
    var c = checkifitemchange(id_);
    if (c == false) {
        return;
    }
    var parm = formatparm();
    var rowid_ = a002_key + "-0_0";
    var rowdata = "";
    var vlist = id_.split("_");

    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", vlist[0]);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "IFSHOW", "0");
    parm = addParm(parm, "REQID", "ITEMCHANGE");
    parm = addParm(parm, "MAINKEY", main_key);
    parm = addParm(parm, "COLID", vlist[2]);
    parm = addParm(parm, "ROWID", vlist[0] + "_" + vlist[1]);
    var rowlist__ = getRowdata(vlist[0] + "_" + vlist[1], "");
    parm = addParm(parm, "ROWLIST", rowlist__);
    if (option != "Q") {
        parm = addParm(parm, "MAINROWLIST", getRowdata(rowid_, ""));
    } else {
        parm = addParm(parm, "MAINROWLIST", rowlist__);
    }
    parm = parm + endformatparm();
    setbtndisable('btn_save');
    url = http_url + "/BaseForm/ItemChange.aspx?A00201KEY=" + vlist[0] + "&ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

    return;
    //判断当前列是否有影响的列 包含 计算 下拉   
    var vlist = id_.split("_");
    var a00201_key_ = vlist[0];
    var rownum = vlist[1];
    var col_line_no = vlist[2];
    /**/
    var a = get_a013010101(a00201_key_);
    var dr = get_a013010101_row(a[1], col_line_no);
    /*获取*/

    var bs_select_sql = dr["BS_SELECT_SQL"];

    var rowid = a00201_key_ + "_" + rownum;


    if (bs_select_sql != null && bs_select_sql.length > 10) {
        bs_select_sql = format_data(bs_select_sql, rowid);
        var bs_col_whither = dr["BS_COL_WHITHER"];
        var data = BasePage.getStrBySql(bs_select_sql).value;
        if (data == "") {
            var check_exist = dr["CHECK_EXIST"];
            if (check_exist == "1") {
                var bs_msg = dr["BS_MSG"];
                bs_msg = format_data(bs_msg, rowid);
                alert(bs_msg);
            }
        }
        else {
            var datalist = data.split("<V></V>");

            var collist = bs_col_whither.split(",");
            for (var i = 0; i < collist.length; i++) {
                this_col_ = replaceAll(collist[i], '[', '');
                this_col_ = replaceAll(this_col_, ']', '');
                if (this_col_ != col_line_no) {
                    if (datalist.length > i) {
                        SetItem(rowid + "_" + this_col_, datalist[i]);
                    }
                }
            }
        }
    }
    /*运行计算公式*/

    var bs_formula_num = dr["BS_FORMULA_NUM"];
    if (bs_formula_num != null && bs_formula_num.length > 5) {

        var i = 0;
        var pos1 = bs_formula_num.search('}');
        while (pos1 > 0 && i < 100) {

            f = get_data_by_index(bs_formula_num, '{', '}');

            bs_formula_num = bs_formula_num.substr(pos1 + 1);

            /*解析数据
            */
            var pos2 = f.search("=");
            f_v = f.substr(1, pos2 - 2);
            f_sql = f.substr(pos2 + 1);
            f_sql = format_data(f_sql, rowid);
            f_sql = "Select " + f_sql + " as c from dual ";

            var data = BasePage.getStrBySql(f_sql).value;
            var datalist = data.split("<V></V>");
            if (datalist.length > 0) {
                SetItem(rowid + "_" + f_v, datalist[0]);
            }

            pos1 = bs_formula_num.search("}");
            i = i + 1;
        }
    }


}
function get_data_by_index(data_, index1_, index2_) {
    var pos1 = data_.search(index1_);
    if (pos1 < 0) {
        return "";
    }
    var pos2 = data_.search(index2_);
    if (pos2 < 0) {
        return "";
    }
    if (pos1 > pos2) {
        return "";
    }
    return data_.substring(pos1 + 1, pos2);

}
function ChooseAll(obj) {
    var name_ = obj.name;
    var objs_ = document.getElementsByName(name_);
    for (var i = 0; i < objs_.length; i++) {
        if (objs_[i] != obj) {
            objs_[i].checked = obj.checked;
        }
    }
}
function chooseselects(rowid_, colid_) {
    var objs_ = document.getElementsByName("con" + colid_);
    var c = 0;
    var vlist = "";
    var if_main = false;
    if (rowid_ == a002_key + "-0_0") {
        if_main = true;
        vlist = document.getElementById("TXT_" + rowid_ + "_" + colid_).value;
        if (vlist != "" && vlist != null) {
            if (vlist.substr(vlist.length - 1, 1) != ',') {
                vlist = vlist + ",";
            }
        }
        vlist = "";
    }
    for (var i = 0; i < objs_.length; i++) {
        if (objs_[i].checked == true && objs_[i].id.indexOf("con" + colid_) == 0) {
            if (c == 0) {
                id_ = rowid_ + "_" + colid_;
                if (if_main == false) {
                    SetItem(id_, objs_[i].value);
                    itemchange(id_);
                }
                else {
                    if (vlist.indexOf(objs_[i].value + ",") < 0) {
                        vlist += objs_[i].value + ",";
                    }
                }
            }
            else {
                if (if_main == false) {
                    var a00201_key_ = rowid_.split("_")[0];
                    var newrowid = AddRow(a00201_key_);
                    id_ = newrowid + "_" + colid_;
                }
                v = "";
                try {
                    v = objs_[i].value;

                }
                catch (e) {
                    v = "";
                }

                if (v != "") {

                    if (if_main == false) {
                        SetItem(id_, v);
                        itemchange(id_);
                    }
                    else {
                        if (vlist.indexOf(v + ",") < 0) {
                            vlist += v + ",";
                        }
                    }
                }


            }
            c = c + 1;
        }
    }
    //主档多选
    if (if_main == true) {
        rbclose();
        id_ = rowid_ + "_" + colid_;
        SetItem(id_, vlist);
    }

}
function chooseselect(id_, v) {
    rbclose();
    SetItem(id_, v);
    itemchange(id_);
}

var queryobj = null;


function showchoose(obj) {
    var id_ = replaceAll(obj.id, 'img_choose', '');
    var vlist = id_.split("_");
    var a00201_key_ = vlist[0];
    var rownum = vlist[1];
    var col_line_no = vlist[2];
    var parm = formatparm();
    var rowid_ = a002_key + "-0_0";
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", a00201_key_);
    parm = addParm(parm, "KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "ROWID", vlist[0] + "_" + vlist[1]);
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "DIVID", "CHOOSEDIV");
    parm = addParm(parm, "REQID", "SHOW");
    parm = addParm(parm, "MAINKEY", main_key);
    parm = addParm(parm, "COLID", vlist[2]);
    var rowlist__ = getRowdata(vlist[0] + "_" + vlist[1], "");
    parm = addParm(parm, "ROWLIST", rowlist__);
    if (option == "Q") {
        parm = addParm(parm, "MAINROWLIST", rowlist__);
    }
    else {
        parm = addParm(parm, "MAINROWLIST", getRowdata(rowid_, ""));
    }

    parm = parm + endformatparm();
    queryobj = obj;
    queryobj.style.disabled = true;
    alertshow(http_url + "/BaseForm/BaseQuery.aspx?ver=" + getClientDate(), 'querydiv', parm);
    return;

    var a = get_a013010101(a00201_key_);
    var dr = get_a013010101_row(a[1], col_line_no);
    /*获取*/
    var bs_choose_sql = dr["BS_CHOOSE_SQL"];
    var rowid = a00201_key_ + "_" + rownum;
    bs_choose_sql = format_data(bs_choose_sql, rowid);

    var v = BasePage.setSession("BS_CHOOSE_SQL", bs_choose_sql).value;
    var table_select = dr["TABLE_SELECT"];
    var result_rows = dr["RESULT_ROWS"];
    var col_exist = dr["COL_EXIST"];
    var col_text = dr["COL_TEXT"];
    if (result_rows != "1") {
        result_rows = "0";
    }

    var url = http_url + "\\ShowForm\\ChooseData.aspx?rowscount=500&col_exist=" + col_exist + "&title=选择" + col_text + "数据&table_id=" + table_select + "&result_rows=" + result_rows + "&code=" + Math.random() * 100000;

    var splashWin = showDialog(url, 50, 30, false, window);
    if (splashWin != undefined) {
        var ifset = 0;
        var DataId = splashWin.DataId;
        var dlist = DataId.split("<V></V>");
        for (var i = 0; i < dlist.length; i++) {
            var value = dlist[i];
            if (value != "") {
                if (ifset > 0) {
                    rowid = AddRow(a00201_key_);
                    SetItem(rowid + "_" + col_line_no, value);
                    itemchange(rowid + "_" + col_line_no);
                }
                else {
                    SetItem(rowid + "_" + col_line_no, value);
                    itemchange(rowid + "_" + col_line_no);
                }
                ifset = ifset + 1;
            }
        }

    }


}
//把sql 或者公式中的变量转换为当前页面中得数据
function format_data(sql_, rowid) {


    var v_Sql_ = replaceAll(sql_, "[MAIN_KEY]", '{MAIN_KEY}'); //菜单 
    v_Sql_ = replaceAll(v_Sql_, "[USER_ID]", a007_key); //用户
    v_Sql_ = replaceAll(v_Sql_, "[MENU_ID]", a002_key); //菜单

    v_Sql_ = replaceAll(v_Sql_, "'['", "'{'"); //菜单
    v_Sql_ = replaceAll(v_Sql_, "']'", "'}'"); //菜单
    /*读取是否有[MAIN_ */
    var pos1 = v_Sql_.indexOf("[MAIN_");
    var v_left = "";
    var v_right = "";
    var col_line_no = "";

    while (pos1 >= 0) {
        v_left = v_Sql_.substr(0, pos1);
        v_right = v_Sql_.substr(pos1 + 6);
        pos2 = v_right.indexOf("]");
        col_line_no = v_right.substr(0, pos2);
        v_right = v_right.substr(pos2 + 1);
        /*获取列的值 TXT_1012-0_0_4*/
        obj = document.getElementById("TXT_" + a002_key + '-0_0_' + col_line_no);
        if (obj != null) {
            v_Sql_ = v_left + obj.value + v_right;
        }
        else {
            v_Sql_ = v_left + v_right;
        }
        pos1 = v_Sql_.indexOf("[MAIN_");
    }

    pos1 = v_Sql_.indexOf("[");
    while (pos1 >= 0) {
        v_left = v_Sql_.substr(0, pos1);
        v_right = v_Sql_.substr(pos1 + 1);
        pos2 = v_right.indexOf("]");
        col_line_no = v_right.substr(0, pos2);
        v_right = v_right.substr(pos2 + 1);
        obj = document.getElementById("TXT_" + rowid + '_' + col_line_no);
        if (obj != null) {
            v_Sql_ = v_left + obj.value + v_right;
        }
        else {
            v_Sql_ = v_left + v_right;
        }
        pos1 = v_Sql_.indexOf("[");
    }
    v_Sql_ = replaceAll(v_Sql_, "{MAIN_KEY}", '[MAIN_KEY]'); //菜单
    v_Sql_ = replaceAll(v_Sql_, "'{'", "'['"); //菜单
    v_Sql_ = replaceAll(v_Sql_, "'}'", "']'"); //菜单

    return v_Sql_;

}

function get_a013010101_row(dt_, line_no_) {
    return;

    for (var i = 0; i < dt_.Rows.length; i++) {
        var line_ = dt_.Rows[i]["LINE_NO"];
        if (line_ == line_no_) {
            return dt_.Rows[i];
        }
    }
    return '';
}

function SaveChangeObj(obj_) {
    var if_exist = "0";
    for (var i = 0; i < changeobjList.length; i++) {
        if (changeobjList[i].id == obj_.id) {
            if_exist = "1";
            break;
        }
    }
    var len = changeobjList.length;
    if (if_exist == "0") {
        changeobjList[len] = obj_;
    }

    setRowChange(obj_);
}
function QuerySaveChangeObj(obj_) {
    var if_exist = "0";
    for (var i = 0; i < changeobjList.length; i++) {
        if (changeobjList[i].id == obj_.id) {
            if_exist = "1";
            break;
        }
    }
    var len = changeobjList.length;
    if (if_exist == "0") {
        changeobjList[len] = obj_;
    }
}

function update0() {


    if (main_key_value < 0) {
        return;
    }

    /*根据当前的表的数据 判断是否是新增 */
    /*解析列表的控件修改列*/

    var check = "0";
    var after_sql_ = new Array();
    after_sql = after_sql_;


    var check_sql_ = new Array();
    check_sql = check_sql_;

    for (var i = 0; i < rowList.length; i++) {
        check = CheckData(i);

        if (check < 0) {
            return;
        }
    }


    var main_key = main_key_value;
    //0 新增    
    var line_no_ = 0;
    if (option == "I") {
        //从序列中取数据


        main_key = BasePage.getMenuKey(a002_key).value;
        if (main_key == "0" || main_key == "") {
            //获取当前界面生成的KEY  
            main_key = input_main_key_value;
        }
    }

    clearlineno();

    var str_v = ""; // formatxml() ;

    var sql_count = 0;
    for (var i = 0; i < rowList.length; i++) {

        var sql__ = replaceAll(rowList[i][7], '[MAIN_KEY]', main_key);
        sql__ = sql__.replace('[SORT_BY]', i);
        if (i > 0) {
            if (sql__.indexOf("Insert Into") == 0) {
                line_no_ = getlineno(rowList[i][10], main_key);
                sql__ = sql__.replace('[LINE_NO]', line_no_);
            }
        }
        if (sql__.length > 10) {
            sql_count = sql_count + 1;
            str_v += sql__ + "<EXECSQL></EXECSQL>";
        }

    }

    /*执行校验*/
    for (var i = 0; i < check_sql.length; i++) {
        sql_ = replaceAll(check_sql[i], '[MAIN_KEY]', main_key);
        data = BasePage.getStrBySql(sql_).value;
        if (data == "") {
            alert(getMsg("M0002"));
            return;

        }
        else {
            data = data.split('<V></V>')[0];
            if (data != "1") {
                alert(data);
                return;
            }
        }
    }
    /*执行保存*/

    for (var i = 0; i < after_sql.length; i++) {
        sql__ = replaceAll(after_sql[i], '[MAIN_KEY]', main_key);
        str_v += sql__ + "<EXECSQL></EXECSQL>";
        sql_count = sql_count + 1;
    }

    if (sql_count == 0) {
        alert(getMsg("M0015"));
        return;
    }
    //table_id_ in varchar2 ,main_key_  in varchar ,key_ in varchar2, user_id_ in varchar2
    if (option == 'I') {
        sql__ = "pkg_a.update_a009('" + rowList[0][8] + "','" + main_key + "','" + rowList[0][5] + "','[USER_ID]')";
        str_v += sql__ + "<EXECSQL></EXECSQL>";
    }
    if (IFA309 == "1") {
        var check__ = BasePage.checkA309(input_main_key_value, a002_key).value;
        if (check__ != "1") {
            alert(check__);
            return;

        }
        //
        var reason_ = "变更原因";
        var res = BasePage.doA309(str_v, input_main_key_value, a002_key, reason_).value;

        doNext(res);
        return;
    }

    var res = BasePage.doXml(str_v, main_key).value;

    if (res.indexOf(getMsg("M0008")) >= 0) {

        alert(getMsg("M0007"));
        if (input_main_key_value != main_key_value) {
            if (main_key_value != 0) {
                var str = document.referrer;
                location.href = str;
            }
            else {
                url_ = location.href;
                if (option == "I") {
                    url_ = url_.replace("&key=0", "&key=" + main_key);
                    url_ = url_.replace("&option=I", "&option=M");
                }

                location.href = url_;
            }
        }
        else {
            var src = parent.location.href.toLowerCase();
            if (if_showDialog == "0") {
                location.reload();
            }
            else {
                window.close();
            }
        }
        return;
        url_ = location.href;
        if (option == "I") {
            url_ = url_.replace("&key=0", "&key=" + main_key);
            url_ = url_.replace("&option=I", "&option=M");
        }
        else {
            location.reload();
        }

    }
    else {
        if (if_showDialog == "0") {
            doNext(res);
            return;
        }
        else {
            window.close();
        }

    }
    main_key_value = main_key;
}
function showurl(url__, target_) {
    var url_ = replaceAll(url__, '[HTTP_URL]', http_url);
    if (target_ == "_self") {
        location.href = url_;
    }
    else {

        window.open(url_);
    }

}
//日期的编辑方式




function show_page(a00201_key_, pagecount_) {
    pagenum = parseFloat(document.getElementById("showpagenum").value);
    if (pagenum > pagecount_ || pagenum < 1) {
        alert("请输入正确的页码！");
        return;
    }
    showquerypage(a00201_key_, pagenum);
}

function showquerypage(a20001_key_, pagenum) {

    var v = BasePage.showPageNum(a20001_key_, pagenum).value;
    doNext(v);
}

/*查询 a20001_key_ 的数据*/
function query(a00201_key_) {

    /*获取当前选择的已经的查询的值*/

    var select_obj = document.getElementById("query_select");

    var query_id = select_obj.options[select_obj.selectedIndex].value;

    if (query_id.length > 0) {
        //alert(v)
        var DataId = query_id;
        var v = BasePage.setSession("IF_JUMP", "0").value;
        var con = BasePage.getCondition(DataId, a00201_key_).value;
        v = BasePage.setSession("CON_" + a00201_key_, con).value;
        v = BasePage.setSession("QUERYID_" + a00201_key_, DataId).value;
        v = BasePage.showPageNum(a00201_key_, "1").value;
        url = location.href;
        url = replaceAll(url, '&IF_JUMP=1', '&IF_JUMP=0');
        location.href = url;
        return;
    }

    /*读取当前的条件的值*/
    var objs = document.getElementsByName("TXT_" + a00201_key_);
    var str_v = formatxml();
    for (var i = 0; i < objs.length; i++) {
        var a10001_key = objs[i].id.replace("TXT_" + a00201_key_ + "_", "");
        if (objs[i].value != "") {
            str_v += "<CON>" + a10001_key + "=" + objs[i].value + "</CON>";

        }

    }
    str_v += endformatxml();
    v = BasePage.getShowCondition(a00201_key_, str_v).value;
    url = location.href;
    url = replaceAll(url, '&IF_JUMP=1', '&IF_JUMP=0');
    location.href = url;

}
function showdetailv(a00201_key_, key_, rowid) {
    url = http_url + "\\ShowForm\\MainForm.aspx?option=V&ROWID=" + rowid + "&A002KEY=" + a002_key + "&key=" + key_ + "&A00201KEY=" + a00201_key_;

    var str_v = get_row_value(rowid);

    var v = BasePage.setSession("SHOW_DATA", str_v).value;
    var splashWin = showDialog(url, 70, 30, false, window);
}


window.onload = function onLoginLoaded() {
    if (isPostBack == "False") {
        GetLastUser();
    }
}

function GetLastUser() {
    var id = "49BAC005-7D5B-4231-8CEA-16939BEACD67"; //GUID标识符  
    var usr = GetCookie(id);
    if (usr != null) {
        document.getElementById('user').value = usr;
    }
    else {
        document.getElementById('user').value = "WTL";
    }
    GetPwdAndChk();
}
//点击登录时触发客户端事件  
function SetPwdAndChk() {
    //取用户名  
    var usr = document.getElementById('user').value;
    alert(usr);
    //将最后一个用户信息写入到Cookie  
    SetLastUser(usr);
    //如果记住密码选项被选中  
    if (document.getElementById('Remeber_PassWord').checked == true) {
        //取密码值  
        var pwd = document.getElementById('pass').value;
        alert(pwd);
        var expdate = new Date();
        expdate.setTime(expdate.getTime() + 14 * (24 * 60 * 60 * 1000));
        //将用户名和密码写入到Cookie  
        SetCookie(usr, pwd, expdate);
    }
    else {
        //如果没有选中记住密码,则立即过期  
        ResetCookie();
    }
}
function SetLastUser(usr) {
    var id = "49BAC005-7D5B-4231-8CEA-16939BEACD67";
    var expdate = new Date();
    //当前时间加上两周的时间  
    expdate.setTime(expdate.getTime() + 14 * (24 * 60 * 60 * 1000));
    SetCookie(id, usr, expdate);
}
//用户名失去焦点时调用该方法  
function GetPwdAndChk() {
    var usr = document.getElementById('user').value;
    var pwd = GetCookie(usr);
    if (pwd != null) {
        document.getElementById('Remeber_PassWord').checked = true;
        document.getElementById('pass').value = pwd;
    }
    else {
        document.getElementById('Remeber_PassWord').checked = false;
        document.getElementById('pass').value = "";
    }
}
//取Cookie的值  
function GetCookie(name) {
    var arg = name + "=";
    var alen = arg.length;
    var clen = document.cookie.length;
    var i = 0;
    while (i < clen) {
        var j = i + alen;
        //alert(j);  
        if (document.cookie.substring(i, j) == arg) return getCookieVal(j);
        i = document.cookie.indexOf(" ", i) + 1;
        if (i == 0) break;
    }
    return null;
}
var isPostBack = "<%= IsPostBack %>";
function getCookieVal(offset) {
    var endstr = document.cookie.indexOf(";", offset);
    if (endstr == -1) endstr = document.cookie.length;
    return unescape(document.cookie.substring(offset, endstr));
}
//写入到Cookie  
function SetCookie(name, value, expires) {
    var argv = SetCookie.arguments;
    //本例中length = 3  
    var argc = SetCookie.arguments.length;
    var expires = (argc > 2) ? argv[2] : null;
    var path = (argc > 3) ? argv[3] : null;
    var domain = (argc > 4) ? argv[4] : null;
    var secure = (argc > 5) ? argv[5] : false;
    document.cookie = name + "=" + escape(value) + ((expires == null) ? "" : ("; expires=" + expires.toGMTString())) + ((path == null) ? "" : ("; path=" + path)) + ((domain == null) ? "" : ("; domain=" + domain)) + ((secure == true) ? "; secure" : "");
}
function ResetCookie() {
    var usr = document.getElementById('user').value;
    var expdate = new Date();
    SetCookie(usr, null, expdate);
}  


function showdetail(a00201_key_, key_, rowid) {
    url = http_url + "\\ShowForm\\MainForm.aspx?option=M&ROWID=" + rowid + "&A002KEY=" + a002_key + "&key=" + key_ + "&A00201KEY=" + a00201_key_;

    var str_v = get_row_value(rowid);

    var v = BasePage.setSession("SHOW_DATA", str_v).value;
    var splashWin = showDialog(url, 70, 30, false, window);
    /*读取返回的值 并且把值写到对应的 行中*/
    if (splashWin != undefined) {
        var DataId = splashWin.DataId;
        //把返回的 changeobjList 写入到当前行中


        var vlist = DataId.split("<V></V>");
        for (var i = 0; i < vlist.length; i++) {
            var pos = vlist[i].indexOf("=");
            if (pos <= 0) {
                break;
            }
            var a10001_key = vlist[i].substring(0, pos);
            var v = vlist[i].substring(pos + 1);
            SetItem(rowid + "_" + a10001_key, v)

        }

    }
}
function SetEnable(id_, enable_) {
    var obj = document.getElementById("TXT_" + id_);
    if (obj == null)
        return;
    if (obj.type == "text") {
        if (enable_ == "0") {
            obj.disabled = true;
            //    obj.style.backgroundColor = "#CCCCCC";
        } else {
            obj.disabled = false;
            // obj.style.backgroundColor = "";
        }
    }
    var check_obj = document.getElementById("CBX_" + id_);
    if (check_obj != null) {
        if (enable_ == "0") {
            check_obj.disabled = true;
        } else {
            check_obj.disabled = false;
        }

    }
    var ddd_obj = document.getElementById("DDD_" + id_);

    if (ddd_obj != null) {
        if (enable_ == "0") {
            ddd_obj.disabled = true;
        } else {
            ddd_obj.disabled = false;
        }
    }
    var img_choose_obj = document.getElementById("img_choose" + id_);
    if (img_choose_obj != null) {
        if (enable_ == "0") {
            img_choose_obj.style.display = "none";
        }
        else {
            img_choose_obj.style.display = "";
        }
    }

}
function SetItem(id_, v__) {
    var obj = document.getElementById("TXT_" + id_);
    var v_ = replaceAll(v__, "<BR>", "\n");
    if (obj != null) {
        if (obj.value != v_) {
            if (obj.type == "text") {
                obj.style.color = "red";
            }
            else {

                var div_obj = document.getElementById("div_" + id_);
                if (div_obj != null) {
                    var s_inn = div_obj.innerHTML;
                    if (s_inn == "" || obj.value == "")
                    { div_obj.innerHTML = v_; }
                    else {
                        div_obj.innerHTML = replaceAll(s_inn, obj.value, v_);
                    }
                }

                var td_obj = document.getElementById("d_" + id_);

                if (td_obj != null) {
                    td_obj.style.backgroundColor = "red";
                }

            }
            SaveChangeObj(obj);
        }
        obj.value = v_;
    }

    var check_obj = document.getElementById("CBX_" + id_);
    if (check_obj != null) {
        if (v_ == "1") {
            check_obj.checked = true;
            check_obj.value = "1";
        }
        else {
            check_obj.checked = false;
            check_obj.value = "0";
        }
    }

    var ddd_obj = document.getElementById("DDD_" + id_);

    if (ddd_obj != null) {
        var selLength = ddd_obj.options.length;

        //将所有Option放入array
        for (var i = 0; i < selLength; i++) {
            if (ddd_obj.options.item(i).value == v_) {
                ddd_obj.options[i].selected = true;
                break;
            }
        }
    }
    var rb_obj = document.getElementsByName("rb_" + id_);

    //将所有Option放入array
    for (var i = 0; i < rb_obj.length; i++) {
        if (rb_obj.value == v_) {
            rb_obj.value.checked = true;

        }
        else {
            rb_obj.value.checked = false;
        }
    }

}
function show_Dialog(url, dw, dh, modeless, args) {
    var url_ = "ShowDialog.aspx?url=" + encodeURIComponent(url + "&dialog=1");

    showDialog(url_, dw, dh, modeless, args);
}

function showDialog(url, dw, dh, modeless, args) {
    if (typeof (args) == "undefined") args = window;
    var r;
    if (modeless)
        r = window.showModelessDialog(url + "&dialog=1", args, "dialogWidth:" + dw + ";dialogHeight:" + dh + ";center:yes;edge:raised;help:no;resizable:yes;scroll:yes;status:no;");
    else
        r = window.showModalDialog(url + "&dialog=1", args, "dialogWidth:" + dw + ";dialogHeight:" + dh + ";center:yes;edge:raised;help:no;resizable:no;scroll:yes;status:no;");
    return r;
}
/**
* 删除左右两端的空格
*/
function trim(str) {
    return str.replace(/(^\s*)|(\s*$)/g, "");
}
/**
* 删除左边的空格


*/
function ltrim(str) {
    return str.replace(/(^\s*)/g, "");
}
/**
* 删除右边的空格


*/
function rtrim(str) {
    return str.replace(/(\s*$)/g, "");
}
//读取父级窗口的值


function get_parent_value(rowid, PARENTROWID) {
    var v = BasePage.getSession("SHOW_DATA").value;
    var vlist = v.split("<V></V>");
    for (var i = 0; i < vlist.length; i++) {
        var pos = vlist[i].indexOf("=");
        if (pos <= 0) {
            break;
        }
        var a10001_key = vlist[i].substring(0, pos);
        var v = vlist[i].substring(pos + 1);
        SetItem(rowid + "_" + a10001_key, v);

    }

}
function get_row_value(rowid) {
    var x = document.getElementsByName(rowid);
    var str_v = "";

    for (var i = 0; i < x.length; i++) {
        if (x[i].id.indexOf("TXT_" + rowid) == "0") {
            str_v += x[i].id.replace("TXT_" + rowid + "_", "") + "=" + x[i].value + "<V></V>";
        }

    }
    return str_v;
}

function set_parent_value(rowid) {
    /*获取当前的*/
    var v_v = new Object();
    str_v = "";
    for (var i = 0; i < changeobjList.length; i++) {

        var a10001_key = changeobjList[i].id.replace("TXT_" + rowid + "_", "");
        str_v += a10001_key + "=" + changeobjList[i].value + "<V></V>";

    }


    v_v.DataId = str_v;
    v_v.Para = window.dialogArguments;
    window.returnValue = v_v;
    window.close();


}

/*
明细添加行


*/
function s_replace(str_data, old_str, new_str) {

    while (str_data.indexOf(old_str) >= 0) {
        str_data = str_data.replace(old_str, new_str);
    }

    return str_data;

}

function get_a013010101(a00201_key) {

    for (var i = 0; i < a013010101.length; i++) {
        var temp_ = a013010101[i];
        if (temp_[0] == a00201_key) {
            if (temp_[1] == "") {
                temp_[1] = BasePage.getdtData(a00201_key, "P1").value;
            }
            if (temp_[5] == "") {
                temp_[5] = BasePage.getdtData(a00201_key, "P5").value;
            }
            if (temp_[6] == "") {
                temp_[6] = BasePage.getdtData(a00201_key, "P6").value;
            }
            if (temp_[7] == "") {
                temp_[7] = BasePage.getPData(a00201_key, "P7").value;
                temp_[7] = temp_[7].substr(0, 1);
            }
            if (temp_[8] == "") {
                temp_[8] = BasePage.getdtData(a00201_key, "P8").value;
            }
            a013010101[i] = temp_;
            return a013010101[i];
            break;
        }
    }
    return "";
}

/*判断输入的数据和数据类型是否匹配*/
function input_onBlur(obj, col_type) {

}
function gjquery(a00201_key_) {
    var url = http_url + "/ShowForm/querycondition.aspx?A00201KEY=" + a00201_key_ + "&code=" + Math.random() * 100000;
    var splashWin = showDialog(url, 50, 30, false, window);
    /*读取返回的值 并且把值写到对应的 行中*/
    if (splashWin != undefined) {
        var DataId = splashWin.DataId;
        var v = BasePage.setSession("IF_JUMP", "0").value;
        var con = BasePage.getCondition(DataId, a00201_key_).value;
        v = BasePage.setSession("CON_" + a00201_key_, con).value;
        v = BasePage.setSession("QUERYID_" + a00201_key_, DataId).value;
        v = BasePage.showPageNum(a00201_key_, "1").value;
        url = location.href;
        url = replaceAll(url, '&IF_JUMP=1', '&IF_JUMP=0');
        location.href = url;
    }

}
function clearshowtab() {

    var obj_ = document.getElementsByName("load_list");
    for (var i = 0; i < obj_.length; i++) {
        obj_[i].value = "0";
    }
    var old_ = old_showtab;
    old_showtab = "0";
    showtab(old_);
}
var old_showtab = "0";
function showtab(a00201_key_) {
    if (old_showtab == a00201_key_) {
        return;
    }
    var obj_ = document.getElementById("load_" + a00201_key_);
    if (obj_ != null) {
        if (obj_.value == "0") {
            obj_.value = "1";
            if (window.execScript) {
                window.execScript(obj_.title, "JavaScript");
            } else {
                window.eval(obj_.title);
            }
        }
    }
    var old_div = document.getElementById("show_" + old_showtab);
    if (old_div != null) {
        old_div.style.display = "none";
        document.getElementById("tab_" + old_showtab).className = "tab_";
    }

    var new_div = document.getElementById("show_" + a00201_key_);
    if (new_div != null) {
        new_div.style.display = "";
        document.getElementById("tab_" + a00201_key_).className = "tab_select";
    }
    old_showtab = a00201_key_;

}
function selectDate_m(obj) {
    SelectDate(obj, 'yyyy-MM-dd');
    // setDay(obj);

}
function selectDateTime_m(obj) {
    //  SelectDate(obj, 'yyyy-MM-dd hh:mm:ss');
    setDayHM(obj);

}
function endrowbyfrom(rowid_) {
    // 获取生成的head的div
    var parm = formatparm();
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", rowid_.split("_")[0]);
    var rowdata = getRowdata(rowid_, "");
    parm = addParm(parm, "KEY", rowdata);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "ROWID", rowid_);
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "IFSHOW", "1");
    parm = parm + endformatparm();
    alertshow(http_url + "/BaseForm/Head.aspx?ver=" + getClientDate(), 'alertdiv', parm);
}
function ddd_onchange(obj_, id_, col_child) {

    obj_txt = document.getElementById("TXT_" + id_);
    obj_txt.value = obj_.options[obj_.selectedIndex].value;
    input_change(obj_txt, id_);
}
function color_change(obj_, id_) {
    try {
        select_color(obj_, id_);
    }
    catch (e) {
        input_change(obj_, id_);
    }
}

function selectDate_m0(obj) {
    SelectDate(obj, 'yyyy-MM-dd');
}

var div_parm = new Array();
function alertDiv(tt, list_) {
    div_parm = list_;

    var QtyDiv = document.getElementById("div_show");
    if (QtyDiv != null) {
        document.body.removeChild(QtyDiv);
    }


    QtyDiv = document.createElement("div");
    QtyDiv.id = "div_show";
    QtyDiv.onmouseleave = function () {
        DivClose();
    };
    var ttop = tt.offsetTop;     //TT控件的定位点高


    var thei = tt.clientHeight;  //TT控件本身的高
    var tleft = tt.offsetLeft;    //TT控件的定位点宽



    while (tt = tt.offsetParent) { ttop += tt.offsetTop; tleft += tt.offsetLeft; }
    var moveTop = ttop + thei + 15;  //parseInt(pointerY_VS());
    var moveLeft = tleft;  // parseInt(pointerX_VS());
    var moveheight = 130 + (list_.length - 3) * 20;


    QtyDiv.style.position = "absolute";
    QtyDiv.style.setAttribute("zIndex", "201");
    QtyDiv.style.setAttribute("backgroundColor", "#EFEFEF");
    QtyDiv.style.setAttribute("Font", "10pt");
    QtyDiv.style.setAttribute("width", 150);
    QtyDiv.style.setAttribute("left", tleft);
    QtyDiv.style.setAttribute("top", ttop + 25);
    html_ = "<table width=\"100%\">";

    for (var i = 2; i < list_.length - 1; i++) {
        n = list_[i];
        n = n.replace("[SHOW_", "");
        n = n.replace("]", "");
        html_ += "<tr><td style=\"height:20px;vertical-align:middle;\"  align=\"left\" valign=\"top\">";
        html_ += "<span style=\"float:left;margin:10px 0 0 5px;\">" + n + ":</span>";
        html_ += "<input type='text' value=\"1\" id='input_" + i + "' style='width:70px;float:left;margin:7px 0 0 0px;vertical-align:middle;' /></td></tr>";

    }

    //          张数：</em><input type='text' value=\"1\" id='qty" + key_ + "' style='width: 90px;float:left;margin:7px 0 0 0px;vertical-align:middle;' /></td></tr>"
    html_ += "<tr><td  style=\"height:20px;Color:blue;\"  align=\"left\" valign=\"top\"><input type='button' value='确定' onclick=\"divdo()\"    style='width:60px;float:left;margin:7px 0 0 0px;cursor:pointer;' />";
    html_ += "<input type='button' value='取消' onclick=\"DivClose()\"    style='width:60px;float:left;margin:7px 0 0 0px;cursor:pointer;' /></td></tr>";
    html_ += "</table>";

    QtyDiv.innerHTML = html_;
    document.body.appendChild(QtyDiv);
    document.getElementById("input_2").focus();

}
function divdo() {
    //获取
    //div_parm  
    var str_v = div_parm[div_parm.length - 1];

    for (var i = 2; i < div_parm.length - 1; i++) {
        obj = document.getElementById("input_" + i);
        str_v = replaceAll(str_v, div_parm[i], obj.value);

    }
    var menu_id_ = div_parm[0];
    var line_no_ = div_parm[1];
    var v = BasePage.dolistA00204(str_v, menu_id_, line_no_).value;
    doNext(v);


}


function DivClose() {
    var div_show = document.getElementById("div_show");
    if (div_show != null) {
        document.body.removeChild(div_show);
    }

}
function do_proc(key_, menu_id_, line_no_, obj) {

    var plist0 = new Array();
    var str_v = formatxml();
    if (key_ == '[LIST]') {
        var objs = document.getElementsByName("cbx_row");
        for (var i = 0; i < objs.length; i++) {
            if (objs[i].checked == true) {
                rowid = objs[i].id.substr(7);
                v = document.getElementById("v_" + rowid).value;
                vlist = v.split(";");
                for (var j = 0; j < vlist.length; j++) {
                    plist = vlist[j].split(",");
                    if (plist[0] == line_no_) {
                        plist0[plist0.length] = vlist[j];
                    }
                }
            }
        }

        if (plist0.length == 0) {
            return false;
        }

        var show_list = new Array();
        show_list[0] = menu_id_;
        show_list[1] = line_no_;

        var str_vv = "";
        for (var i = 0; i < plist0.length; i++) {
            /*过滤line_no*/
            str_vv = "";
            vv = plist0[i].split(",");
            for (var j = 1; j < vv.length; j++) {
                if (vv[j] != null && vv[j] != "") {
                    str_vv += vv[j] + ",";
                    if (i == 0 && vv[j].indexOf("SHOW_") >= 0) {
                        show_list[show_list.length] = vv[j];
                    }
                }
            }
            str_v += "<ROW><PARM>" + str_vv + "</PARM></ROW>";
        }
        str_v += endformatxml();
        show_list[show_list.length] = str_v;

        if (show_list.length > 3) {
            alertDiv(obj, show_list);
        }
        else {
            var v = BasePage.dolistA00204(str_v, menu_id_, line_no_).value;
            doNext(v);
        }

    }
    else {
        var v = BasePage.doA00204(key_, menu_id_, line_no_).value;
        doNext(v);

    }



    // alert(plist0.length)



}
function selectdetailrow(trid, lb_selected) {
    var obj = document.getElementById("R" + trid);


    if (obj != null && (obj.tagName == "tr" || obj.tagName == "TR")) {

        if (lb_selected == true) {
            obj.style.backgroundColor = "#46AACC";
            obj = document.getElementById("L" + trid);
            if (obj != null)
                obj.style.backgroundColor = "#46AACC";

        }
        else {
            obj.style.backgroundColor = "";
            obj = document.getElementById("L" + trid);
            if (obj != null)
                obj.style.backgroundColor = "";
        }
    }
}

function cbx_selectall(obj, a00201_key_) {
    var objs = document.getElementsByName("cbx_" + a00201_key_);
    // alert(objs.length)
    for (var i = 0; i < objs.length; i++) {

        if (obj.value == "0") {
            objs[i].checked = true;
            selectdetailrow(objs[i].id.substr(4), true);
        }
        else {
            objs[i].checked = false;
            selectdetailrow(objs[i].id.substr(4), false);
        }
    }

    if (obj.value == "0") {
        obj.value = "1"
    }
    else {
        obj.value = "0";
    }

}
function DelRow0(a00201_key_) {
    var objs = document.getElementsByName("cbx_" + a00201_key_);

    for (var i = 0; i < objs.length; i++) {
        if ((objs[i].id != "cbx_" + a00201_key_) && (objs[i].id != "cbx_" + a00201_key_ + "_[ROW]")) {
            if (objs[i].checked == true) {
                rowid = objs[i].id.substr(4);
                setrowiddeleteed(rowid);

            }
        }
    }


}

function setrowiddeleteed(rowid_) {

    for (var i = 0; i < rowList.length; i++) {
        if (rowList[i][0] == rowid_) {

            if (rowList[i][2] == "I") {
                rowList[i][3] = "0"; //如果是新增行删除 设置不变化


            }
            if (rowList[i][2] == "M") {
                rowList[i][2] = "D"; //设置删除
                rowList[i][3] = "1"; //如果是新增行删除 设置不变化


            }

            tr_obj = document.getElementById("R" + rowid_);

            if (tr_obj != null) {
                tr_obj.style.display = "none";
            }
        }

    }

}

function showxls(a00201_key_) {
    show_loading();
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", a00201_key_);
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "DOWNXLS");
    parm = addParm(parm, "MAINKEY", "");
    parm = addParm(parm, "KEY", "");
    parm = addParm(parm, "ROWID", "");
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key_ + "&ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

}
function showa013(a00201_key_) {
    var url = http_url + "/ShowForm/A013.aspx?A002ID=" + a00201_key_.split("-")[0] + "&code=" + Math.random() * 100000;

    var splashWin = showDialog(url, 60, 40, false, window);

    location.reload();

}
function showa100(a00201_key_) {
    var url = http_url + "/ShowForm/A100.aspx?A002ID=" + a00201_key_.split("-")[0] + "&code=" + Math.random() * 100000;

    var splashWin = showDialog(url, 60, 40, false, window);

    location.reload();
}

function selectrow(obj, class1, class2) {
    if (obj.className == class1) {
        obj.className = class2;
    }
    else {
        obj.className = class1;
    }

}

function loadfile(table_id_, line_no_, id_) {

    //必须先保存再
    if (changeobjList.length > 0) {
        alert("请先保存数据！");
        return;

    }
    //主键     
    var vlist = id_.split("_");
    var basekey_ = 'rowid'
    //客户
    var key_ = document.getElementById('objid_' + vlist[0] + "_" + vlist[1]).value;
    key_ = replaceAll(key_, '+', '-');
    var url = http_url + "\\showform\\uploadfile.aspx?basekey=" + key_ + "&table_id=" + table_id_ + "&line_no=" + line_no_ + "&key_id=" + key_ + "&code=" + Math.random() * 100000;

    var splashWin = showDialog(url, 50, 30, false, window);
    if (splashWin != undefined) {
        location.reload();
    }

}
function bill_sp(obj, table_id_, key__, if_tg) {
    //审批不通过 输入不同的原因

    var des_ = "";
    if (if_tg == "1") {
        html_ = "<table width=\"100%\">";
        html_ += "<tr><td>请输入原因</td></tr>";

        html_ += "<tr><td><textarea  style=\"width:100%;\"  rows=\"3\"    id=\"sp_des\" value=\"\"/></textarea></td></tr>";
        html_ += "<tr><td><input type=\"button\" value=\"确定\" onclick=\"bill_sp_1('" + table_id_ + "','" + key__ + "')\"></td></tr>";
        html_ += "</table>";
        alert_div(obj, html_);
        return;
    }
    var v = BasePage.userdosp(main_key_value, table_id_, if_tg, des_, key__).value;
    doNext(v);

}
function bill_do(obj, table_id_, key___) {
    var des_ = "";
    html_ = "<table width=\"100%\">";
    html_ += "<tr><td>备注</td></tr>";
    html_ += "<tr><td><textarea  style=\"width:100%;\"  rows=\"3\"    id=\"sp_des\" value=\"\"/></textarea></td></tr>";
    html_ += "<tr><td><input type=\"button\" value=\"确定\" onclick=\"bill_sp_1('" + table_id_ + "','" + key___ + "')\"></td></tr>";
    html_ += "</table>";
    //  alert_div(obj,html_); 
    alert_rbdiv(obj, html_, 'sp_des', 250, event.x, event.y);
}

function bill_sp_1(table_id_, key__) {
    var des_ = document.getElementById("sp_des").value;
    DivClose();
    var v = BasePage.userdosp(main_key_value, table_id_, '1', des_, key__).value;
    doNext(v);
}

function showtaburl(url, menu_id) {
    var url_ = replaceAll(url, '[HTTP_URL]', http_url);
    try {
        parent.parent.main.showtaburl(url_, menu_id);
    }
    catch (ex) {
        window.open(url_);
    }
}
function showtabwindow(url_, menu_id_, con_) {
    showtaburl(url_, menu_id_);

}
function getMsg(msg_id) {
    var v = BasePage.getMsg(msg_id).value;

    return v;
}
/*
$("body").click(function(){
try
{
$("#div_show").hide();
}
catch (e)
{
return false ;
}
});*/
function alert_rbdiv(tt, html_, focus_obj_id_, twidth_, x_, y_) {
    currtr = 0;
    var QtyDiv = document.getElementById("div_show");
    if (QtyDiv != null) {
        document.body.removeChild(QtyDiv);
    };
    QtyDiv = document.createElement("div");
    QtyDiv.id = "div_show";
    QtyDiv.onmouseleave = function () {
        DivClose();
    };
    QtyDiv.innerHTML = html_;
    document.body.appendChild(QtyDiv);
    var twidth = twidth_;
    var ttop = y_;
    var thei = 0;
    var tleft = x_;
    if ((tleft + twidth) > document.body.clientWidth) {
        tleft = tleft - twidth;
    }

    var moveTop = ttop + thei;
    var moveLeft = tleft;
    var moveheight = 20;
    /*
    QtyDiv.style.position="absolute";
    QtyDiv.style.setAttribute("zIndex","201");
    QtyDiv.style.setAttribute("backgroundColor","#ffffff");
    QtyDiv.style.setAttribute("Font","10pt");*/
    if (twidth > 0) {
        $("#div_show").css("width", twidth);
        //QtyDiv.style.setAttribute("width",twidth);
    }
    $("#div_show").css({ "left": tleft, "top": ttop });
    /*QtyDiv.style.setAttribute("left",tleft);
    QtyDiv.style.setAttribute("top",ttop );*/

    obj = document.getElementById(focus_obj_id_);
    if (obj != null) {
        document.getElementById(focus_obj_id_).focus();
    }
    moverb("UP");
    var rightedge = document.body.clientWidth - x_;
    var bottomedge = document.body.clientHeight - y_;
    if (rightedge < QtyDiv.offsetWidth)
        QtyDiv.style.left = document.body.scrollLeft + x_ - QtyDiv.offsetWidth;
    else
        QtyDiv.style.left = document.body.scrollLeft + x_;
    var top_ = 0;
    if (bottomedge < QtyDiv.offsetHeight)
        top_ = document.body.scrollTop + y_ - QtyDiv.offsetHeight;
    else
        top_ = document.body.scrollTop + y_;
    if (top_ < 0)
        top_ = 0;
    QtyDiv.style.top = top_;
}
function doa014(tt, a014_id_, objid_, table____) {

    var v = BasePage.DoA014(a014_id_, objid_, table____).value;
    doNext(v);
}
function doqueryrb(tt, a014_id_, objid_, table____) {
    var objs = document.getElementsByName("cbx_row");
    var rowList = new Array();
    var rowdata = "";
    var myJSONText = "";
    for (var i = 0; i < objs.length; i++) {

        rowdata = "";
        if (objs[i].checked == true) {
            rowid = objs[i].id.substr(7);
            v = document.getElementById("objid_" + rowid).value;
            rowdata += "OBJID|" + v + data_index;
            for (var k = 0; k < changeobjList.length; k++) {
                if (changeobjList[k].id.indexOf("_" + rowid + "_") > 0) {
                    // if (obj_.getAttribute("COLNAME") != null)
                    colname = changeobjList[k].getAttribute("COLNAME");
                    v = changeobjList[k].value;
                    rowdata += colname + "|" + v + data_index;
                }
            }

            myJSONText += rowdata + "<V></V>";


        }

    }
    var v = BasePage.DoA014Query(a014_id_, myJSONText, table____).value;
    doNext(v);
}
function showrbwindow(tt, a014_id_, objid_, table____) {
    var url = http_url + "\\ShowForm\\Dchild.aspx?ROWID=" + objid_ + "&A014ID=" + a014_id_ + "&code=" + Math.random() * 100000;
    var splashWin = showDialog(url, 70, 30, false, window);
    if (splashWin != undefined) {
        try {
            var ifset = 0;
            var DataId = splashWin.DataId;
            if (DataId != "0") {
                doNext(DataId);
            }
        }
        catch (e) {
            location.reload();
        }
    }
}





function get_sysdate() {
    var a = new Date();
    var y = a.getYear() + "-";
    var m = a.getMonth() + "-";
    var d = a.getDay() + " ";
    var h = a.getHours() + ":";
    var x = a.getMinutes() + ":";
    var s = a.getSeconds() + ".";
    var ms = a.getMilliseconds();
    return y + m + d + h + x + s + ms;
}

//用户设置列宽
function ShowA016(a00201_key_, divid) {
    var parm = formatparm();
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", a00201_key_);
    parm = addParm(parm, "KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "ROWID", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "DIVID", divid);
    parm = addParm(parm, "REQID", "INPUT");
    parm = parm + endformatparm();
    alertshow(http_url + "/BaseForm/ChangeA016.aspx?ver=" + getClientDate(), 'querydiv', parm);
}


function QueryData(a00201_key_, divid) {
    var parm = formatparm();
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", a00201_key_);
    parm = addParm(parm, "KEY", main_key_value);
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "ROWID", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "DIVID", divid);
    parm = addParm(parm, "REQID", "INPUT");
    parm = parm + endformatparm();
    alertshow(http_url + "/BaseForm/BaseQuery.aspx?ver=" + getClientDate(), 'querydiv', parm);
}

document.onkeydown = function (oEvent) {
    basekeydown(oEvent);
}
function basekeydown(oEvent) {
    if (!oEvent) oEvent = window.event;

    if (oEvent.keyCode == 13) {
        if ((location.pathname.toLowerCase() == "/login.aspx" || location.pathname == "/")) {
            userlogin();
            return;
        }
        if (document.getElementById("query_id_submit") != null) {
            obj = document.getElementById("query_id_submit");
            obj.click();
            return;
        }
        if (document.getElementById("query_btnshow") != null) {
            obj = document.getElementById("query_btnshow");
            obj.click();
            return;
        }
    }
    //ESC
    if (oEvent.keyCode == 27) {
        if (document.getElementById("query_btnshow") != null) {
            rbclose();
            return;
        }
        if (document.getElementById("query_id_submit") != null) {
            rbclose();
            return;
        }
    }

    if (oEvent.ctrlKey) {
        if (oEvent.keyCode == 83) {
            if (location.pathname.toLowerCase().indexOf('mainform.aspx') > 0) {
                if (document.getElementById("btn_save").disabled == true) {
                    return;
                }
                update();
                return;
            }
        }

    }




    source = event.srcElement;
    if (if_showDialog == "0") {
        if (oEvent.keyCode == 8) {
            if (source.tagName.toLowerCase() == "input" || source.tagName.toLowerCase() == "textarea") {
                return true;
            }
            else {
                return false;
            }
        }
    }



    var vlist = source.id.split("_");
    if (vlist.length == 4) {

        switch (oEvent.keyCode) {
            case 27:
                try
                { tiannetHideControl(); }
                catch (e) { }
            case 39:
                return true;
                var id = vlist[1] + "_" + String(parseFloat(vlist[2]));
                obss = $("[name='" + id + "']:text");
                for (var i = 0; i < obss.length; i++) {
                    if (obss[i].id == source.id) {
                        if (i + 1 < obss.length) {
                            try {
                                id = obss[i + 1].id;
                            }
                            catch (e)
                            { }
                        }
                        break;
                    }
                }
                obj_ = document.getElementById(id);
                if (obj_ != null) {
                    $("#" + id).focus();
                    $("#" + id).select();
                    return false;
                }
                break;
            case 37:
                return true;
                var id = vlist[1] + "_" + String(parseFloat(vlist[2]));
                obss = $("[name='" + id + "']:text");
                for (var i = 0; i < obss.length; i++) {
                    if (obss[i].id == source.id) {
                        if (i - 1 >= 0) {
                            try {
                                id = obss[i - 1].id;
                            }
                            catch (e)
                            { }
                        }
                        break;
                    }
                }
                obj_ = document.getElementById(id);
                if (obj_ != null) {
                    $("#" + id).focus();
                    $("#" + id).select();
                    return false;
                }

                break;

            case 38:
                var id = vlist[0] + "_" + vlist[1] + "_" + String(parseFloat(vlist[2]) - 1) + "_" + vlist[3];
                var obj_ = document.getElementById(id);
                if (obj_ != null) {
                    $("#" + id).focus();
                    $("#" + id).select();
                }
                else {
                    id = vlist[0] + "_" + vlist[1] + "_" + String(parseFloat(vlist[2]) - 2) + "_" + vlist[3];
                    obj_ = document.getElementById(id);
                    if (obj_ != null) {
                        $("#" + id).focus();
                        $("#" + id).select();
                    }
                }
                break;
            case 40:
                var id = vlist[0] + "_" + vlist[1] + "_" + String(parseFloat(vlist[2]) + 1) + "_" + vlist[3];
                var obj_ = document.getElementById(id);
                if (obj_ != null) {
                    $("#" + id).focus();
                    $("#" + id).select();
                }
                else {
                    id = vlist[0] + "_" + vlist[1] + "_" + String(parseFloat(vlist[2]) + 2) + "_" + vlist[3];
                    obj_ = document.getElementById(id);
                    if (obj_ != null) {
                        $("#" + id).focus();
                        $("#" + id).select();
                    }
                }
                break;
            default:
                break;
        }
    }
}
function setbtnenable(id) {
    var btn = document.getElementById(id);
    if (btn != null) {
        btn.disabled = false;
    }
}
function setbtndisable(id) {
    var btn = document.getElementById(id);
    if (btn != null) {
        btn.disabled = true;
    }
}
function showrbdetail(obj, count_) {
    if (obj.value == "0") {
        obj.value = "1";
        for (var i = 0; i < count_; i++) {
            document.getElementById(obj.id + String(i)).style.display = "";
        }
    }
    else {
        obj.value = "0";
        for (var i = 0; i < count_; i++) {
            document.getElementById(obj.id + String(i)).style.display = "none";
        }
    }




}
function QueryById(a00201_key__, divid) {
    var select_obj = document.getElementById("Select_query_0");
    var query_id = select_obj.options[select_obj.selectedIndex].value;
    loaddetail(a002_key, a00201_key__, main_key_value, "Q", "0", "1", query_id);

}
var clicktr;

document.onmouseup = function (oEvent) {
    baseonmouseup(oEvent);

}

function baseonmouseup(oEvent) {
    if (!oEvent) oEvent = window.event;
    source = oEvent.srcElement;
    if (source == null) {
        source = oEvent.target;
    }
    if (allrepcount != 0) {
        return false;
    }
    //任意点击时关闭该控件

    if (source.tagName != "INPUT" && source.getAttribute("Author") != "tiannet") {
        try {
            tiannetHideControl();
        }
        catch (e)
            { }
    }

    if (clicktr != null) {
        var rcbx = document.getElementById("CBX_" + clicktr.id.substr(1));
        if (rcbx != null && rcbx.type.toLowerCase() == "checkbox") {
            selectdetailrow(clicktr.id.substr(1), rcbx.checked);
        }
        else {
            clicktr.style.backgroundColor = "";
        }
    }
    onclickevent = oEvent;
    try {
        if (source.id.length > 4) {
            if (source.id.toUpperCase().indexOf("CBX_") == 0 && source.type.toLowerCase() == "checkbox") {
                vlist = source.id.split("_");
                if (source.checked == false) {
                    selectdetailrow(vlist[1] + "_" + vlist[2], true);
                }
                else {
                    selectdetailrow(vlist[1] + "_" + vlist[2], false);
                }


            }
            if (source.id.toUpperCase().indexOf("CBX_") == 0) {

                if ((source.disabled == null || source.disabled == false)) {
                    if (source.id.indexOf("CBX_ALL_") == 0) {
                        //全选
                        vlist = source.id.split("_");
                        a00201_key__ = vlist[2];
                        a10001_key__ = vlist[3];
                        if_b = false;
                        //var trobj = document.getElementById("R_" + id_);.
                        for (var i = 0; i < 5000; i++) {
                            id_ = a00201_key__ + "_" + String(i) + "_" + a10001_key__;
                            objtxt = document.getElementById("TXT_" + id_);
                            if (objtxt != null) {
                                if_b = true;
                                obj_cbx = document.getElementById("CBX_" + id_);
                                if (obj_cbx != null && (obj_cbx.disabled == null || obj_cbx.disabled == false)) {
                                    if (source.checked == true) {
                                        objtxt.value = "0";
                                        obj_cbx.checked = false;
                                    } else {
                                        objtxt.value = "1";
                                        obj_cbx.checked = true;
                                    }
                                    input_change(objtxt, id_);
                                }

                                //SetItem(id_, objtxt.value);
                            }
                            else {
                                if (if_b == true) {
                                    break;
                                }
                            }

                        }

                    }
                    else {
                        id_ = source.id.substr(4);
                        objtxt = document.getElementById("TXT_" + id_);
                        if (source.checked == true) {
                            objtxt.value = "0";
                        } else {
                            objtxt.value = "1";
                        }
                        input_change(objtxt, id_);
                    }
                }
            }
        }
        if (oEvent.button == 2 && if_showDialog == "0") {
            //source = event.srcElement;
            document.body.style.cursor = 'wait';
            createrb(source);

            document.body.style.cursor = '';
        }
        if (oEvent.button != 2 && if_showDialog == "0" && source.type != "text") {
            var tr_select = get_select_tr(source);
            if (tr_select != null) {
                var old_c = tr_select.style.backgroundColor;
                if (option == "Q") {
                    var trv = "";
                    try {
                        trv = tr_select.getAttribute("value");
                        op = tr_select.getAttribute("op");
                        if (op == "Q") {
                            showline(trv);
                        }
                    }
                    catch (e) {

                    }
                }
                if (old_c != "") {
                    if (old_c.toLowerCase().indexOf("rgb") >= 0) {
                        old_c = String(old_c.colorHex());
                    }

                }

                if (old_c.toLowerCase() == "#ffccff") {
                    tr_select.style.backgroundColor = "";
                    if (tr_select.id.indexOf("R") == 0) {
                        id = "L" + tr_select.id.substr(1);
                        var trobj_ = document.getElementById(id);
                        if (trobj_ != null) {
                            trobj_.style.backgroundColor = "";
                        }
                    }
                    if (tr_select.id.indexOf("L") == 0) {
                        id = "R" + tr_select.id.substr(1);

                        var trobj_ = document.getElementById(id);
                        if (trobj_ != null) {
                            trobj_.style.backgroundColor = "";
                        }
                    }
                }
                else {
                    tr_select.style.backgroundColor = "#ffccff";
                    if (tr_select.id.indexOf("R") == 0) {
                        id = "L" + tr_select.id.substr(1);
                        var trobj_ = document.getElementById(id);
                        if (trobj_ != null) {
                            trobj_.style.backgroundColor = "#ffccff";
                        }
                    }
                    if (tr_select.id.indexOf("L") == 0) {
                        id = "R" + tr_select.id.substr(1);
                        var trobj_ = document.getElementById(id);
                        if (trobj_ != null) {
                            trobj_.style.backgroundColor = "#ffccff";
                        }
                    }
                }
            }

        }

        if (source.id == "bgdiv" || source.id == "rbdiv") {
            if (document.getElementById("alerttitle") == null) {
                rbclose();
            }
        }
    }
    catch (e) {
    }
}
function get_select_tr(ttid) {
    var tt = ttid;
    var rbtype = "";
    var selecttr = null;

    while (tt = tt.parentElement) {
        if (selecttr == null && (tt.tagName == "TR" || tt.tagName == "TABLE")) {
            if (tt.id.indexOf("R") == 0 || tt.id.indexOf("L") == 0) {
                selecttr = tt;
            }
        }
    }
    if (selecttr == null) {
        return null;
    }

    return selecttr;

}

function checkrb(ttid) {
    var tt = ttid;
    var rbtype = "";
    var selecttr = null;

    while (tt = tt.parentElement) {
        if (selecttr == null && (tt.tagName == "TR" || tt.tagName == "TABLE")) {
            if (tt.id.indexOf("R") == 0 || tt.id.indexOf("L") == 0) {
                if (tt.id.indexOf("L") == 0) {
                    tt.style.backgroundColor = "#66CCFF";
                    tt = document.getElementById("R" + tt.id.substr(1));
                }
                if (tt.id.indexOf("R") == 0) {
                    if (document.getElementById("L" + tt.id.substr(1)) != null) {
                        document.getElementById("L" + tt.id.substr(1)).style.backgroundColor = "#66CCFF";
                    }
                }
                selecttr = tt;
                clicktr = selecttr;
                if (clicktr != null) {
                    clicktr.style.backgroundColor = "#66CCFF";
                }
            }
        }
    }
    if (selecttr == null) {
        return null;
    }

    return selecttr;
}


function createrb(ttid) {
    //获取A00201_KEY
    var selecttr = checkrb(ttid);
    if (selecttr == null) {
        showsysrb = true;
        return;
    }
    var obj = document.getElementById('objid_' + selecttr.id.substr(1));
    var objid = "";
    if (obj != null) {
        objid = obj.value;
    }
    var rowid = selecttr.id.substr(1);
    var a00201_key__ = rowid.split("_")[0];
    if (rowid.indexOf("S") == 0) {
        return false;
    }




    if (option == "Q") {
        //获取选中的行name="cbx_<%=a00201_key %>"
        var objs = document.getElementsByName("cbx_" + a00201_key__);
        rowid = "";
        selectedrowlist = "";
        for (var i = 0; i < objs.length; i++) {
            if (objs[i].checked == true && objs[i].id.indexOf('[ROW]') <= 0 && objs[i].id.substr(4) != a00201_key__) {
                rowid = rowid + objs[i].id.substr(4) + ",";
                var obj_obj = document.getElementById("objid_" + objs[i].id.substr(4));
                if (obj_obj != null) {
                    selectedrowlist = selectedrowlist + obj_obj.value + ",";
                }

            }
        }

        creatrbdiv(a00201_key__, objid, rowid, option);
    }
    else {
        var save_obj = document.getElementById("btn_save")
        if (if_changeitem == "1" && save_obj != null && changeobjList.length > 0) {
            if (save_obj.disabled == false) {
                alert("请先保存修改的数据！")
                return;
            }
        }
        var objs = document.getElementsByName("cbx_" + a00201_key__);
        var rowid__ = "";
        selectedrowlist = "";
        for (var i = 0; i < objs.length; i++) {
            if (objs[i].checked == true && objs[i].id.indexOf('[ROW]') <= 0 && objs[i].id.substr(4) != a00201_key__) {
                var obj_obj = document.getElementById("objid_" + objs[i].id.substr(4));
                rowid__ = rowid__ + objs[i].id.substr(4) + ",";
                if (obj_obj != null) {
                    selectedrowlist = selectedrowlist + obj_obj.value + ",";
                }

            }
        }
        selectedrowidlist = rowid__;
        creatrbdiv(a00201_key__, objid, rowid, option);
    }


}
//保存用户属性
function savea016_(a00201_key_) {




}

function set_alter_rowlist(obj, get_row, req_id_, column_) {
    var objs = document.getElementsByName(req_id_);
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].type == "radio") {
            var value_ = data_index + objs[i].value;
            if (value_.indexOf(data_index + get_row + data_index) >= 0) {
                //赋值
                var v_ = ""; //当前值
                if (obj.tagName.toLowerCase() == "select") {
                    v_ = obj.options[obj.options.selectedIndex].value
                }
                else {
                    v_ = obj.value;
                }
                //var id = objs[i].id.replace("T_ALTER","");
                var id = column_;
                objs[i].value = setColValue_rowlist(value_, id, v_);
            }
        }
    }
}
function setColValue_rowlist(rowlist_, id_, v_) {
    var new_rowlist_ = rowlist_;
    var pos = new_rowlist_.indexOf(data_index + id_ + "|");
    if (pos < 0) {
        return new_rowlist_;
    }
    else {
        var l = new_rowlist_.substr(0, pos + 1);
        var r = new_rowlist_.substr(pos + (data_index + id_ + "|").length);
        var pos1 = r.indexOf(data_index);
        new_rowlist_ = l + id_ + "|" + v_ + data_index + r.substr(pos1 + 1);

    }

    return new_rowlist_;
}

function doDes(req_id_, rowid, objid_, a00201_key__) {
    setbtndisable("btn_doDes");
    setbtndisable("btn_doDes_c");
    var objs = document.getElementsByName(req_id_);

    var v = "OBJID|" + objid_ + data_index;
    var ifs = 0;
    for (var i = 0; i < objs.length; i++) {
        var cid = objs[i].id.substr(2);

        if (objs[i].type == "radio") {
            if (objs[i].checked == true) {
                ifs = 1;
                v += objs[i].value;
                break;
            }
        }
        else {
            if (objs[i].tagName.toLowerCase() == "textarea" || objs[i].type.toLowerCase() == "hidden") {
                v += cid + "|" + objs[i].value + data_index;
                ifs = 1;
            }
        }
    }
    if (ifs == 0) {
        return;
    }
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "EXEC");
    parm = addParm(parm, "MAINKEY", req_id_);
    parm = addParm(parm, "KEY", v);
    parm = addParm(parm, "DOMAINKEY", main_key_value);
    parm = addParm(parm, "OBJID", objid_);
    parm = addParm(parm, "ROWID", rowid);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key__ + "&ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);
    rbclose();
}
function getPwidth() {
    var h = 0;
    if (if_showDialog == "1") {
        h = parseFloat(window.dialogWidth) - 20;
    }
    else {
        try {
            h = parent.getframeWidth();
        }
        catch (e) {
            h = window.screen.availWidth - window.screenLeft - 200;
        }
    }
    return h;

}
function set_mainquery(html_) {
    try {
        h = parent.set_query_html_(location.href, html_);
    }
    catch (e) {
    }
}
function query_select(select_obj_, old_key_) {

    var v = select_obj_.options[select_obj_.selectedIndex].value;
    if (v != "" && v != main_key_value) {
        change_url_key(main_key_value, v);
    }

}
function change_url_key(oldkey_, newkey_) {
    var v = $("#showquery_" + a002_key + "-0").html();
    set_mainquery(v);
    var url = location.href;
    var vvv_ = "";
    try {
        vvv_ = "&KEY=" + oldkey_.toUpperCase();
    }
    catch (e) {
        vvv_ = "&KEY=" + main_key_value.toUpperCase();
    }
    var pos = url.toUpperCase().indexOf(vvv_);
    if (pos > 0) {
        var r = url.substr(pos + ("&KEY=" + oldkey_).length);
        pos1 = r.indexOf("&");
        if (pos1 > 0) {
            r = r.substr(pos1 + 1);
            url = url.substr(0, pos) + "&KEY=" + newkey_ + "&" + r;
        }
        else {
            url = url.substr(0, pos) + "&KEY=" + newkey_;
        }
    }
    location.href = url;

}
function get_mainquery() {
    var h = "";
    try {
        h = parent.get_query_html_(location.href);

        $("#showquery_" + a002_key + "-0").html(h);
        return h;
    }
    catch (e) {

    }

    return "";
}

function clear_mainquery() {

    try {
        h = parent.clear_query_html_(location.href);
        return h;
    }
    catch (e) {

    }
}
function reload_tree() {
    if (option != "I") {
        try {
            var url_ = http_url + "/BaseForm/BaseTree.aspx?A00201KEY=&ver=" + getClientDate();
            var parm = formatparm();
            parm = addParm(parm, "A00201KEY", a002_key + "-0");
            parm = addParm(parm, "OPTION", option);
            parm = addParm(parm, "VER", "");
            parm = addParm(parm, "URL", location.href);
            parm = addParm(parm, "REQID", "TREE");
            parm = addParm(parm, "MAINKEY", main_key_value);
            parm = addParm(parm, "KEY", main_key_value);
            parm = addParm(parm, "DOMAINKEY", main_key_value);
            parm = addParm(parm, "TREEID", '[TREEID]');
            parm = parm + endformatparm();
            url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a002_key + "-0&ver=" + getClientDate();
            h = parent.ref_tree(location.href, url_, parm, a002_key);
        }
        catch (e) {
        }
    }
}
function Show_mainTree(width_, key__) {
    havetree = "1";
    if (option != "I") {
        try {
            var url_ = http_url + "/BaseForm/BaseTree.aspx?A00201KEY=&ver=" + getClientDate();
            var parm = formatparm();
            parm = addParm(parm, "A00201KEY", a002_key + "-0");
            parm = addParm(parm, "OPTION", option);
            parm = addParm(parm, "VER", "");
            parm = addParm(parm, "URL", location.href);
            parm = addParm(parm, "REQID", "TREE");
            parm = addParm(parm, "MAINKEY", key__);
            parm = addParm(parm, "KEY", key__);
            parm = addParm(parm, "DOMAINKEY", main_key_value);
            parm = addParm(parm, "TREEID", "[TREEID]");
            parm = parm + endformatparm();
            url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a002_key + "-0&ver=" + getClientDate();
            h = parent.Set_tree(width_, url_, location.href, parm, a002_key);
        }
        catch (e) {
        }
    }

}

function getPheight() {
    var h = 0;
    if (if_showDialog == "1") {
        h = parseFloat(window.dialogHeight) - 60;
    }
    else {
        try {
            h = parent.getframeheight();
        }
        catch (e) {
            h = window.screen.availHeight - window.screenTop - 130;
        }
    }
    return h;


}
function getCfgValue(id_) {
    var v = "";
    try {
        v = parent.GetCfg(id_);
    }
    catch (e) {
        v = "";
    }
    return v;
}

function checkidexist(id) {
    var obj = document.getElementById(id);
    if (obj != null) {
        return true;
    }
    return false;
}
function showcon(obj_, obj_id_, h) {
    var obj = document.getElementById("div_con");
    if (obj != null) {
        if (obj.style.display == "none") {
            obj.style.display = "";
            obj_.value = "隐藏条件";
            //document.getElementById(obj_id_).style.height = h + "px";
        }
        else {
            obj.style.display = "none";
            obj_.value = "显示条件";
            obj___ = document.getElementById(obj_id_);
            // obj___.style.height = "310px";
        }
    }
}
function showdataquery(conid, sql_, rs_, w, rowid__, col_, treecon_) {
    var objs = document.getElementsByName(conid);
    var vlist = "";
    var calalist = "";
    for (var i = 0; i < objs.length; i++) {
        //获取关系的值
        var v__ = objs[i].value;
        var select_obj = document.getElementById("CALC" + objs[i].id.substr(4));
        var cala = "LIKE";
        if (select_obj != null) {
            var cala = select_obj.options[select_obj.selectedIndex].value;
            if (cala == "" || cala == null) {
                cala = "LIKE";
            }
        }
        calalist += "C" + String(i) + "|" + cala + data_index;
        vlist += String(i) + "|" + v__ + data_index;
    }
    vlist = vlist + calalist;
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "SHOWQUERYDATA");
    parm = addParm(parm, "MAINKEY", sql_);
    parm = addParm(parm, "KEY", vlist);
    parm = addParm(parm, "DIVID", "alert_" + conid);
    parm = addParm(parm, "RESULTROWS", rs_);
    sw_ = "500";
    //显示结果行数
    if (document.getElementById("SHOWROWS_" + conid) != null) {
        sw_ = document.getElementById("SHOWROWS_" + conid).value;
    }
    parm = addParm(parm, "SHOWROWS", sw_);
    parm = addParm(parm, "WIDTH", w);
    parm = addParm(parm, "ROWID", rowid__);
    parm = addParm(parm, "COLID", conid.substr(3));
    parm = addParm(parm, "COLNAME", col_);
    parm = addParm(parm, "TREECON", treecon_);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/HtmlReq.aspx?A00201KEY=&ver=" + getClientDate();
    FunGetHttp(url, "alert_" + conid, parm);
}

document.write("<a id=\"showwinurl\" style=\"display:none;\" target=\"\"  href=\"\" ></a>");
function openwin(url, tar_) {
    var tmp = window.open(url, "newwindow", "status=no,toolbar=no,menubar=no,resizable=yes");
    //tmp.moveTo(0, 0);
    //tmp.focus();
    //tmp.location = url;
}
function rbshowdata(querytxt, divid, rowdata) {
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", "");
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "SHOWRBDATA");
    parm = addParm(parm, "MAINKEY", rowdata);
    parm = addParm(parm, "KEY", document.getElementById(querytxt).value);
    parm = addParm(parm, "DIVID", divid);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/HtmlReq.aspx?A00201KEY=";
    FunGetHttp(url, divid, parm);

}
function savea016_(a00201_key_) {

    var objs = document.getElementsByName("value" + a00201_key_);
    var column_data = new Array();
    for (var i = 0; i < objs.length; i++) {
        var id = objs[i].id.substr(2);
        var type = objs[i].id.substr(0, 1);
        var col_v = objs[i].value;
        //可用 E 可见 V      //WS宽度 //X 顺序
        if (type == "E" || type == "V") {
            if (objs[i].checked == true) {
                col_v = "1";
            }

        }



        var if_exist = false;
        for (var j = 0; j < column_data.length; j++) {
            if (column_data[j][0] == id) {
                if_exist = true;
                column_data[j][1] = column_data[j][1] + type + "|" + col_v + data_index;
                break;
            }
        }
        if (if_exist == false) {
            var this_data = new Array();
            this_data[0] = id;
            this_data[1] = "A00201_KEY" + "|" + a00201_key_ + data_index + "COLUMN_ID" + "|" + id + data_index + type + "|" + col_v + data_index;
            column_data[column_data.length] = this_data;
        }

    }


    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", a00201_key_);
    parm = addParm(parm, "OPTION", "");
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "SAVEA016");
    parm = parm + "<ROWDATA>";
    for (var j = 0; j < column_data.length; j++) {
        parm = parm + "<ROW>";
        parm = parm + column_data[j][1];
        parm = parm + "</ROW>";
    }
    parm = parm + "</ROWDATA>";
    parm = addParm(parm, "MAINKEY", a00201_key_);
    parm = addParm(parm, "KEY", a00201_key_);
    parm = addParm(parm, "DIVID", "div_req");
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key_ + "&ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

}

function showleft__(a00201_key_) {
    var obj = document.getElementById("showl_" + a00201_key_);
    if (obj.value == "1") {
        obj.value = "0";
        document.getElementById("imgsl_" + a00201_key_).src = http_url + "/images/22.png";
    }
    else {
        document.getElementById("imgsl_" + a00201_key_).src = http_url + "/images/21.png";
        obj.value = "1";
    }
    setdetailheight(a00201_key_);
}
function set_width_() {
    if (ifshowend == true) {
        if (a002_key.indexOf("-0") > 0) {
            setdetailheight(a002_key);
        }
        else {
            setdetailheight(a002_key + "-0");
        }
    }
}
function add_tree(a00201_key_, tree_key_, rowid, treenode_) {

    var t_obj = document.getElementById("T" + a00201_key_);
    var tr_obj = document.getElementById("R" + a00201_key_ + "_[ROW]");
    if (tr_obj == null) {
        return;
    }
    var prow = document.getElementById("R" + a00201_key_ + "_" + rowid);
    if (prow == null) {
        return;
    }
    var par_objid = document.getElementById("objid_" + a00201_key_ + "_" + rowid).value;
    if (prow.getAttribute("sc") == '1') {
        prow.setAttribute("sc", "0"); //
        $("[pid='" + par_objid + "']").hide();
        return;
    }
    else {
        if (prow.getAttribute("sc") == '0') {
            $("[pid='" + par_objid + "']").show();
            prow.setAttribute("sc", "1"); //
            return;
        }
    }

    loaddetail(a002_key, a00201_key_, tree_key_, "T", treenode_, rowid, "TREE");

}
function get_rownum(t_obj, rownum) {
    //    for (var i = 0; i < t_obj.rows.length; i++) {
    //        if ((t_obj.rows[i].id +"_").indexOf("_" + rownum + "_") > 0) {
    //            return i;
    //        }

    //    }
    var trs = $("#" + t_obj.id + " tr");
    for (var i = 0; i < trs.length; i++) {
        if ((trs[i].id + "_").indexOf("_" + rownum + "_") > 0) {
            return i;
        }

    }

    return 0;
}

function add_row_(a00201_key_, rowid, rowdata_) {
    /**/
    var str_html = "";
    var t_obj = document.getElementById("T" + a00201_key_);
    var tr_obj = document.getElementById("R" + a00201_key_ + "_[ROW]");
    if (tr_obj == null) {
        return;
    }
    var prow = document.getElementById("R" + a00201_key_ + "_" + rowid);
    if (prow == null) {
        return;
    }
    var par_objid = document.getElementById("objid_" + a00201_key_ + "_" + rowid).value;
    if (prow.getAttribute("sc") == '1') {
        prow.setAttribute("sc", "0"); //
        $("[pid='" + par_objid + "']").hide();
        return;
    }
    else {
        if (prow.getAttribute("sc") == '0') {
            $("[pid='" + par_objid + "']").show();
            prow.setAttribute("sc", "1"); //
            return;
        }
    }
    var prownum = get_rownum(t_obj, rowid);

    var beginrow = 0;
    try {
        beginrow = document.getElementById("beginrow_" + a00201_key_).value;
    }
    catch (ex) {
        beginrow = 0;
    }

    var rowscount = t_obj.rows.length + +parseFloat(beginrow);

    for (r = 0; r < rowdata_.length; r++) {
        var newrow = t_obj.insertRow(prownum + r + 1);
        if (r % 2 == 0) {
            newrow.className = "r0";
        }
        else {
            newrow.className = "r1";
        }
        rownum = rowscount + r;
        newrow.id = "R" + a00201_key_ + "_" + rownum;
        newrow.setAttribute("pid", par_objid);
        for (var i = 0; i < tr_obj.children.length; i++) {
            var newcell = newrow.insertCell(i);
            var td_obj = tr_obj.children[i];
            newcell.id = s_replace(td_obj.id, "[ROW]", rownum);
            newcell.style.width = td_obj.style.width;
            // newcell.style.text-align = td_obj.style.text-align;
            newcell.className = s_replace(td_obj.className, "[ROW]", rownum);
            newcell.innerHTML = s_replace(s_replace(td_obj.innerHTML, "[ROW]", rownum), '[ROWNUM]', rownum);
            $("#" + newcell.id).css("text-align", $("#" + td_obj.id).css("text-align"));
        }
        var rowdata__ = rowdata_[r];
        var pos_ = rowdata__.indexOf(data_index);

        //获取编辑属性
        // string enable_attr = BaseFun.getStrByIndex(rowdata__, data_index +  "10001|", data_index);
        // string disable_attr = BaseFun.getStrByIndex(rowdata__, data_index + "10000|", data_index);
        while (pos_ >= 0) {
            var v = rowdata__.substring(0, pos_);
            var pos1_ = v.indexOf("|");
            var column_id = v.substring(0, pos1_);
            v = v.substring(pos1_ + 1);
            v = s_replace(v, "[ROW]", rownum);
            if (column_id == "OBJID") {

                $("#objid_" + a00201_key_ + "_" + rownum + "_" + column_id).val(v);
            }
            else {
                //  $("#div_" + a00201_key_ + "_" + rownum + "_" + column_id).css("margin-left", "5px");
                $("#div_" + a00201_key_ + "_" + rownum + "_" + column_id).html(v);
            }
            rowdata__ = rowdata__.substring(pos_ + 1);
            pos_ = rowdata__.indexOf(data_index);
        }
    }


    prow.setAttribute("sc", "1");
}


//setTimeout("set_placeholder()", 5000);
function set_placeholder() {
    if (!placeholderSupport()) {   // 判断浏览器是否支持 placeholder
        $('[placeholder]').focus(function () {
            var input = $(this);
            if (input.val() == input.attr('placeholder')) {
                input.val('');
                input.removeClass('placeholder');
            }
        }).blur(function () {
            var input = $(this);
            if (input.val() == '' || input.val() == input.attr('placeholder')) {
                input.addClass('placeholder');
                input.val(input.attr('placeholder'));
            }
        }).blur();
    };
}

function placeholderSupport() {
    return 'placeholder' in document.createElement('input');
}



// by zhangxinxu welcome to visit my personal website http://www.zhangxinxu.com/
// 2010-03-12 v1.0.0
//十六进制颜色值域RGB格式颜色值之间的相互转换

//-------------------------------------
//十六进制颜色值的正则表达式
var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
/*RGB颜色转换为16进制*/
String.prototype.colorHex = function () {
    var that = this;
    if (/^(rgb|RGB)/.test(that)) {
        var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g, "").split(",");
        var strHex = "#";
        for (var i = 0; i < aColor.length; i++) {
            var hex = Number(aColor[i]).toString(16);
            if (hex === "0") {
                hex += hex;
            }
            strHex += hex;
        }
        if (strHex.length !== 7) {
            strHex = that;
        }
        return strHex;
    } else if (reg.test(that)) {
        var aNum = that.replace(/#/, "").split("");
        if (aNum.length === 6) {
            return that;
        } else if (aNum.length === 3) {
            var numHex = "#";
            for (var i = 0; i < aNum.length; i += 1) {
                numHex += (aNum[i] + aNum[i]);
            }
            return numHex;
        }
    } else {
        return that;
    }
};

//-------------------------------------------------

/*16进制颜色转为RGB格式*/
String.prototype.colorRgb = function () {
    var sColor = this.toLowerCase();
    if (sColor && reg.test(sColor)) {
        if (sColor.length === 4) {
            var sColorNew = "#";
            for (var i = 1; i < 4; i += 1) {
                sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
            }
            sColor = sColorNew;
        }
        //处理六位的颜色值
        var sColorChange = [];
        for (var i = 1; i < 7; i += 2) {
            sColorChange.push(parseInt("0x" + sColor.slice(i, i + 2)));
        }
        return "RGB(" + sColorChange.join(",") + ")";
    } else {
        return sColor;
    }
};

