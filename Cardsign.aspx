<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cardsign.aspx.cs" Inherits="Card_sign" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="" charset="UTF-8" />
    <title>刷卡签到</title>
    <link rel="stylesheet" type="text/css" href="Css/CardSign.css" />
    <script type="text/javascript" src="js/jquery-1.4.1.js"></script>
    <script src="Js/jquery-1.9.1.js" type="text/javascript"></script>
    <script type="text/javascript">
           function ReadCardForQuery(ctrl) {
               // Read_CardInfo
               var CardCtl = document.getElementById("CardCtl");
               var cardinfo = "-1";
               if (CardCtl != null) {

                   try {

                       CardCtl.Read_CardInfo();
                       cardinfo = CardCtl.ReadInfo;

                       if (CardCtl.status != 0) {
                           alert("读卡失败,请检查卡片是否正确插入！")
                           return "-1";
                       }
                   }
                   catch (err) {
                       alert("读卡信息失败" + err.description);
                       cardinfo = "-1";
                       return "-1";
                   }

               }
               var info_list = cardinfo.split("|");

               if (info_list.length > 0) {
                   document.getElementById(ctrl).value = info_list[0];
               }

           }
           function Sign() {
               $("#action").val("sign");
               $("#form1").submit();
           }
    </script>

    
    <script language="JavaScript1.2">
        function M1Reset_onclick() {
            var str = SynCardOcx1.M1Reset();
            document.getElementById('card_no').value = "05770" + str ;
            SynCardOcx1.SendBeep(1000);
           
            $("#action").val("readcard"); 
            $("#form1").submit();
        }
    </script>
</head>
<body>

<p>
<object classid="clsid:46E4B248-8A41-45C5-B896-738ED44C1587" id="SynCardOcx1" codeBase="SynCardOcx.CAB#version=1,0,0,1" width="0" height="0" >
</object>
</p>
    <form method="post" action="" id="form1" runat="server">
    <input type="hidden" name="action" id="action" />
    <input type="hidden" name="m001_key" value="<%=m001_key %>" >
    <%--<object id="CardCtl" align="top" width="0" height="0" codebase="/CardActiveX_WZ.CAB#version=1,0,0,4"
        classid="CLSID:83766BBD-2217-4432-895A-4AA12545CDDF">
    </object>--%>
    <div>
        <div id="top">
            <%--<div class="top_kh">
                <a style="margin-right: 20px;">会员卡号：</a>
                <input type="text" id="card_no" name="card_no" value="<%=ucid %>"/>
            </div>--%>
            <div class="top_kh">
                <a style="margin-right:20px;">会员卡号：</a> 
                <input type="text" id="card_no" name="card_no"  value="<%=ucid %>"/>
                <input id="b_color" type="button" onclick="javascript:M1Reset_onclick()"
                    value="读 卡 " />
            </div>
          

            <div class="top_aj">
            
                    <input id="autograph" type="button" onclick="javascript:Sign()" value="签 到 " /></div>
        </div>
        <div id="center">
            <fieldset>
                <legend class="title-info">会员信息</legend>
                <div class="center_xx">
                    <a style="margin-right: 20px;">会员姓名：</a>
                    <input type="text" id="vip_name" name="vip_name" value="<%=vip_name %>" />
                </div>
                <div class="center_xx">
                    <a style="margin-right: 36px;">手机号：</a>
                    <input type="text" id="mobile_no" name="mobile_no" value="<%=mobile_no %>" />
                </div>
            </fieldset>
        </div>
    </div>
    </form>
</body>
</html>
