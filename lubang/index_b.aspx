<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index_b.aspx.cs" Inherits="index_b" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>路邦网-商户主页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10" />
    <meta name="description" content="路邦网">
    <meta name="keywords " content="路邦网">
    <meta name="robots" content="all">
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/index_b.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="w_960">
        <div class="head_main">
            <div class="lubanglogo">
            </div>
            <div class="login">
                <ul>
                    <li><a href="<%=http_url %>/Lbindex.aspx">返回首页</a></li>
                    <li><a href="<%=http_url %>/lubang/lubanglogin/login.aspx">[登录]</a></li>
                    <li><a href="<%=http_url %>/lubang/lubanglogin/reg.aspx">[注册]</a></li>
                    <li>更多<img alt="" src="images/sjx_b.png" /></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="clear">
    </div>
    <div class="w_960">
        <div class="main_box">
            <div class="bussiness_des">
                <div class="b_img">
                    <img alt="" src="images/bussiness_logo/xysj.jpg" /></div>
                <div class="b_box">
                    <div class="b_title">
                        <span>
                            <%=dt_m00202_v01.Rows[0]["shopname"].ToString()%></span> <a href="<%=http_url %>/lubang/lubanglogin/login.aspx?keyid=<%=dt_m00202_v01.Rows[0]["m002_key"].ToString() %>" target="_blank">管理店铺</a></div>
                    <div class="address">
                        <div class="address_des">
                            <p>
                                店铺地址：</p>
                            <p>
                                营业时间：</p>
                            <p>
                                预约电话：</p>
                        </div>
                        <div class="address_des1">
                            <p>
                                <%=dt_m00202_v01.Rows[0]["store_address"].ToString() %></p>
                            <p>
                                <%=dt_m00202_v01.Rows[0]["store_runtime"].ToString() %></p>
                            <p>
                                <%=dt_m00202_v01.Rows[0]["store_tel"].ToString() %></p>
                        </div>
                        <div class="map_des">
                            <div class="pointer">
                            </div>
                            地图/交通指南</div>
                        <div class="pingfen">
                            <div class="pf_tit">
                                综合评分</div>
                            <div class="wx_y">
                                <ul>
                                    <li></li>
                                    <li></li>
                                    <li></li>
                                    <li></li>
                                </ul>
                            </div>
                            <div class="wx_n">
                                <ul>
                                    <li></li>
                                </ul>
                            </div>
                            <div class="score">
                                4分</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bussiness_menu">
                <div class="menu_title">
                    <div class="out">
                        商家概况</div>
                    <div class="current">
                        服务套系</div>
                    <div class="out">
                        商家点评</div>
                    <div class="line">
                    </div>
                </div>
                <div class="bussiness_product">
                    <div class="product_type">
                        <ul>
                            <li class="current">出售中的套餐</li>
                            <li>往期套餐</li>
                        </ul>
                    </div>
                </div>
                <asp:ListView ID="ListView1" runat="server">
                    <ItemTemplate>
                        <div class="product_list">
                            <div class="p_img">
                                <img alt="" src="<%#Eval("WEB_BIG") %>" /></div>
                            <div class="p_price">
                                <span>
                                    <%#Eval("shopname")%></span>
                                <div class="p_list_des">
                                    <%#Eval("product_show_memo")%></div>
                                <div class="box_price">
                                    <div class="price_01">
                                        ￥<%#Eval("product_dis_price")%>
                                    </div>
                                    <div class="price_02">
                                        <ul>
                                            <li class="b01">
                                                <p>
                                                    门店价</p>
                                                <p class="line_01 fontsize">
                                                    ￥<%#Eval("product_price")%></p>
                                            </li>
                                            <li class="b01">
                                                <p>
                                                    折扣</p>
                                                <p class="fontsize">
                                                    <%#Eval("product_discount") %>折</p>
                                            </li>
                                            <li>
                                                <p>
                                                    已购买</p>
                                                <p class="fontsize">
                                                    <%#Eval("product_buynumber")%>人</p>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="price_button">
                                        <div class="button_img">
                                            立即抢购</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:ListView>
                <div class="page_num">
                    <div class="page_p">
                        <asp:DataPager ID="DataPager1" runat="server" PagedControlID="ListView1" PageSize="6"
                            OnPreRender="DataPager1_PreRender">
                            <Fields>
                                <%--<asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowLastPageButton="True" />--%>
                                <asp:NumericPagerField ButtonCount="4" CurrentPageLabelCssClass="current" NumericButtonCssClass="out"
                                    NextPreviousButtonCssClass="out" />
                                <asp:NextPreviousPagerField FirstPageText="First" LastPageText="Last" NextPageText="下一页"
                                    PreviousPageText="上一页" ButtonCssClass="out" />
                            </Fields>
                        </asp:DataPager>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
