// JScript 文件
var table_id ="";

function onlyNum()
{
 // event.returnValue=true;
  /*
 if(!(event.keyCode==46)&&!(event.keyCode==8)&&!(event.keyCode==37)&&!(event.keyCode==39))
  if(!((event.keyCode>=48&&event.keyCode<=57)||(event.keyCode>=96&&event.keyCode<=105)))
    event.returnValue=false;
 */
}
function Crystal_print()
{   

  var number =  Math.random() * 100000; 
  url ="../base_ql/Crystal_Report.aspx?code="+number;
  window.open(url,"_blank");

}
//消费券时间控制


function ChooseUseTime(key)
{

       var obj_key= document.getElementById(table_id+"_KEY");
       var key000 = obj_key.value;
       var pk_key_ = key000;
       var key_0 =  BaseDoPage.getDecryptData("",pk_key_).value;
     
        if (key_0 == "-1") //表示新增
        {
            //先保存数据


            
           lb_update=   update(table_id,false);
           if (lb_update !=  "1")
           {
                return ;
           }
          
          pk_key_ = obj_key.value;
          key_0 =  BaseDoPage.getDecryptData("",pk_key_).value;
        }
         var number =  Math.random() * 100000; 
         var url="../m001/choosetime.aspx?code="+number;
       //  alert(key_0)
         var v = BaseDoPage.setSession("PK_M00203_KEY",key_0).value;
         var splashWin= showDialog(url,43,18,false,window);
}

function loadpic(key)
{


          var obj_key= document.getElementById(table_id+"_KEY");

          var key000 = obj_key.value;
          var pk_key_ = key000;
          var key_0 =  BaseDoPage.getDecryptData("",pk_key_).value;
     
        if (key_0 == "-1") //表示新增
        {
            //先保存数据


            
           lb_update=   update(table_id,false);
           if (lb_update !=  "1")
           {
                return ;
           }
          
          pk_key_ = obj_key.value;
          key_0 =  BaseDoPage.getDecryptData("",pk_key_).value;
        }

    var number =  Math.random() * 100000; 

    var url="../UploadFile/updateM.aspx?code="+number;
   // alert(url);
    var v = BaseDoPage.setSession("PIC_LINE_NO",key).value;
    var v = BaseDoPage.setSession("PK_KEY_PIC",key_0).value;
    var splashWin= showDialog(url,50,30,false,window);
  //  var  splashWin = showModalDialog(url,'dialogWidth:40;dialogHeight:10;dialogLeft:200px;dialogTop:150px;center:yes;help:yes;resizable:yes;status:yes;location:no') 
    if   (splashWin   !=   undefined)   
      {   
   
         var  choose_value = splashWin.DataId;

         var obj_key= document.getElementById("v_"+key);
         if (obj_key != null && choose_value !="" && choose_value  != null)
         {
            obj_key.value = choose_value;
         }
    
    }

}
function SelectM001Id(key)
{
    var obj_key= document.getElementById("v_"+key);
    var url="../M001/ChooseID.aspx";
    var splashWin= showDialog(url,44,23,false,window);
    if   (splashWin   !=   undefined)   
    {   

         var  choose_value = splashWin.DataId;  
        
         if (obj_key != null && choose_value !="" && choose_value  != null)
         {
            obj_key.value = choose_value;
         }
    
    }

}




