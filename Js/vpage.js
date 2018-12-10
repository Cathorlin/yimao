// JScript 文件
//领用消费券
var m002_key___ ;  
///*个人申请加入会员*/
var  do___type="PayM00203";
/*免费获取消费券 短信下载消费券  购买消费券
    type_  0  免费 购买

 */
var PayM00203___obj ;
var PayM00203_type_ ;
var PayM00203_m00203_key_;
var PayM00203_payamount_ ;
function PayM00203(obj,type_,m00203_key,payamount)
{
    PayM00203___obj = obj;
    PayM00203_type_ = type_;
    PayM00203_m00203_key_ = m00203_key;
    PayM00203_payamount_ = payamount;
    var  user_ = VPage.CheckUserLogin().value;
    if (user_ == "-1" )
    {
        do___type="PayM00203";
        alertUserLogin('登录','',300,120)                    
        return true ;
    }
    /*下载到手机*/
      var v;
    if (type_ =="2")
    {
       v = VPage.downToMobile(m00203_key).value;
       if (v != "0")
       {
            alert("下载失败:"+ v) ;
       }
       else
       {
           alert("消费券已下载到您绑定的手机，请注意查收！")
       }
        return  ;
    }
    
    
    /*根据不同的逻辑来处理数据*/
    /*判断当前消费券是否有价*/      

    v = VPage.BeginM00203Pay(m00203_key,'1').value;
    if ( v != "1")
    {    
       alert(v)
       return ;
    }
    var number =  Math.random() * 100000; 

    var paynum = VPage.getSession("PAY_PAYID").value ;
  
    v =VPage.setSession("PayUrl",location.href ) ;
    var a=location.href;
var b=a.match(/^([^:]+:\/\/)[^\/]+\/(.*)$/i);

    var  url = "http://" + window.location.host + "/m002/paymain.aspx?key="+ paynum +"&code="+number ;
    //alert(url)
    var splashWin= showDialog(url,50,30,false,window);
    //location.href = location.href;
    if   (splashWin   !=   undefined)   
    {   
   
         var  DataId = splashWin.DataId;
         
         if (DataId =="ZFB")
         {
            location.href = splashWin.Url;
            return ;
         }
        
    }
    return true ;
}
var bgObj_;
var msgObj_
var alert_login = false ;
function alertUserLogin(title, msg, w, h){ 
    var titleheight = "22px"; // 提示窗口标题高度 
    var bordercolor = "#FF6600"; // 提示窗口的边框颜色 
    var titlecolor = "#FFFFFF"; // 提示窗口的标题颜色 
    var titlebgcolor = "#FF6600"; // 提示窗口的标题背景色
    var bgcolor = "#FFFFFF"; // 提示内容的背景色
    alert_login = true;
    var iWidth = document.documentElement.clientWidth;
    var iHeight = document.documentElement.clientHeight
    var itop = document.documentElement.scrollTop + document.body.scrollTop;
    var bgObj = document.createElement("div"); 
    bgObj.id="bgObjId";
    bgObj.style.cssText = "position:absolute;left:0px;top:0px;width:"+iWidth+"px;height:"+Math.max(document.body.clientHeight, iHeight)+"px;filter:Alpha(Opacity=30);opacity:0.3;background-color:#000000;z-index:101;";
    document.body.appendChild(bgObj); 
    var msgObj=document.createElement("div");
    msgObj.id="msgObjId";
    msgObj.style.cssText = "position:absolute;font:11px '宋体';top:" + String((iHeight - h) / 2 + itop) + "px;left:" + (iWidth - w) / 2 + "px;width:" + w + "px;height:" + h + "px;text-align:center;border:1px solid " + bordercolor + ";background-color:" + bgcolor + ";padding:1px;line-height:22px;z-index:102;";
    document.body.appendChild(msgObj);
    
    var table = document.createElement("table");
    msgObj.appendChild(table);
    table.style.cssText = "margin:0px;border:0px;padding:0px;";
    table.cellSpacing = 0;
    var tr = table.insertRow(-1);
    var titleBar = tr.insertCell(-1);
    titleBar.style.cssText = "width:100%;height:"+titleheight+"px;text-align:left;padding:3px;margin:0px;font:bold 13px '宋体';color:"+titlecolor+";border:0px solid " + bordercolor + ";cursor:move;background-color:" + titlebgcolor;
    titleBar.style.paddingLeft = "10px";
    titleBar.innerHTML = title;
    var moveX = 0;
    var moveY = 0;
    var moveTop = 0;
    var moveLeft = 0;
    var moveable = false;
    var docMouseMoveEvent = document.onmousemove;
    var docMouseUpEvent = document.onmouseup;
    titleBar.onmousedown = function() {
        var evt = getEvent();
        moveable = true; 
        moveX = evt.clientX;
        moveY = evt.clientY;
        moveTop = parseInt(msgObj.style.top);
        moveLeft = parseInt(msgObj.style.left);
        
        document.onmousemove = function() {
            if (moveable) {
                var evt = getEvent();
                var x = moveLeft + evt.clientX - moveX;
                var y = moveTop + evt.clientY - moveY;
                if ( x > 0 &&( x + w < iWidth) && y > 0 && (y + h < iHeight) ) {
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
    closeBtn.style.cssText = "cursor:pointer; padding:2px;background-color:" + titlebgcolor;
    closeBtn.innerHTML = "<span style='font-size:18pt; color:"+titlecolor+";'>×</span>";
    closeBtn.onclick = function(){ 
        document.body.removeChild(bgObj); 
        document.body.removeChild(msgObj); 
    } 
    var msgBox = table.insertRow(-1).insertCell(-1);
    msgBox.style.cssText = "font:10pt '宋体';";
    msgBox.colSpan = 2;
    
    var msgs = "<span style='float:left;margin:11px 0 0 45px;'>账 号：</span><input type='text' id='User1' style='width: 160px;float:left;margin:7px 0 0 0px;' /><br />"
                +"<span style='float:left;margin:31px 0 0 -213px;'>密 码：</span><input type='password' id='Pass1' style='width: 160px;float:left;margin:27px 0 0 -166px;' /><br />"
                +"<input class='denglu' type='button' value='登 录' onclick='javascript:Userlogin()' style='float:left;margin:37px 0 0 -166px; padding:0 auto; cursor:pointer;' /><br />"
                + "<span class='zhu-ce' title='注册'><a href='../register/reg.aspx' target='_blank'>注册</a></span>"
                + "<span class='huoquyanzhengma'onclick='dtUserPass();' title='获取验证码'>获取验证码</span>";
    msgBox.innerHTML = msgs;
    
    bgObj_ = bgObj;
    msgObj_ = msgObj;
    document.getElementById("User1").focus();
    // 获得事件Event对象，用于兼容IE和FireFox
    function getEvent() {
        return window.event || arguments.callee.caller.arguments[0];
    }
    
} 
 function  dtUserPass()
    {     
      var obj_user;
      obj_user = document.getElementById("User1");
      if (trim(obj_user.value) == "")
        {
            alert("请输入账号！")
            obj_user.focus();
            return  false ;
        }
        user_ = trim(obj_user.value);

         var r_ =  VPage.checkUser(user_).value;
         if  (r_ != "1")
         {
            alert(r_);
         }
         else
         {
            alert("已发出动态密码！")
         }
    }
function Userlogin()
{

    alert_login = false ;
    var user_ = document.getElementById("User1").value;
    var pass_ = document.getElementById("Pass1").value;
    var v =  VPage.checkUserPass("1","0" ,user_,pass_).value;   
   
    if ( v != "1")
    {
        alert(v);
        return false ;
    }
    
    document.body.removeChild(bgObj_); 
    document.body.removeChild(msgObj_); 
    if ( do___type=="PayM00203")
    {
   
        PayM00203(PayM00203___obj,PayM00203_type_,PayM00203_m00203_key_,PayM00203_payamount_)
    
    }
     
   
    return true ;
}

document.onkeydown = function()
{
    if (alert_login == true)
    {
        if (event.keyCode   ==   13)  
        { 
            kill();  
        }
    }      
}