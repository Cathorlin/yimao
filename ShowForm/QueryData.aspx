<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QueryData.aspx.cs" Inherits="ShowForm_QueryData"  Buffer="true"   EnableViewState ="false"%>
<html >
<head>
<%string jsver = GlobeAtt.GetValue("JSVER");
%>
  <title><%=dt_main.Rows[0]["MENU_NAME"].ToString()%>--<%=BaseMsg.getMsg("M0012")%></title>
  <script src="<%=http_url %>js/BasePage.js?ver=<%=jsver %>"   type="text/javascript"></script>	
  <script src="<%=http_url %>js/WebCalendar.js?ver=<%=jsver %>"  type="text/javascript" language="JavaScript"></script> 
  <script src="<%=http_url %>js/Calendar.js?ver=<%=jsver %>"     type="text/javascript" language="JavaScript"></script>  
  <script src="<%=http_url %>js/jquery-1.9.1.js?ver=<%=jsver %>"   type="text/javascript"></script>
  <script src="<%=http_url %>js/option.js?ver=<%=jsver %>"       language="javascript"   ></script>
  <script src="<%=http_url %>js/BaseQuery.js?ver=<%=jsver %>"    type="text/javascript"></script>
  <script src="<%=http_url %>js/rbutton.js?ver=<%=jsver %>"      language="javascript"></script>	
  <script src="<%=http_url %>js/http.js?ver=<%=jsver %>"        language="javascript" type="text/javascript"></script>
  <link  href="<%=http_url %>Css/BasePage.css?ver=<%=jsver %>"  rel="stylesheet"  type="text/css" />
 <script>
     a002_key = '<%=a002_key%>';
     if_showDialog = '0';
     data_index = "<%=GlobeAtt.DATA_INDEX %>";
     option = "Q";
     main_key = "";
     show_sysrb = '<%=GlobeAtt.GetValue("SHOW_SYS_RB") %>';
  document.write('<div id="loader_container"><div id="loader"><div align="center" style="font-size:9pt;">页面正在加载中……</div><div align="center"><img src="../images/loading.gif" alt="loading" /></div></div></div>');
  function showmaintab(a00201_key, tabi) {
      
      setdetailheight(a00201_key);
  }
  var showchild = "<%=showchild %>";
  function setchild(showchild__) {
      showchild = showchild__;
      setdetailheight('<%=a002_key%>');
      if (showchild == "1") {
          clearshowtab();
      }
  }
 
  function showline(key_) {
      main_key_value = key_;
      main_key = key_;
      if (showchild == "1") {
          clearshowtab();
      }
  }

  function showdetail(a00201_key__) {
     
      loaddetail('<%=a002_key%>', a00201_key__, main_key_value, 'V', '1', '1', '');
     
  }

  function setdetailheight(a00201_key__) {

      var objs = document.getElementById("scroll_" + a00201_key__);
      if (objs == null)
          return;

      var tmainh = 0
      var tmainw = 0;
      var childheight = 100;
      if (a00201_key__ == a002_key) {
          tmainh = getPheight() - 58;
          tmainw = getPwidth() - 5;
          if (showchild == "1") {
              tmainh = tmainh - childheight - 70;
              $("#tr_child").show();
          }
          else {
              $("#tr_child").hide();
          }
      }
      else {
          tmainh = childheight;
          tmainw = getPwidth() - 15;
      }
    
     
      

     
      //判断有没有按钮
     
      try {
          var showl = document.getElementById("showl_" + a00201_key__).value;
          var ldwidth = parseInt(document.getElementById("showld_" + a00201_key__).value);
       
          if (showl == "1") {
              $("#d_main_" + a00201_key__).width( tmainw);
              //固定列
              $("#d_r_" + a00201_key__).width(lwidth);
              $("#d_lr_" + a00201_key__).width(ldwidth);
              $("#d_l_" + a00201_key__).width(tmainw - lwidth - ldwidth - 2);

             //document.getElementById("d_r_" + a00201_key__).style.width = lwidth;
             // document.getElementById("d_lr_" + a00201_key__).style.width = ldwidth;
             // document.getElementById("d_l_" + a00201_key__).style.width = tmainw - lwidth - ldwidth - 2;
             // objs.style.height = tmainh;
              $("#" + objs.id).height(tmainh);

              $("#d_main_" + a00201_key__).height(tmainh);
              $("#d_l_" + a00201_key__).height(tmainh);
              $("#d_r_" + a00201_key__).height(tmainh);
              $("#d_lr_" + a00201_key__).height(tmainh);

              $("#scroll_" + a00201_key__).width(tmainw - lwidth - ldwidth - 2);
              $("#scroll_" + a00201_key__ + "_x").width(tmainw - lwidth - ldwidth - 2);
            //  document.getElementById("d_main_" + a00201_key__).style.height = tmainh;
             // document.getElementById("d_l_" + a00201_key__).style.height = tmainh;
             // document.getElementById("d_r_" + a00201_key__).style.height = tmainh;
             // document.getElementById("d_lr_" + a00201_key__).style.height = tmainh;

             // document.getElementById("scroll_" + a00201_key__ + "_x").style.width = tmainw - lwidth - ldwidth - 2;
           //   document.getElementById("scroll_" + a00201_key__).style.width = tmainw - lwidth - ldwidth - 2;
              //固定列
              document.getElementById("d_r_" + a00201_key__).style.display = "";
              if (document.getElementById("scroll0_" + a00201_key__) != null) {
                  document.getElementById("scroll0_" + a00201_key__).style.height = tmainh;
                  document.getElementById("scroll0_" + a00201_key__ + "_x").style.width = lwidth;
                  document.getElementById("scroll0_" + a00201_key__).style.width = lwidth;

                  document.getElementById("scroll0_" + a00201_key__ + "_x").style.display = "";
                  document.getElementById("scroll0_" + a00201_key__).style.display = "";
              }
          }
          else {
              document.getElementById("d_main_" + a00201_key__).style.width = tmainw;
              //固定列
              document.getElementById("d_r_" + a00201_key__).style.display = "none";
       

              document.getElementById("d_lr_" + a00201_key__).style.width = ldwidth;
              document.getElementById("d_l_" + a00201_key__).style.width = tmainw - ldwidth - 2;

              objs.style.height = tmainh;
        
              document.getElementById("d_main_" + a00201_key__).style.height = tmainh;
              document.getElementById("d_l_" + a00201_key__).style.height = tmainh;
              document.getElementById("d_r_" + a00201_key__).style.height = tmainh;
              document.getElementById("d_lr_" + a00201_key__).style.height = tmainh;

              document.getElementById("scroll_" + a00201_key__ + "_x").style.width = tmainw  - ldwidth - 2;
              document.getElementById("scroll_" + a00201_key__).style.width = tmainw - ldwidth - 2;
              if ( document.getElementById("scroll0_" + a00201_key__) != null)
              {
              document.getElementById("scroll0_" + a00201_key__).style.height = tmainh;
              document.getElementById("scroll0_" + a00201_key__ + "_x").style.display = "none";
              document.getElementById("scroll0_" + a00201_key__).style.display = "none";
              }
              //固定列            
      }
    }
      catch (e)
    { }

  }
 </script>
 <style>
