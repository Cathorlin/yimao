//把行转换为列

function set_d_height(a00201_key__, w, h) { 


}

function setdetailheight(a00201_key__) {

    var objs = document.getElementById("scroll_" + a00201_key__);
    if (objs == null)
        return;
    var winh = getPheight();
    if (document.getElementById("td_link") != null) {
        winh = winh - $("#td_link").height();
    }
    var height_ = "";

    if (document.getElementById("tr_main").style.display == "none") {
        height_ =  $("#tr_button").height() + $("#tr_2").height();
    }
    else {
        height_ = $("#tr_main").height() + $("#tr_button").height() + $("#tr_2").height();
    }
    height_ = winh - height_ - 55   ;
    var tmainw = getPwidth() - 35;
    var wid = tmainw;
    //判断有没有按钮
    try {

        //objs.style.height = 100;
        // document.getElementById("mainhead").style.width = wid;
        $("#scroll_" + a00201_key__).height(100);
        $("#mainhead").width(wid);
        $("#scroll_" + a00201_key__ + "_x").width(wid);
        $("#scroll_" + a00201_key__ ).width(wid);
        //document.getElementById("scroll_" + a00201_key__ + "_x").style.width = wid + "px";
        // document.getElementById("scroll_" + a00201_key__).style.width = wid + "px";
        if (height_ < 40) {
            height_ = 100;
        }
        //objs.style.height = height_ + "px";
        $("#scroll_" + a00201_key__).height(height_);

        var showl = document.getElementById("showl_" + a00201_key__).value;
        var ldwidth = parseInt(document.getElementById("showld_" + a00201_key__).value);
        //弹出减少宽度
        if (if_showDialog == "1") {
            ldwidth = ldwidth + 30;
        }
        if (showl == "1") {
            document.getElementById("d_main_" + a00201_key__).style.width = wid + "px"; 
            //固定列
            document.getElementById("d_r_" + a00201_key__).style.width = lwidth + "px";
            document.getElementById("d_lr_" + a00201_key__).style.width = ldwidth + "px";
            document.getElementById("d_l_" + a00201_key__).style.width = String(wid - lwidth - ldwidth - 2) + "px"; 

            objs.style.height = String(height_) + "px";

            document.getElementById("d_main_" + a00201_key__).style.height = String(height_) + "px";
            document.getElementById("d_l_" + a00201_key__).style.height = String(height_) + "px";
            document.getElementById("d_r_" + a00201_key__).style.height = String(height_) + "px";
            document.getElementById("d_lr_" + a00201_key__).style.height = String(height_) + "px";

            document.getElementById("scroll_" + a00201_key__ + "_x").style.width = String(wid - lwidth - ldwidth) + "px";
            document.getElementById("scroll_" + a00201_key__).style.width = String(wid - lwidth - ldwidth) + "px";
            //固定列
            document.getElementById("d_r_" + a00201_key__).style.display = "";
            try {
                document.getElementById("scroll0_" + a00201_key__).style.height = String(height_)  +"px";
                document.getElementById("scroll0_" + a00201_key__ + "_x").style.width =  String(lwidth)  +"px";
                document.getElementById("scroll0_" + a00201_key__).style.width = String(lwidth) + "px";
                document.getElementById("scroll0_" + a00201_key__ + "_x").style.display = "";
                document.getElementById("scroll0_" + a00201_key__).style.display = "";
                /*调整行高*/
                var objs = $("tr.r0");
                for (var i = 0; i < objs.length; i++) {
                     var id = objs[i].id;
                     if (id.indexOf("R") == 0) {
                         id = "L" + id.substring(1);
                         document.getElementById(id).style.height = String($("#" + objs[i].id).height())+ "px";
                     }
                 }
                 var objs = $("tr.r1");
                 for (var i = 0; i < objs.length; i++) {
                     var id = objs[i].id;
                     if (id.indexOf("R") == 0) {
                         id = "L" + id.substring(1);
                         document.getElementById(id).style.height = String($("#" + objs[i].id).height()) + "px";
                     }
                 }
            }
            catch (e) {

            }
        }
        else {
            $("#d_main_" + a00201_key__).width(wid);

            // document.getElementById("d_main_" + a00201_key__).style.width = wid;
            //固定列
            document.getElementById("d_r_" + a00201_key__).style.display = "none";

            $("#d_lr_" + a00201_key__).width(ldwidth);
            $("#d_l_" + a00201_key__).width(wid - ldwidth );
            $("#" + objs.id).height(height_);
           // document.getElementById("d_lr_" + a00201_key__).style.width = ldwidth;
           // document.getElementById("d_l_" + a00201_key__).style.width = wid - ldwidth ;

            //objs.style.height = height_;


            $("#d_main_" + a00201_key__).height(height_);
            $("#d_l_" + a00201_key__).height(height_);
            $("#d_r_" + a00201_key__).height(height_);
            $("#d_lr_" + a00201_key__).height(height_);

            $("#scroll_" + a00201_key__ + "_x").width(wid - ldwidth);
            $("#scroll_" + a00201_key__ + "").width(wid - ldwidth);

           // document.getElementById("d_main_" + a00201_key__).style.height = height_;
          //  document.getElementById("d_l_" + a00201_key__).style.height = height_;
           // document.getElementById("d_r_" + a00201_key__).style.height = height_;
           // document.getElementById("d_lr_" + a00201_key__).style.height = height_;

           // document.getElementById("scroll_" + a00201_key__ + "_x").style.width = wid - ldwidth ;
           // document.getElementById("scroll_" + a00201_key__).style.width = wid - ldwidth ;
             try {
            //固定列
                 document.getElementById("scroll0_" + a00201_key__).style.height = height_;
                 $("#scroll0_" + a00201_key__).height(height_);
                 document.getElementById("scroll0_" + a00201_key__ + "_x").style.display = "none";
                 document.getElementById("scroll0_" + a00201_key__).style.display = "none";
            }
              catch (e) {
       
             }
            

        }
    }
    catch (e) {
        objs.style.height = 100;
    }
 
        







}
function setdetailpagenum(a00201_key_,pagenum_)           
{
  var v =  BasePage.setSession("detail_"+ a00201_key_ , pagenum_ ).value;
  if (if_showDialog =="1")
  {
       parent.document.getElementById("child").src = location.href+"0";
  }
  else
  {
      location.reload();     
  }
}
var tablength ="";
var selectmaintab = -1;
var if_showDialog = "0"; //是否子窗口
var main_key = "-1";//当前界面的主键
function showmaintab(a00201_key , tabi)
{
    var  obj = document.getElementById("maintable_" + a00201_key + "_" + tabi);
    var objtr_tab_head = document.getElementById("tr_tab_head" + a00201_key  + tabi);
    if (obj != null) {
         if (obj.style.display == "")
         {
              obj.style.display ="none";
                if (objtr_tab_head !=  null )
                {
                objtr_tab_head.className = "tr_tab_head";
                }   
        }
        else
        {
            obj.style.display ="" ; 
            if (objtr_tab_head !=  null )
            {
                objtr_tab_head.className = "tr_tab_head_hover";      
            }     
        }

   }
    var objs = document.getElementsByTagName("div");
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].id.indexOf("scroll_") >= 0 && objs[i].id.indexOf("_x") < 0) {
            setdetailheight(objs[i].id.substr(7));
        }
    }
   // rbclose();
}



