<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Login.ascx.cs" Inherits="BaseForm_Login" %>
<div id="login">
<div class="left">
   <div class="img0">
        <a>
        <img alt=""  src="<%= GlobeAtt.HTTP_URL  %>/images/logon_bg.gif"/>
        </a>
    
   </div>
   
</div>
<div class="right">


<div class="dl">
  <div class="dll">
             <div class="field">
                 <label>账户名</label><input type="text" id="user"  value="ADMIN"/><span id="user_ness" style="color:Red; visibility:hidden;"> *请输入账户名 </span>
             </div>
             <div class="field">
                 <label>密 &nbsp;码</label><input type="password" id="pass" value="work1" /><span id="pass_ness" style="color:Red; display:none; "> *请输入密码 </span>
             </div>
             <div class="field">
                 <label>验证码</label><input type="text" id="txtVerifyCode" onfocus="show_vCode('img_code')" /><img alt=""  src="<%=GlobeAtt.HTTP_URL %>/VerifyCode.aspx"  onclick="show_vCode('img_code')" id="img_code" style="display:none" /><span id="vc_ness" style="color:Red; visibility:hidden;"> * </span>
             </div>
             <div class="img_login">
                <a onclick="javascript:login()" ></a> 
                <span id="txt_error" style="color:Red; visibility:hidden;"></span>
             </div>
        </div>

</div>
</div>
</div>