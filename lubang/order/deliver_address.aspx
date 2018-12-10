<%@ Page Language="C#" AutoEventWireup="true" CodeFile="deliver_address.aspx.cs"
    Inherits="lubang_order_deliver_address" %>

<%@ Register Src="../main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>管理收货地址-路邦网</title>
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/deliver.css" rel="Stylesheet" />
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/deliver_address.css" rel="Stylesheet" />
    <link href="<%=http_url %>/Order/Order.css" rel="Stylesheet" type="text/css" />
    <script src="<%=http_url %>/Order/jquery-1[1].2.6.js" type="text/javascript"></script>
    <script src="<%=http_url %>/Order/jquery.provincesCity.js" type="text/javascript"></script>
    <script src="<%=http_url %>/Order/provincesdata.js" type="text/javascript"></script>
    <script type="text/javascript">
        //调用插件
        $(function () {
            $("#city").ProvinceCity();
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div class="top_main">
        <div class="top_bar">
            <div class="join_sc">
                <a onclick="shoucang(document.title,window.location)">加入收藏</a></div>
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
                    </ul>
                </div>
            </li>
            <li class="phone"><a class="phone_bg">电话</a></li>
        </ul>
    </div>
    <div class="clear">
    </div>
    <div class="page" id="J_Page">
        <div class="form-box" id="J_FormBox">
            <div class="global-msg msg-b hide" id="J_MsgGlobal">
                <i></i>
                <div class="msg-tit msg-vm">
                </div>
                <div class="msg-cnt">
                </div>
            </div>
            <div class="item item-title">
                <span class="item-label" id="J_DeliverTitle">新增收货地址 </span>电话号码、手机号选填一项,其余均为必填项
            </div>
            <form id="J_FormDeliver" action="" method="post">
            <div class="item item-devision" id="J_ItemDivision">
                <span class="item-label">所在地区：<i>*</i></span>
                <div id="city"></div>
                <%--<select name="prov" id="J_Province" data-key="province" data-available="true">
                    <option value="">请选择省市/其他...</option>
                    <option value="110000">北京</option>
                    <option value="120000">天津</option>
                    <option value="130000">河北省</option>
                    <option value="140000">山西省</option>
                    <option value="150000">内蒙古自治区</option>
                    <option value="210000">辽宁省</option>
                    <option value="220000">吉林省</option>
                    <option value="230000">黑龙江省</option>
                    <option value="310000">上海</option>
                    <option value="320000">江苏省</option>
                    <option value="330000">浙江省</option>
                    <option value="340000">安徽省</option>
                    <option value="350000">福建省</option>
                    <option value="360000">江西省</option>
                    <option value="370000">山东省</option>
                    <option value="410000">河南省</option>
                    <option value="420000">湖北省</option>
                    <option value="430000">湖南省</option>
                    <option value="440000">广东省</option>
                    <option value="450000">广西壮族自治区</option>
                    <option value="460000">海南省</option>
                    <option value="500000">重庆</option>
                    <option value="510000">四川省</option>
                    <option value="520000">贵州省</option>
                    <option value="530000">云南省</option>
                    <option value="540000">西藏自治区</option>
                    <option value="610000">陕西省</option>
                    <option value="620000">甘肃省</option>
                    <option value="630000">青海省</option>
                    <option value="640000">宁夏回族自治区</option>
                    <option value="650000">新疆维吾尔自治区</option>
                    <option value="710000">台湾省</option>
                    <option value="810000">香港特别行政区</option>
                    <option value="820000">澳门特别行政区</option>
                    <option value="990000">海外</option>
                </select>
                <select name="country" id="J_Country" style="display: none;" data-key="country" data-available="">
                </select>
                <select name="provExt" id="J_ProvinceExt" style="display: none;" data-key="provinceExt"
                    data-available="">
                </select>
                <select name="city" id="J_City" data-key="city" data-available="true">
                    <option value="">请选择城市...</option>
                </select>
                <select name="area" id="J_Area" data-key="area" data-available="true">
                    <option value="">请选择区/县...</option>
                </select>
                <select name="town" id="J_Town" data-key="town" data-available="true">
                    <option value="">请选择...</option>
                </select>
                <div class="tip-town" id="J_TipTown">
                    <i></i>建议选择街道/乡镇信息,让配送服务更精准！
                </div>
                <div class="msg-box">
                    <div class="msg msg-error hide" id="J_MsgDivision">
                        <i></i>
                        <div class="msg-cnt">
                        </div>
                    </div>
                </div>--%>
            </div>
            <div class="item item-postcode" id="J_ItemPostCode">
                <span class="item-label">邮政编码：<i>*</i></span>
                <input name="post" class="i-text" id="J_PostCode" type="text" value="" data-msg="请输入邮编"
                    data-pattern="^[\da-zA-Z]{3,10}$" data-item="postcode">
                <div class="msg hide" id="J_MsgPostCode">
                    <i></i>
                    <div class="msg-cnt">
                        邮编不存在</div>
                </div>
            </div>
            <div class="item item-street" id="J_ItemStreet">
                <span class="item-label">街道地址：<i>*</i></span>
                <div class="ks-combobox" id="J_ComboboxStreet">
                    <div class="ks-combobox-input-wrap">
                        <textarea name="addressDetail" class="ks-combobox-input i-ta" id="J_Street" role="combobox"
                            placeholder="不需要重复填写省市区，必须大于5个字符，小于120个字符" data-msg="5-120个字符，一个汉字为两个字符" data-pattern="^.{5,120}$"
                            data-ph="不需要重复填写省市区，必须大于5个字符，小于120个字符" autocomplete="off" aria-combobox="list">不需要重复填写省市区，必须大于5个字符，小于120个字符</textarea>
                    </div>
                </div>
                <div class="msg-box">
                    <div class="msg msg-error hide" id="J_MsgStreet">
                        <i></i>
                        <div class="msg-cnt">
                        </div>
                    </div>
                </div>
            </div>
            <div class="item item-name" id="J_ItemName">
                <span class="item-label">收货人姓名：<i>*</i></span>
                <input name="fullName" class="i-text" id="J_Name" type="text" placeholder="长度不超过25个字"
                    value="" data-msg="2-25个字符，一个汉字为两个字符" data-pattern="^.{2,25}$" data-ph="长度不超过25个字">
                <div class="msg hide" id="J_MsgName">
                    <i></i>
                    <div class="msg-cnt">
                    </div>
                </div>
            </div>
            <div class="item item-mobile" id="J_ItemMobile">
                <span class="item-label">手机号码：</span>
                <input name="mobile" class="i-text" id="J_Mobile" type="text" placeholder="电话号码、手机号码必须填一项"
                    value="" data-msg="6-20个数字" data-pattern="^\d{6,20}$" data-ph="电话号码、手机号码必须填一项6-20个数字">
                <div class="msg hide" id="J_MsgMobile">
                    <i></i>
                    <div class="msg-cnt">
                    </div>
                </div>
            </div>
            <div class="item item-phone" id="J_ItemPhone">
                <span class="item-label">电话号码：</span>
                <input name="phoneSection" class="i-text i-text-short" id="J_PhoneSection" type="text"
                    placeholder="区号" value="" data-ph="区号">
                -
                <input name="phoneCode" class="i-text i-text-short" id="J_PhoneCode" type="text"
                    placeholder="电话号码" value="" data-ph="电话号码">
                -
                <input name="phoneExt" class="i-text i-text-short" id="J_PhoneExt" type="text" placeholder="分机"
                    value="" data-ph="分机">
                <input id="J_Phone" type="hidden" value="" data-msg="格式错误" data-pattern="^\d+-\d+(?:-\d+)?$">
                <div class="msg hide" id="J_MsgPhone">
                    <i></i>
                    <div class="msg-cnt">
                    </div>
                </div>
            </div>
            <div class="item item-set-default" id="j_ItemSetDefault">
                <span class="item-label">设为默认地址：</span>
                <input name="defaultAddress" class="i-chk" id="J_SetDefault" type="checkbox"><label
                    for="J_SetDefault">设置为默认收货地址</label>
            </div>
            </form>
        </div>
        <div style="padding-left: 135px;">
            <div class="skin-gray" id="createD">
                <button class="short-btn" onclick="createOrUpdate()" type="button">
                    保存</button>
            </div>
        </div>
        <div class="tbl-deliver-address">
            <table class="tbl-main" border="0" cellspacing="0" cellpadding="0">
                <caption>
                    已保存的有效地址</caption>
                <colgroup>
                    <col class="col-man">
                    <col class="col-area">
                    <col class="col-address">
                    <col class="col-postcode">
                    <col class="col-phone">
                    <col class="col-actions">
                </colgroup>
                <tbody>
                    <tr class="thead-tbl-grade">
                        <th>
                            收货人
                        </th>
                        <th>
                            所在地区
                        </th>
                        <th>
                            街道地址
                        </th>
                        <th>
                            邮编
                        </th>
                        <th>
                            电话/手机
                        </th>
                        <th>
                        </th>
                        <th>
                            操作
                        </th>
                    </tr>
                    <tr class="thead-tbl-address" id="414968958" bgcolor="white">
                        <td class="cell-align-center">
                            龚文明
                        </td>
                        <td>
                            上海 上海市 徐汇区
                        </td>
                        <td>
                            凯旋路3500号华苑大厦1号楼9A
                        </td>
                        <td class="cell-align-center">
                            200030
                        </td>
                        <!--处理单个电话号码，上下居中的问题：add by yundian-->
                        <!--这里的座机和手机可能为null或“”或有值-->
                        <td>
                            13918332931
                        </td>
                        <td class="thead-tbl-status" style="color: blue;">
                        </td>
                        <td class="cell-align-center">
                            <a onclick="selectDeliver(414968958)" href="#">修改</a> | <a onclick="del(414968958)"
                                href="#">删除</a>
                        </td>
                    </tr>
                    <tr class="thead-tbl-address" id="1070843270" bgcolor="#c6d9f0">
                        <td class="cell-align-center">
                            龚文明
                        </td>
                        <td>
                            上海 上海市 松江区
                        </td>
                        <td>
                            城鸿路222弄17号楼604室
                        </td>
                        <td class="cell-align-center">
                            201600
                        </td>
                        <!--处理单个电话号码，上下居中的问题：add by yundian-->
                        <!--这里的座机和手机可能为null或“”或有值-->
                        <td>
                            15072322593
                        </td>
                        <td class="thead-tbl-status" style="color: blue;">
                            默认地址
                        </td>
                        <td class="cell-align-center">
                            <a onclick="selectDeliver(1070843270)" href="#">修改</a> | <a onclick="del(1070843270)"
                                href="#">删除</a>
                        </td>
                    </tr>
                    <tr class="thead-tbl-address" id="1443894011" bgcolor="white">
                        <td class="cell-align-center">
                            高月英
                        </td>
                        <td>
                            上海 上海市 闵行区
                        </td>
                        <td>
                            虹莘路1518弄28支弄30号301室
                        </td>
                        <td class="cell-align-center">
                            201100
                        </td>
                        <!--处理单个电话号码，上下居中的问题：add by yundian-->
                        <!--这里的座机和手机可能为null或“”或有值-->
                        <td>
                            18917342109
                        </td>
                        <td class="thead-tbl-status" style="color: blue;">
                        </td>
                        <td class="cell-align-center">
                            <a onclick="selectDeliver(1443894011)" href="#">修改</a> | <a onclick="del(1443894011)"
                                href="#">删除</a>
                        </td>
                    </tr>
                    <tr class="thead-tbl-address" id="1049983541" bgcolor="white">
                        <td class="cell-align-center">
                            龚文明
                        </td>
                        <td>
                            上海 上海市 松江区
                        </td>
                        <td>
                            上海市松江区沈砖公路5500号保隆科技有限公司
                        </td>
                        <td class="cell-align-center">
                            201600
                        </td>
                        <!--处理单个电话号码，上下居中的问题：add by yundian-->
                        <!--这里的座机和手机可能为null或“”或有值-->
                        <td>
                            13918332931
                        </td>
                        <td class="thead-tbl-status" style="color: blue;">
                        </td>
                        <td class="cell-align-center">
                            <a onclick="selectDeliver(1049983541)" href="#">修改</a> | <a onclick="del(1049983541)"
                                href="#">删除</a>
                        </td>
                    </tr>
                    <tr class="thead-tbl-address" id="757578050">
                        <td class="cell-align-center">
                            龚文明
                        </td>
                        <td>
                            浙江省 温州市 鹿城区
                        </td>
                        <td>
                            人民东路18号移动大楼4楼
                        </td>
                        <td class="cell-align-center">
                            325000
                        </td>
                        <!--处理单个电话号码，上下居中的问题：add by yundian-->
                        <!--这里的座机和手机可能为null或“”或有值-->
                        <td>
                            15990756451
                        </td>
                        <td class="thead-tbl-status" style="color: blue;">
                        </td>
                        <td class="cell-align-center">
                            <a onclick="selectDeliver(757578050)" href="#">修改</a> | <a onclick="del(757578050)"
                                href="#">删除</a>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p class="tbl-attach">
                最多保存20个有效地址</p>
        </div>
    </div>
    <uc2:foot ID="foot_1" runat="server" />
    </form>
</body>
</html>
