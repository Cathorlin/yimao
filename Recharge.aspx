<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Recharge.aspx.cs" Inherits="Recharge" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
     <meta content="" charset="UTF-8" />
    <title>充值</title>
    <link href="Css/Pay.css" rel="stylesheet" type="text/css" />
    
    <script type="text/javascript" src="js/jquery-1.4.1.js"></script>
    <script src="Js/jquery-1.9.1.js" type="text/javascript"></script>
   
    <script type="text/javascript">
        function recharge() {
            var recharge_money = $("#recharge-money").val();
            if (isNaN(recharge_money)) {
                alert("输入充值金额必须为数字！");l
                return;
            }
            if (recharge_money <= 0) {
                alert("充值金额必须大于0！");
                return;
            }
//            var balance = $("#balance").val();
            $("#action").val("recharge");
            $("#form1").submit();
           

        }
        function myFunction() {
            var recharge_money = $("#recharge-money").val();
            document.getElementById("show_money").innerHTML = recharge_money + "元整";
        }

        function ReadCard() {
            $("#action").val("readCard");
            $("#form1").submit();
        }

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
//            var card_no = $("#card_no").val();
            $("#action").val("readcard");
            $("#form1").submit();
//            var ajax = "1";
//            var url = "Recharge.aspx?ajax=" + ajax + "&card_no=" + card_no;
//            window.location.href = url;
           
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
    <OBJECT id="CardCtl" align="top" WIDTH=0 HEIGHT=0 codeBase="/CardActiveX_WZ.CAB#version=1,0,0,4" classid="CLSID:83766BBD-2217-4432-895A-4AA12545CDDF" ></OBJECT>  
    <div id="all">
        <div id="money">
            <table id="tab1">
                <tr>
                    <td>
                        充值金额：
                    </td>
                    <td>
                        <input type="text" id="recharge-money" name="recharge_money" placeholder="00.00"
                            size="30" class="checkbox-money" onblur="myFunction()" />
                    </td>
                    <td>
                        <span class="show-money" id="show_money"></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        赠送金额：
                    </td>
                    <td>
                        <input type="text" name="give-money" value="" placeholder="0.00" size="30" class="checkbox-money" />
                    </td>
                </tr>
            </table>
        </div>
        <br />
        <hr />
        <div id="info">
            <div id="print-info">
                <div id="operate">
                    <button type="button" class="btn-operate" onclick="javascript:M1Reset_onclick()">
                        读卡</button>
                   <%-- <button type="button" class="btn-operate" onclick="javascript:ReadCard()">
                        读卡</button>--%>
                    <button type="button" class="btn-operate">
                        取消</button>                             
                    <button type="button" class="btn-operate" onclick="javascript:recharge()">
                        充值</button>
                </div>
            </div>
            <div id="vip-info">
                <form>
                <fieldset>
                    <legend class="title-info">会员信息</legend>
                    <table id="tab">
                        <tr id="row-one">
                            <td class="left-font">
                                会员卡号：
                            </td>
                            <td>
                                <input type="text" name="card_no" id="card_no"  size="30" value="<%=ucid %>">
                            </td>
                            <td class="right-font">
                                姓名：
                            </td>
                            <td>
                                <input type="text" name="M001_NAME" id="emp_name" size="30" value="<%=m001_name %>"><br />
                            </td>
                        </tr>
                        <tr>
                            <td class="left-font">
                                会员级别：
                            </td>
                            <td>
                                <select name="vip-level" id="emp_level" style="width: 210px; border: 1px solid #c7cbce; display: false;">
                                    <%foreach (System.Data.DataRow row in v_member_level.Rows)
                                      {
                                          name = string.Format("{0}", row["STATE_Name"]);
                                          id = string.Format("{0}", row["STATE_ID"]);
                                          if (id == member_level)
                                          {%>
                                    <option value="<%=id %>" selected="selected">
                                        <%=name%>
                                    </option>
                                    <%}
                                          else
                                          {%>
                                    <option value="<%=id %>">
                                        <%=name%>
                                    </option>
                                    <%}
                                    %>
                                    <%}%>
                                </select>
                            </td>
                            <td class="right-font">
                                有效期：
                            </td>
                            <td>
                                <input type="text" size="30" name="validate" id="validate" value="<%=enter_date %>">
                            </td>
                        </tr>
                        <tr>
                            <td class="left-font">
                                可用积分：
                            </td>
                            <td>
                                <input type="text" size="30"  name="points" id="points" value="<%=recharge_money %>">
                            </td>
                            <td class="right-font">
                                可用储值：
                            </td>
                            <td>
                                <input type="text" size="30" name="balance" id="balance" value="<%=balance %>">
                               <%-- <input type="hidden" id="UCID" value="<%=ucid %>" name="UCID" />--%>
                                <input type="hidden" id="M001_KEY" value="<%=m001_key %>" name="M001_KEY" />
                                <input type="hidden" id="M002_KEY" value="<%=m002_key %>" name="M002_KEY" />
                                <input type="hidden" id="user_id" value="<%=user_id %>" name="user_id" />
                            </td>
                        </tr>
                    </table>
                </fieldset>
                </form>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
