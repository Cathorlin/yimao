<%@ Page Language="C#" AutoEventWireup="true" CodeFile="loginform.aspx.cs" Inherits="BaseForm_loginform" %>

<% 
            string pic = "logon_bg.gif";

            dt_temp = fun.getDtBySql("SELECT a022_name from A022 t where t.a022_id='LOGIN_PIC'");
            if (dt_temp.Rows.Count > 0)
            {
                pic = dt_temp.Rows[0][0].ToString();
            }
%>


<div id="login">
    <div class="left">
        <div class="img0">
        </div>
    </div>
    <div class="right">
        <div class="dl">
            <p class="welcome">用户登录</p>
            <div  class="Base">
             <span class="TitleInfo">
            <%--<%=BaseMsg.getMsg("M0055")%>--%>
                   <p>IM-Environment</p>
            </span>
                <img src="../images/bg/bg_top1-1.png" />
                </div>
               
            <div class="dll" style="background-image: url(images/bg/bg_top2.png);">
            <%--用户名密码框--%>
            <div style="margin:6px 0 0 17px;">
                <div class="field">
                    <%--<label style="font-weight:bold"><%=BaseMsg.getMsg("M0050")%></label>    --%>
                    <%
        dt_temp = fun.getDtBySql("Select pkg_user.get_last_user('" + fun.getClientIp() + "') as c from dual ");
        string v = "";
        try
        {
            v =  dt_temp.Rows[0][0].ToString();
        }
        catch(Exception ex)
        {
            v ="";
        }
                    %>
                    <img src="../images/bg/bg_User.png" style="float: left;margin: 20 0 0 15;" /> 
                    <input type="text" id="user" style="text-indent:5px;"  onblur="GetPwdAndChk()" placeholder="<%=BaseMsg.getMsg("M0050")%>" />
                    <%-- style="background-image:url(images/bg/bg_User.png);background-<%=v %>repeat:no-repeat;background-position:left center;" --%>
                    <span id="user_ness" style="color: Red; visibility: hidden;">
                        <%=BaseMsg.getMsg("M0052")%>
                    </span>
                </div>
                <div class="field">
                    <%--<label style="font-weight:bold"> <%=BaseMsg.getMsg("M0051")%></label>  --%>
                    <img src="../images/bg/bg_Pwd.png" style="float: left; margin: 5 0 0 15;" />
                    <input type="password" id="pass" style="text-indent:5px;"  placeholder="<%=BaseMsg.getMsg("M0051")%>" />
                    <%-- style="background-image:url(images/bg/bg_Pwd.png);background-repeat:no-repeat;background-position:left center"--%>
                    <span id="pass_ness" style="color: Red; display: none;">
                        <%=BaseMsg.getMsg("M0053")%>
                    </span>
                </div>
                <div class="Remeber">
                
                      <input type="checkbox"name="Remeber_PassWord" id="Remeber_PassWord"  /><span style="vertical-align:middle;">记住密码</span>
                </div>
            
              </div>
                <div>
                    <a href="#" id="Forget_Pwd" style="float:left; text-decoration: none; font-family:微软雅黑; color:#6d6d6d; margin-top:-10px;margin-left:42px;">
                        </a></div>
                <div class="field" style="display: none;">
                    <label style="font-weight: bold">
                        <%=BaseMsg.getMsg("M0054")%></label>
                    <input type="text" id="txtVerifyCode" onfocus="show_vCode('img_code','0')" /><img
                        alt="" src="<%=GlobeAtt.HTTP_URL %>/VerifyCode.aspx"  onclick="show_vCode('img_code','1')"
                        id="img_code" style="display: none" />
                    <span id="vc_ness" style="color: Red; visibility: hidden;">*</span>
                </div>
                <%--登录按钮--%>
                <div class="img_login">
                    <input type="button" id="SaveInfo" style="outline:none;" onblur="javascript:SetPwdAndChk()" onclick="javascript:userlogin();" value="<%=BaseMsg.getMsg("M0055")%>">
                    <span id="txt_error" style="color: Red; visibility: hidden;"></span>
                </div>
                <%--<div class="field" style="width:200px;height:130px;" >
    <img src="../images/logoef.jpg" style="width:200px;height:130px; padding-top:100px;" />
</div>--%>
            </div>
        </div>
    </div>
</div>
