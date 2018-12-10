<%@ Page Language="C#" AutoEventWireup="true" CodeFile="help.aspx.cs" Inherits="help" %>
<%@ Register Src="../main_form/head.ascx" TagName="head" TagPrefix="uc1" %>
<%@ Register Src="../main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>用户帮助</title>
    <link type="text/css" href="../../CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="../../CSSLUBANG/help.css" rel="Stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
    <uc1:head ID="head_" runat="server" />
    <div class="w_960">
        <div class="center_left">
            <div class="list_order">
                <h1>用户帮助</h1>
                <ul>
                    <li><div class="current"></div><a>服务承诺</a></li>
                    <li><div class="outer"></div><a>投诉建议</a></li>
                    <li><div class="outer"></div><a>增值服务</a></li>
                </ul>
                <h1>商务合作</h1>
                <ul>
                    <li><div class="outer"></div><a>提供合作信息</a></li>
                    <li><div class="outer"></div><a>开放API</a></li>
                </ul>
                <h1>公司信息</h1>
                <ul>
                    <li><div class="outer"></div><a>关于路邦</a></li>
                    <li><div class="outer"></div><a>加入我们</a></li>
                    <li><div class="outer"></div><a>媒体报道</a></li>
                    <li><div class="outer"></div><a>营业执照</a></li>
                </ul>
                <h1>更新</h1>
                <ul>
                    <li><div class="outer"></div><a>邮件订阅</a></li>
                </ul>
            </div>
        </div>
        <div class="center_right">
            <div class="right_title">
                <h1>服务承诺</h1>
                <div class="title_line"></div>
            </div>
            <div class="right_img">
                <div><img alt="" src="../images/first.jpg" /></div>
                <div><img alt="" src="../images/second.jpg" /></div>
                <div><img alt="" src="../images/third.jpg" /></div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    <div class="product_list4">
        <div class="zxyh">
            <div class="title01">
                <ul>
                    <li class="current_t">最新优惠</li>
                    <li>热门优惠</li>
                    <li>精品推荐</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    <div class="product_list5">
        <div class="listmain">
            <div class="list_div">
                <div class="list01">
                    <img alt="" src="../images/pic/Jellyfish.jpg" /></div>
                <div class="listdes">
                    路邦网 汽车生活</div>
            </div>
        </div>
        <div class="listmain">
            <div class="list_div">
                <div class="list01">
                    <img alt="" src="../images/pic/Jellyfish.jpg" /></div>
                <div class="listdes">
                    路邦网 汽车生活</div>
            </div>
        </div>
        <div class="listmain">
            <div class="list_div">
                <div class="list01">
                    <img alt="" src="../images/pic/Jellyfish.jpg" /></div>
                <div class="listdes">
                    路邦网 汽车生活</div>
            </div>
        </div>
        <div class="listmain">
            <div class="list_div">
                <div class="list01">
                    <img alt="" src="../images/pic/Jellyfish.jpg" /></div>
                <div class="listdes">
                    路邦网 汽车生活</div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    <uc2:foot ID="foot_" runat="server" />
    </form>
</body>
</html>
