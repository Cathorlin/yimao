//显示当前日期
var xf_i=0;//消费查询的次数
var week = new Array(7);
week[1]="星期一";week[2]="星期二";week[3]="星期三";week[4]="星期四";week[5]="星期五";week[6]="星期六";week[0]="星期天";
dayObj = new Date();
 var username = '<%=Session["user_name"]%>';
if(dayObj.getYear()<1000) year = 1900 + dayObj.getYear();
else year = dayObj.getYear();
DateandWeek = '今天是' + year + '年' + (dayObj.getMonth() + 1) + '月' + dayObj.getDate() + '日' + ' ' ;
function showhidemenu(menuname,sender){
	if(document.getElementById(menuname)){
		var obj=document.getElementById(menuname);
		if(obj.style.display=="none"){
			obj.style.display="block";
			sender.src="../images/arrow_down.jpg"
		}else{
			obj.style.display="none";
			sender.src="../images/arrow_right.jpg"
		}
	}
}
function SelectM001Id(key)
{
    var obj_key= document.getElementById("v_"+key);
   
    var url="../M001/ChooseID.aspx";
    var splashWin= showDialog(url,45,24,false,window);
    if   (splashWin   !=   undefined)   
    {   
   
         var  choose_value = splashWin.DataId;  
        // var obj_key= document.getElementById("v_"+key);
         if (obj_key != null && choose_value !="" && choose_value  != null)
         {
            obj_key.value = choose_value;
         }
    
    }

}

function SelectM002Id(key, menu_) {
    var obj_key = document.getElementById("v_" + key);
    var url_ = "../jump.aspx?menu_id=" + menu_;
    if (obj_key != null) {
        var phone_nm = obj_key.value;
        if (phone_nm == "") {
            location.href = url_;
        }
        else
         {
            if (confirm("您已绑定手机,要重新绑定新手机吗？") )
            {
                 location.href = url_;
            }
            return false;
            
        }
    }

}

function input_onBlur(obj)
{
obj.style.borderColor='#B5B8C8';
}
function  input_onFocus(obj)
{

obj.style.borderColor='#1b3143';

}
function selectDate_m(obj)
{
    selectDate(obj);
}


function doproc(sql,key)
{
  var  this_sql =  BaseDoPage.getDecryptData("",sql).value;
  
  var v = BaseDoPage.execSql(this_sql).value;
 
  
  
  if (v  == "-1" || v==null)
  {
     alert("执行操作失败！")
    
  }
  else
  {
   // alert("执行操作成功！")
   if (v =="0")
   {
   
    trobj = document.getElementById('row'+key);
    
    if (trobj !=null)
    {
        trobj.style.display = "none";
    }
    }
    else
    {
        alert(v);
    }
    
  }
  
  
  
  
}

function updatestate(sql,ls_state)
{
   //提示是否挂失卡
   if(confirm("是否挂失会员卡？")){
     
         if (ls_state != "0")
         {
            alert("不是激活状态的卡不能挂失！");
            return;
         }
          var v = doproc(sql);
          if (v == 1)
          {
             main_modify.changeState('2');
          }
      }
}

