<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login"
    EnableViewState="false" %>

<%--<%@ Register Src="BaseForm/Head.ascx" TagName="Head" TagPrefix="uc1"  %>
<%@ Register Src="BaseForm/Foot.ascx" TagName="Foot" TagPrefix="uc2"  %>--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>
        <%=BaseMsg.getMsg("M0061")%>
    </title>
    <script type="text/javascript" src="<%=http_url %>/js/http.js?ver=20130114"></script>
    <script type="text/javascript" src="<%=http_url %>/js/BasePage.js?ver=20130114"></script>
    <link href="Css/page.css" rel="stylesheet" type="text/css" />
    <link href="Css/login.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="<%=http_url %>/js/jquery.min.js?ver=20130114"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div id="showlogin">
        <table>
            <tr class="tr_1">
                <td colspan="2">
                    <label class="label_title">
                        系统登陆 - 条码管理</label>
                </td>
            </tr>
            <tr class="tr_2">
                <td class="td_1">
                    <label>
                        <%=BaseMsg.getMsg("M0050")%></label>
                </td>
                <td>
                    <%
                        dt_temp = fun.getDtBySql("Select pkg_user.get_last_user('" + fun.getClientIp() + "') as c from dual ");
                        string v = "";
                        try
                        {
                            v = dt_temp.Rows[0][0].ToString();
                        }
                        catch (Exception ex)
                        {
                            v = "";
                        }
                    %>
                    <input class="txt1" type="text" id="user" value="<%=v %>" /><span id="user_ness" style="color: Red; display: none;">
                        <%=BaseMsg.getMsg("M0052")%>
                    </span>
                </td>
            </tr>
            <tr>
                <td class="td_1">
                    <label>
                        <%=BaseMsg.getMsg("M0051")%></label>
                </td>
                <td>
                    <input class="txt1" type="password" id="pass" value="" /><span id="pass_ness" style="color: Red;
                        display: none;">
                        <%=BaseMsg.getMsg("M0053")%>
                    </span>
                </td>
            </tr>
            <tr style="display: none;">
                <td class="td_1">
                    <label>
                        <%=BaseMsg.getMsg("M0054")%></label>
                </td>
                <td>
                    <input type="text" id="txtVerifyCode" onfocus="show_vCode('img_code','0')" /><img
                        alt="" src="<%=GlobeAtt.HTTP_URL %>/VerifyCode.aspx" onclick="show_vCode('img_code','1')"
                        id="img_code" style="display: none" />
                    <span id="vc_ness" style="color: Red; visibility: hidden;">* </span>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input class="button" type="button" id="login" onclick="javascript:userlogin()" value="<%=BaseMsg.getMsg("M0055")%>" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span id="txt_error" style="color: Red; visibility: hidden; font-size:13px; margin-left:10px;"></span>
                </td>
            </tr>
        </table>
    </div>
    <div>
        <input type="hidden" id="ltype" value="1" />
    </div>
    </form>
    <%--<script language="javascript" type="text/javascript">
        loadChildUrl("showlogin", "/HandEquip/BaseForm/loginform.aspx");
    </script>--%>
    <script language="javascript" type="text/javascript">
        $(function () {
            $("#user").focus();
            $(document).keydown(function (e) {
                if (!e) e = window.event;
                if (e.keyCode==13) {
                    var b = e.target;
                    if (b.id == "user") {
                        $("#pass").focus();
                    } else if (b.id == "pass") {
                        $("#login").focus();
                    } else if (b.id == "login") {
                        userlogin();
                    }
                }
            });
        })       
    </script>
</body>
</html>
