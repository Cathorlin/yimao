function selectqueryall(obj, a10001_key) {
    var v = obj.value;
    objlist = document.getElementsByName("value" + a10001_key);

    for (var r = 0; r < objlist.length; r++) {
        if (objlist[r].type == "checkbox") {
            if (v == "0") {

                objlist[r].checked = true;
            }
            else {
                objlist[r].checked = false;
            }
        }


    }
    if (v == "0") {
        obj.value = "1";
    }
    else {
        obj.value = "0";
    }

}
function get_condition(a00201_key__ , query_id,divid) {
    var v = save_condition(a00201_key__, query_id, "loadquery('" + a00201_key__ + "','" + query_id + "','" + divid + "');");
    if (v == "-100") {
        loadquery(a00201_key__, "", divid);
    }
}


function clear_conditon() {
    var vlist = document.getElementById("querycol").value.split(",");
    for (var i = 0; i < vlist.length; i++) {
        var a10001_key = vlist[i];
        var all_obj = document.getElementById("all" + a10001_key);
        if (all_obj != null) {
            all_obj.value = "0";
            all_obj.checked = false;
        }
        clearitem(a10001_key);

    }

}




//根据查询的编码显示查询
var select_query_id = "";
function show_condition(select_obj,a00201_key__) {
    clear_conditon();
    var query_id__ = select_obj.options[select_obj.selectedIndex].value;
    if (query_id__ != "") {

        select_query_id = query_id__;
        var parm = formatparm();
        parm = addParm(parm, "A002ID", "");
        parm = addParm(parm, "A00201KEY", a00201_key__);
        parm = addParm(parm, "OPTION", option);
        parm = addParm(parm, "VER", "");
        parm = addParm(parm, "URL", location.href);
        parm = addParm(parm, "REQID", "GETA006");
        parm = addParm(parm, "MAINKEY", main_key);
        parm = addParm(parm, "KEY", query_id__);
        parm = parm + endformatparm();
        url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key__ + "&ver=" + getClientDate();
        FunGetHttp(url, "query_req", parm);
    }
}
function sort_change(selectobj) {

    var v_ = selectobj.options[selectobj.selectedIndex].value;
    if (v_ == "") {
       document.getElementById("by" + selectobj.id).selectedIndex = 99;
    }
    else
    {
       document.getElementById("by" + selectobj.id).selectedIndex = 98;
    }
    sort_ref();
}
//重新拍下
function sort_ref() {
    var bysorts = document.getElementsByName("bysort");
    var  sort_list = new  Array();
    for (var i = 0; i < bysorts.length; i++) { 
        if ( bysorts[i].selectedIndex != 99)
        {
            sort_list[sort_list.length] = bysorts[i];           
        }
    }
    var  sort_list1 = new Array();
    
    for(var i=0;i < sort_list.length;i++ )
    {
        var sindex = sort_list[i].selectedIndex;
        var c = 0;        
        for(var j=0;j<sort_list.length;j++ )
        {
            if (sort_list[j].selectedIndex < sindex)
            {
               c = c + 1;
            }
       }
       sort_list1[i] = c * 100 + i ;
   }


   for (var i = 0; i < sort_list1.length; i++) {
       c = 1;
       for (var j = 0; j < sort_list1.length; j++) {
           if (sort_list1[j] < sort_list1[i]) {
               c = c + 1;
           }
       }
       sort_list[i].selectedIndex = c  ;

    }

}

//设置数据
function setqueryitem(a10001_key, CALC, col_type, col_sort, vlist) {
    var obj_select = document.getElementById("CALC" + a10001_key);
    if (obj_select != null) {
        for (var j = 0; j < obj_select.options.length; j++) {
            if (obj_select.options[j].value == CALC) {
                obj_select.selectedIndex = j ;
                break;
            }
        }
    }
    var bysort_ = 99;
    var col_sort_ ="";
    if (col_sort.length == 3) {
        col_sort_ = col_sort.substring(2);
        bysort_ = parseFloat(col_sort.substring(0, 2));
    }
    else {
        if (col_sort.length == 1) {
            col_sort_ = col_sort;
        }
        else {
            col_sort_ = "";
        }
    }
    var  obj_sort = document.getElementById("sort_" + a10001_key);
    if (obj_sort != null) {
        for (var j = 0; j < obj_sort.options.length; j++) {
            if (obj_sort.options[j].value == col_sort_) {
                obj_sort.selectedIndex = j;
                break;
            }
        }
    }
    var obj_bysort = document.getElementById("bysort_" + a10001_key);
    if (obj_sort != null) {
        for (var j = 0; j < obj_bysort.options.length; j++) {
            if (obj_bysort.options[j].value == bysort_) {
                obj_bysort.selectedIndex = j ;
                break;
            }
        }
    }


       var objlist = document.getElementsByName("value" + a10001_key);
        if (vlist == "" || vlist == null) {
            return;
        }
        if (objlist.length == 0) {
            return;
        }

        if (CALC == "SQL") {
            calc_change(obj_select);
            document.getElementById("vsql_" + a10001_key).value = vlist;
            return;
        }
        for (var r = 0; r < objlist.length; r++) {
            if (objlist[r].type == "checkbox") {

                if (("|" + vlist).indexOf("|" + objlist[r].value + "|") >= 0) {
                    objlist[r].checked = true;
                }
                else {
                    objlist[r].checked = false;
                }

            }
            if (objlist[r].type == "text") {
                 // col_type == "date" || col_type == "datetime"
                if (CALC == "BETWEEN" && (objlist.length == 2)) {
                    var vv = vlist.split("|");
                    objlist[r].value = vv[r];
                    objlist[r].style.color = "red";
                }
                else {
                    if (CALC == "BETWEEN") {
                        vo = s_replace(vlist, '|', '..');
                        objlist[r].value = vo.substr(0, vo.length - 2);
                        objlist[r].style.color = "red";
                    }
                    else {
                        objlist[r].value = s_replace(vlist, '|', '');
                        objlist[r].style.color = "red";
                    }
                }
            }
        }
     
}


