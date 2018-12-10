<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CarsSerive.aspx.cs" Inherits="CarsSerive" %>

<%@ Register Src="main_form/head.ascx" TagName="head" TagPrefix="uc1" %>
<%@ Register Src="main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<%@ Register Src="main_form/rementuijian.ascx" TagName="rementuijian" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>非凡网-汽车服务</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10" />
    <meta name="description" content="非凡网">
    <meta name="keywords " content="非凡网">
    <meta name="robots" content="all">
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/CarsSerive.css" rel="Stylesheet" />
    <script type="text/javascript" src="<%=http_url %>/lubang/js/jquery.js"></script>
    <script type="text/javascript" src="<%=http_url %>/lubang/js/showp.js"></script>
    <script type="text/javascript">
        var m036_key = '<%=m036_key %>';
        var m03601_key = '<%=m03601_key %>';
        var a0360101_key = '<%=a0360101_key %>';

        window.onload = function () {
            var m036 = document.getElementById('yi_' + m036_key);
            var m03601 = document.getElementById('er_' + m03601_key);
            var dq = document.getElementById('dq_' + a0360101_key);
            if (m036 != null) {
                m036.className = 'current';
                document.getElementById("yi").className = "none";
            }
            if (m03601 != null) {
                m03601.className = 'current';
            }
            else {
                document.getElementById("fl2").className = "gray"
            }
            if (dq != null) {
                dq.className = 'current';
                document.getElementById("dq").className = "none";
            }
        }

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <uc1:head ID="head_" runat="server" />
    <div class="f_main">
        <div class="f_border">
            <div class="f fenlei">
                <div class="f_tit">
                    热门：</div>
                <ul>
                    <li><span class="current"><a>洗车</a></span></li>
                    <li><span><a href="#">电子狗</a></span></li>
                    <li><span><a href="#">行车记录仪</a></span></li>
                    <li><span><a href="#">汽车美容</a></span></li>
                    <li><span><a href="#">改装</a></span></li>
                    <li><span><a href="#">汽油添加剂</a></span></li>
                    <li><span><a href="#">安全座椅</a></span></li>
                    <li><span><a href="#">代办</a></span></li>
                </ul>
            </div>
            <div class="f">
                <div class="f_tit">
                    分类：</div>
                <ul>
                    <li><a href="<%=http_url %>/lubang/CarsSerive.aspx?mnameid=''"><span id="yi" class="current">全部</span></a></li>
                    <%for (int i = 0; i < dt_m036.Rows.Count; i++)
                      {
                          string m036_name = dt_m036.Rows[i]["m036_name"].ToString();
                          string icount = dt_m036.Rows[i]["icount"].ToString();
                          string m036_key = dt_m036.Rows[i]["m036_key"].ToString();
                    %>
                    <li>
                        <a onclick="window.location.href='<%=http_url %>/lubang/CarsSerive.aspx?mnameid=<%=m036_key %>'"><span id="yi_<%=m036_key %>"><%=m036_name %> <span id="fl1" class="gray"><%=icount %></span></span></a></li>
                    <%} %>
                </ul>
            </div>
            <div class="f">
                <div class="f_tit">
                    小类：</div>
                <ul>
                    <%for (int i = 0; i < dt_m03601.Rows.Count; i++)
                      {
                          string m03601_name = dt_m03601.Rows[i]["m03601_name"].ToString();
                          string icount = dt_m03601.Rows[i]["icount"].ToString();
                          string m03601_key = dt_m03601.Rows[i]["m03601_key"].ToString();
                    %>
                    <li>
                        <a onclick="window.location.href='<%=http_url %>/lubang/CarsSerive.aspx?nameid=<%=m03601_key %>'"><span id="er_<%=m03601_key %>"><%=m03601_name %> <span id="fl2" class="gray"><%=icount %></span></span></a></li>
                    <%} %>
                </ul>
            </div>
            <div class="f">
                <div class="f_tit">
                    区域：</div>
                <ul>
                    <li><a href="<%=http_url %>/lubang/CarsSerive.aspx?anameid=''"><span id="dq" class="current">全部</span></a></li>
                    <%for (int i = 0; i < dt_a03601.Rows.Count; i++)
                      {
                          string a0360101_name = dt_a03601.Rows[i]["a0360101_name"].ToString();
                          string icount = dt_a03601.Rows[i]["icount"].ToString();
                          string a0360101_key = dt_a03601.Rows[i]["a0360101_key"].ToString();
                    %>
                    <li>
                    <a onclick="window.location.href='<%=http_url %>/lubang/CarsSerive.aspx?anameid=<%=a0360101_key %>'">
                        <span id="dq_<%=a0360101_key %>"><%=a0360101_name %> <span id="fl3" class="gray"><%=icount %></span></span></a></li>
                    <%} %>
                </ul>
            </div>
        </div>
        <div class="f_paixu">
                <ul>
                    <li class="f_current"><span><a href="#">默认排序</a></span></li>
                    <li><span><a href="#">一周热卖</a></span></li>
                    <li><span><a href="#">最具口碑</a></span></li>
                    <li><span><a href="#">最低折扣</a></span></li>
                </ul>
         </div>
    </div>
    <div class="product_list clearfix">
        <asp:ListView ID="ListView1" runat="server">
            <ItemTemplate>
                <div class="div_li">
                    <div class="inner_li">
                        <div class="product_buy">
                            <div class="product_posi">
                                <span><%#Eval("product_buynumber") %></span>人已购买</div>
                        </div>
                        <div class="product_pic">
                            <a href="<%=http_url %>/lubang/CarDes.aspx?keyid=<%#Eval("m00203_key") %>">
                                <img alt="" src="<%#Eval("product_picture") %>" /></a>
                        </div>
                        <div class="product_price">
                            <ul>
                                <li class="p01 color_yellow">￥<%#Eval("product_dis_price") %></li>
                                <li>门店价：<span class="p02">￥<%#Eval("product_price") %></span></li>
                                <li class="p01"><%#Eval("product_discount") %>折</li>
                            </ul>
                        </div>
                        <div class="product_des">
                            <div class="procuct_name">
                                <p>
                                    <a><b><%#Eval("product_title") %></b></a></p>
                                <p>
                                    <img alt="" src="images/line_des.jpg" /></p>
                                <p class="procuct_des">
                                    <span><%#Eval("product_desc") %></span><a href="<%=http_url %>/lubang/CarDes.aspx?keyid=<%#Eval("m00203_key") %>" class="a_button">去看看</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </div>
    <div class="clear">
    </div>
    <div class="page_num">
        <div class="page_p">
            <asp:DataPager ID="DataPager1" runat="server" PagedControlID="ListView1" PageSize="9"
                OnPreRender="DataPager1_PreRender">
                <Fields>
                    <%--<asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowLastPageButton="True" />--%>
                    <asp:NumericPagerField ButtonCount="4" CurrentPageLabelCssClass="current_p" NumericButtonCssClass="out" NextPreviousButtonCssClass="out" />
                    <asp:NextPreviousPagerField FirstPageText="First" LastPageText="Last" NextPageText="下一页"
                        PreviousPageText="上一页" ButtonCssClass="out" />
                </Fields>
            </asp:DataPager>
            <%--<ul>
                <li class="current">1</li>
                <li>2</li>
                <li>3</li>
                <li>4</li>
                <li class="next">
                    <img alt="" src="images/next.png" /></li>
            </ul>--%><%--
            <div class="tiaozhuan">
                跳转到：<input type="text" value="1" class="input_num" />
                <input type="button" value="GO" class="next_go" />
            </div>--%>
        </div>
    </div>
    <div class="clear">
    </div>
    <uc3:rementuijian ID="rementuijian_" runat="server" />
    <div class="clear">
    </div>
    <uc2:foot ID="foot_" runat="server" />
    </form>
</body>
</html>