function selectDate_m(obj)
{
  //  selectDate(obj);
        setday(obj);
}
function selectTime_m(obj)
{
    setday(obj);
}
  function update(tableid,show_msg_)
   {
       //获取页面所有v_id的值
       setbtndisable('btn_save');
   
//p_m002_key
    if (show_msg_== null)
    {
        show_msg_ = true;
    }
      var p_m002_key = BaseDoPage.getSession("M002_KEY").value;
      var logintype =  BaseDoPage.getSession("logintype").value;
      if (logintype == "0")
      {
          p_m002_key ="0" ;
      }
         
        // var ness = document.getElementsByTagName('input');
        
         var ness ="";
         var check = new Array();
         var controls = document.getElementsByTagName("input");
         var str="";
         var con_data_="";
         var pos = 0;
        
         

          
 
          for(var i=0; i<controls.length; i++)
          {
           
            con_data_ = controls[i].value;
            if(controls[i].id.indexOf("v_") ==0  )
            {
                //controls[i].value='';
                //如果输入的值不为空
                //
                if (con_data_ == "")
                {
                    con_data_ = "null";
                }
                str = str + "{"+controls[i].id+"="+ con_data_+"}"
            
                
            }
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
                ness= BaseDoPage.getDecryptData("",controls[i].value).value;
            }
            
          }   
          var controls1= document.getElementsByTagName("textarea");
          for(var i=0; i<controls1.length; i++)
          {
                con_data_ = controls1[i].value;
               // alert(controls1[i].id)
                if(controls1[i].id.indexOf("v_") ==0  )
                {
                    //controls[i].value='';
                    //如果输入的值不为空
                    //
                    if (con_data_ == "")
                    {
                        con_data_ = "null";
                    }
                    str = str + "{"+controls1[i].id+"="+ con_data_+"}"
                
                    
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
                    alert(obj_v.name +"必须填写！")
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
               if (v_d.substring(0,1) == "0" )
               {
                    alert("<"+obj_d.name +">" +v_d.substring(1))
                    if (obj_d.type =="text")
                    {
                        obj_d.focus();
                    }
                return  "0" ;
               
               }              
           }
          
          
         

          //    public String  saveData(string t_id,string datalist,string pk_key)
         // alert(p_m002_key);
          var v= BaseDoPage.saveData(tableid,str,pk_key_,userid,p_m002_key).value;
          if (v !="Error"  && v != null)
          {
              obj_key.value = v;
              if (show_msg_== true)
              {
                 alert("保存数据成功！");
             
                     /* //alert(tableid)
                     if (tableid == "M500" )
                     {
                       var key_0 =  BaseDoPage.getDecryptData("",pk_key_).value;
                     //  alert(key_0)
                       if (key_0 == "-1") //表示新增
                       {
                            var key_1 =  BaseDoPage.getDecryptData("",v).value; //解密key
                            //执行开户


                            if (key_1 != v)
                             {   
                                if ( confirm("是否需要发送信息给市民卡？如果数据发送成功将不允许修改！") ) 
                                {
                                    url = "../interface/index.aspx?M107KEY=1018&M500KEY=" + key_1 +"&code="+ String(Math.random() * 100000);
                                    var splashWin= showDialog(url,50,30,false,window);
                                }
                            }
                       }
                       
                        
                     }
                     */
                     
                     var next_do =  BaseDoPage.getSession("next_do").value;
                        var act =   BaseDoPage.getSession("action").value;
                 
                     if  (next_do != "")
                     {
                        /*解析next_do*/
                         var key_0 =  BaseDoPage.getDecryptData("",pk_key_).value;
                         if (key_0 == "-1") //表示新增
                         {
                              key_0 =  BaseDoPage.getDecryptData("",v).value; //解密key
                         }
                     
                         next_do = next_do.replace('[KEY]',key_0);
              
                         // [Q=........][V=.....] 
                         // .....
                         if (next_do.indexOf('[') < 0 )
                         {
                            location.href = next_do;
                         }
                         else
                         {

                            pos1 = next_do.indexOf('[' +  act +"=");
                            if (pos1 >= 0)
                            {
                                next_do = next_do.substr(pos1 + act.length +  2);
                                pos2 = next_do.indexOf(']');
                                if (pos2 > 0 )
                                {
                                     next_do = next_do.substr(0, pos2 );
                                     window.execScript(next_do)
                                }
                                //location.href = next_do;
                            } 
                            
                         }
                     }
               }       
             return "1"  ;
          }
          alert("保存数据失败！");
           return "0"   ;
          
    }
    

