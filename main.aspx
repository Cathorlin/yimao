<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main.aspx.cs" Inherits="main" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>主页面</title>
     <script language=javascript src ="<%=http_url %>js/BasePage.js"></script>	
     <script language=javascript src ="<%=http_url %>js/BMMain.js?ver=60113161"></script>
     <script language=javascript src ="<%=http_url %>js/Http.js"></script>	
     <script language=javascript src ="<%=http_url %>js/showmsg.js"></script>
     <script type="text/javascript" src="../js/jquery-1.9.1.js"></script>
     <link rel="stylesheet" type="text/css" href="Css/BasePage.css?ver=112122"/>

    <link rel="stylesheet" href="ztree/css/demo.css" type="text/css">
    <link rel="stylesheet" href="ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <script type="text/javascript" src="ztree/js/jquery.ztree.core-3.5.js"></script>

    <script language=javascript>
       show_sysrb = '<%=GlobeAtt.GetValue("SHOW_SYS_RB") %>';
       cfg =<%=GlobeAtt.GetValue("CFG") %>;
       BS_TABS = <%=BS_TABS %>;
        var Ntree_t9507020=[];
        Ntree_t9507020.push({id:1, pId: -1, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=4');\">张祖秋</a></nobr>",open:true});Ntree_t9507020.push({id:2, pId:1, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=6');\">陈洪泉 - 副总裁/AMT总监  (未提交)</a></nobr>"});Ntree_t9507020.push({id:3, pId:2, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=20');\">谭禾刈 - 高级经理  (退回至下级)</a></nobr>"});Ntree_t9507020.push({id:4, pId:3, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=65');\">王行兵 - 销售经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:5, pId:3, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=66');\">肖飞 - 销售经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:6, pId:3, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=67');\">周玲 - 销售经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:7, pId:3, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=68');\">魏莉 - 客服科科长兼客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:8, pId:3, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=71');\">袁雪 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:9, pId:3, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=73');\">何蕙州 - 客户经理  (被退回)</a></nobr>"});Ntree_t9507020.push({id:10, pId:3, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=75');\">吴自菲 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:11, pId:2, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=21');\">刘仕模 - 高级经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:12, pId:11, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=76');\">窦练龙 - 销售经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:13, pId:11, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=83');\">刘军 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:14, pId:11, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1473');\">王丽蓉 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:15, pId:11, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1474');\">赵丽萍 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:16, pId:11, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1472');\">金佳艳 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:17, pId:2, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=79');\">吴强 - 销售经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:18, pId:17, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=80');\">刘维辉 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:19, pId:1, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=7');\">冯美来 - 副总裁/汽车电子单元总监  (未提交)</a></nobr>"});Ntree_t9507020.push({id:20, pId:19, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=23');\">韩战稳 - 经理  (退回至下级)</a></nobr>"});Ntree_t9507020.push({id:21, pId:20, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=94');\">周微艳 - 客户经理  (被退回)</a></nobr>"});Ntree_t9507020.push({id:22, pId:20, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=95');\">封燕 - 高级客户助理  (未提交)</a></nobr>"});Ntree_t9507020.push({id:23, pId:19, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=25');\">李威 - 汽车电子总经理  (未提交)</a></nobr>"});Ntree_t9507020.push({id:24, pId:23, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=106');\">周彬 - 经理  (未提交)</a></nobr>"});Ntree_t9507020.push({id:25, pId:24, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=226');\">粟晓瑜 - 高级客户经理  (未提交)</a></nobr>"});Ntree_t9507020.push({id:26, pId:24, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=227');\">张涛 - 销售员  (未提交)</a></nobr>"});Ntree_t9507020.push({id:27, pId:1, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=8');\">李前进 - 国际贸易总监  (未提交)</a></nobr>"});Ntree_t9507020.push({id:28, pId:27, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=26');\">王冬梅 - 部门经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:29, pId:28, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=122');\">姚士尧 - 销售经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:30, pId:28, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=123');\">赵宏霞 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:31, pId:28, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=124');\">干玲燕 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:32, pId:1, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=13');\">江昌雄 - 副总裁/内销总监/总经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:33, pId:32, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=48');\">杨俊 - 高级经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:34, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1475');\">查丹萍 - 销售员  (已提交)</a></nobr>"});Ntree_t9507020.push({id:35, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1476');\">孟定兵 - 销售员  (已提交)</a></nobr>"});Ntree_t9507020.push({id:36, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=180');\">叶定超 - 销售专员  (已提交)</a></nobr>"});Ntree_t9507020.push({id:37, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=182');\">姜国胜 - 大区经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:38, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=184');\">高宁宁 - 主管  (已提交)</a></nobr>"});Ntree_t9507020.push({id:39, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=185');\">张尚武 - 主管  (已提交)</a></nobr>"});Ntree_t9507020.push({id:40, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=186');\">胡星宁 - 销售专员  (已提交)</a></nobr>"});Ntree_t9507020.push({id:41, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=188');\">高兰兰 - 主管  (已提交)</a></nobr>"});Ntree_t9507020.push({id:42, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=189');\">王伟 - 销售专员  (已提交)</a></nobr>"});Ntree_t9507020.push({id:43, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=190');\">吴飞 - 大区经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:44, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=196');\">张腾龙 - 销售专员  (已提交)</a></nobr>"});Ntree_t9507020.push({id:45, pId:33, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1471');\">隆卓 - 初级技术服务支持  (已提交)</a></nobr>"});Ntree_t9507020.push({id:46, pId:1, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=14');\">王胜全 - 副总裁/总监  (已提交)</a></nobr>"});Ntree_t9507020.push({id:47, pId:46, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=49');\">于晨 - 高级经理兼售后业务科科长  (已提交)</a></nobr>"});Ntree_t9507020.push({id:48, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=115');\">郑秀超 - 科长  (已提交)</a></nobr>"});Ntree_t9507020.push({id:49, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=117');\">章琦 - 售后业务科副科长  (已提交)</a></nobr>"});Ntree_t9507020.push({id:50, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=118');\">瞿丽娜 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:51, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=136');\">倪国强 - 销售经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:52, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=202');\">钟靓琛 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:53, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=203');\">冯超亚 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:54, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1477');\">黄丽娜 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:55, pId:47, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=1306');\">刘立钦 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:56, pId:46, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=50');\">王小青 - 经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:57, pId:56, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=173');\">王伟伟 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:58, pId:56, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=175');\">袁天娥 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:59, pId:56, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=176');\">吕宝林 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:60, pId:56, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=177');\">潘浩 - 客户经理  (已提交)</a></nobr>"});Ntree_t9507020.push({id:61, pId:56, name:"<nobr><a onclick=\"ShowChildUrl(this,'/ShowForm/MainForm.aspx?option=M&A002KEY=950702&key=178');\">朱桂林 - 副经理  (已提交)</a></nobr>"});createTree("tree_t9507020", Ntree_t9507020);ifdiv_req = "0";
    </script>

</head>


<body scroll=no   >

<form id="form1" runat="server"> 
<div id="header" >						
<div id="nav1"  style="margin:0">
<ul id="ultab">
</ul>
</div>


</div>
<div class="line" id="line"></div>
<div id="divmain" style="width:100%;">
<div style="float:left;" id="mleft">
<div id="showtree">
</div>
</div>
<div style="float:left;" id="mright">
<div  id="showdiv" style="width:100%;" >

</div>
  <script language=javascript>
      setH();
      <%
        string LINK_P_URL = "";
        try
        {
            LINK_P_URL = Session["LINK_P_URL"].ToString();
        }
        catch
        {
            LINK_P_URL = "";
        }
        if (LINK_P_URL.Length > 1)
        {
            %>
            showtaburl( "<%=LINK_P_URL %>","连接");
            <%
        }            
     %>
  </script>
</div>
</div>
<script language=javascript>
    Set_tree(0, "", "", "");
    $("#mright").width($("#divmain").width() - $("#mleft").width() - 20);

</script>
 </form>
</body>
</html>
