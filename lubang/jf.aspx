<%@ Page Language="C#" AutoEventWireup="true" CodeFile="jf.aspx.cs" Inherits="jf" %>
<%@ Register Src="main_form/head.ascx" TagName="head" TagPrefix="uc1" %>
<%@ Register Src="main_form/foot.ascx" TagName="foot" TagPrefix="uc2" %>
<%@ Register Src="main_form/rementuijian.ascx" TagName="rementuijian" TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>�Ƿ���-���ֶһ�</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
    <meta http-equiv="X-UA-Compatible" content="IE=8, IE=9, IE=10" />
    <meta name="description" content="�Ƿ���">
    <meta name="keywords " content="�Ƿ���">
    <meta name="robots" content="all">
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/index.css" rel="Stylesheet" />
    <link type="text/css" href="<%=http_url %>/CSSLUBANG/jf.css" rel="Stylesheet" />
    <script type="text/javascript" src="<%=http_url %>/lubang/js/jquery.js"></script>
    <script type="text/javascript" src="<%=http_url %>/lubang/js/showp.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <uc1:head ID="head_" runat="server" />
    <div class="w_960">
        <div class="title_order"><a href="../Lbindex.aspx" class="color">��ҳ</a><span> > </span>���ֶһ�</div>
        <div class="list_main">
            <div class="list_title"><span>�����ϼ�</span><a>���ࡷ</a></div>
        </div>
        <div class="list_main">
            <div class="list_title"><span>�����Ƽ�</span><a>���ࡷ</a></div>
        </div>
        <div class="order_main">
            <ul>
                <li class="current"><span>����</span></li>
                <li><span>�Ż�ȯ</span></li>
                <li><span>��������</span></li>
                <li><span>��Ʒ��</span></li>
            </ul>
        </div>
        <div class="order_list">
            <div class="page_num">
                <ul>
                    <li class="current">1</li>
                    <li>2</li>
                    <li>3</li>
                    <li>4</li>
                    <li class="next"><img alt="" src="images/next.png" /></li>
                </ul>
                <div class="tiaozhuan">
                    ��ת����<input type="text" value="1" class="input_num" />
                    <input type="button" value="GO" class="next_go" />
                </div>
            </div>
        </div>
    </div>
    <div class="clear"></div>
    <uc3:rementuijian ID="rementuijian_" runat="server" />
    <div class="clear"></div>
    <uc2:foot ID="foot_" runat="server" />
    </form>
</body>
</html>
