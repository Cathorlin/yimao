function showdivbutton(tt,menu_id_){
	var QtyDiv=document.getElementById("div_show");
	if(QtyDiv!=null){
		document.body.removeChild(QtyDiv);
	};
	QtyDiv=document.createElement("div");
	QtyDiv.id="div_show";
	QtyDiv.onmouseleave=function(){
		DivClose();
	};
	var ttop=tt.offsetTop;
	var thei=tt.clientHeight;
	var tleft=tt.offsetLeft;
	while(tt=tt.offsetParent){
		ttop+=tt.offsetTop;
		tleft+=tt.offsetLeft;
	};
	var moveTop=ttop+thei-10;
	var moveLeft=tleft;

	QtyDiv.style.position="absolute";
	QtyDiv.style.setAttribute("zIndex","201");
	QtyDiv.style.setAttribute("backgroundColor","#EFEFEF");
	QtyDiv.style.setAttribute("Font","10pt");
	QtyDiv.style.setAttribute("width",150);
	QtyDiv.style.setAttribute("left",tleft);
	QtyDiv.style.setAttribute("top",ttop+25);
    var dt=BasePage.getDtBySql("select t.* from A00205 t  where menu_id ='"+menu_id_+"'").value;
    var moveheight=20+(dt.Rows.length)*20;
	html_="<table width=\"100%\">";
	var rpt_;
	var sql_;
	var parm_list_;
	for(var i=0;i<dt.Rows.length;i++){
		n=dt.Rows[i]["DW_NAME"];
		sql_=dt.Rows[i]["BS_RPT_SQL"];
		parm_list_=dt.Rows[i]["BS_PARM_LIST"];
		if ((sql_==""||sql_==null) && (parm_list_ =="" || parm_list_ == null) )
		{
			continue;
		};
		sql_=format_data(sql_,menu_id_+"-0_0");
		parm_list_ =format_data(parm_list_,menu_id_+"-0_0");
		sql_=replaceAll(sql_,"'","!!!");
	    parm_list_=replaceAll(parm_list_,"'","!!!");
		rpt_=dt.Rows[i]["DW_ID"];
		html_+="<tr><td  style=\"height:20px;Color:blue;\"  align=\"center\" valign=\"top\"><input type='button' class='_button' value='"+n+"' onclick=\"rptdo('"+rpt_+"','"+sql_+"','"+parm_list_+"')\" /></td></tr>"
	}
	html_+="</table>";
	QtyDiv.innerHTML=html_;
	document.body.appendChild(QtyDiv);
	if (dt.Rows.length == 1)
	{
	    rptdo(rpt_,sql_,parm_list_);
	}
	
}
function alert_div(tt,html_)
{
    var QtyDiv=document.getElementById("div_show");
	if(QtyDiv!=null){
		document.body.removeChild(QtyDiv);
	};
	QtyDiv=document.createElement("div");
	QtyDiv.id="div_show";
	QtyDiv.onmouseleave=function(){
		DivClose();
	};
	var ttop=tt.offsetTop;
	var thei=tt.clientHeight;
	var tleft=tt.offsetLeft;
	while(tt=tt.offsetParent){
		ttop+=tt.offsetTop;
		tleft+=tt.offsetLeft;
	};
	var moveTop=ttop+thei-10;
	var moveLeft=tleft;
	var moveheight=20+(dt.Rows.length)*20;
	QtyDiv.style.position="absolute";
	QtyDiv.style.setAttribute("zIndex","201");
	QtyDiv.style.setAttribute("backgroundColor","#EFEFEF");
	QtyDiv.style.setAttribute("Font","10pt");
	QtyDiv.style.setAttribute("width",150);
	QtyDiv.style.setAttribute("left",tleft);
	QtyDiv.style.setAttribute("top",ttop+25);
    QtyDiv.innerHTML=html_;
	document.body.appendChild(QtyDiv);
}

