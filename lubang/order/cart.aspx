<%@ Page Language="C#" AutoEventWireup="true" CodeFile="cart.aspx.cs" Inherits="lubang_order_cart" %>
<%@ Register Src="../main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>购物车—路邦网</title>
    <link type="text/css" href="../../CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="../../CSSLUBANG/cart.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="top_main">
        <div class="top_bar">
            <div class="join_sc">
                <a href="<%=http_url %>/Lbindex.aspx">路邦首页</a></div>
            <div class="login">
                <ul>
                    <li>Hi，<a href="<%=http_url %>/lubang/main_user.aspx" target="_blank"><%=dt_m001.Rows[0]["m001_name"].ToString() %></a></li>
                    <li><span>| </span></li>
                    <li><a href="<%=http_url %>/lubang/Lubanglogin/register.aspx">[免费注册]</a></li>
                    <li><span>| </span></li>
                    <li>我的路邦网</li>
                    <li><span>| </span></li>
                    <li>我是分销</li>
                    <li><span>| </span></li>
                    <li>我是商家</li>
                    <li><span>| </span></li>
                    <li>更多<img alt="" src="<%=http_url %>/lubang/images/sjx_b.png" /></li>
                </ul>
            </div>
        </div>
    </div>
    <div class="top_bar1">
        <ul>
            <li class="logo"><a href="http://www.68hui.com/" class="logo_bg">路邦网</a></li>
        </ul>
        <div class="line">
        </div>
    </div>
    <div id="content">
        <div id="J_Cart">
            <div class="cart-filter-bar" id="J_FilterBar">
                <ul class="switch-cart" id="J_CartSwitch">
                    <li class="btn-switch-cart current"><a class="J_MakePoint" href="http://cart.tmall.com/cart.htm?spm=a220l.1.0.0.Dt0An5&amp;from=bmini"
                        data-point="tbcart.8.35"><em>全部商品</em></a></li><li class="btn-switch-cart disabled">
                            <a class="J_MakePoint" href="javascript: void(0);" data-point="tbcart.8.34"><em>降价商品</em>(<span
                                class="number">0</span>)</a></li><li class="btn-switch-cart disabled"><a class="J_MakePoint"
                                    href="javascript: void(0);" data-point="tbcart.8.36"><em>库存紧张</em>(<span class="number">0</span>)</a></li><span
                                        class="pipe">|</span></ul>
                <div class="status-bar" id="J_StatusBar">
                    <span class="bar-title">购物车商品总数：1</span>
                </div>
                <ul class="cart-filters">
                    <li class="active"><a href="#">全部</a></li>
                    <li><a href="#">降价商品<span>（<em>0</em>）</span></a></li>
                    <li><a href="#">库存紧张<span>（<em>0</em>）</span></a></li>
                </ul>
                <div class="cart-sum">
                    已选商品(不含运费)：<strong class="price">¥<em id="J_SmallTotal">0.00</em></strong><a class="submit-btn submit-btn-disabled"
                        id="J_SmallSubmit">结算</a>
                </div>
            </div>
            <div class="cart-main" id="J_CartMain">
                <div class="cart-table-th">
                    <div class="wp">
                        <div class="th th-chk">
                            <div class="select-all J_SelectAll" id="J_SelectAll1">
                                <span class="s-checkbox"></span>&nbsp;&nbsp;全选</div>
                        </div>
                        <div class="th th-item">
                            商品</div>
                        <div class="th th-info">
                            商品信息</div>
                        <div class="th th-price">
                            单价</div>
                        <div class="th th-amount">
                            数量</div>
                        <div class="th th-sum">
                            小计</div>
                        <div class="th th-op">
                            操作</div>
                    </div>
                </div>
                <div id="J_OrderList">
                    <div id="J_OrderHolder_s_1714072548_1" style="height: auto;">
                        <div class="J_Order clearfix order-body  " id="J_Order_s_1714072548_1">
                            <div class="J_ItemHead shop clearfix">
                                <div class="shop-info">
                                    <span class="s-checkbox J_forShop"></span>&nbsp;&nbsp;店铺：<a
                                        title="davidgreff旗舰店" class="J_MakePoint">davidgreff旗舰店</a><span class="ww-light ww-small"
                                            data-display="inline" data-nick="davidgreff旗舰店" data-items="s_1714072548_1" data-icon="small"></span></div>
                            </div>
                            <div class="order-content">
                                <div class="item-list" id="J_BundleList_s_1714072548_1">
                                    <div class="bundle  bundle-last " id="J_Bundle_s_1714072548_1_0">
                                        <div id="J_ItemHolder_55961420363">
                                            <div class="J_ItemBody item-body clearfix item-normal  first-item  last-item   "
                                                id="J_Item_55961420363">
                                                <ul class="item-content clearfix">
                                                    <li class="td td-chk">
                                                        <div class="td-inner">
                                                            <span class="s-checkbox J_CheckBoxItem"></span>
                                                        </div>
                                                    </li>
                                                    <li class="td td-item">
                                                        <div class="td-inner">
                                                            <div class="item-pic J_ItemPic img-loaded">
                                                                <a class="J_MakePoint">
                                                                    <img class="itempic J_ItemImg" src="http://img02.taobaocdn.com/bao/uploaded/i2/T1Gph_FnVbXXbUsaI9_102417.jpg_80x80.jpg"></a></div>
                                                            <div class="item-info">
                                                                <a class="item-title J_MakePoint">davidgreff男士春装外套短款修身英伦韩版羊毛呢子大衣男装呢大衣</a>
                                                                <div class="item-icon-list clearfix">
                                                                    <div class="item-icons J_ItemIcons  item-icons-collapse ">
                                                                        <a title="消费者保障服务，卖家承诺7天退换" class="item-icon item-icon-0 J_MakePoint">
                                                                            <img alt="七天退换" src="http://a.tbcdn.cn/tbsp/icon/xiaobao/a_7-day_return_16x16.png"></a><a
                                                                                title="消费者保障服务，卖家承诺如实描述" class="item-icon item-icon-1 J_MakePoint"><img alt="如实描述" src="http://a.tbcdn.cn/tbsp/icon/xiaobao/a_true_description_16x16.png"></a><a
                                                                                    title="消费者保障服务，卖家承诺假一赔三" class="item-icon item-icon-2 J_MakePoint"><img alt="假一赔三" src="http://a.tbcdn.cn/tbsp/icon/xiaobao/an_authentic_item_16x16.png"></a><span
                                                                                        title="支持信用卡支付" class="item-icon item-icon-3"><img alt="" src="http://a.tbcdn.cn/sys/common/icon/trade/xcard.png"></span><span
                                                                                            class="more">更多<span class="arrow"></span></span></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li class="td td-info">
                                                        <div class="item-props item-props-can">
                                                            <p class="sku-line">
                                                                颜色分类：驼色</p>
                                                            <p class="sku-line">
                                                                尺码：L/175</p>
                                                            <span class="btn-edit-sku J_BtnEditSKU J_MakePoint" data-point="tbcart.8.10">修改</span></div>
                                                    </li>
                                                    <li class="td td-price">
                                                        <div class="td-inner">
                                                            <div class="item-price">
                                                                <div class="price-line">
                                                                    <em class="price-original">1248.00</em></div>
                                                                <div class="price-line">
                                                                    <em tabindex="0" class="J_Price price-now">499.00</em></div>
                                                                <div class="promo-main promo-promo">
                                                                    <div class="promo-content  promo-Tmall$tmallItemPromotion J_ItemPromotions">
                                                                        卖家促销<span class="arrow"></span></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li class="td td-amount">
                                                        <div class="td-inner">
                                                            <div class="item-amount ">
                                                                <a class="J_Minus no-minus" href="#">-</a><input class="text text-amount J_ItemAmount"
                                                                    type="text" value="1" autocomplete="off" data-max="249" data-now="1"><a class="J_Plus plus"
                                                                        href="#">+</a></div>
                                                            <div class="amount-msg J_AmountMsg">
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li class="td td-sum">
                                                        <div class="td-inner">
                                                            <em tabindex="0" class="J_ItemSum number">499.00</em><div class="J_ItemLottery">
                                                            </div>
                                                        </div>
                                                    </li>
                                                    <li class="td td-op">
                                                        <div class="td-inner">
                                                            <a title="移至收藏夹" class="fav J_Fav J_MakePoint" >
                                                                移入收藏夹</a><a class="J_Del J_MakePoint">删除</a></div>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="float-bar-holder" id="J_FloatBarHolder">
                <div class="float-bar clearfix default" id="J_FloatBar" style="position: static;">
                    <div class="group-wrapper group-popup hidden" id="J_SelectedItems" style="display: none;">
                        <div class="group-content" id="J_SelectedItemsList">
                        </div>
                        <span class="arrow" style="left: 669px;"></span>
                    </div>
                    <div class="float-bar-wrapper">
                        <div class="select-all J_SelectAll" id="J_SelectAll2">
                            <span class="s-checkbox"></span>&nbsp;全选</div>
                        <div class="operations">
                            <a class="J_DeleteSelected" hidefocus="true" href="#">删除</a><a class="J_ClearInvalid hidden"
                                hidefocus="true" href="#">清除失效宝贝</a><a class="J_BatchFav" hidefocus="true" href="#">批量移入收藏夹</a><a
                                    class="J_BatchShare" hidefocus="true" href="#">分享</a></div>
                        <div class="float-bar-right">
                            <div class="amount-sum" id="J_ShowSelectedItems">
                                <span class="txt">已选商品</span><em id="J_SelectedItemsCount">0</em><span class="txt">件</span><div
                                    class="arrow-box">
                                    <span class="selected-items-arrow"></span><span class="arrow"></span>
                                </div>
                            </div>
                            <div class="check-cod" id="J_CheckCOD" style="display: none;">
                                <span class="icon-cod"></span><span class="s-checkbox J_CheckCOD"></span>货到付款</div>
                            <div class="pipe">
                            </div>
                            <div class="price-sum">
                                <span class="txt">合计(不含运费)：</span><strong class="price">¥<em id="J_Total">0.00</em></strong></div>
                            <div class="btn-area">
                                <a class="submit-btn" id="J_Go" href="confirm_order.aspx?userid=<%=dt_m001.Rows[0]["m001_key"].ToString() %>"><span>
                                    结算</span><b></b></a></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="recommendBox">
            
        </div>
    </div>
    <div class="clear"></div>
    <uc2:foot ID="foot_1" runat="server" />
    </form>
</body>
</html>