._button
{
	text-align: center;
	vertical-align: middle;
	height: 23px;
	line-height: 18px;
	cursor: pointer;
	text-align: center;
	padding: 2px 8px 0;
	color: white;
	-webkit-border-radius: 4px;
	-moz-border-radius: 4px;
	background-color: #43A1DA;
}
 
 </style>
</head>
<body scroll="no" style="margin:0 0 0 5px; ">
<div style="width:100%;" id="main">

<form id="form1" runat="server">   
<table width="100%"    style="table-layout:fixed;margin:0 0 0 0 ;" border="0" align="center" cellpadding="0" cellspacing="0" id="tmain">
<tr id="tr_1">
<td style="margin-left:5px;display:none;" height="30">     
</td>
</tr>    
<tr>
<td>
<table width="100%"   style="table-layout:fixed;" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td width="1">&nbsp;</td>
        <td>
        <table width="100%" id="tr_main"  style="table-layout:fixed" border="0" cellspacing="0" cellpadding="0"> 
        <tr >
        <td id="td_main">
         <div id="mainhead">    
         </div>
        </td>
        </tr>
        <tr id="tr_2">
        <td>
        <table width="100%" >
        <tr id="tr_button" style="display:none;">
        <td>
        </td>
         <td height="29">   
         </td>
        <td>        
        </td>
        </tr>
        </table>   
        </td>
        </tr>
        <tr id="tr_detail" >
        <td id="td_detail"  width="100%" >
         <div id="show_<%=a002_key %>"></div>         
        </td>    
        </tr> 
        <tr id="tr_child" style="display:none;">
        <td id="td_child" width="100%">
               <div id="child_<%=a002_key %>">
         <table width="100%"  style="table-layout:fixed" border="0" cellspacing="0" cellpadding="0">
         <tr>
        <td width="9">&nbsp;</td>
        <td>
        <table width="100%"  style="table-layout:fixed" border="0" cellspacing="0" cellpadding="0"> 
        <tr id="tr2">
        <td>
        <table width="100%">
        <tr id="tr3">
        <td>
        </td>
         <td height="29">
            <div id="tabsJ">
    <ul>  
    <%  for (int i = 0; i < dt_detail.Rows.Count; i++)
        {
            string a00201_key__ = dt_detail.Rows[i]["a00201_key"].ToString();

            string tab_name = dt_detail.Rows[i]["tab_name"].ToString();
            if (GlobeAtt.LANGUAGE_ID == "EN")
            {
                tab_name = dt_detail.Rows[i]["en_tab_name"].ToString();
            }
    %>    <li   id="tab_<%=a00201_key__ %>">
        <a><span onclick="showtab('<%=a00201_key__ %>')">
        <input  type="hidden" name="load_list" id="load_<%=a00201_key__ %>" value="0" title="showdetail('<%=a00201_key__ %>')"/> <%=tab_name%> </span> </a> 
    </li>
    <%     } %>
    </ul>
        </div> 
         </td>
        <td>        
        </td>
        </tr>
        </table>   
        </td>
        </tr>
        <tr id="tr4">
        <td id="td2">
          <% 
              string showtab__ = "0";
              for (int i = 0; i < dt_detail.Rows.Count; i++)
           {
              string a00201_key__ = dt_detail.Rows[i]["a00201_key"].ToString();
              if ( i ==0)
              {
                  showtab__ = a00201_key__;
              }
          

         %>
          <div id="show_<%=a00201_key__ %>" style="display:none;"></div>
             <%
         }%>  
        </td>    
        </tr> 
        </table> 
        </td>
        </tr>
        </table>
        </div>              
   
        </td>

        </tr>   
      </table>
                 <% if (dt_detail.Rows.Count > 0) { 
           %>
           <script language=javascript>
               showtab('<% =showtab__ %>')
           </script>
           <%} %>   
    </td>
    </tr>
    <tr>
    <td height="9">
    <table width="100%"  style="table-layout:fixed;" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="1" height="9"></td>
        <td>

        </td>
        <td width="1"></td>
      </tr>
    </table>
    </td>
    </tr>
    </table>
    </td>
    </tr>
    </table>
</form>

<script language=javascript>
<%
    if (query_id == "" || query_id == null)
    {
  %>      
     loaddetail("<%=a002_key %>","<%=a002_key %>","","Q","0","0","<%=query_id %>");
   <%}
   else
   {
   %>
    loaddetail("<%=a002_key %>","<%=a002_key %>","","Q","0","1","<%=query_id %>");
   <%}
   %>
   
    remove_loading();
    pageInit(); 
    ifshowend  = true;
</script>

</div>
</body>
</html>

