<%@ Control Language="C#" AutoEventWireup="true" CodeFile="head.ascx.cs" Inherits="main_form_head" %>

<div class="top_main">
    <div class="top_bar">
        <div class="join_sc">
            <a onclick="shoucang(document.title,window.location)">加入收藏</a></div>
        <div class="login">
            <ul>
                <li><%if (m001_key == "")
                                                                              { %><a href="<%=http_url %>/lubang/Lubanglogin/login1.aspx">个人登录</a><%} %><%else
                                                                              { %>Hi，<a href="<%=http_url %>/lubang/main_user.aspx"><%=dt_m001.Rows[0]["m001_name"].ToString() %></a><%} %></li>
                
                <li><span>| </span></li>
                <li><a href="<%=http_url %>/lubang/Lubanglogin/reg.aspx">免费注册</a></li>
                <li><span>| </span></li>
                <li><a href="http://111.1.15.101:90/lubang/Lubanglogin/login.aspx">商家登录</a></li>
<%--                <li><span>| </span></li>
                <li><a href="http://111.1.15.86/lubang/checkcodes.aspx">商家验证码</a></li>
                <li><span>| </span></li>
                <li><a href="http://111.1.15.86/lubang/MercExchange.aspx">商家扣积分</a></li>--%>
                <li><span>| </span></li>
                <li style="cursor:pointer;">更多<img alt="" src="<%=http_url %>/lubang/images/sjx_b.png" /></li>
            </ul>
        </div>
    </div>
</div>
<div class="top_bar1">
    <ul>
        <li class="logo"><a href="http://www.xiche1.com/" class="logo_bg">非凡网</a></li>
        <li class="city">
            <p>
                <%=Session["A03601_NAME"].ToString() %></p>
            <p class="color">
                <a href="<%=http_url %>/lubang/ChangeCity.aspx">[ 切换城市 ]</a></p>
        </li>
        <li class="textbox">
            <div>
                <asp:TextBox ID="TextBox1" CssClass="box" runat="server" TextMode="SingleLine" placeholder="输入 回车搜索"
                    autofocus="true" x-webkit-speech x-webkit-grammar="builtin:translate"></asp:TextBox><asp:Button
                        ID="Button1" runat="server" Text="搜 索" CssClass="search_button" /></div>
            <div class="hot_search">
                <ul>
                    <li>热门搜索：</li>
                    <li class="color">洗车</li>
                    <li>汽车美容</li>
                    <li>业务代理</li>
                    <li>汽车用品</li>
                    <li>汽车服务</li>
                    <li>系统养护</li>
                    <li>电子狗</li>
                </ul>
            </div>
        </li>
       <%-- <li class="phone"><a class="phone_bg">电话</a></li>--%>
    </ul>
</div>
<div class="daohang">
    <div class="list">
        <ul>
            <li onclick="window.location.href='<%=http_url %>/Lbindex.aspx'" id="shouye">首页</li>
            <li class="img1">
                <img alt="" src="<%=http_url %>/lubang/images/line.png" /></li>
            <li onclick="window.location.href='<%=http_url %>/lubang/CarsSerive.aspx'" id="qichefw">汽车服务</li>
            <li class="img1">
                <img alt="" src="<%=http_url %>/lubang/images/line.png" /></li>
            <li onclick="window.location.href='<%=http_url %>/lubang/CarsProduct.aspx'" id="qicheyp">汽车用品</li>
            <li class="img1">
                <img alt="" src="<%=http_url %>/lubang/images/line.png" /></li>
            <li onclick="window.location.href='<%=http_url %>/lubang/jf.aspx'" id="jifendh">积分兑换</li>
            <li class="zjll">
                <div class="zjtit">
                    最近浏览<img alt="" src="<%=http_url %>/lubang/images/sjx.png" /></div>
            </li>
        </ul>
    </div>
</div>