// JScript 文件
function getM00203Html(dt_m00203)
{
    var html_ = "<div id=\"m00203\">";
    html_ += "<div class=\"listm00203\">";
    html_ += "<ul>";
    for (var i = 0; i < dt_m00203.Rows.Count; i++)
    {
       //连接的url
      var li_url = http_url + "/" + dt_m00203.Rows[i]["LI_URL"];
      //图片路径
      var pic = http_url + "/images/" + dt_m00203.Rows[i]["PIC"];
      //
      var dp_url = http_url + "/" + dt_m00203.Rows[i]["DP_URL"];

      var dp_count =  dt_m00203.Rows[i]["dp_count"];

      var des = dt_m00203.Rows[i]["des"];
      var m002_name = dt_m00203.Rows[i]["m002_name"];
      var  name = dt_m00203.Rows[i]["name"];
      html_ +="<li id=\"li_m00203_"+ i+"\">";
      html_ +="<div class=\"showrow\">";
      html_ +="<div class=\"pic\">";
      html_ += "<a href=\""+ li_url+ "\" target=_blank>";
      html_ += "<img src=\""+ pic +"\"/></a>";
      html_ +="</div>";
      html_ +="<div class=\"txt\">"
      html_ +="<div class=\"nm1\">"; 
      html_ += name +"<a> 所有者："+ m002_name +"</a>"; 
      html_ +="</div>";  
      html_ +="<div class= \"dp\">"; 
      html_ +="<a href=\""+ dp_url+"\" target=_blank> 点评</a>"
      html_ +="<span><%=dp_count %>条</span>"
      html_ +="</div> "
      html_ +="<div class=\"nm3\">"
      html_ +=des;
      html_ +="</div>"
      html_ +="</div>"
      html_ +="</div>"
      html_ +="</li>"
      
      
    }
     html_ +="</ul>"
     html_ +="</div>"
     html_ +="</div>"
     alert(html_)
}









  function update(tableid)
    {
        //获取页面所有v_id的值

     
        // var ness = document.getElementsByTagName('input');
        
         var ness ="";
         var check = new Array();
         var controls = document.getElementsByTagName('input');
         var str="";
         var pos = 0;
         var data_00 ;
          for(var i=0; i<controls.length; i++)
          {
            if(controls[i].id.indexOf("v_") ==0  )
            {
                //controls[i].value='';
                //如果输入的值不为空
                //
                if  ( controls[i].value == "")
                {
                    data_00 = "null";
                }
                else
                {
                    data_00 = controls[i].value;
                }
                str = str + "{"+controls[i].id + "="+ data_00 +"}"
            
                
            }
            //
            if (controls[i].id.indexOf('_check') >0)
            {
                pos = controls[i].id.indexOf('_check')  ;
                //alert(controls[i].id.substring(1,pos));
                check[check.length] = controls[i] ;//.substring(1,pos);
                   
            }
            //="_113_check"
            
            
            
            //必须填写
            if (controls[i].id =="_ness")
            {
                 ness= BaseDoPage.getDecryptData(tableid,controls[i].value).value;
            }
            
            
             
            
            
          }   
          var ness_list = ness.split(",");
          var ness_id="";
          for (var i= 0;i < ness_list.length - 1 ;i++)
          {
             ness_id = "v_" + ness_list[i];
             var obj_v = document.getElementById(ness_id);
             if (obj_v != null)
             {
                if (trim(obj_v.value)=="") 
                {
                    //
                    alert("填写的信息不完整！")
                    if (obj_v.type =="text")
                    {
                        obj_v.focus();
                    }
                    return ;
                }
             }
          
          }
                    var obj_key= document.getElementById(tableid+"_KEY");
                    
          var key = obj_key.value;
          var pk_key_ = key;
          var userid = document.getElementById("userid").value;
          
          /*检测存在性 判断返回的sql值是否是1*/
          
          for ( i= 0;i < check.length ;i++)
          {
               //   pos = controls[i].id.indexOf('_check')  ;
              //    alert(controls[i].id.substring(1,pos));
              //    ness_id = "_" + check[i]+"_check";
              var ch_sql = check[i].value ;// BaseDoPage.getDecryptData(tableid,check[i].value).value;
              var pos1 = ch_sql.indexOf('[');
              var pos2 = ch_sql.indexOf(']');
              //获取当前的值

              
              var pos = check[i].id.indexOf('_check')  ;
              var obj_d =   document.getElementById("v_"+ check[i].id.substring(1,pos));
              //alert("v_"+ check[i].id.substring(1,pos));
              if (obj_d ==null ||  trim(obj_d.value) == "" )
              {
                continue 
              }

              
              var t=0;
              while (pos1 > 0 && pos2 > 0 && t < 100)
              {
                var id = ch_sql.substring(pos1 + 1 ,pos2);
                
                obj_v = document.getElementById("v_"+ id);
                if (obj_v != null)
                {
                    ch_sql = ch_sql.replace("["+id+"]",obj_v.value);
                }
                else
                {
                    ch_sql = ch_sql.replace("["+id+"]","");
                }
                pos1 = ch_sql.indexOf('[');
                pos2 = ch_sql.indexOf(']');
                t = t +1 ;
                
              }
             
          
               var v_d = BaseDoPage.getCheckData(ch_sql,key).value;
               if (v_d == "0" )
               {
                alert("存在性检测失败！")
                if (obj_d.type =="text")
                {
                    obj_d.focus();
                }
                return  ;
               
               }              
           }
          
          
          //    public String  saveData(string t_id,string datalist,string pk_key)
          var v= BaseDoPage.saveData(tableid,str,pk_key_,userid,'0').value;
          if (v !="Error"  && v != null)
          {
             obj_key.value = v;
             alert("保存数据成功！");
             return ;
          }
          alert("保存数据失败！");
          
    }
    
  function PageFooter(){
        document.writeln(" <!--底部 开始-->");
        document.writeln("  <div class=\"footer\">");
        document.writeln("    <div class=\"footer_lr\"> <a href=\"javascript:;\"   class=\"link1\">友情链接<\/a><\/div>");
        document.writeln("    <div class=\"footer_lrr\"><img src=\"../images/ydba.gif\" width=\"12\" height=\"13\" \/> 浙ICP备<a href=\"http://www.miibeian.gov.cn\" target=_blank class=\"link1\">11028857号<\/a> | 上海博脉信息科技有限公司 版权所有 <\/div>");
        document.writeln("  <\/div>");
        document.writeln("  <div class=\"separate_10px\"><\/div>");
        document.writeln("  <!--底部 结束-->");
   }
   function PageHeader(){
   var  str = "";
   str = str + '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="1000" height="80">';
   str = str +   ' <param name="movie" value="../Images/topflash.swf" />';
    str = str +  ' <param name="quality" value="high" />';
    str = str +   '<embed src="../Images/topflash.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="1000" height="80"></embed>';
    str = str + ' </object>';
    document.write(str);
    }
    
