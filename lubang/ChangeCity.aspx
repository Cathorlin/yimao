<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangeCity.aspx.cs" Inherits="ChangeCity" %>

<%@ Register Src="main_form/head.ascx" TagName="head" TagPrefix="uc1" %>
<%@ Register Src="main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>�Ƿ���-���и���</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10" />
    <meta name="description" content="�Ƿ���">
    <meta name="keywords " content="�Ƿ���">
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
                ����<span>����</span></div>
            <ul>
                <li><b>���ų��У�</b></li>
                <li><a>����</a></li>
                <li><a>�Ϻ�</a></li>
                <li><a>����</a></li>
                <li><a>����</a></li>
                <li><a>����</a></li>
                <li><a>����</a></li>
                <li><a>�ൺ</a></li>
                <li><a>����</a></li>
                <li><a>����</a></li>
                <li><a>�ɶ�</a></li>
                <li><a>���</a></li>
                <li><a>�人</a></li>
                <li><a>��ɳ</a></li>
                <li><a>����</a></li>
                <li><a>�Ͼ�</a></li>
            </ul>
        </div>
        <div class="letter">
            <div class="select">
                <b>��ʡ��ѡ��</b>
                <select>
                    <option>����</option>
                    <option selected="selected">�㽭</option>
                </select>
                <select>
                    <option selected="selected">����</option>
                    <option>̨��</option>
                </select>
                <input type="button" value="ȷ��" class="sure_button" />
            </div>
            <div class="select_list">
                <div class="list_type">��ƴ������ĸѡ��</div>
                <div class="list_name">
                    <ul>
                        <li><span class="name">A</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">B</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">C</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">D</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">E</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">F</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">G</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">H</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">J</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">K</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">L</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">M</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">N</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">P</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">Q</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">R</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">S</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">T</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">W</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">X</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">Y</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                    </ul>
                    <ul>
                        <li><span class="name">Z</span></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
                        <li><a>��ɽ</a></li>
                        <li><a>����</a></li>
                        <li><a>����</a></li>
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