function rptdo(rpt_,sql__,parm_list__){
	sql_=replaceAll(sql__,"!!!","'");
	parm_list_ = replaceAll(parm_list__,"!!!","'");
	v=BasePage.setSession("REPORT_FILE",rpt_).value;
	v=BasePage.setSession("REPORT_SQL",sql_).value;
	v=BasePage.setSession("REPORT_PARM",parm_list_).value;
	url=http_url+"\\report\\crystalreport.aspx?showreport=1&code="+Math.random()*100000;
	window.open(url);
	DivClose();
}
/*
    rowList  a20001_key  + r = key
    其他就是主键 
*/
function getA0130101(a00201_key_,table_key,main_key,table_id)
{
    var line_ = new Array();
    line_[0] = a00201_key_ ;
    var if_exist = "0";
    for (var  i=0 ;i <a013010101.length ;i++ )
    {
        if (a013010101[i][0] == line_[0])
        {
            if_exist ="1";
            line_ = a013010101[i];
            break ;
        }    
    }
    if (if_exist =="0")
    {
         var len = a013010101.length;
         line_[1] = BasePage.getA013010101(a00201_key_).value;
         line_[2]  = table_key ;
         line_[3]  = main_key ;
         line_[4]  = table_id ; 
         line_[5]  =    BasePage.getDtBySql("select t.* from A00210_V01 t  where a00201_key ='"+a00201_key_ +"' and   rb_type='C'").value ;
         line_[6]  =    BasePage.getDtBySql("select t.* from A00210_V01 t  where a00201_key ='"+a00201_key_ +"' and   rb_type='U'").value ;
         line_[7]  =    BasePage.getStrBySql("select t.tbl_type from A100 t  where table_id ='"+table_id +"'").value ;  
         line_[7]  = line_[7].substr(0,1) ;
         line_[8]  =  BasePage.getDtBySql("select t.*   from a014_v01 t  where table_id ='"+table_id +"' order by sort_by").value ;
         a013010101[len] = line_;           
         dt =  BasePage.getDtBySql("select f_get_data_index() as c  from dual  ").value ;
         data_index =dt.Rows[0]["C"];
    }   
    return line_[1] ;
}
function AddrowList( rowid ,table_key, main_key ,key,table_id,row_line_no,option_)
{
    var len = rowList.length;
    var row = new Array();
    var if_exist = "0";
    var a00201_key= rowid.split("_")[0];
    for (var i = 0 ;i < A00201_LIST.length ;i++)
    {
        if (A00201_LIST[i][0] == a00201_key )
        {
            if_exist = "1";
            break;
        }
    }
    if (if_exist =="0")
    {
        var a00201_ = new Array();
        a00201_[0] = a00201_key;
        a00201_[1] = 0 ;
        a00201_[2] = 0 ;
        var alen = A00201_LIST.length;
        A00201_LIST[alen] = a00201_; 
        
        
    }
    row[0] = rowid ;//行编码
    row[1] = key ;//行的主键 0 表示是新增的行  -100 表示主键错误 无法处理
    row[2] = option_ ; //行的动作 M 修改 D 表示是删除 I 新增
    row[3] = "0" ;//判断行是否变化
    
    row[4] ="" ;//行的数据
    row[5] = main_key;//通用主键
    row[6] = table_key;//当前表的主键

    
    row[7] = "" ; //存放更新的sql语句
    row[8] = table_id;
    if ( row_line_no > 0 )
    {
        row[9] = " WHERE " + main_key + "='"+ key +"' and LINE_NO= " + row_line_no   ;//存放更新和删除的where 语句
    }
    else
    {
        row[9] = " WHERE " + main_key + "='"+ key +"'" ;//存放更新和删除的where 语句
    }
    if (main_key == "")
    {
        row[5] = table_key;//通用主键
        row[9] = " WHERE " + table_key + "='"+ key +"'" ;//存放更新和删除的where 语句

    }
    
    
    row[10] = a00201_key;
     if ( row_line_no > 0 )
    {
      row[11] = key + "-" + row_line_no;
    }
    else
    {
       row[11] = key; 
    }

   // row[9] =  getA0130101(a00201_key) ;
    rowList[len]  = row ;  
    return  len;
}