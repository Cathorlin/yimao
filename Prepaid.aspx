<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Prepaid.aspx.cs" Inherits="Prepaid" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta content="" charset="utf-8" />
    <title>--充值--</title>

    <link href="Css/prepaid.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="js/jquery-1.4.1.js"></script>
    <script src="Js/jquery-1.9.1.js" type="text/javascript"></script>
    <script type="text/javascript">

        function Query() {
            var vip_id = $("#vip_id").val();           
            if (vip_id=="") {
                alert("会员账号不能为空！");
                return;
            }
            $("#action").val("query");
            $("#form1").submit();
        }

        function prepaid() {
            var card_count = $("#card_count").val();
            if (card_count == "") {
                alert("卡券数量不能为空！");
                return;
            } 
            if(isNaN(card_count)){
                alert("输入数量必须为数字！");
                return;
            }
            if(card_count<=0)
            {
                alert("充值数量必须大于0！");
                return;
            }
            $("#action").val("chongzhi");     
            $("#form1").submit();
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
    <input type="hidden" name="USER_ID" value="<%=user_id %>" >
    <input type="hidden" name="m001_key" id="txt_m001_key" runat="server" />
     <%--<OBJECT id="CardCtl" align="top" WIDTH=0 HEIGHT=0 codeBase="/CardActiveX_WZ.CAB#version=1,0,0,4" classid="CLSID:83766BBD-2217-4432-895A-4AA12545CDDF" ></OBJECT>  --%>
    <div id="all">
        <div id="head">
            <table id="tab1">
                <tr>
                    <td>
                        会员账号：
                    </td>
                    <td>
                        <input type="text" id="txt_vip_id" name="vip_id" runat="server" size="30" placeholder="手机或卡号"/>
                    </td>
                    <td class="btn_select">
                        <button type="button" class="btn-query" onclick="javascript:Query()">
                            查询</button>
                    </td>
                    <td class="btn_select">
                        <button type="button" class="btn-readcard" onclick="javascript:M1Reset_onclick()">
                            读卡</button>
                    </td>
                </tr>
                <tr>
                    <td>
                        会员信息：
                    </td>
                    <td>
                        <input type="text" name="vip_info" runat="server" size="30" id="vip_info" placeholder="会员名称"/>
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <hr />
        <div id="foot">
            <fieldset>
                <legend class="title-info">会员信息</legend>
                <table id="tab2">
                    <tr>
                        <td class="left_font">
                            券名：
                        </td>
                        <td>
                            <select name="card_name" id="card_name">
                              <%foreach (System.Data.DataRow row in dt_m00203.Rows)
                                      {
                                          var m00203_name = string.Format("{0}", row["M00203_NAME"]);
                                          var m00203_key = string.Format("{0}", row["m00203_key"]);
                                     %>
                                <option value="<%=m00203_key %>"><%=m00203_name %></option>
                                       <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr >
                        <td class="left_font">
                            数量：
                        </td>
                        <td>
                            <input type="text" name="card_count" runat="server" value="" size="30" id="card_count" />
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
        <br />
        <div id="prepaid">
            <button type="button" class="btn-prepaid" onclick="javascript:prepaid()">
                充值</button>
            
        </div>
    </div>
    </form>
</body>
</html>