function   selectchange(obj)
{
   // alert();
    //rb_191
    var id = obj.id;
    var d_list_ = id.split("_");
    var row = d_list_[0];
    var col = d_list_[1];
    var this_obj=document.getElementById("v_"+col);
    //this_obj.value = obj.value;
    //获取select的值

 
    if (this_obj != null)
    {
        this_obj.value  =  obj.options[obj.selectedIndex].value;	    
   
    }   

}
function rbselectchange(obj)
{
   // alert();
    //rb_191
    var id = obj.id;
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

//身份证号码校验函数


function checkIdcard2(idcard){
var Errors=new Array(
"验证通过!",
"身份证号码位数不对!",
"身份证号码出生日期超出范围或含有非法字符!",
"身份证号码校验错误!",
"身份证地区非法!"
);
var area={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"} 

var idcard,Y,JYM;
var S,M;
var idcard_array = new Array();
idcard_array = idcard.split("");
//地区检验


if(area[parseInt(idcard.substr(0,2))]==null) 
{
alert(Errors[4]);
return false ; 
}
//身份号码位数及格式检验


switch(idcard.length){
case 15:
if ( (parseInt(idcard.substr(6,2))+1900) % 4 == 0 || ((parseInt(idcard.substr(6,2))+1900) % 100 == 0 && (parseInt(idcard.substr(6,2))+1900) % 4 == 0 )){
ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$/;//测试出生日期的合法性


} else {
ereg=/^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$/;//测试出生日期的合法性


}
if(ereg.test(idcard)) return true;
else
{
alert(Errors[2]);
return false; 
} 
break;
case 18:
//18位身份号码检测


//出生日期的合法性检查 
//闰年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))
//平年月日:((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))
if ( parseInt(idcard.substr(6,4)) % 4 == 0 || (parseInt(idcard.substr(6,4)) % 100 == 0 && parseInt(idcard.substr(6,4))%4 == 0 )){
ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$/;//闰年出生日期的合法性正则表达式
} else {
ereg=/^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$/;//平年出生日期的合法性正则表达式
}
if(ereg.test(idcard)){//测试出生日期的合法性


//计算校验位


S = (parseInt(idcard_array[0]) + parseInt(idcard_array[10])) * 7
+ (parseInt(idcard_array[1]) + parseInt(idcard_array[11])) * 9
+ (parseInt(idcard_array[2]) + parseInt(idcard_array[12])) * 10
+ (parseInt(idcard_array[3]) + parseInt(idcard_array[13])) * 5
+ (parseInt(idcard_array[4]) + parseInt(idcard_array[14])) * 8
+ (parseInt(idcard_array[5]) + parseInt(idcard_array[15])) * 4
+ (parseInt(idcard_array[6]) + parseInt(idcard_array[16])) * 2
+ parseInt(idcard_array[7]) * 1 
+ parseInt(idcard_array[8]) * 6
+ parseInt(idcard_array[9]) * 3 ;
Y = S % 11;
M = "F";
JYM = "10X98765432";
M = JYM.substr(Y,1);//判断校验位


if(M == idcard_array[17]) return true; //检测ID的校验位
else
{ alert(Errors[3]);
return false;
}
}
else 
{
alert(Errors[2]);
return false; 
}
break;
default:
alert(Errors[1]);
return false ; 
break;
}
}

function input_onchange(obj,col_child)
{
     if (col_child == "")
        {
            return ;
        }
        /*判断影响到那些列*/
        var collist = col_child.split(",");
        for(var i=0;i < collist.length;i++)
        {
            if (collist[i] != "" )
            {
               /*修改影响的列的属性*/
                setChange(collist[i])        
            }
        }
}

function dddchange(obj,col_child)
{
    selectchange(obj)
    if (col_child == "")
    {
        return ;
    }
    /*判断影响到那些列*/
    var collist = col_child.split(",");
    for(var i=0;i < collist.length;i++)
    {
        if (collist[i] !=  "" )
        {
           /*修改影响的列的属性*/
            setChange(collist[i])        
        }
    }
    
}
//重置列的属性
function setChange(col_line_no)
{
        var td= document.getElementById("td_" +col_line_no );
        var p_m002_key = BaseDoPage.getSession("M002_KEY").value;
        var logintype =  BaseDoPage.getSession("logintype").value;
        if (logintype == "0")
         {
             p_m002_key ="0" ;
         }
        var controls = document.getElementsByTagName("input");
        var str="";
        var con_data_="";
        var pos = 0;
        for(var i=0; i<controls.length; i++)
        {
            con_data_ = controls[i].value;
            if(controls[i].id.indexOf("v_") ==0  )
            {
                //controls[i].value='';
                //如果输入的值不为空
                //
                if (con_data_ == "")
                {
                    con_data_ = "null";
                }
                str = str + "{"+controls[i].id+"="+ con_data_+"}"
            
                
            }
     
                
          }   
          var controls1= document.getElementsByTagName("textarea");
          for(var i=0; i<controls1.length; i++)
          {
                con_data_ = controls1[i].value;
               // alert(controls1[i].id)
                if(controls1[i].id.indexOf("v_") ==0  )
                {
              
                    if (con_data_ == "")
                    {
                        con_data_ = "null";
                    }
                    str = str + "{"+controls1[i].id+"="+ con_data_+"}"

                }
          }
         
          var obj_key= document.getElementById(table_id+"_KEY");

          var key = obj_key.value;
          var pk_key_ = key;
       
          var userid = document.getElementById("userid").value;
           var  obj = document.getElementById("v_" + col_line_no); 
           var enable="1";
//string enable,string str_data
            try
            {
                if (obj.disabled == true )
                {
                    enable ="0";
                }
            }
            catch(e)
            {
                  enable ="0";
            }  
            
          var v= BaseDoPage.getColumnHtml(col_line_no,table_id,str,pk_key_,userid,p_m002_key,enable ,obj.value).value;
   
         if (v=="0")
         {
            return  ;
         }
         if (v.indexOf("HTML=")==0)
         {
            td.innerHTML =v.replace("HTML=","")
         }
         if (v.indexOf("FORM=")==0)
         {
            
            if (obj != null)
            {
                obj.value = v.replace("FORM=","");
            }
         }
    
    
    

}

//调用的形式为checkIdcard2('123456789098765432') 
function input_onBlur(obj,col_type)
{
    
    col_type = col_type.toLowerCase();
    if ((col_type=="number" || col_type=="decimal" || col_type=="int") && obj.value != "")
    {
        if (String(parseFloat(obj.value)) == "NaN")
        {
            obj.value ="0";
        }
        
        obj.value = String(parseFloat(obj.value));       
        
    }
    obj.style.borderColor='#B5B8C8';
    if (table_id =="M001" && obj.value != "")
    {
        if (obj.id== 'v_141')//检测编码


        {
           return  checkM001Id(obj);
        }
        if (obj.id== 'v_23')//检测身份证
        {
                /*根据身份证填写日期*/
                var lbcheck=   checkIdcard2(obj.value);
                if (lbcheck== true)
                {
                     var vv = obj.value;
                /*421182 19811023  0217*/
                     var vvv = vv.substr(6,4)  + '-' +  vv.substr(10,2) + '-' +vv.substr(12,2)
                     var obj_b = document.getElementById("v_19")
                     if (obj_b != null)
                     {
                        obj_b.value = vvv;                        
                     }
                    
                }
            return lbcheck
        
            
            
        }
         if (obj.id== 'v_15')//检测手机


        {
            return checkSj(obj);
        }
        if (obj.id== 'v_16')//检测邮箱


        {
           return  checkYx(obj);
        }
        if (obj.id== 'v_37')//检测扣费手机


        {
            return checkSj(obj);
        }
        
        
    }
       

}
function  input_onFocus(obj,col_type)
{
 
    //obj.style.borderColor='#1b3143';
    obj.style.borderColor='red';
 
}


function checkYx(obj)
{

    var reEmail=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;  //邮箱检测


    var b_email=reEmail.test(obj.value);
    if (b_email == false)
    {

        alert("邮箱格式不正确！");
        obj.focus();
          
    }
    return b_email;
}

function checkSj(obj)
{
    var Pho=/(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)/ ;         //手机号码检测           
    var b_Phone=Pho.test(obj.value);
    if (b_Phone == false)
    {
        alert(obj.name + "格式不正确！");
        obj.focus();
    }
    return b_Phone;
}

function checkM001Id(obj)
{
var Pho=/(^0{0,1}[1|2][3|4|5|6|7|8|9][0-9]{9}$)/ ;         //手机号码检测           
var b_Phone=Pho.test(obj.value);
    if (b_Phone == false)
    {

        alert("ID格式不正确！");
      
    }
      return b_Phone;
}
           

/*
作用：将id为dayin的内容，新建页面并打印，可解决打印某页面中的部分内容的问题。


使用方法：将要打印的内容通过 <span id="dayin"></span>包含起来，然后在某个按扭中定义事件


<input type="button" onclick="dayin()" value="打印">
 
 */
function dayin()  
{
  var code="<body onload=window.print()>"
  code+=document.all.dayin.innerHTML;
  code=code.toUpperCase();
  code=code.replace(/<A[^>]*>删除<\/A>/gi, "");
  code=code.toLowerCase();
  var newwin=window.open('','','');
  newwin.opener = null;
  newwin.document.write(code);
  newwin.document.close();
} 

/* 
其中code=code.replace(/<A[^>]*>删除<\/A>/gi, "");
是过滤掉内容中的所有删除连接


 
2、isNumber(st)
作用：判断变量st是否由数字组成(包括负数和小数)，如果是返回true,否则返回false。


*/
function isNumber(st)
{ 
var Letters = "1234567890-.";
var i;
var c;
if(st.charAt( 0 )=='.')
return false;
if(st.charAt( 0 )=='-'&&st.charAt( 1 )=='.')
return false;
if( st.charAt( st.length - 1 ) == '-' )
return false;
for( i = 0; i < st.length; i ++ )
{
c = st.charAt( i );
if (Letters.indexOf( c ) < 0)
return false;
}
return true;
} 

 /* 
3、createCookie(name,value,days)
作用：建立名称为name,值为values，有效期为days天的cookie。同时可用做修改。


*/
function createCookie(name,value,days){
  var expires = "";
  if (days) {
   var date = new Date();
   date.setTime(date.getTime()+(days*24*60*60*1000));
   expires = "; expires="+date.toGMTString();
  };
  document.cookie = name+"="+value+expires+"; path=/";
}; 
 /* 
4、readCookie(name)
作用：根据名称，读取出cookie的值。如果无，则返回null。


*/
function readCookie(name){
  var nameEQ = name + "=";
  var ca = document.cookie.split(';');
  for(var i=0;i < ca.length;i++) {
   var c = ca[i];
   while (c.charAt(0)==' ') c = c.substring(1,c.length);
   if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
  };
  return null;
}; 
 /* 
5、request(st)
作用：得到浏览器地址栏中的某个参数的值（不完美解决，例如有空格的话会得到%20，但支持中文）


*/
function request(st) {
var ustr=document.location.search;
var intPos = ustr.indexOf("?");
var strRight = ustr.substr(intPos + 1);
var arrTmp = strRight.split("%26");
for(var i = 0; i < arrTmp.length; i++)
{
var arrTemp = arrTmp[i].split("=");
if(arrTemp[0].toUpperCase() == st.toUpperCase()) return arrTemp[1];
}
return "";
} 
 /* 
6、hideObject(obj)
作用：隐藏obj
*/
function hideObject(obj) {
  obj.style.display = "none";
} 
/*
7、showObject(obj)
作用：显示obj
 */
function showObject(obj) { 
  obj.style.display = "block";
} 
/*
8、trim(str)
作用：去str两边空格
*/
function trim(str)
{
   return str.replace(/^\s*|\s*$/g,"");
} 

 /* 9、function bj_date(d1,d2)
作用：比较d1,d2日期的大小


*/
function bj_date(d1,d2)
{
/*
author:wxg
作用:比较日期大小
参数:d1 d2
字符型 年-月-日  类型,如 2005-01-22
返回值: 0/1/2 
数字型


d1>d2 返回0
d1=d2 返回1
d1<d2 返回2
*/
if(d1==""&&d2==""){
return 3
}
if(d1==""||d2==""){
return 4
}
d1=d1.split("-")
d2=d2.split("-")
var a = new Date(Number(d1[0]),Number(d1[1]),Number(d1[2]))
var b=new Date(Number(d2[0]),Number(d2[1]),Number(d2[2]))
a = a.valueOf()
b=b.valueOf()
if(a-b>0)
return 0
if(a-b==0)
return 1
if(a-b<0)
return 2
} 
 /* 
 
10、格式化数字成货币格式


*/
function setCurrency(s){
if(/[^0-9\.\-]/.test(s)) return "invalid value";
s=s.replace(/^(\d*)$/,"$1.");
s=(s+"00").replace(/(\d*\.\d\d)\d*/,"$1");
s=s.replace(".",",");
var re=/(\d)(\d{3},)/;
while(re.test(s))
s=s.replace(re,"$1,$2");
s=s.replace(/,(\d\d)$/,".$1");
return s.replace(/^\./,"0.")
}
 
/*11、运行代码


 */
function runCode(obj) 
{
        var winname = window.open('', "_blank", '');
        winname.document.open('text/html', 'replace');
        winname.opener = null // 防止代码对论谈页面修改


        winname.document.writeln(obj.value);
        winname.document.close();
}
 /*
12、保存代码


 */
function saveCode(obj) {
        var winname = window.open('', '_blank', 'top=10000');
        winname.document.open('text/html', 'replace');
        winname.document.writeln(obj.value);
        winname.document.execCommand('saveas','','code.htm');
        winname.close();
}
 
function strLen(str) {
 var count=0, asc, test='中文';
 if (test.length==2) {
  for (var i=0;i<str.length;i++) {
   asc = str.charCodeAt(i);
   if (asc < 0) asc += 65536;
   if (asc > 255) count++;
  }
 }
 return str.length+count;
}
//按字节数截取左侧字符串


function strSubLeft(str, len) {
 var count=0, asc, ret = "";
 for (var i=0;i<str.length;i++) {
  asc = str.charCodeAt(i);
  if (asc < 0) asc += 65536;
  if (asc > 255) count++;
  if (i + count >= len) {
   ret = str.substr(0, i);
   break;
  }
 }
 return ret;
}
function getRandom(){
 return "&"+Math.random()*1000+"&";
}
function checkInt(str){
 if(str==null||str==""){
  //alert("请输入数字!");
  return false;
 }
 var digits = "1234567890";
 var i = 0;
 var strlen = str.length;
 while((i<strlen)){
  var char = str.charAt(i);
  if(digits.indexOf(char) == -1) {
   //alert("请输入正确的数字!");
   return false;
  }
  i++;
 }
 return true;
}
function hasWord(str){
 if(str.replace(/ /g,'')==""||str.replace('　','')==""){
  return false;
 }else{
  return true;
 }
}
function replaceAll(oldStr,findStr,repStr){
 var srchNdx = 0;
 var newStr = "";
 while (oldStr.indexOf(findStr,srchNdx) != -1){
  newStr += oldStr.substring(srchNdx,oldStr.indexOf(findStr,srchNdx));
  newStr += repStr;
  srchNdx = (oldStr.indexOf(findStr,srchNdx) + findStr.length);
 }
 newStr += oldStr.substring(srchNdx,oldStr.length);
 return newStr;
}

function checkPrice(inputValue){
 inputValue=""+inputValue;
 
 myRegExp = /^(\d+),(\d+)$/;
 if (inputValue.match(myRegExp)) return true;
 else return false;
}
/*验证正整数*/
function checkNum(valueStr){
 var myRegExp = /^(\d+)$/;
 if (valueStr.match(myRegExp)){
   return true;
 }else{
   return false;
 }
}
/*限制obj(通常为TEXTAREA)中的字符个数*/
function checkWordsLength(obj,maxLength){
  if(obj.value.length>=maxLength){
  obj.value=obj.value.substring(0,maxLength-1)
   }
}

function ReadCard()
{
   // Read_CardInfo
   
	    var   CardCtl = document.getElementById("CardCtl");
	    var cardinfo = "-1";
	    if (CardCtl != null)
	    {
	      
	        try
		    {
		    
		       CardCtl.Read_CardInfo();
		       return CardCtl.ReadInfo ;
		    }
		    catch(err)
		    {
			    alert("读卡信息失败" +  err.description );
			    return "-1";			  
		    }
		  
		}    

        return "-1";

}


function ReadCard()
{
   // Read_CardInfo
   
	    var   CardCtl = document.getElementById("CardCtl");
	    var cardinfo = "-1";
	    if (CardCtl != null)
	    {
	      
	        try
		    {
		    
		           CardCtl.Read_CardInfo();
		           cardinfo =  CardCtl.ReadInfo ;
		           if (CardCtl.status != 0)
                   {
	                   alert("读卡失败!")
	                   return "-1";
                   }
		    }
		    catch(err)
		    {
			    alert("读卡信息失败" +  err.description );
			    cardinfo =  "-1";	
			    return "-1" ;		  
		    }
		  
		}    

           var info_list = cardinfo.split("|");
            
           for (var i= 0;i < info_list.length - 1 ;i++)
            {
                if ( i == 0)
                {   var v_data = document.getElementById("v_10").value; 
                       if ( v_data == "" )
                       {
                            document.getElementById("v_10").value = info_list[i];
                       }
                       else
                       {
                             if (v_data != info_list[i])
                             {
                                alert("卡号"+v_data+ "和读取的卡号"+  info_list[i] +"不一致！")
                             }
                       }
                  
                }
                    
            }
        return cardinfo;

}


function WriteCard()
{   
    /*
    姓名		20
    证件号码		18
    性别		1
    证件类型		2
    卡主类型		2
    卡子类型		2
    卡发行日期	YYYYMMDD	8
    卡有效日期	YYYYMMDD	8
    启用标志		2
    城市公共交通应用启用日期	YYYYMMDD	8
    城市公共交通应用有效日期	YYYYMMDD	8
    月票钱包应用启用日期	YYYYMMDD	8
    月票钱包应用有效日期	YYYYMMDD	8
    月票子类型		2
   
    */
    if  (document.getElementById("v_22").value =="")
    {
        alert("必须填写姓名");
        return "-1";
    }
      if  (document.getElementById("v_18").value =="")
    {
        alert("必须填写证件号码");
        return "-1" ;
    }
    if  (document.getElementById("v_23").value =="")
    {
        alert("必须填写性别");
        return "-1" ;
    }
    
   var   CardCtl = document.getElementById("CardCtl");   
   var info = "测试00|330300197707179411|1|00|00|00|20111205|20211205|01|20111205|20211205|20111205|20111205|00|"; //要写入的数据
   info = "" ;
   info += document.getElementById("v_22").value + "|"; //姓名
   info += document.getElementById("v_18").value + "|"; //证件号码
   info += document.getElementById("v_23").value + "|"; //性别
   info += '0' + document.getElementById("v_17").value + "|"; //证件类型
   info += "00" + "|"; //卡主类型
   info += "00" + "|"; //卡子类型
   info += showdate() + "|"; //卡发行日期

   info += "20220101" + "|"; //卡有效日期

   info += "01" + "|"; //启用标志
   info += showdate() + "|"; //城市公共交通应用启用日期

   info += "20220101" + "|"; //城市公共交通应用有效日期

   info += showdate() + "|"; //月票钱包应用启用日期
   info += "20220101" + "|"; //月票钱包应用有效日期
   info += "00" + "|"; //月票子类型

   var write_info =""

   CardCtl.Write_CardInfo(info);
   if (CardCtl.status==0)
   {
	   write_info = CardCtl.WriteRInfo;
	   alert("写卡成功")
   }
   else
   {
        alert("写卡失败")
   
   }
   

   
   
}
function showdate(){
var today=new Date();
date=today.getDate();
month=today.getMonth();
month=month+1;
if(month<=9)
     month="0"+month;
year=today.getYear();
var nowDate=String(year) + String(month)+ String(date);
alert(nowDate)
return nowDate;
}
function showInterface(url)
{
    var splashWin= showDialog(url,50,30,false,window);
     if   (splashWin   !=   undefined)   
      {   
   
         var  choose_value = splashWin.DataId;

         return  choose_value;
    
    }

    return "0";
  
}


function Write_CardInfo()
{ 
   
   CardCtl.Write_CardInfo(writeinfo.value);
   Status.value = CardCtl.status;
   if (CardCtl.status==0)
   {
	   writerinfo.value = CardCtl.WriteRInfo;
   }
}
 
function Read_CardInfo()
{ 
   
   CardCtl.Read_CardInfo();
   Status1.value = CardCtl.status;
   if (CardCtl.status==0)
   {
	   readinfo.value = CardCtl.ReadInfo;
   }
}

