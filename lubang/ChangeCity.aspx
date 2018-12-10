<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangeCity.aspx.cs" Inherits="ChangeCity" %>

<%@ Register Src="main_form/head.ascx" TagName="head" TagPrefix="uc1" %>
<%@ Register Src="main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>非凡网-城市更改</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10" />
    <meta name="description" content="非凡网">
    <meta name="keywords " content="非凡网">
    <meta name="robots" content="all">
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/ChangeCity.css" rel="Stylesheet" />
    <script type="text/javascript" src="<%=http_url %>/lubang/js/showp.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <uc1:head ID="head_" runat="server" />
    <div class="w_960">
        <div class="city_title">
            <div class="main_city">
                进入<span>温州</span></div>
            <ul>
                <li><b>热门城市：</b></li>
                <li><a>北京</a></li>
                <li><a>上海</a></li>
                <li><a>广州</a></li>
                <li><a>杭州</a></li>
                <li><a>深圳</a></li>
                <li><a>三亚</a></li>
                <li><a>青岛</a></li>
                <li><a>丽江</a></li>
                <li><a>重庆</a></li>
                <li><a>成都</a></li>
                <li><a>天津</a></li>
                <li><a>武汉</a></li>
                <li><a>长沙</a></li>
                <li><a>西安</a></li>
                <li><a>南京</a></li>
            </ul>
        </div>
        <div class="letter">
            <div class="select">
                <b>按省份选择：</b>
                <select>
                    <option>江苏</option>
                    <option selected="selected">浙江</option>
                </select>
                <select>
                    <option selected="selected">温州</option>
                    <option>台州</option>
                </select>
                <input type="button" value="确定" class="sure_button" />
            </div>
            <div class="select_list">
                <div class="list_type">按拼音首字母选择</div>
                <div class="list_name">
                    <ul>
                        <li><span class="name">A</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">B</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">C</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">D</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">E</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">F</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">G</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">H</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">J</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">K</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">L</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">M</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">N</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">P</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">Q</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">R</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">S</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">T</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">W</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">X</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">Y</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">Z</span></li>
                        <li><a>安阳</a></li>
                        <li><a>安庆</a></li>
                        <li><a>鞍山</a></li>
                        <li><a>安康</a></li>
                        <li><a>阿坝</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <div class="clear">
    </div>
    <uc2:foot ID="foot_" runat="server" />
    </form>
</body>
</html>
