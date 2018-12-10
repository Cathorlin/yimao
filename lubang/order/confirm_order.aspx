<%@ Page Language="C#" AutoEventWireup="true" CodeFile="confirm_order.aspx.cs" Inherits="lubang_order_confirm_order" %>

<%@ Register Src="../main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>确认订单—路邦网</title>
    <link type="text/css" href="../../CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="../../CSSLUBANG/confirm_order.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <div class="top_main">
        <div class="top_bar">
            <div class="join_sc">
                <a href="<%=http_url %>/Lbindex.aspx" target="_blank">路邦首页</a></div>
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
    <div class="clear">
    </div>
    <div class="w_960">
        <div class="order_flow">
            <ol class="order_step">
                <li class="step-first">
                    <div class="step-done">
                        <div class="step-name">
                            拍下商品</div>
                        <div class="step-no">
                        </div>
                    </div>
                </li>
                <li>
                    <div class="step-name">
                        付款到支付宝</div>
                    <div class="step-no">
                        2</div>
                </li>
                <li>
                    <div class="step-name">
                        确认收货</div>
                    <div class="step-no">
                        3</div>
                </li>
                <li class="step-last">
                    <div class="step-name">
                        评价</div>
                    <div class="step-no">
                        4</div>
                </li>
            </ol>
        </div>
        <div class="addresses addrMuch address-option-enable" id="J_addresses">
            <h2>
                选择收货地址</h2>
            <div class="list">
                <div class="addr addr-def addr-cur" style="height: 138px;">
                    <div class="inner">
                        <div title="上海 上海 (龚文明收)" class="addr-hd">
                            <span class="prov">上海</span><span class="city">上海</span><span>（</span><span class="name">龚文明</span><span>
                                收）</span></div>
                        <div title="徐汇 凯旋路3500号华苑大厦1号楼9A" class="addr-bd">
                            <span class="dist">徐汇</span><span class="street">凯旋路3500号华苑大厦1号楼9A</span><span class="phone">13918332931</span><span
                                class="last">&nbsp;</span></div>
                        <div class="addr-toolbar">
                        </div>
                    </div>
                    <ins class="curmarker"></ins><a class="setdefault">设为默认</a><ins class="deftip">默认地址</ins><div
                        class="floater">
                    </div>
                    <div class="option" style="bottom: 0px;">
                        <div class="container">
                            <input class="option-checkbox use-station" type="checkbox"><span class="station-label">代收包裹</span><span
                                class="station-info-free">免费</span></div>
                    </div>
                </div>
                <div class="addr" style="height: 106px;">
                    <div class="inner">
                        <div title="上海 上海 (龚文明收)" class="addr-hd">
                            <span class="prov">上海</span><span class="city">上海</span><span>（</span><span class="name">龚文明</span><span>
                                收）</span></div>
                        <div title="松江 城鸿路222弄17号楼604室" class="addr-bd">
                            <span class="dist">松江</span><span class="street">城鸿路222弄17号楼604室</span><span class="phone">15072322593</span><span
                                class="last">&nbsp;</span></div>
                        <div class="addr-toolbar">
                        </div>
                    </div>
                    <ins class="curmarker"></ins><a class="setdefault">设为默认</a><ins class="deftip">默认地址</ins><div
                        class="floater">
                    </div>
                    <div class="option" style="bottom: 26px;">
                        <div class="container">
                            <input class="option-checkbox use-station" type="checkbox"><span class="station-label">代收包裹</span><span
                                class="station-info-free">免费</span></div>
                    </div>
                </div>
                <div class="addr">
                    <div class="inner">
                        <div title="上海 上海 (龚文明收)" class="addr-hd">
                            <span class="prov">上海</span><span class="city">上海</span><span>（</span><span class="name">龚文明</span><span>
                                收）</span></div>
                        <div title="松江 上海市松江区沈砖公路5500号保隆科技有限公司" class="addr-bd">
                            <span class="dist">松江</span><span class="street">上海市松江区沈砖公路5500号保隆科技有限公司</span><span
                                class="phone">13918332931</span><span class="last">&nbsp;</span></div>
                        <div class="addr-toolbar">
                        </div>
                    </div>
                    <ins class="curmarker"></ins><a class="setdefault">设为默认</a><ins class="deftip">默认地址</ins><div
                        class="floater">
                    </div>
                    <div class="option">
                        <div class="container">
                        </div>
                    </div>
                </div>
                <div class="tc-feedback feedback-ft">
                    <div class="tc-feedback-inner">
                        <div class="tc-feedback-con tc-feedback-tip">
                            <p class="tc-feedback-content">
                                小天猫猜您是海外用户，来试试<span class="tip-btn">
                                    国际转运 </span>服务吧~</p>
                            <s class="tc-feedback-icon"></s>
                        </div>
                    </div>
                </div>
                <div class="moreAddr">
                    <div class="addr">
                        <div class="inner">
                            <div title="浙江 温州 (龚文明收)" class="addr-hd">
                                <span class="prov">浙江</span><span class="city">温州</span><span>（</span><span class="name">龚文明</span><span>
                                    收）</span></div>
                            <div title="鹿城 人民东路18号移动大楼4楼" class="addr-bd">
                                <span class="dist">鹿城</span><span class="street">人民东路18号移动大楼4楼</span><span class="phone">15990756451</span><span
                                    class="last">&nbsp;</span></div>
                            <div class="addr-toolbar">
                            </div>
                        </div>
                        <ins class="curmarker"></ins><a class="setdefault">设为默认</a><ins class="deftip">默认地址</ins><div
                            class="floater">
                        </div>
                        <div class="option">
                            <div class="container">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="control">
                <a class="showAll">显示全部地址</a>
                <button class="tc-btn createAddr" type="button">
                    使用新地址</button><div class="tc-feedback feedback-ft">
                        <div class="tc-feedback-inner">
                            <div class="tc-feedback-con tc-feedback-tip">
                                <p class="tc-feedback-content">
                                    小天猫猜您是海外用户，来试试<span class="tip-btn">
                                        国际转运 </span>服务吧~</p>
                                <s class="tc-feedback-icon"></s>
                            </div>
                        </div>
                    </div>
                <a class="manageAddr">管理收货地址</a></div>
        </div>
        <form id="J_orderForm" action="" method="post" target="_self">
        <div class="shine-list" id="J_orders">
            <h2>
                确认订单信息<span class="reconfirm-tip" id="R_reConfirmTip" style="display: none; visibility: visible;">更换地址后，您需要重新确认订单信息<s></s></span></h2>
            <div class="bundle">
                <table class="grid-bundle grid-bundle-B">
                    <thead>
                        <tr>
                            <th class="tube-title">
                                <div class="title-wrap">
                                    <div class="bundle-title">
                                        <a title="antszone旗舰店">店铺：antszone旗舰店</a><span class="ww-light ww-small" data-display="inline"
                                            data-nick="antszone旗舰店" data-icon="small"><a title="点此可以直接和卖家交流选好的宝贝，或相互交流网购体验，还支持语音视频噢。"
                                                class="ww-inline ww-online"><span>旺旺在线</span></a></span></div>
                                </div>
                            </th>
                            <th class="tube-price">
                                单价（元）
                            </th>
                            <th class="tube-amount">
                                数量
                            </th>
                            <th class="tube-promo">
                                优惠（元）
                            </th>
                            <th class="tube-sum">
                                小计(元)
                            </th>
                            <th class="tube-postage">
                                配送方式
                            </th>
                        </tr>
                        <tr class="row-border">
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td class="tube-postage">
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="grid-main" id="main70467322821" data-main="70467322821">
                            <td class="tube-main" colspan="5">
                                <table>
                                    <tbody>
                                        <tr class="grid-order" id="order70467322821_0" data-order="70467322821_0">
                                            <td class="tube-img">
                                                <a title="AZ男装 男士冬装外套长款羊毛翻领风衣 绅士休闲修身毛呢大衣" class="img">
                                                    <img height="50" src="http://img03.taobaocdn.com/bao/uploaded/i3/582937438/T2Bf8UXuFXXXXXXXXX_!!582937438.jpg_sum.jpg"
                                                        data-mm="tmalljy.2.6?action=openitem_pic"></a><input name="70467322821_0|ep" type="hidden"
                                                            value=""><input name="70467322821_0|codRank" type="hidden" value=""><input name="70467322821_0|tgKey"
                                                                type="hidden" value="">
                                            </td>
                                            <td class="tube-master">
                                                <p class="item-title">
                                                    <a title="AZ男装 男士冬装外套长款羊毛翻领风衣 绅士休闲修身毛呢大衣">AZ男装 男士冬装外套长款羊毛翻领风衣 绅士休闲修身毛呢大衣</a></p>
                                                <div class="iconlist">
                                                    <span class="icon-group"><a title="消费者保障服务，卖家承诺7天退换">
                                                        <img alt="" src="http://a.tbcdn.cn/tbsp/icon/xiaobao/a_7-day_return_16x16.png"></a>
                                                        <a title="消费者保障服务，卖家承诺如实描述">
                                                            <img alt="" src="http://a.tbcdn.cn/tbsp/icon/xiaobao/a_true_description_16x16.png"></a><a
                                                                title="消费者保障服务，卖家承诺假一赔三"><img alt="" src="http://a.tbcdn.cn/tbsp/icon/xiaobao/an_authentic_item_16x16.png"></a></span><span
                                                                    class="icon-group"><a title="支持信用卡支付"><img alt="" src="http://a.tbcdn.cn/sys/common/icon/trade/xcard.png"></a><a
                                                                        title="货到付款"><img alt="" src="http://a.tbcdn.cn/sys/common/icon/trade/item_cod.png"></a></span></div>
                                            </td>
                                            <td class="tube-sku">
                                                <p>
                                                    <span class="hd">颜色：</span><span class="bd">驼色</span></p>
                                                <p>
                                                    <span class="hd">尺码：</span><span class="bd">L</span></p>
                                            </td>
                                            <td class="tube-price">
                                                898.00
                                            </td>
                                            <td class="tube-amount">
                                                <div class="tc-amount">
                                                    <span class="minus minus-off">
                                                    </span>
                                                    <input class="tc-text amount" type="text" value="1"><span class="plus"></span></div>
                                            </td>
                                            <td class="tube-promo">
                                                <div class="tc-util tc-select order-promo-select" style="width: 100px;">
                                                    <input name="bundleList_70467322821_0" type="hidden"><div
                                                        class="tc-select-content" style="width: 100px;">
                                                        <div class="tc-select-label">
                                                            省399元:梦想价</div>
                                                        <span class="tc-select-arrow"><ins></ins></span>
                                                    </div>
                                                    <div class="tc-select-options">
                                                        <div title="省399元:梦想价" class="tc-select-option tc-select-active">
                                                            省399元:梦想价</div>
                                                    </div>
                                                </div>
                                                <span class="promo-desc">
                                                    <div class="tc-feedback">
                                                        <div class="tc-feedback-inner">
                                                            <div class="tc-feedback-con tc-feedback-tip">
                                                                <div class="tc-feedback-content">
                                                                    <ul>
                                                                        <li>梦想价:省399.00元,包邮</li></ul>
                                                                </div>
                                                                <s class="tc-feedback-icon"></s>
                                                            </div>
                                                            <s class="tc-feedback-arrow tc-feedback-arrow-top" style="visibility: visible;">
                                                            </s><s class="tc-feedback-close" style="visibility: hidden;"></s>
                                                        </div>
                                                    </div>
                                                </span>
                                                <div class="camp-box">
                                                    <span class="camp-icon">满199包邮</span></div>
                                            </td>
                                            <td class="tube-sum">
                                                <p class="sum">
                                                    499.00</p>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td class="tube-postage">
                                <div class="postage-cage postage-cage-undefined">
                                    <div class="bundle-post">
                                        <div class="postage-group postage-group-pt">
                                            <label class="group-label">
                                                <input name="postageGroup70467322821" class="postage-radio" hidefocus="true" type="radio"
                                                    checked="checked">普通配送</label><div class="tc-util tc-select bundle-postage">
                                                        <input type="hidden" value="-4"><div class="tc-select-content">
                                                            <div class="tc-select-label">
                                                                快递:包邮</div>
                                                            <span class="tc-select-arrow"><ins></ins></span>
                                                        </div>
                                                        <div class="tc-select-options">
                                                            <div title="快递:包邮" class="tc-select-option tc-select-active">
                                                                快递:包邮</div>
                                                        </div>
                                                    </div>
                                        </div>
                                        <div class="postage-schedule">
                                        </div>
                                        <div class="postage-tip" style="display: none;">
                                        </div>
                                        <div class="postage-coverage" style="display: none;">
                                        </div>
                                    </div>
                                    <div class="postage-group postage-group-cod">
                                        <label class="group-label">
                                            <input name="postageGroup70467322821" class="postage-radio" hidefocus="true" type="radio">货到付款</label><span class="postage-cod-tip">(下一步计算运费)</span></div>
                                    <input name="70467322821|trans" class="postage-trans" type="hidden" value="-4"><input
                                        name="70467322821|postFee" class="postage-postFee" type="hidden" value="0"><input
                                            name="70467322821|codServiceFeeRate" class="postage-buyerPayRate" type="hidden"
                                            value="100"><input name="70467322821|codSellerServiceFee" class="postage-codSellerServiceFee"
                                                type="hidden" value="false"></div>
                                <div class="insure">
                                    <input class="toggleInsure" type="checkbox"><div
                                        class="rgCardBox">
                                        <span class="rgCard">运费险</span><div class="tc-feedback">
                                            <div class="tc-feedback-inner">
                                                <div class="tc-feedback-con tc-feedback-tip">
                                                    <div class="tc-feedback-content">
                                                        天猫达人凭退货保障卡专享，退货运费可赔6元</div>
                                                    <s class="tc-feedback-icon"></s>
                                                </div>
                                                <s class="tc-feedback-arrow tc-feedback-arrow-top" style="visibility: visible;">
                                                </s><s class="tc-feedback-close" style="visibility: hidden;"></s>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="tc-util tc-select " style="width: 78px;">
                                        <input type="hidden" value="postageinsure_tmall_return_goods_card|1"><div class="tc-select-content"
                                            style="width: 78px;">
                                            <div class="tc-select-label">
                                                天猫赠送</div>
                                            <span class="tc-select-arrow"><ins></ins></span>
                                        </div>
                                        <div class="tc-select-options">
                                            <div title="天猫赠送" class="tc-select-option" data-value="postageinsure_tmall_return_goods_card|1">
                                                天猫赠送</div>
                                            <div title="￥1.00购买" class="tc-select-option" data-value="1064|5">
                                                <span class="tc-rmb">¥</span>1.00购买</div>
                                        </div>
                                    </div>
                                    <input name="70467322821|newInsuancePi" class="newInsuancePi" type="hidden" value=""></div>
                                <input name="70467322821|actualPaidFee" class="actualPaid" type="hidden" value="45900">
                            </td>
                        </tr>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td class="tube-annex" colspan="3">
                                <div class="gbook">
                                    <label class="hd" for="memo70467322821">
                                        补充说明：</label><label class="guilty-info">重要提醒<div class="tc-feedback info-feed">
                                            <div class="tc-feedback-inner">
                                                <div class="tc-feedback-con tc-feedback-attention">
                                                    <div class="tc-feedback-content">
                                                        此处所填内容仅限对商家的温馨提醒，若您需改变订单内容或另有特殊需求，请您务必通过旺旺与商家确认一致。否则，该填写内容将视为无效。</div>
                                                    <s class="tc-feedback-icon"></s>
                                                </div>
                                                <s class="tc-feedback-arrow tc-feedback-arrow-top" style="visibility: visible;">
                                                </s><s class="tc-feedback-close" style="visibility: hidden;"></s>
                                            </div>
                                        </div>
                                        </label>
                                    <div class="tc-util tc-inputmask">
                                        <textarea name="70467322821|memo" class="tc-text tc-util tc-counter" id="memo70467322821"
                                            data-maxlength="200"></textarea><span class="tc-counter-tip">还可以输入<span>200<span>字</span></span></span><label
                                                for="memo70467322821">选填，可告诉卖家您的特殊要求</label></div>
                                </div>
                            </td>
                            <td class="tube-bill" colspan="3">
                                <div class="bundle-promo" id="shoppromo582937438" data-bundle="582937438">
                                    店铺优惠：<div class="tc-util tc-select bundle-promo-select" style="width: 127px;">
                                        <input name="bundleList_582937438" type="hidden" value="Tmall$tspAll-31372025"><div
                                            class="tc-select-content" style="width: 127px;">
                                            <div class="tc-select-label">
                                                省40元:满199包邮</div>
                                            <span class="tc-select-arrow"><ins></ins></span>
                                        </div>
                                        <div class="tc-select-options">
                                            <div title="-" class="tc-select-option" data-value="0">
                                                -</div>
                                            <div title="省40元:满199包邮" class="tc-select-option tc-select-active" data-value="Tmall$tspAll-31372025">
                                                省40元:满199包邮</div>
                                        </div>
                                    </div>
                                    <span class="promo-desc">
                                        <div class="tc-feedback">
                                            <div class="tc-feedback-inner">
                                                <div class="tc-feedback-con tc-feedback-tip">
                                                    <div class="tc-feedback-content">
                                                        <ul>
                                                            <li>满199包邮:省40.00元,包邮</li></ul>
                                                    </div>
                                                    <s class="tc-feedback-icon"></s>
                                                </div>
                                                <s class="tc-feedback-arrow tc-feedback-arrow-top" style="visibility: visible;">
                                                </s><s class="tc-feedback-close" style="visibility: hidden;"></s>
                                            </div>
                                        </div>
                                    </span><span class="promo-discount">-<span class="tc-rmb">¥</span><strong>40.00</strong></span></div>
                                <div class="sum">
                                    店铺合计<span class="isIncPostage">(含运费)</span>: <span class="tc-rmb">¥</span><strong
                                        id="J_BundleSum582937438">459.00</strong></div>
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
        <div class="checkbar paytype-Fenqi-disabled" id="J_checkbar" style="display: block;">
            <div class="main">
                <div class="opt opt-Coupon" id="R_coupon">
                    <input class="paytype-trigger" id="R_PT_Coupon" type="checkbox" value="on" data-type="Coupon"
                        data-evt="buy-order/biz/paytype:select" data-mm="tmalljy.2.6?action=dq_check">
                    <label class="paytype-name" for="R_PT_Coupon">
                        使用天猫点券</label>
                </div>
                <div class="points points-off" id="R_points">
                    <div class="hd">
                        <input class="togglePoint" id="J_UsePoints" type="checkbox" data-evt="buy-order/biz/point:toggle"
                            data-mm="tmalljy.2.6?action=usepoints"><label for="J_UsePoints">使用天猫积分</label><p>
                                &nbsp;</p>
                    </div>
                    <div class="bd">
                        <span class="colon">：</span><span class="txtBox"><input name="costPoint" class="tc-text costPoint"
                            type="text" autocomplete="off">点<div class="tc-feedback" style="display: none;">
                                <div class="tc-feedback-inner">
                                    <div class="tc-feedback-con tc-feedback-stop">
                                        <div class="tc-feedback-content">
                                        </div>
                                        <s class="tc-feedback-icon"></s>
                                    </div>
                                    <s class="tc-feedback-arrow tc-feedback-arrow-top" style="visibility: visible;">
                                    </s><s class="tc-feedback-close" style="visibility: hidden;"></s>
                                </div>
                            </div>
                        </span><span class="discharge">- <span class="tc-rmb">¥</span><strong id="J_Discharge">0.00</strong></span><p
                            class="totalPoint points-hidden">
                            <span>（可用<span class="usablePoints"></span>点）</span></p>
                    </div>
                </div>
                <div class="due">
                    <p class="pay-info">
                        <span class="hd">实付款：</span><span class="bd"><span class="tc-rmb">¥</span><strong
                            id="J_ActualPaid">459.00</strong></span></p>
                    <p class="points-obtain">
                        可获得天猫积分：<span class="bd"><span id="J_ObtainPoints">229</span>点</span></p>
                </div>
            </div>
            <div class="option" id="R_option">
                <div class="opt opt-anony">
                    <input name="anony" id="anonyBuy" type="checkbox" checked="" data-mm="tmalljy.2.6?action=anony"><label
                        for="anonyBuy">匿名购买</label></div>
                <div class="opt opt-Agent">
                    <input name="pay_for_another" class="paytype-trigger" id="R_PT_Agent" type="checkbox"
                        value="true" data-type="Agent" data-evt="buy-order/biz/paytype:select" data-mm="tmalljy.2.6?action=otherspay"><label
                            class="paytype-name" for="R_PT_Agent">找人代付</label></div>
                <div class="opt opt-Fenqi">
                    <input name="payType" disabled="" class="paytype-trigger" id="R_PT_Fenqi" type="checkbox"
                        value="on" data-type="Fenqi" data-evt="buy-order/biz/paytype:select" data-mm="tmalljy.2.6?action=fenqi_pay"><label
                            class="paytype-name" for="R_PT_Fenqi">分期付款</label></div>
            </div>
            <div class="action">
                <a title="返回购物车修改" class="back-cart" href="#" target="_self">返回购物车修改</a>
                <span>
                    <asp:Button ID="Button1" runat="server" Text="提交订单" class="go-btn"  /></span></div>
        </div>
        <div class="unvalid-order" id="J_unvalids">
        </div>
        <input name="tpId" id="F_tpId" type="hidden" value=""></form>
    </div>
    <div class="clear">
    </div>
    <uc2:foot ID="foot_1" runat="server" />
    </form>
</body>
</html>
