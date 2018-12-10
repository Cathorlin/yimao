function showDialog(url, dw, dh, modeless, args){
	if (typeof(args) == "undefined") args = window;
	var r;
	if (modeless)
		r = window.showModelessDialog(url, args, "dialogWidth:"+dw+";dialogHeight:"+dh+";center:yes;edge:raised;help:no;resizable:yes;scroll:yes;status:no;");
	else
		r = window.showModalDialog(url, args, "dialogWidth:"+dw+";dialogHeight:"+dh+";center:yes;edge:raised;help:no;resizable:no;scroll:yes;status:no;");
	return r;
}
/**
* 删除左右两端的空格
*/
function trim(str)
{
     return str.replace(/(^\s*)|(\s*$)/g, "");
}
/**
* 删除左边的空格
*/
function ltrim(str)
{
     return str.replace(/(^\s*)/g,"");
}
/**
* 删除右边的空格
*/
function rtrim(str)
{
     return str.replace(/(\s*$)/g,"");
}


 function FormatNumber(value,num)    //直接去尾
        {
            var a,b,c,i
            a = value.toString();
            b = a.indexOf('.');             //判断小数点在字符串中第几个位置出现
            c = a.length;                   //获取字符串长度
            if (num == 0)
            {
                if (b!=-1)                  //如果没有找到字符串，则返回 -1
                {
                    a = a.substring(0,b);   //截取整数部分
                }
                else
                {
                    if (b==-1)              //如果没有找到字符串，则返回 -1
                    {
                        a = a + ".";
                        for (i=1;i<=num;i++)
                        a = a + "0";
                    }
                    else
                    {
                        a = a.substring(0,b+num+1);
                        for (i=c;i<=b+num;i++)
                        a = a + "0";
                    }
                }
            }
            return a
        }
        
       function adv_format(value,num)   //四舍五入
        {
          if (num==0)
              a_str =  Math.round(value);
          if (num==1)
              a_str =  Math.round(value*10)/10;
          if (num==2)
              a_str =  Math.round(value*100)/100;    
           if (num==3)
              a_str =  Math.round(value*1000)/1000;   
         if (num==4)
              a_str =  Math.round(value*10000)/10000;            
            return a_str
        }      

function changecbx(cbx_obj)
{
    if (cbx_obj.checked)
    {   
        cbx_obj.value = "1" ;
    }
    else
    {
        cbx_obj.value = "0" ;
    
    }
     var id = cbx_obj.id ;
     var this_id ="";
     var cl = document.getElementsByTagName("input");//先获得所有的input
             var len = cl.length;
             for(i=0;i<len;i++)
             {
                 if(cl[i].type == "checkbox")//如果是checkbox，就让它选中
                 {
                    this_id = cl[i].id;
                    if (this_id.indexOf(id) >= 0)
                    {
                        cl[i].value = cbx_obj.value;
                        if (cbx_obj.value=="1")
                        {
                            cl[i].checked = true;
                            cl[i].value ="1";
                        }
                        else
                        {
                            cl[i].checked = false;
                            cl[i].value ="0";
                        }
                    
                    }
                    
                    //
                    if (id.indexOf(this_id) >= 0)
                    {
                       if (cbx_obj.value=="1")
                       {
                          if ( cl[i].value=="0")
                          {
                               cl[i].checked = true;
                               cl[i].value ="1";
                          }
                       } 
                    
                    
                    }
                    
                    

                 }
             }
    
    
    
    

}
function redirect(url){
	window.location.assign(url);
}

/* 选中DataGrid中所有行 */
function SelectAll(obj){
	var cbx = obj;
	while(obj.tagName != "TABLE"){
		obj = obj.parentElement;
	}
	for(var i=1; i<obj.rows.length; i++){
		obj.rows[i].cells[0].children[0].checked = cbx.checked;
	}
}

/* 检查DataGrid中是否有记录被选中 */
function NeedSelectionCheck(tb){
	if(tb != "undefined" && tb != null){
		var k = 0;
		for(var i=1; i<tb.rows.length; i++){
			if(tb.rows[i].cells[0].children[0].checked)
				k++;
		}
		if(k == 0){
			window.alert("请选择一条记录，再进行操作！");
			return false;
		}
		else
			return true;
	}
}