function checkPwdFmt(password){
	if(password == '') {
		return false;
	}
	else {
		//密码长度检查
		if(password.length < 6 || password.length > 12) {
			return false;
		}
		//密码字符检查
		else if(!passwordValidator(password)) {
			return false;
		}
		//密码不能与账号相同
		//else if(password == 'zweiatsh') {
		//	return false;
		//}
		else {
			return true;
		}
	}
}
function passwordValidator(password) {
	var numFlag = 2;
	var charFlag = 2;
	validnum = /^\d$/;
	validchar = /^\[a-zA-Z]+$/;
	validall = /^\w{6,12}$/;
	if(!validall.test(password)) {
		return false;
	}
	else {
		for(var i = 0; i < password.length; i++) {
			cPwd = password.substr(i, 1);
			if(validnum.test(cPwd)) {
				numFlag = 1;
			}
			else if(65 < cPwd < 90 || 97 < cPwd < 122) {
				charFlag = 1;
			}
			if((numFlag == 1) && (charFlag == 1)) {
				break;
			}
		}
		if((numFlag == 2) || (charFlag == 2)) {
			return false;
		}
	}
	return true;	
}
//修改用户密码
var CUSER="";
var CTYPE="1";
function check_data(){
	var old_pwd= document.getElementById("old_pwd").value;
	var new_pwd=  document.getElementById("new_pwd").value;
	var new_pwd_cfm=document.getElementById("new_pwd_cfm").value;
	if (CTYPE =="1")
	{
	    if(old_pwd.length < 1 || old_pwd.length > 25){
		    alert('请输入旧密码!');
		    document.getElementById("old_pwd").focus(); 
		    return  -1;
	    }
	}
	//if(!checkPwdFmt(new_pwd)){
		//alert('请输入英文字母加数字的新密码密码长度6-12位');
		//document.getElementById("new_pwd").focus(); 
		//return -1;
	//}
	if (new_pwd.length < 1)
	{
	    alert('请输入新密码!');
		document.getElementById("old_pwd").focus(); 
		return  -1;
	}
	
	
	if(new_pwd!=new_pwd_cfm){
	   alert('确认密码不一致')
	   	document.getElementById("new_pwd_cfm").focus(); 
		return -1;
	}
}

function update_pass_()
{
    
     if  (check_data() == "-1")//检测数据     {
         return;
     }
     /*校验旧密码*/
     var old_pwd= document.getElementById("old_pwd").value;
     var new_pwd=  document.getElementById("new_pwd").value;     //
         var check_=ChangePass.changePass(old_pwd,new_pwd).value;
         if (check_ != "1")
         {
                alert(check_);
        	    return;
            	
         }
           alert("更改密码成功！")

         var next_do =  BaseDoPage.getSession("next_do").value;
            
             if  (next_do != "")
             {
                location.href = next_do;
             }
             else
             {
             
         var number =  Math.random() * 100000; 
                      location.href  = "changePass.aspx?code="+ number;
             }
 
     //保存密码
     
     

}

function update_pass()
{
 if  (check_data() == "-1")//检测数据 {
    return;
 }
  //更新数据库中的数据
  /*校验旧密码*/
     var old_pwd= document.getElementById("old_pwd").value;
     var new_pwd=  document.getElementById("new_pwd").value;     //
         var check_=main_modify.changePass(old_pwd,new_pwd).value;
         if (check_ != "1")
         {
                alert(check_);
        	    return;
            	
         }
          alert("更改密码成功！")


   /* var ls_password =  BaseDoPage.getDecryptData(table_id,ls_password_).value;
  	var new_pwd=  document.getElementById("new_pwd").value;
    var this_sql =  BaseDoPage.getDecryptData("",this_sql_).value;
 	var old_pwd= document.getElementById("old_pwd").value;
  	if(old_pwd!=ls_password){
	   alert('旧密码和系统密码不一致')
	   	document.getElementById("old_pwd").focus(); 
		return;
	}
	var  new_pwd=BaseDoPage.getEncryptData(table_id,new_pwd).value;
	this_sql=this_sql.replace('[SYS_PASSWORD]',new_pwd)
    var v = BaseDoPage.execSql(this_sql).value;
      if (v  == "-1" || v==null)
      {
         alert("更改密码失败！")
        
      }
      else
      {
        alert("更改密码成功！")
       }  
        */
        url = location.href;
        location.href = url;  //window.location.href
     
}
 function check_clear()
 {
 	document.getElementById("old_pwd").value="";
	document.getElementById("new_pwd").value="";
	document.getElementById("new_pwd_cfm").value="";
 }