function AddRow(a00201_key_) {
    /**/
    var str_html = "";
    var t_obj = document.getElementById("T" + a00201_key_);
    var rownum = t_obj.rows.length ;
    var newrow = t_obj.insertRow(rownum );
    if (t_obj.rows.length % 2 == 0) {
        newrow.className = "r0";
    }
    else {
        newrow.className = "r1";
    }
    var beginrow  = 0;
    try{
        beginrow = document.getElementById("beginrow_" + a00201_key_).value;
    }
    catch (ex)
    {
        beginrow = 0;
    }
    rownum = parseFloat(rownum) + parseFloat(beginrow);
    
    newrow.id = "R" + a00201_key_ + "_" + rownum;

    var tr_obj = document.getElementById("R" + a00201_key_ + "_[ROW]");
    var focu_obj= null;
    for (var i = 0; i < tr_obj.children.length; i++) {
        var newcell = newrow.insertCell(i);
        var td_obj = tr_obj.children[i];
 
        newcell.id = s_replace(td_obj.id, "[ROW]", rownum);
        newcell.style.width = td_obj.style.width;
        newcell.className = s_replace(td_obj.className, "[ROW]", rownum);
        newcell.innerHTML = s_replace(s_replace(td_obj.innerHTML, "[ROW]", rownum), '[ROWNUM]', rownum);
        if (focu_obj == null) {
            for (var c = 0; c < newcell.children.length; c++) {
                if (newcell.children[c].id.indexOf("TXT_") == 0 && newcell.children[c].type == "text") {
                    focu_obj = newcell.children[c];
                }
            }
        }
    }
    try
    {
     if (focu_obj != null){
         focu_obj.focus();
     }
    }
    catch(ex) {
    }
    return a00201_key_ + "_" + rownum;
}
function DelRow(a00201_key_) {
    var objs = document.getElementsByName("cbx_" + a00201_key_);
    for (var i = 0; i < objs.length; i++) {
        if ((objs[i].id != "cbx_" + a00201_key_) && (objs[i].id != "cbx_" + a00201_key_ + "_[ROW]")) {
            if (objs[i].checked == true) {
                tr_obj = document.getElementById("R" + objs[i].id.substr(4));
                if (tr_obj != null) {
                    tr_obj.style.display = "none";
                    setbtnenable("btn_save");
                }

            }
        }
    }
}
function getRowdataStr(rowid, collist) {
    var objs = document.getElementsByName(rowid);
    var rowlist = "";
    var rowlist1 = "";
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

    rowlist1 = rowlist;
    var rowid_ = "TXT_" + rowid;
    for (var i = 0; i < objs.length; i++) {
        if (objs[i].id.indexOf(rowid_) == 0) {
            var line_no = objs[i].id.substr(rowid_.length + 1);
            if (collist.length > 1) {
                 if (collist.indexOf("[" + line_no + "]") >= 0) {
                    rowlist += line_no + "|" + objs[i].value + data_index;
                }
            }
            else {
                rowlist += line_no + "|" + objs[i].value + data_index;
            } 
            rowlist1 += line_no + "|" + objs[i].value + data_index;
        }
    }
    rowlist = "<KEY>" + rowlist + "</KEY>";
    rowlist = rowlist + "<ROWALLKEY>" + rowlist1 + "</ROWALLKEY>";
    return rowlist;
}
function setfocus(objid) {
    try {
        document.getElementById(objid).focus();
    }
    catch (e) { 
    }
}
var main_show = "1";
function showmian() {
    if (main_show == "1") {
        document.getElementById("tr_main").style.display = "none";
        main_show = "0";
        

    }
    else {
        main_show = "1";
        document.getElementById("tr_main").style.display = "";
    }
    showmaintab("", "");
}