function dgItemOnClick()
{
	var eo = window.event.srcElement;
	if(eo == null) 
		return;
	var tr = eo;
	var tbl;
	var o;
	
	while(tr.tagName != "TR")
	{
		tr = tr.parentElement;
		if(tr == "undefined" || tr == null)
			return;
	}
	
	tbl = tr;
	while(tbl.tagName != "TABLE")
	{
		tbl = tbl.parentElement;
		if(tbl == "undefined" || tbl == null)
			return;
	}
	
	// 如果直接是点击Checkbox，则让系统直接处理
	if(eo.tagName == "INPUT" && eo.type == "checkbox")
		return;	

	// 点击的不是Checkbox or Radio
	o = tr.children[0].children[0];
	if(o != "undefined" && o != null && o.tagName == "INPUT" && o.type == "checkbox")
		o.checked = !o.checked;
	else if(o != "undefined" && o != null && o.tagName == "INPUT" && o.type == "radio")
	{
		for(var i = 1; i < tbl.rows.length; i++)
		{
			tbl.rows[i].cells[0].children[0].checked = false;
		}
		o.checked = true;
	}
}

function QueryItemClicked(){
	var tr;
	tr = window.event.srcElement;
	while(tr.tagName != "TR"){
		tr = tr.parentElement;
		if(tr == "undefined" || tr == null)
			return;
	}
	tr.cells[0].children[0].checked = true;
}

function OpenModalDialog(url)
{
	return showDialog(url, "720px", "500px", false, null);
}