function update_add(ls_sql,ls_id)//加盟商户
{
   var v = doproc(ls_sql);
   if (v ==1)
   {
       document.getElementById(ls_id).value="已加盟";
       document.getElementById(ls_id).disabled =!(document.getElementById(ls_id).disabled);
   }
   
}
function update_delete(ls_sql,ls_id)//加盟商户
{
  var v = doproc(ls_sql);
    if (v ==1)
    {
       document.getElementById(ls_id).value="加盟";
       document.getElementById(ls_id).disabled =!(document.getElementById(ls_id).disabled);
      }
   
}
function rbselectchange(obj)
{
   // alert();
    //rb_191
    var id = obj.name;
    var d_list_ = id.split("_");
    var row = d_list_[0];
    var col = d_list_[1];
    var this_obj=document.getElementById("v_"+col);
    //this_obj.value = obj.value;
    //获取select的值
    if (this_obj != null)
    {
        this_obj.value  =  obj.value;	    
   
    }   

}
function flash_ad()
{
 if(typeof sas=="undefined")var sas=new Object();if(typeof sas.ued=="undefined")sas.ued=new Object();if(typeof sas.ued.util=="undefined")sas.ued.util=new Object();if(typeof sas.ued.FlashObjectUtil=="undefined")sas.ued.FlashObjectUtil=new Object();sas.ued.FlashObject=function(swf,id,w,h,ver,c,useExpressInstall,quality,xiRedirectUrl,redirectUrl,detectKey){if(!document.createElement||!document.getElementById)return;this.DETECT_KEY=detectKey?detectKey:'detectflash';this.skipDetect=sas.ued.util.getRequestParameter(this.DETECT_KEY);this.params=new Object();this.variables=new Object();this.attributes=new Array();this.useExpressInstall=useExpressInstall;if(swf)this.setAttribute('swf',swf);if(id)this.setAttribute('id',id);if(w)this.setAttribute('width',w);if(h)this.setAttribute('height',h);if(ver)this.setAttribute('version',new sas.ued.PlayerVersion(ver.toString().split(".")));this.installedVer=sas.ued.FlashObjectUtil.getPlayerVersion(this.getAttribute('version'),useExpressInstall);if(c)this.addParam('bgcolor',c);var q=quality?quality:'high';this.addParam('quality',q);var xir=(xiRedirectUrl)?xiRedirectUrl:window.location;this.setAttribute('xiRedirectUrl',xir);this.setAttribute('redirectUrl','');if(redirectUrl)this.setAttribute('redirectUrl',redirectUrl)};sas.ued.FlashObject.prototype={setAttribute:function(name,value){this.attributes[name]=value},getAttribute:function(name){return this.attributes[name]},addParam:function(name,value){this.params[name]=value},getParams:function(){return this.params},addVariable:function(name,value){this.variables[name]=value},getVariable:function(name){return this.variables[name]},getVariables:function(){return this.variables},createParamTag:function(n,v){var p=document.createElement('param');p.setAttribute('name',n);p.setAttribute('value',v);return p},getVariablePairs:function(){var variablePairs=new Array();var key;var variables=this.getVariables();for(key in variables){variablePairs.push(key+"="+variables[key])}return variablePairs},getFlashHTML:function(){var flashNode="";if(navigator.plugins&&navigator.mimeTypes&&navigator.mimeTypes.length){if(this.getAttribute("doExpressInstall"))this.addVariable("MMplayerType","PlugIn");flashNode='<embed type="application/x-shockwave-flash" src="'+this.getAttribute('swf')+'" width="'+this.getAttribute('width')+'" height="'+this.getAttribute('height')+'"';flashNode+=' id="'+this.getAttribute('id')+'" name="'+this.getAttribute('id')+'" ';var params=this.getParams();for(var key in params){flashNode+=[key]+'="'+params[key]+'" '}var pairs=this.getVariablePairs().join("&");if(pairs.length>0){flashNode+='flashvars="'+pairs+'"'}flashNode+='/>'}else{if(this.getAttribute("doExpressInstall"))this.addVariable("MMplayerType","ActiveX");flashNode='<object id="'+this.getAttribute('id')+'" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="'+this.getAttribute('width')+'" height="'+this.getAttribute('height')+'">';flashNode+='<param name="movie" value="'+this.getAttribute('swf')+'" />';var params=this.getParams();for(var key in params){flashNode+='<param name="'+key+'" value="'+params[key]+'" />'}var pairs=this.getVariablePairs().join("&");if(pairs.length>0){flashNode+='<param name="flashvars" value="'+pairs+'" />'}flashNode+="</object>"}return flashNode},write:function(elementId){if(this.useExpressInstall){var expressInstallReqVer=new sas.ued.PlayerVersion([6,0,65]);if(this.installedVer.versionIsValid(expressInstallReqVer)&&!this.installedVer.versionIsValid(this.getAttribute('version'))){this.setAttribute('doExpressInstall',true);this.addVariable("MMredirectURL",escape(this.getAttribute('xiRedirectUrl')));document.title=document.title.slice(0,47)+" - Flash Player Installation";this.addVariable("MMdoctitle",document.title)}}else{this.setAttribute('doExpressInstall',false)}if(this.skipDetect||this.getAttribute('doExpressInstall')||this.installedVer.versionIsValid(this.getAttribute('version'))){var n=(typeof elementId=='string')?document.getElementById(elementId):elementId;n.innerHTML=this.getFlashHTML()}else{if(this.getAttribute('redirectUrl')!=""){document.location.replace(this.getAttribute('redirectUrl'))}}}};sas.ued.FlashObjectUtil.getPlayerVersion=function(reqVer,xiInstall){var PlayerVersion=new sas.ued.PlayerVersion(0,0,0);if(navigator.plugins&&navigator.mimeTypes.length){var x=navigator.plugins["Shockwave Flash"];if(x&&x.description){PlayerVersion=new sas.ued.PlayerVersion(x.description.replace(/([a-z]|[A-Z]|\s)+/,"").replace(/(\s+r|\s+b[0-9]+)/,".").split("."))}}else{try{var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");for(var i=3;axo!=null;i++){axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash."+i);PlayerVersion=new sas.ued.PlayerVersion([i,0,0])}}catch(e){}if(reqVer&&PlayerVersion.major>reqVer.major)return PlayerVersion;if(!reqVer||((reqVer.minor!=0||reqVer.rev!=0)&&PlayerVersion.major==reqVer.major)||PlayerVersion.major!=6||xiInstall){try{PlayerVersion=new sas.ued.PlayerVersion(axo.GetVariable("$version").split(" ")[1].split(","))}catch(e){}}}return PlayerVersion};sas.ued.PlayerVersion=function(arrVersion){this.major=parseInt(arrVersion[0])||0;this.minor=parseInt(arrVersion[1])||0;this.rev=parseInt(arrVersion[2])||0};sas.ued.PlayerVersion.prototype.versionIsValid=function(fv){if(this.major<fv.major)return false;if(this.major>fv.major)return true;if(this.minor<fv.minor)return false;if(this.minor>fv.minor)return true;if(this.rev<fv.rev)return false;return true};sas.ued.util={getRequestParameter:function(param){var q=document.location.search||document.location.href.hash;if(q){var startIndex=q.indexOf(param+"=");var endIndex=(q.indexOf("&",startIndex)>-1)?q.indexOf("&",startIndex):q.length;if(q.length>1&&startIndex>-1){return q.substring(q.indexOf("=",startIndex)+1,endIndex)}}return""}};if(Array.prototype.push==null){Array.prototype.push=function(item){this[this.length]=item;return this.length}}var getQueryParamValue=sas.ued.util.getRequestParameter;var sohuFlash=sas.ued.FlashObject;