function delete_conditon(a00201_key__) {
    var select_obj = document.getElementById("Select_query");
    var query_id = select_obj.options[select_obj.selectedIndex].value;
    var query_text = select_obj.options[select_obj.selectedIndex].text;
    var parm = formatparm();
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "DELETEA006");
    parm = addParm(parm, "MAINKEY", main_key);
    parm = addParm(parm, "KEY", query_id);
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key__ + "&ver=" + getClientDate();
    FunGetHttp(url, "query_req", parm);
}
function delete_a006(query_id) {
    var select_obj = document.getElementById("Select_query");
    for (i = 0; i < select_obj.options.length; i++) {
        v = select_obj.options[i].value;
        if (v == query_id) {
            select_obj.remove(i);
            select_obj.selectedIndex = 0;
            break;
        }
    }

}
function cancel_window() {
    rbclose();
}
function set_con_default(a00201_key__, divid_) {
    //判断名称是否存在
    var select_obj = document.getElementById("Select_query");
    select_query_id = select_obj.options[select_obj.selectedIndex].value
    
    if (select_query_id == "" || select_query_id == "最近的查询") {
        alert("请选择查询!");
        select_obj.focus();
        return;
    }
    var parm = formatparm();
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "SET_A006_DEF");
    parm = addParm(parm, "MAINKEY", main_key);
    parm = addParm(parm, "KEY", select_query_id);
    var nextdo_html = "alert('设置默认查询成功！');"
    parm = addParm(parm, "NEXTDO", nextdo_html); 
    parm = parm + endformatparm();
    var url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key__ + "&ver=" + getClientDate();
    FunGetHttp(url, "query_req", parm);
}
function save_(a00201_key__) {
    var query_id_obj = document.getElementById("input_query_id");
    if (query_id_obj.value == "") {
        alert("请输入保存的查询名称！");
        query_id_obj.focus();
        return;
    }
    var query_id = query_id_obj.value;
    //判断名称是否存在
    var select_obj = document.getElementById("Select_query");
    var if_exist = '0';
    for (i = 0; i < select_obj.options.length; i++) {
        var this_v = select_obj.options[i].text;
        if (this_v == query_id) {
            if_exist = '1';
            break;
        }

    }
    if (if_exist == '1') {
        alert("保存的查询名称" + query_id + "已经存在！");
        return;
    }
    var v = save_condition(a00201_key__, query_id, "alert('保存查询" + query_id + "成功!');");
    if (v == query_id) {
        //alert("保存查询（" + query_id + "）成功！");
    }
    else {
        if (v == "-100") {
            alert("没有条件，无需保存");
            return;
        }
        alert("保存查询（" + query_id + "）失败！");
        return;
    }

    if_exist = '0';
    for (i = 0; i < select_obj.options.length; i++) {
        var this_v = select_obj.options[i].value;
        if (this_v == query_id) {
            if_exist = '1';
            break;
        }
    }
    if (if_exist == '0') {
        fnAdd(select_obj, query_id, query_id);
    }
}
//修改条件
function calc_change(obj) {
    var a10001_key__ = obj.id.substr(4);
    if (obj.options[obj.selectedIndex].value == "SQL"  ) {
        document.getElementById("input_" + a10001_key__).style.display = "none";
        document.getElementById("inputsql_" + a10001_key__).style.display = "";
    }
    else {
        if (obj.options[obj.selectedIndex].value == "NULL" || obj.options[obj.selectedIndex].value == "NOT NULL" ) {
            document.getElementById("input_" + a10001_key__).style.display = "none";
            document.getElementById("inputsql_" + a10001_key__).style.display = "none";
        }
        else {
            document.getElementById("input_" + a10001_key__).style.display = "";
            document.getElementById("inputsql_" + a10001_key__).style.display = "none";
        }
    }
}
//清除条件
function clearitem(a10001_key__) {
    var all_obj = document.getElementById("all" + a10001_key__);
    if (all_obj != null) {
        all_obj.value = "0";
        all_obj.checked = false;
    }
    obj_select = document.getElementById("CALC" + a10001_key__);
    if (obj_select == null) {
        return;
    }
    obj_select.selectedIndex = 0;
    calc_change(obj_select);

    obj_select = document.getElementById("sort_" + a10001_key__);
    obj_select.selectedIndex = 0;

    obj_select = document.getElementById("bysort_" + a10001_key__);
    obj_select.selectedIndex = 99;

    objlist = document.getElementsByName("value" + a10001_key__);

    for (var r = 0; r < objlist.length; r++) {
        if (objlist[r].type == "checkbox") {
            objlist[r].checked = false;
        }
        if (objlist[r].type == "text") {
            objlist[r].value = "";
        }
    }
    document.getElementById("vsql_" + a10001_key__).value = "";

    sort_ref();
}
//保存查询
function save_condition(a00201_key__, query_id_, nextdo_html) {
    var parm = formatparm();
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", a00201_key__);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "SAVEA006");
    parm = addParm(parm, "MAINKEY", main_key);
    parm = addParm(parm, "KEY", query_id_);
    parm = addParm(parm, "NEXTDO", nextdo_html);    
    parm = parm + "<ROWDATA>"
    var vlist = document.getElementById("querycol").value.split(",");
    var v_all = 0;
    for (var i = 0; i < vlist.length; i++) {
        var a10001_key = vlist[i];
        if (a10001_key == "") {
            continue;
        }
        var all_obj = document.getElementById("all" + a10001_key);
        if (all_obj != null) {
            all_obj.value = "0";
            all_obj.checked = false;
        }   
        obj_select = document.getElementById("CALC" + a10001_key);
        obj_sort = document.getElementById("sort_" + a10001_key);
        obj_bysort = document.getElementById("bysort_" + a10001_key);

        var vcount = false;
        var rowxml = "";
        objlist = document.getElementsByName("value" + a10001_key);
        rowxml += "<ROW>";
        rowxml += "<A10001_KEY>" + a10001_key + "</A10001_KEY>";
        rowxml += "<CALC>" + obj_select.options[obj_select.selectedIndex].value + "</CALC>";
        if (obj_sort.selectedIndex > 0) {
            rowxml += "<SORT>" + obj_bysort.options[obj_bysort.selectedIndex].value + obj_sort.options[obj_sort.selectedIndex].value + "</SORT>";
        }
        else {
            rowxml += "<SORT>" + obj_sort.options[obj_sort.selectedIndex].value + "</SORT>";

        }
          if (obj_sort.selectedIndex > 0) {
            vcount = true;
        }
        v = "";
        rowxml += "<VALUE>";
        var calc_v = obj_select.options[obj_select.selectedIndex].value;
        if (calc_v == "SQL" || calc_v == "NULL" || calc_v == "NOT NULL") { /*判断有没有值*/
            if (calc_v == "SQL") {
                var sql_v = document.getElementById("vsql_" + a10001_key).value;
                if (sql_v != "") {
                    vcount = true;
                    rowxml += sql_v;
                }
            }
            else {
                vcount = true;
                rowxml += calc_v;
            }

        }
        else {
            for (var r = 0; r < objlist.length; r++) {

                if (objlist[r].type == "checkbox") {
                    if (objlist[r].checked == true) {
                        rowxml += objlist[r].value + "|";
                        vcount = true;
                    }
                }
                if (objlist[r].type == "text") {
                    if (objlist[r].value != "" || calc_v == "BETWEEN") {
                        rowxml += objlist[r].value + "|";
                        if (objlist[r].value != "") {
                            vcount = true;
                        }
                    }
                }
            }
            if (calc_v == "BETWEEN") {
                rowxml = s_replace(rowxml, '..', '|');
            }
        }
        rowxml += "</VALUE>";
        rowxml += "</ROW>";

        if (vcount == true) {
            v_all = v_all + 1;
            parm = parm + rowxml;
        }

    }
    parm = parm + "</ROWDATA>";
    parm = parm + endformatparm();

    if (v_all > 0) {
          var  url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key__ + "&ver=" + getClientDate();
          FunGetHttp(url, "query_req", parm);
          return query_id_;
    }
    else {
        return "-100";
    }

}