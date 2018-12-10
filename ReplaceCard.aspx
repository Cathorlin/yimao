<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReplaceCard.aspx.cs" Inherits="Buhuanka" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>补/换卡</title>
    <script src="Js/jquery-1.9.1.js" type="text/javascript"></script>
    <script src="Js/JScript.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="Css/ReplaceCard.css" />
    <script type="text/javascript">
        function submit() {
            var old_card = $("#old_card").val();
            var new_card = $("#new_card").val();
            if (new_card == '') {
                alert('新卡卡号不能为空！'); return;
            } if (old_card == new_card) {
                alert('新卡卡号和原卡号相同！'); return;
            }
            $("#form1").submit();
        }
        function close() {
            alert("Closed!");
            //window.top.opener = null;
            window.close();
        }
        function ReadCardForQuery(ctrl) {
            // Read_CardInfo
            var CardCtl = document.getElementById("CardCtl");
            var cardinfo = "-1";
            //alert(CardCtl);
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
    </script>

    <script language="JavaScript1.2">
        function M1Reset_onclick() {
            var str = SynCardOcx1.M1Reset();
            document.getElementById('new_card').value = "05770" + str ;
            SynCardOcx1.SendBeep(1000);
        }
    </script>
</head>
<body>
<p>
<object classid="clsid:46E4B248-8A41-45C5-B896-738ED44C1587" id="SynCardOcx1" codeBase="SynCardOcx.CAB#version=1,0,0,1" width="0" height="0" >
</object>
</p>
    <form method="post" action="ReplaceCard.aspx" id="form1" runat="server" >
<%--    上半部分--%>

 <%--<OBJECT id="CardCtl" align="top" WIDTH=0 HEIGHT=0 codeBase="/CardActiveX_WZ.CAB#version=1,0,0,4" classid="CLSID:83766BBD-2217-4432-895A-4AA12545CDDF" ></OBJECT>  --%>
    <div id="top1" style="width:100%;height:45px;background:url(images/bg/ReplaceCard_top1.png)">
        <div class="top_wz">
            <a>补/换卡</a>
        </div>
    </div>

   <%-- 中间内容--%>
    <div id="center1">
    <div class="center_zj">
    <%if (dt_m00101.Rows.Count != 0)
      {
          string m001_name = dt_m00101.Rows[0]["M001_NAME"].ToString();
          string old_card = dt_m00101.Rows[0]["UCID"].ToString();
          %>
        <div class="center_xx"><a style="margin-right:40px;">会员名字：</a>
        <input type="text" id="name" name="name" value="<%=m001_name %>"/></div>

        <div class="center_xx"><a style="margin-right:57px;">原卡号：</a>
        <input type="text" id="old_card" name="old_card" value="<%=old_card %>"/></div>

        <div class="center_xx"><a style="margin-right:22px;">新会员卡号：</a>
        <input type="text" id="new_card" name="new_card"/>

        <input id="center_dk" type="button" value="读  卡" onclick="javascript:M1Reset_onclick()"/></div>
        <div class="center_xx"><a style="margin-right:75px;">备注：</a>
        <input type="text" id="description" name="description"/><div>
    <%} %>
    </div>
    </div>
    </div>
    </div>

<%--    下半按钮部分--%>
<div id="down1">
<div class="down_zj">
 <input id="confirm" type="button" onclick="javascript:submit()" value="确  认" />
 <%--<input id="cancel" type="button" onclick="javascript:close()" value="取  消" />--%>
 <input type="hidden" id="m00101_key" value="<%=Objid %>" name="m00101_key"/>
 <input type="hidden" id="user_id" value="<%=User_Id %>" name="user_id"/>
</div>
</div>


    </form>
</body>
</html>