function Cookie(document,name,hours,path,domain,secure){this.$document=document;this.$name=name;this.$expiration=hours?new Date((new Date()).getTime()+hours*3600000):null;this.$path=path?path:null;this.$domain=domain?domain:null;this.$secure=secure;};Cookie.prototype.store=function (){var cookieval="";for(var prop in this){if((prop.charAt(0)=='$')||((typeof this[prop])=='function')) continue;if(cookieval!="") cookieval+='&';cookieval+=prop+':'+escape(this[prop]);}var cookie=this.$name+'='+cookieval;if(this.$expiration)cookie+='; expires='+this.$expiration.toGMTString();if(this.$path) cookie+='; path='+this.$path;if(this.$domain) cookie+='; domain='+this.$domain;if(this.$secure) cookie+='; secure';this.$document.cookie=cookie;};Cookie.prototype.load=function(){var allcookies=this.$document.cookie;if(allcookies=="") return false;var start=allcookies.indexOf(this.$name+'=');if(start==-1) return false;start+=this.$name.length+1;var end=allcookies.indexOf(';',start);if(end==-1) end=allcookies.length;var cookieval=allcookies.substring(start,end);var a=cookieval.split('&');for(var i=0; i<a.length; i++) a[i]=a[i].split(':');for(var i=0; i<a.length; i++) this[a[i][0]]=unescape(a[i][1]);return true;};Cookie.prototype.remove = function(){var cookie;cookie = this.$name + '=';if (this.$path) cookie += '; path=' + this.$path;if (this.$domain) cookie += '; domain=' + this.$domain;cookie += '; expires=Fri, 02-Jan-1970 00:00:00 GMT';this.$document.cookie = cookie;};

	var pics='../images/a-01.jpg|../images/a-02.jpg|../images/a-03.jpg|../images/a-04.jpg|../images/a-05.jpg|_|../images/b-01.jpg|../images/b-02.jpg|../images/b-03.jpg|../images/b-04.jpg|../images/b-05.jpg|_|../images/c-01.jpg|../images/c-02.jpg|../images/c-03.jpg|../images/c-04.jpg|../images/c-05.jpg';
	var
links='javascript:;|javascript:;|javascript:;|javascript:;|javascript:;|_|javascript:;|javascript:;|javascript:;|javascript:;|javascript:;|_|javascript:;|javascript:;|javascript:;|javascript:;|javascript:;'; 	

var texts='|||';
	
	var sohuFlash2 = new sohuFlash("../flash/3dswf.swf","sohuFlashID01","230","180","6","#ffffff");
	sohuFlash2.addParam("quality", "high");
	sohuFlash2.addParam("salign", "t");
	sohuFlash2.addParam("wmode", "opaque");
	sohuFlash2.addVariable("pics",pics);
	sohuFlash2.addVariable("links",links);
	sohuFlash2.addVariable("texts",texts);
	sohuFlash2.write("3dswf")
}
function ru_jifen(m002_key,point,pro_store)
{
 var  ls_m002_key =  BaseDoPage.getDecryptData("",m002_key).value;
 //document.getElementById("div_content").style.display='none';
 var ls_html =  main_modify.getHtmlJF(ls_m002_key,pro_store,point).value;
  var inner = "积分:"+point+"<br>"+ ls_html
  var mycell = document.getElementById("div_td_content")
   //   var mycell = myrow.insertCell();	 
	   mycell.innerHTML=inner;
  // document.write(ls_html);
}
//function update_dh(sql,ls_point,ls_qty,ls_hold_point)//积分兑换
//{
//     if (ls_qty<=0){
//       alert("兑换物品的数量为0,不能兑换！");
//        return ;
//       }
//     if(ls_point > ls_hold_point){
//       alert("兑换物品的分数大于你所拥有的积分！");
//          return ;
//     }
//     window.open('http://www.baidu.com','');
//  //   window.open( 'product_jf.aspx', ' ')
//    // location.href = "product_jf.aspx?key="+sql;
// //    var v = doproc(sql);
////          if (v == 1)
////          {
////              location.href = "../jump.aspx?menu_id=200207";
////          }