/* 格式化提示（title, alt） */
var pltsPop=null;
var pltsoffsetX = 10;
var pltsoffsetY = 15;
var pltsPopbg="#FFFFEE";
var pltsPopfg="#111111";
var pltsTitle="";
document.write('<div id=pltsTipLayer style="display: none;position: absolute; z-index:10001; font-size:12px;font-family: Tahoma;"></div>');
function pltsinits()
{
    document.onmouseover   = plts;
    document.onmousemove = moveToMouseLoc;
}
function plts()
{  var o=event.srcElement;
if (o==null) 
	return;
    if(o.alt!=null && o.alt!=""){o.dypop=o.alt;o.alt=""};
    if(o.title!=null && o.title!=""){o.dypop=o.title;o.title=""};
    pltsPop=o.dypop;
    if(pltsPop!=null&&pltsPop!=""&&typeof(pltsPop)!="undefined")
    {
	pltsTipLayer.style.left=-1000;
	pltsTipLayer.style.display='';
	var Msg=pltsPop.replace(/\n/g,"<br>");
	Msg=Msg.replace(/\0x13/g,"<br>");
	var re=/\{(.[^\{]*)\}/ig;
	if(!re.test(Msg))pltsTitle="Enterprise SMS Data Center";
	else{
	  re=/\{(.[^\{]*)\}(.*)/ig;
  	  pltsTitle=Msg.replace(re,"$1")+"&nbsp;";
	  re=/\{(.[^\{]*)\}/ig;
	  Msg=Msg.replace(re,"");
	  Msg=Msg.replace("<br>","");}
	  var attr=(document.location.toString().toLowerCase().indexOf("list.asp")>0?"nowrap":"");
       	var content =
      	'<table style="FILTER:alpha(opacity=90) shadow(color=#bbbbbb,direction=135);" id=toolTipTalbe border=0><tr><td width="100%"><table class=youqing cellspacing="1" cellpadding="0" style="width:100%" style="font size:11px;">'+
      	'<tr id=pltsPoptop><th height=18 valign=bottom><p id=topleft align=left>↖'+pltsTitle+'</p><p id=topright align=right style="display:none">'+pltsTitle+'↗</font></th></tr>'+
      	'<tr><td "+attr+" class=f_one style="padding-left:10px;padding-right:10px;padding-top: 4px;padding-bottom:4px;line-height:135%">'+Msg+'</td></tr>'+
      	'<tr id=pltsPopbot style="display:none"><th height=18 valign=bottom><p id=botleft align=left>↙'+pltsTitle+'</p><p id=botright align=right style="display:none">'+pltsTitle+'↘</font></th></tr>'+
      	'</table></td></tr></table>';
       	pltsTipLayer.innerHTML=content;
       	toolTipTalbe.style.width=Math.min(pltsTipLayer.clientWidth,document.body.clientWidth/2.2);
       	moveToMouseLoc();
       	return true;
       }
    else
    {
    	pltsTipLayer.innerHTML='';
      	pltsTipLayer.style.display='none';
       	return true;
    }
}

function moveToMouseLoc()
{
	if(pltsTipLayer.innerHTML=='')return true;
	var MouseX=event.x;
	var MouseY=event.y;
	//window.status=event.y;
	var popHeight=pltsTipLayer.clientHeight;
	var popWidth=pltsTipLayer.clientWidth;
	if(MouseY+pltsoffsetY+popHeight>document.body.clientHeight)
	{
	  	popTopAdjust=-popHeight-pltsoffsetY*1.5;
	  	pltsPoptop.style.display="none";
	  	pltsPopbot.style.display="";
	}
	 else
	{
	   	popTopAdjust=0;
	  	pltsPoptop.style.display="";
	  	pltsPopbot.style.display="none";
	}
	if(MouseX+pltsoffsetX+popWidth>document.body.clientWidth)
	{
		popLeftAdjust=-popWidth-pltsoffsetX*2;
		topleft.style.display="none";
		botleft.style.display="none";
		topright.style.display="";
		botright.style.display="";
	}
	else
	{
		popLeftAdjust=0;
		topleft.style.display="";
		botleft.style.display="";
		topright.style.display="none";
		botright.style.display="none";
	}
	pltsTipLayer.style.left=MouseX+pltsoffsetX+document.body.scrollLeft+popLeftAdjust;
	pltsTipLayer.style.top=MouseY+pltsoffsetY+document.body.scrollTop+popTopAdjust;
  	return true;
}
//pltsinits();
var return_col=Array();
function  ChooseChildData(parm,table_id,column_id,menu_id,tab_seq)
//function  ChooseChildData(parm,table_id,column_id,	menu_id,tab_seq,exist_check_sql,COL_WHITHER,COL_ATTACH)

{
	 var e=event.srcElement.parentElement;
	 var qstring="column="+column_id;
	 	// alert(exist_check_sql);
	if(e.tagName=="TD"){
		var r=e.parentElement.rowIndex;
		 var c = e.cellIndex +1;
	    var vWidth = "750";
		var vHeight = "500" ;		
		
  		var vParam = "width=" + vWidth + ",height="+vHeight+",top=120,left=120,resizable=no,scrollbars=yes";
	   	var object_id = e.children[0].id;
		return_col[0]=object_id;
		var win = window.open("../DataDefine.aspx?"+parm+"&object_id="+object_id+"&sql_txt=", "newwindow",vParam);
		win.focus();
	}
 	
  	return false;
}

function  ChooseDefineData(parm,table_id,column_id,	menu_id,tab_seq,COL_SELECT,COL_WHITHER)
{

	 var e=event.srcElement.parentElement;
	 var qstring="column="+column_id;
	if(e.tagName=="TD"){
		 var r=e.parentElement.rowIndex;
		 var c = e.cellIndex +1;
	    var vWidth = "750";
		var vHeight = "500" ;		
		var check_sql="";

  		var vParam = "width=" + vWidth + ",height="+vHeight+",top=120,left=120,resizable=no,scrollbars=yes";
	   	var object_id = e.children[0].id;
	   	return_col[0]=object_id;
	  
	   	if ( Trim(COL_WHITHER).length > 0 )
	   	{
	   	   	var li_pos=object_id.indexOf(COL_SELECT);
	   	   	
	   		return_col[1]=object_id.substr(0,li_pos) + COL_WHITHER;
	   	}
	   	return_col[0]=object_id;
	   	
		var win = window.open("../DataDefine.aspx?"+parm+"&object_id="+object_id+"&sql_txt=", "newwindow",vParam);
		win.focus();

	}
 	
  	return false;
}
function  	SetValue (data)
{
	  for(var i=0; i< return_col.length; i++)
	   {
		 		document.all.item(return_col[i]).value=data[i];
	   }
}

function Trim(string){
		return string.replace(/(\s+)$/g,"").replace(/^(\s+)/g,"");
}
//设置添加列的属性
      
      
// 更加不同的动作返回不同的字符串
function getInsertHtml(td,dt_column, col)
{
var str_visble;
var str_column_id;
var str_enable;
var str_addhtml ;
str_addhtml ="";


    //显示标题
    if (col < dt_column.Rows.Count)
    {
         str_visble = dt_column.Rows[col]["sys_visible"].ToString();
         str_column_id = dt_column.Rows[col]["column_id"].ToString();
         str_enable = dt_column.Rows[col]["sys_enable"].ToString();
    } 

alert( str_enable);

   //    str_addhtml.Append("<td style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'>");
   
   
        if (str_enable == "1")
        {
            str_addhtml ="<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' type=text value='' id='N_" + str_column_id + "' >";
        }
        else
        {
             str_addhtml ="<INPUT style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' type=text  display  value='' id='N_" + str_column_id + "' >";

        }
                


td.innerHTML = str_addhtml;

return false ;
}


//通过JS弹出一个等待对话框
function close$(){ 
	var elements = new Array(); 
	for(var i = 0;i<arguments.length;i++){ 
		var element = arguments[i]; 
		if (typeof element == 'string') 
			element = document.getElementById(element); 
		if (arguments.length == 1) 
			return element; 
		elements.push(element); 
	} 
	return elements; 
}


function Show(message){
    HideElement();
    var eSrc=(document.all)?window.event.srcElement:arguments[1];
    var shield = document.createElement("DIV");//产生一个背景遮罩层
    shield.id = "shield";
    shield.style.position = "absolute";
    shield.style.left = "0px";
    shield.style.top = "0px";
    shield.style.width = "100%";
    shield.style.height = ((document.documentElement.clientHeight>document.documentElement.scrollHeight)?document.documentElement.clientHeight:document.documentElement.scrollHeight)+"px";
    //shield.style.height =document.body.scrollHeight;
    shield.style.background = "#333";
    shield.style.textAlign = "center";
    shield.style.zIndex = "10000";
    shield.style.filter = "alpha(opacity=0)";
    shield.style.opacity = 0;

    var alertFram = document.createElement("DIV");//产生一个提示框
    var height="50px";
    alertFram.id="alertFram";
    alertFram.style.position = "absolute";
    alertFram.style.width = "300px";
    alertFram.style.height = height;
    alertFram.style.left = "35%";
    alertFram.style.top = "30%";
   // alertFram.style.marginLeft = "-225px" ;
   // alertFram.style.marginTop = -75+document.documentElement.scrollTop+"px";
    alertFram.style.background = "#fff";
    alertFram.style.textAlign = "center";
    alertFram.style.lineHeight = height;
    alertFram.style.zIndex = "10001";

	strHtml =" <div style=\"width:100%;border:#58a3cb solid 1px;text-align:center;padding-top:10px;line-height:30px;font-size:14pt;color:#336600;\">";
	strHtml+=" <IMG SRC=../images/dot/load.gif BORDER=0><BR>&nbsp;";
	if (typeof(message)=="undefined"){
		strHtml+="正在服务器上执行, 请稍候...";
	} 
	else{
		strHtml+=message;
	}
	strHtml+=" </div>";

	strHtml+="<iframe src=\"\" style=\"position:absolute;visibility:inherit;top:0px; left:0px; width:300px;height:100px;z-index:-1;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';\"></iframe>";//加个iframe防止被drowdownlist等控件挡住

	alertFram.innerHTML=strHtml;
	document.body.appendChild(alertFram);
	document.body.appendChild(shield);

	this.setOpacity = function(obj,opacity){
		if(opacity>=1)opacity=opacity/100;
		try{
			obj.style.opacity=opacity; 
		}
		catch(e){}
		try{ 
			if(obj.filters.length>0&&obj.filters("alpha")){
				obj.filters("alpha").opacity=opacity*100;
			}
			else{
				obj.style.filter="alpha(opacity=\""+(opacity*100)+"\")";
			}
		}
		catch(e){}
	}

    var c = 0;
    this.doAlpha = function(){
    if (++c > 20){clearInterval(ad);return 0;}
		setOpacity(shield,c);
    }
    var ad = setInterval("doAlpha()",1);//渐变效果

    eSrc.blur();
    document.body.onselectstart = function(){return false;}
    document.body.oncontextmenu = function(){return false;}
}

   //隐藏页面上一些特殊的控件
function HideElement(){
	var HideElementTemp = new Array('IMG','SELECT','OBJECT','IFRAME');
	for(var j=0;j<HideElementTemp.length;j++){
		try{
			var strElementTagName=HideElementTemp[j];
			for(i=0;i<document.all.tags(strElementTagName).length; i++){
				var objTemp = document.all.tags(strElementTagName)[i];
				if(!objTemp||!objTemp.offsetParent)
				continue;
				//objTemp.style.visibility="hidden";
				objTemp.disabled="disabled"
			}
		}
		catch(e){}
	}
}

function Close(){
	var shield= close$("shield");
	var alertFram= close$("alertFram");
	if(shield!=null) {
		document.body.removeChild(shield);
	}
	if(alertFram!=null) {
		document.body.removeChild(alertFram);
	} 
	document.body.onselectstart = function(){return true};
	document.body.oncontextmenu = function(){return true};
}  //-->