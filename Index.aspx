<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Index" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
  <title>联盟商圈</title>
<meta name="keywords" content="联盟商圈,移动联盟商圈,移动联盟卡" />
<meta name="description" content="联盟商圈是移动联盟卡平台下的一个商圈集合，在里面你找得到最新有商家优惠和最低的商家折扣" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="format-detection" content="telephone=no" />
<meta name="viewport" content="width=640px,user-scalable=0,target-densitydpi=device-dpi" />
<meta name="format-detection" content="telephone=no" />
<link href="css/common.css?v=<%=Configs.Ver %>" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
   
<div class="webpage"> 
	<div class="g-pindex">
        <div class="row">
            <div class="c-col2 col1">
                <div class="btn-wrap btn-wrap-111"><a href="PCenter.aspx" class="a2">我  的</a></div>
                <div class="btn-wrap btn-wrap-112"><a href="http://mall.9eat.com/126" class="a23">我要点餐</a></div>
            </div>
            <div class="c-col col2" onclick="window.location.href='dzq/index.aspx'">
                <div class="btn-wrap-12">
                <a href="dzq/index.aspx" class="a3">移动电子券</a>
                </div>
            </div>
            <div class="c-col col3" onclick="window.location.href='productlist.aspx?producttype=0'">
                <div class="btn-wrap-13">
                <a href="productlist.aspx?producttype=0" class="a3">优惠券</a>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="c-col col21" onclick="window.location.href='Score.aspx'">
                <div class="btn-wrap-21">
                <a href="Score.aspx" class="a3">积分换礼</a>
                </div>
            	
            </div>
            <div class="c-col col22">
                <div class="btn-wrap-22">
                <a href="#" class="a3">移动市民卡副卡</a>
                </div>
            </div>
            <div class="c-col2 col23" >
				<div class="btn-wrap btn-wrap-231"><a href="shopindex.aspx" class="a23">和超市</a></div>
                <div class="btn-wrap btn-wrap-232"><a href="dzcdList.aspx" class="a23">电子传单</a></div>
            </div>
        </div>
        <div class="row2">
        <div class="col1"><img src="images/g-index-help.jpg" /></div>
        <div class="col2"><img src="images/g-index-app.jpg" onclick="window.location.href='DownLoad.aspx'"/></div>
         </div>
    </div>
</div>
    </form>
</body>
</html>