//}
function update_send_dh(sql,ls_point_user,ls_qty,ls_user_key,ls_user)//积分兑换
{

  var ls_type;
  var ls_time;
  var ls_address;
  var  ls_coumn;
  ls_coumn = " ";
   var  send_address = document.getElementsByName("send_address");//获取被选中的地址值
  for(var i=0;i< send_address.length;i++)
   {
     if(send_address[i].checked)
     {
       ls_address = send_address[i].value;
     }
   }

   var send_type = document.getElementsByName("send_type");//获取被选中的类型值
   for(var i=0;i< send_type.length;i++)
   {
     if(send_type[i].checked)
     {
       ls_type = send_type[i].value;
     }
   }

   var send_time = document.getElementsByName("send_time");//获取被选中的时间值
  for(var i=0;i< send_time.length;i++)
   {
     if(send_time[i].checked)
     {
       ls_time = send_time[i].value;
     }
   }
  
         
    var  ls_amount  =  document.getElementById('amout_hufeijf').value ;
    var  ls_buyqty = document.getElementById('quantityInput').value ;
    alert(ls_point_user);
    alert(ls_amount);
     if (parseInt(ls_qty)<=0){
          alert("兑换物品的数量为0,不能兑换！");
          return ;
        }
      if(parseInt(ls_buyqty) > parseInt(ls_qty))
      {
          alert("兑换物品的数量大于存货的数量,不能兑换！");
          return ;
      }
     if(parseInt(ls_amount) > parseInt(ls_point_user)){
        alert("兑换物品的分数大于你所拥有的积分,不能兑换！");
        return ;
     }
     if(ls_address=="Other")//检测地址是否填写完全
     {   var add1=document.getElementById("Select1").value;
         alert(add1);
         var add2=document.getElementById("Select2").value;
            alert(add2);
         var add3=document.getElementById("Select3").value;
            alert(add3);
         //var  deliverpostCode = document.getElementById("deliverpostCode").value ;//邮政
           //  alert(deliverpostCode);
          var  deliverAddress =  document.getElementById("deliverAddress").value ;//地址
           alert(deliverAddress);
         var   deliverName =  document.getElementById("deliverName").value ;//送货人
             alert(deliverName);
         var    deliverPhoneBak =  document.getElementById("deliverPhoneBak").value ;//手机
           alert(deliverPhoneBak);
         var   phoneSection =  document.getElementById("phoneSection").value ; //电话1
            alert(phoneSection);
         var  phoneCode  =  document.getElementById("phoneCode").value ; //电话2
           alert(phoneCode);
         var  phoneExt =  document.getElementById("phoneExt").value ;//电话3
                alert(phoneExt);
          ls_coumn = "'"+deliverAddress+"','"+deliverName+"','"+deliverPhoneBak+"','"+phoneSection+'-'+phoneCode+'-'+phoneExt+"','"+add1+"','"+add2+"','"+add3+"'";
         alert(ls_coumn);
     }
   var ls_sql = product_jf.updatedatabase(sql,ls_address,ls_type,ls_time ,ls_coumn,ls_user_key,ls_amount,ls_user).value;
   if (ls_sql=="Error")
   {
     alert("更新数据失败！");
   }
   else
   {
     var v = doproc(ls_sql);
   }
}
function query_xf(sql_dt,sql_dw,ls_action)
{
   xf_i = xf_i + 1;
  var beg_time = document.getElementById("TimeBegin").value;
  var end_time = document.getElementById("TimeEnd").value;
  var m002_name = document.getElementById("select_m002_name").value;
//  for(var i=0;i<xf_i;i++)
//  {
//     alert("div_content_xf_"+i);
//     var ls_type= document.getElementById("div_content_xf_"+i).style.display
//     alter(ls_type);  
//     if(document.getElementById("div_content_xf_"+i).style.display !='none')
//     {
//        document.getElementById("div_content_xf_"+i).style.display='none';
//      }
//  }
  var ls_html =  main_modify.getHtmlXF(sql_dt,sql_dw,ls_action,beg_time,end_time,m002_name).value;
  var inner = "<div id='div_content_xf_"+xf_i+"'>"+ ls_html+"</div>";
  var mycell = document.getElementById("div_td_content_xf")
   //   var mycell = myrow.insertCell();	 
	   mycell.innerHTML=inner;
  
}
var PAGE_ROWS =20 ;
var PAGE_ROWS_PIC =2 ;//图片一行8个
function showpage(pagenum)
{
    var s= (pagenum - 1 ) * PAGE_ROWS ;
    var e = pagenum * PAGE_ROWS;
    var obj_tr ;
     for(var i= 0 ; i< 10000; i++  )
     {
        obj_tr=document.getElementById("row" + i)
        if (obj_tr != null)
        {
            if (i >=s && i < e)
            {
                obj_tr.style.display ="";
            }
            else
            {
                 obj_tr.style.display ="none";
            }
        }
        else
        {
            break;
        }
        
     }

}
function showpage_pic(pagenum)
{
    var s= (pagenum - 1 ) * PAGE_ROWS_PIC ;
    var e = pagenum * PAGE_ROWS_PIC;
    var obj_tr ;
     for(var i= 0 ; i< 10000; i++  )
     {
        obj_tr=document.getElementById("row" + i)
        if (obj_tr != null)
        {
            if (i >=s && i < e)
            {
                obj_tr.style.display ="";
            }
            else
            {
                 obj_tr.style.display ="none";
            }
        }
        else
        {
            break;
        }
        
     }

}
function update_jf_send(ls_key,ls_tab,ls_pro_store,ls_user)
{
 var ls_html =  product_jf.getHTMLJF_send(ls_key,ls_tab,ls_pro_store,ls_user).value;

     if(navigator.appName.indexOf("Explorer") > -1) 
     {
   // var text = document.getElementById("div_content_jf").innerText; 
    document.getElementById("div_content_jf").innerHTML = ls_html;
       Init();
    }

    else
    { 
    var text = document.getElementById("div_content_jf").textContent; 
    }
   
}
 var   xmlDoc;   
  var   nodeIndex; 
  function   getxmlDoc()   
  {   
      xmlDoc=new   ActiveXObject("Microsoft.XMLDOM");   
          var   currNode;   
          xmlDoc.async=false;   
          xmlDoc.load("Area.xml");   
          if(xmlDoc.parseError.errorCode!=0)   
          {   
                  var   myErr=xmlDoc.parseError;   
                  alert("出错！"+myErr.reason);   
          }           
  }
  function Init()
  {
    //打开xlmdocm文档
    getxmlDoc();
    var   dropElement1=document.getElementById("Select1"); 
    var   dropElement2=document.getElementById("Select2"); 
    var   dropElement3=document.getElementById("Select3");   
    RemoveDropDownList(dropElement1);
    RemoveDropDownList(dropElement2);
    RemoveDropDownList(dropElement3);
    var  TopnodeList=xmlDoc.selectSingleNode("address").childNodes;
    if(TopnodeList.length>0)
    {
        //省份列表
        var country;
        var province;
        var city;
        for(var   i=0; i<TopnodeList.length;   i++)
        {
              //添加列表项目
              country=TopnodeList[i];       
              var   eOption=document.createElement("option");   
              eOption.value=country.getAttribute("name");
              eOption.text=country.getAttribute("name");
              dropElement1.add(eOption);
        }
        if(TopnodeList[0].childNodes.length>0)
        {
            //城市列表
            for(var i=0;i<TopnodeList[0].childNodes.length;i++)
            {
               var   id=dropElement1.options[0].value;
               //默认为第一个省份的城市
               province=TopnodeList[0]; 
               var   eOption=document.createElement("option");  
               eOption.value=province.childNodes[i].getAttribute("name");   
               eOption.text=province.childNodes[i].getAttribute("name");   
               dropElement2.add(eOption);
            }
            if(TopnodeList[0].childNodes[0].childNodes.length>0)
            {
               //县列表
               for(var i=0;i<TopnodeList[0].childNodes[0].childNodes.length;i++)
               {
                  var   id=dropElement2.options[0].value;
                  //默认为第一个城市的第一个县列表
                  city=TopnodeList[0].childNodes[0];  
                  var   eOption=document.createElement("option");  
                  eOption.value=city.childNodes[i].getAttribute("name");   
                  eOption.text=city.childNodes[i].getAttribute("name");   
                  this.document.getElementById("Select3").add(eOption);
               }
            }
        }
    }
  }   
  function   selectCity()   
  {       var   dropElement1=document.getElementById("Select1"); 
          var   name=dropElement1.options[dropElement1.selectedIndex].value;
          //alert(id);
          var   countryNodes=xmlDoc.selectSingleNode('//address/province [@name="'+name+'"]');   
          //alert(countryNodes.childNodes.length); 
          var   province=document.getElementById("Select2");       
          var   city=document.getElementById("Select3");       
          RemoveDropDownList(province);   
          RemoveDropDownList(city);
          if(countryNodes.childNodes.length>0)
          {
               //填充城市          
               for(var   i=0;   i<countryNodes.childNodes.length;   i++)   
               {   
                  var   provinceNode=countryNodes.childNodes[i];     
                  var   eOption=document.createElement("option");   
                  eOption.value=provinceNode.getAttribute("name");   
                  eOption.text=provinceNode.getAttribute("name");   
                  province.add(eOption);   
               }
               if(countryNodes.childNodes[0].childNodes.length>0)
               {
                  //填充选择省份的第一个城市的县列表
                  for(var i=0;i<countryNodes.childNodes[0].childNodes.length;i++)
                  {
                      //alert("i="+i+"\r\n"+"length="+countryNodes.childNodes[0].childNodes.length+"\r\n");
                      var   dropElement2=document.getElementById("Select2"); 
                      var   dropElement3=document.getElementById("Select3"); 
                      //取当天省份下第一个城市列表
                      var cityNode=countryNodes.childNodes[0];
                      //alert(cityNode.childNodes.length); 
                      var   eOption=document.createElement("option");  
                      eOption.value=cityNode.childNodes[i].getAttribute("name");   
                      eOption.text=cityNode.childNodes[i].getAttribute("name");   
                      dropElement3.add(eOption);
                  }
               }
          }
  }   
  function   selectCountry()   
  {   
          var   dropElement2=document.getElementById("Select2");   
          var   name=dropElement2.options[dropElement2.selectedIndex].value;   
          var   provinceNode=xmlDoc.selectSingleNode('//address/province/city[@name="'+name+'"]');   
          var   city=document.getElementById("Select3");       
          RemoveDropDownList(city);   
          for(var   i=0;   i<provinceNode.childNodes.length;   i++)   
          {   
                  var   cityNode=provinceNode.childNodes[i];     
                  var   eOption=document.createElement("option");   
                  eOption.value=cityNode.getAttribute("name");   
                  eOption.text=cityNode.getAttribute("name");   
                  city.add(eOption);   
          }   
  }   
  function   RemoveDropDownList(obj)   
  {   
      if(obj)
      {
          var   len=obj.options.length;   
          if(len>0)
          {
            //alert(len);   
            for(var   i=len;i>=0;i--)   
            {   
                  obj.remove(i);   
            }
          }
       }
            
  }   
 function Set_hidden(obj,ul_id,radioname,class_id,ls_if)
 {
   
   // obj.parentNode.style.background='ff0000';
   var  li_i= document.getElementById(ul_id).getElementsByTagName('li').length;
   for(var i= 0 ;i < li_i; i++)
   {
      document.getElementById(ul_id).getElementsByTagName('li')[i].className =  'unselected';
   }
     obj.parentNode.className = 'selected';
   if  ( radioname == "send_address" )
   {
       if (ls_if=="1")
       {
        document.getElementById(class_id).className = 'other-address';
       }
       else
       {
         document.getElementById(class_id).className = 'other-address hidden';
       }
    }
 }
 function jf_jisuan(obj,price_wupin)
 {
 alert("fan");
  var  qty  = obj.value;
  alert(qty);
  var price = document.getElementById(price_wupin).value;
    alert(price);
  if (price==""){ price = 0;}
  if (qty=="") { qty = 0;}
  var  amount = qty * price;
  alert(amount);
  document.getElementById('amout_hufeijf').value = amount;
 }
 
 
 
    /*检测输入的手机号码*/
   function check_mobile_no(obj)
   {
        /*检验输入的数据号码的格式 和 是否 已经使用 过*/
        var ma =["* 手机号不能为空","* 请输入11位数中国移动手机号"];
         var s = obj.value;
	    if(s==null||s.length==0)
	    {
		    showInfo(obj.id,ma[0]);
		    return false;
	    }
	    if(!isMobile(s)){
		    showInfo(obj.id,ma[1]);
		    return false;
	    }
	    if(s.length < 11){
		    showInfo(obj.id,ma[1]);
		    return false;
        }if(!isNumber(s)){
		    showInfo(obj.id,ma[1]);
		    return false;
	     } 		
	    //检测手机号码是否已经被使用
	     
	     var v = main_modify.checkBdMobile(s).value;
	     if (v != "1") {
	         showInfo(obj.id, v);
	         document.getElementById("sendmsgA").disabled = true;
	         return false;
	     }
	     else {
	         document.getElementById("sendmsgA").disabled = false;
         }
	     ifcheckmsg = false ;
	     return true;
	 }
	
   function SendMsg()
   {
        var obj = document.getElementById("mobile_no");
        var s = obj.value;
        if (s == "") {
            alert("请输入您要绑定的手机号码！");
            return;
        }
        var r = BaseDoPage.getRANDOM(8).value;
        v = BaseDoPage.SendSms(s, 'MOBILE', r).value;
        if (v == "0") 
        {
            alert("验证码已发送！");
            waittime = 5;
            document.getElementById("sendmsgA").disabled = true;
            setbuttontime();

        }

        ifcheckmsg = false;


    }
    var speed = 1000;
    var waittime = 5;
    function setbuttontime() {
        var obj = document.getElementById("sendmsgA");
        if (waittime == 0) {
            obj.disabled = false;
            obj.innerText = "点击获取验证码";
           // waittime = 30;
        }
        else {
            obj.innerText = "请等待" + waittime + "S";
            waittime--;
            window.setTimeout("setbuttontime()", speed);
        }
    }

   var ifcheckmsg = false ;
   function CheckMsg(obj_yzm)
   {
         var obj = document.getElementById("mobile_no");
         var s = obj.value;
         var yzm = obj_yzm.value;
         if (yzm != "")
         {
             var v = BaseDoPage.CheckSms(s,yzm).value;
             if (v != "1")
             {
                showInfo(obj_yzm.id,"错误的验证码");
                return false ;
             }
             else
             {
                showInfo(obj_yzm.id,"");
             }
             ifcheckmsg = true ;
         }
         return true ;
   }
   /*绑定手机号码*/
   function  BdMobile()
   {
         var obj = document.getElementById("mobile_no");
         var s = obj.value;
         if (s=="")
         {
            alert("请输入手机号码！")
            return false;
         }
         var  obj_yzm = document.getElementById("yzm");
         var yzm = obj_yzm.value;
         if (yzm=="")
         {
            alert("请输入手机号码！")
            return false;
         }
         
         var v = BaseDoPage.CheckSms(s,yzm).value;
    
         if (v=="1")
         {
            var m001_key_ = BaseDoPage.getSession("M001_KEY").value;
            var sql ="Update M001 set mobile_no='"+ s +"' where m001_key=" + m001_key_;
          // alert(sql);
            v = BaseDoPage.execSql(sql).value;
            if (v != "0")
            {
                alert(v)
                return false ;
            }
            alert("已成功绑定手机号码"+ s);
            location.href="main_user.aspx"
         }
         else
         {
            alert("验证码错误！")
         }
        return true;
   }