//组织要更新的数据
function update() {
    //获取主档的数据
    if (ifreqdo == true) {
        return;
    }
    var parm = formatparm();
    var rowid_ = a002_key + "-0_0";
    var rowdata ="";
    parm = addParm(parm, "A002ID", "");
    parm = addParm(parm, "A00201KEY", rowid_.split("_")[0]);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "IFSHOW", "0");
    parm = addParm(parm, "REQID", "SAVE");
    parm = addParm(parm, "MAINKEY", main_key);
    parm = addParm(parm, "SHOWTAB", old_showtab);
        
    var lb_change = false;
    var collist = "";
    var rowid__ = "TXT_" + rowid_;
    for (var c = 0; c < changeobjList.length; c++) {
        if (changeobjList[c].id.indexOf(rowid__) >= 0) {
            lb_change = true;
            var line_no = changeobjList[c].id.substr(rowid__.length + 1);
            collist += "[" + line_no + "]"
            continue;
        }
    }
    parm = addParm(parm, "MAINROWLIST", getRowdata(rowid_, ""));
    parm = parm + "<ROWDATA>";  
    if (lb_change == true) {
        parm = parm + "<ROW>";
        parm = addParm(parm, "ROWID", rowid_);
        if (option == 'I')
            collist = "";
        rowdata = getRowdataStr(rowid_, collist);
        if (rowdata == "")
            return;
        parm = parm + rowdata;
        parm = addParm(parm, "ACTION", option);
        parm = parm + "</ROW>";
    }
    var trobjs = document.getElementsByTagName("tr");
    for (var i = 0; i < trobjs.length; i++) {
        if (trobjs[i].id.indexOf("R") < 0 ||  trobjs[i].id.indexOf("[ROW]") > 0) 
            continue;

            rowid_ = trobjs[i].id.substr(1);
            var objid = document.getElementById("objid_" + rowid_).value;
            //新增删除的
            if (objid == "NULL" && trobjs[i].style.display == "none") {
                continue;
            }
            //删除
            if (objid != "NULL" && trobjs[i].style.display == "none") {
                rowdata = getRowdata(rowid_, "");
                parm = parm + "<ROW>";
                parm = addParm(parm, "ROWID", rowid_);
                parm = addParm(parm, "KEY", rowdata);
                parm = addParm(parm, "ACTION", "D");
                parm = parm + "</ROW>";
                continue;

            }
            //新增
          
            if ((objid == "NULL" ) && trobjs[i].style.display != "none") {
                rowdata = getRowdata(rowid_, "");
             
                parm = parm + "<ROW>";
                parm = addParm(parm, "ROWID", rowid_);
                parm = addParm(parm, "KEY", rowdata);
                parm = addParm(parm, "ACTION", "I");
                parm = parm + "</ROW>";
                continue;
            }
            //修改
            
            //判断当前行有没有修改

            rowid__ = "TXT_" + rowid_;
            lb_change = false;
            for (var c = 0; c < changeobjList.length; c++) {                
                if (changeobjList[c].id.indexOf(rowid__ +"_") >= 0) {
                    lb_change = true;
                    var line_no = changeobjList[c].id.substr(rowid__.length + 1);
                    collist += "[" + line_no + "]"
                    continue;
                }

            }

            if (lb_change == true) {
                rowdata = getRowdata(rowid_, collist);
                parm = parm + "<ROW>";
                parm = addParm(parm, "ROWID", rowid_);
                parm = parm + getRowdataStr(rowid_, collist);
                parm = addParm(parm, "ACTION", "M");
                parm = parm + "</ROW>";
                continue;
            }

    }
    parm = parm + "</ROWDATA>";
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a002_key + "-0&ver=" + getClientDate();
    //不允许再发送保存
    if (location.href.toLowerCase().indexOf("mainform.aspx") > 0) {
        
        try {
            if (document.getElementById("btn_save").disabled == true) {
                return;
            }
        }
        catch (e)
         { }
         setbtndisable('btn_save');
    }
   
    FunGetHttp(url, "div_req", parm);

}

//把单据导入xls
function DOWNALL(a00201_key_) {
    var parm = formatparm();
    parm = addParm(parm, "A00201KEY", a00201_key_);
    parm = addParm(parm, "OPTION", option);
    parm = addParm(parm, "VER", "");
    parm = addParm(parm, "URL", location.href);
    parm = addParm(parm, "REQID", "DOWNALL");
    parm = addParm(parm, "MAINKEY", main_key_value);
    parm = addParm(parm, "KEY", "");
    parm = addParm(parm, "ROWID", "");
    parm = parm + endformatparm();
    url = http_url + "/BaseForm/MyReq.aspx?A00201KEY=" + a00201_key_ + "&ver=" + getClientDate();
    FunGetHttp(url, "div_req", parm);

}
function do_new()
{
    if (option != "I") {
        var obj_ = document.getElementById("btn_new_" + a002_key +"-0");
        if (obj_ != null) {
            if (obj_.disabled == false) {
                showtaburl('ShowForm/MainForm.aspx?option=M&A002KEY=' + a002_key + '&key=NULL&code=' + getClientDate(), '浏览');            
            }
        }
    }
    rbclose();

}