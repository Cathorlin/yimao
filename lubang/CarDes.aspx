<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CarDes.aspx.cs" Inherits="CarDes" %>

<%@ Register Src="main_form/head.ascx" TagName="head" TagPrefix="uc1" %>
<%@ Register Src="main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<%@ Register Src="main_form/rementuijian.ascx" TagName="rementuijian" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>非凡网-产品详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10" />
    <meta name="description" content="非凡网">
    <meta name="keywords " content="非凡网">
    <meta name="robots" content="all">
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/CarDes.css" rel="Stylesheet" />
    <script type="text/javascript" src="<%=http_url %>/lubang/js/jquery.js"></script>
    <script type="text/javascript" src="<%=http_url %>/lubang/js/showp.js"></script>
    <script type="text/javascript">
        function like_add() {
            var add_num_ = document.getElementById("add_num");
            add_num_ = add_num_ + 1;
            add_num_.innerHTML = "<span>" + add_num_ + "</span>";
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <uc1:head ID="head_" runat="server" />
    <div class="w_960">
        <div class="title_order">
            <a href="<%=http_url %>/Lbindex.aspx" class="color">
                <%=dt_m0203_m036.Rows[0]["首页"].ToString() %></a><span> > </span><a href="<%=http_url %>/lubang/CarsSerive.aspx?mnameid=<%=dt_m0203_m036.Rows[0]["m036_key"].ToString() %>"
                    class="color">
                    <%=dt_m0203_m036.Rows[0]["m036_name"].ToString() %></a><span> > </span><a href="<%=http_url %>/lubang/CarsSerive.aspx?nameid=<%=dt_m0203_m036.Rows[0]["m03601_key"].ToString() %>"
                        class="color">
                        <%=dt_m0203_m036.Rows[0]["m03601_name"].ToString()%></a>
                        <%--<span> > </span>
            <%=dt_m0203_m036.Rows[0]["a0360101_name"].ToString()%>--%></div>
        <div class="box01">
            <h1>
                【<span><%=dt_m0203_m036.Rows[0]["product_title"].ToString()%></span>】</h1>
            <div class="box_des">
                <%=dt_m0203_m036.Rows[0]["product_desc"].ToString()%>
            </div>
            <div class="box_img">
                <img alt="" src="<%=dt_m0203_m036.Rows[0]["WEB_BIG"].ToString()%>" width="500px" height="330px" />
                <div class="box_price">
                    <div class="price_01">
                        ￥<%=dt_m0203_m036.Rows[0]["product_dis_price"].ToString() %>
                    </div>
                    <div class="price_02">
                        <ul>
                            <li class="b01">
                                <p>
                                    门店价</p>
                                <p class="line_01 fontsize">
                                    ￥<%=dt_m0203_m036.Rows[0]["product_price"].ToString() %></p>
                            </li>
                            <li class="b01">
                                <p>
                                    折扣</p>
                                <p class="fontsize">
                                    <%=dt_m0203_m036.Rows[0]["product_discount"].ToString() %>折</p>
                            </li>
                            <li>
                                <p>
                                    已购买</p>
                                <p class="fontsize">
                                    <%=dt_m0203_m036.Rows[0]["product_buynumber"].ToString() %>人</p>
                            </li>
                        </ul>
                    </div>
                    <div class="price_button">
                        <div class="button_img">
                            <asp:Button ID="Button1" runat="server" CssClass="button_b" UseSubmitBehavior="false"
                                OnClick="liji_buy" Text="立即抢购" /></div>
                    </div>
                    <div class="price_baozheng">
                        <ul>
                            <li class="b02">
                                <div class="sxt_img">
                                </div>
                            </li>
                            <li class="b02">
                                <div class="gqt_img">
                                </div>
                            </li>
                            <li>
                                <div class="qedb_img">
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="box_buttom">
                <div class="sc_img">
                </div>
                <a onclick="shoucang(document.title,window.location)"><span>收藏本单</span></a>
                <div class="lianxiimg">
                    分享到：<a class="renren"></a><a class="QQweiboimg"></a><a class="xinlangweiboimg"></a><a
                        class="QQimg"></a></div>
            </div>
        </div>
        <div class="box02">
            <div class="box2_left">
                <%if (dt_m0203_m036.Rows[0]["presents_desc"].ToString() != "" && dt_m0203_m036.Rows[0]["after_sales_desc"].ToString() != "")
                  { %>
                <div class="box2_border">
                    <div class="dgyl_img">
                    </div>
                    <div class="li_img">
                    </div>
                    <div class="box2_des">
                        <p>
                            <%=dt_m0203_m036.Rows[0]["presents_desc"].ToString()%></p>
                    </div>
                    <div class="box2_sh">
                        <div class="sh_img">
                        </div>
                        <div class="box2_des">
                            <%=dt_m0203_m036.Rows[0]["after_sales_desc"].ToString()%>
                        </div>
                    </div>
                </div>
                <%} %>
                <%if (dt_m0203_m036.Rows[0]["show_html"].ToString() != "")
                  { %>
                <div class="box_title">
                    <div class="title_yp">
                        产品详情</div>
                </div>
                <div class="box2_img">
                    <ul>
                        <li><%=dt_m0203_m036.Rows[0]["show_html"].ToString()%></li>
                    </ul>
                </div>
                <%} %>
                <div class="box_title">
                    <div class="title_yp">
                        商家信息</div>
                </div>
                <div class="sjxx">
                    <div class="sjxx_w">
                        <table>
                            <tr>
                                <td class="td1">商家名称：</td>
                                <td class="td2"><a href="<%=http_url %>/lubang/index_b.aspx?keyid=<%=dt_m0203_v01.Rows[0]["m00203_key"].ToString() %>">
                                <span>
                                    <%=dt_m0203_v01.Rows[0]["shopName"].ToString()%></span>【进入店铺】</a></td>
                            </tr>
                            <tr>
                                <td class="td1">联系电话：</td>
                                <td class="td2"><%=dt_m0203_v01.Rows[0]["store_tel"].ToString() %></td>
                            </tr>
                            <tr>
                                <td class="td1">详细地址：</td>
                                <td class="td2"><%=dt_m0203_v01.Rows[0]["store_address"].ToString() %></td>
                            </tr>
                            <tr>
                                <td class="td1">交通指南：</td>
                                <td class="td2"><%=dt_m0203_v01.Rows[0]["traffic_guide"].ToString()%></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <div class="ljqg">
                    <div class="ljqg_m">
                        <div class="ljqg_w">
                            <div class="like_img">
                            </div>
                            <div class="like_t">
                                <a onclick="like_add()">喜欢(<span id="add_num">0</span>)</a></div>
                            <div class="sj_img">
                            </div>
                            <div class="sj_t">
                                <a onclick="shoucang(document.title,window.location)">收藏</a></div>
                        </div>
                        <div class="lianxiimg">
                            分享到：<a class="renren"></a><a class="QQweiboimg"></a><a class="xinlangweiboimg"></a><a
                                class="QQimg"></a></div>
                        <div class="price_button">
                            <div class="button_img">
                                <asp:Button ID="Button2" runat="server" UseSubmitBehavior="false" CssClass="button_b"
                                    Text="立即抢购" /></div>
                        </div>
                    </div>
                </div>
                <div class="xfdp">
                    <div class="xf_tit">
                        消费点评(0)</div>
                    <div class="xf_tit01">
                    </div>
                    <div class="dp_list">
                        暂无消费点评</div>
                </div>
            </div>
            <div class="box2_right">
                <div class="right_title">
                    最热销的同类型套系<a>更多》</a></div>
                <div class="right_list">
                    <ul>
                        <%for (int i = 0; i < dt_m0203_v02.Rows.Count; i++)
                          {
                              string product_desc = dt_m0203_v02.Rows[i]["product_desc"].ToString();
                              string product_dis_price = dt_m0203_v02.Rows[i]["product_dis_price"].ToString();
                              string product_buynumber = dt_m0203_v02.Rows[i]["product_buynumber"].ToString();
                        %>
                        <li>
                            <img alt="" src="images/pic/a01.jpg" width="222px" height="166px" />
                            <div class="list_des">
                                <p>
                                    <%=product_desc %></p>
                                <p class="tuan">
                                    喜团价<span class="color">￥<%=product_dis_price %></span><span class="buy_01"><%=product_buynumber %>人购买</span></p>
                            </div>
                        </li>
                        <%} %>
                    </ul>
                </div>
            </div>
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
