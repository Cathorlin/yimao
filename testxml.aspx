<%@ Page Language="C#"  validateRequest="false" AutoEventWireup="true" CodeFile="testxml.aspx.cs" Inherits="testxml" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link   href ="Css/BasePage.css"  rel="stylesheet"  type="text/css" />
    <script src ="js/http.js" language="javascript" type="text/javascript"></script>
 <style>
 table
 {
      table-layout:fixed;
     }
 </style>
 <script>
     // 对Date的扩展，将 Date 转化为指定格式的String 
     // 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
     // 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
     // 例子： 
     // (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
     // (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
     Date.prototype.Format = function (fmt) { //author: meizz 
         var o = {
             "M+": this.getMonth() + 1,                 //月份 
             "d+": this.getDate(),                    //日 
             "h+": this.getHours(),                   //小时 
             "m+": this.getMinutes(),                 //分 
             "s+": this.getSeconds(),                 //秒 
             "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
             "S": this.getMilliseconds()             //毫秒 
         };
         if (/(y+)/.test(fmt))
             fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
         for (var k in o)
             if (new RegExp("(" + k + ")").test(fmt))
                 fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
         return fmt;
     }
     document.write('<div id="loader_container"><div id="loader"><div align="center" style="font-size:9pt;">页面正在加载中……</div><div align="center"><img src="../images/loading.gif" alt="loading" /></div></div></div>');
     remove_loading();
     function set_xml() {
         var txtobjs = document.getElementsByName("colv");

         var transid = (new Date()).Format("yyyyMMddhhmmssS");
         var xmlhead = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
          xmlhead += "<miap><miap-header><transactionid>"+transid +"</transactionid>";
          xmlhead += "<version>1.0</version><messagename><%=a319_id%>req</messagename>";
          xmlhead += "</miap-header><miap-body><<%=a319_id%>req>";
         
         for (var i = 0; i < txtobjs.length; i++) {
             var col_id = txtobjs[i].id.substr(4);
             xmlhead += "<" + col_id + ">" + txtobjs[i].value + "</" + col_id + ">";

         }
         xmlhead += "</<%=a319_id%>req></miap-body></miap>";
         document.getElementById("sendxml").value = xmlhead;


         xmlhead = encodeURIComponent(xmlhead);
         var parm = formatparm();
         parm = addParm(parm, "A00201KEY","");
         parm = addParm(parm, "REQID", "GET_XML_REQ");
         parm = addParm(parm, "VER", "");
         parm = addParm(parm, "URL", location.href);
         parm = addParm(parm, "REQURL", document.getElementById("txturl").value);
         parm = addParm(parm, "SENDXML", xmlhead);
         parm = addParm(parm, "DOFUN","show_xml('[XML]');");
         parm = parm + endformatparm();
         url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
         FunGetHttp(url, "div_req", parm);

     }
     function show_xml(receive_xml) {
         var xml_ = decodeURIComponent(receive_xml);
         document.getElementById("receivexml").value = xml_;
     }
 </script>
</head>
<center>
<body>
<div style="width:1024px;text-align:center;">
<div  style="width:1024px;">
    <%for (int i = 0; i < dt_data.Rows.Count; i++)
      {
          string a319_id_ = dt_data.Rows[i]["a319_id"].ToString();
          string a319_name_ = dt_data.Rows[i]["a319_name"].ToString();
          string url = Request.Url.OriginalString;
          if (a319_id_ == a319_id)
          {
              Response.Write("<input id=\"Rd_" + a319_id + "\"  checked name=\"a309id\" type=\"radio\" value=\"" + a319_id_ + "\"/>" + a319_name_);
          }
          else
          {
              Response.Write("<input id=\"Rd_" + a319_id + "\"  name=\"a309id\" type=\"radio\" value=\"" + a319_id_ + "\" onclick=\"location.href='testxml.aspx?key=" + a319_id_ + "'\"/>" + a319_name_);
          }
      }
     %>
</div> 
<div style=" width:1024px;"></div>
<div  style="width:99%;text-align:center;">
     <%if  (dt_detail.Rows.Count >0)
       {
   
           for (int i = 0; i < dt_detail.Rows.Count; i++)
           {
               string column_id = dt_detail.Rows[i]["column_id"].ToString();
               string col_id = dt_detail.Rows[i]["col_id"].ToString();
               string column_name = dt_detail.Rows[i]["column_name"].ToString();
               Response.Write("<li style=\"float:left;margin:5px 5px 6px 5px\">");
               Response.Write("<table><tr>");
               Response.Write("<td width='80px'>");
               Response.Write(column_name);
               Response.Write("</td>");
               Response.Write("<td width='150px'>");
               string if_detail = dt_detail.Rows[i]["if_detail"].ToString();
               if (if_detail == "1")
               {
                   Response.Write("<textarea id=\"txt_" + column_id + "\"  name=\"colv\" style=\"height:100px;width:300px;\" /><detail>");

                   dt_temp = Fun.getDtBySql("SELECT t.* from a31801 t where  t.a318_id='" + dt_detail.Rows[i]["a318_id"].ToString() + "' order by t.col_id");
                   for (int j = 0; j < dt_temp.Rows.Count; j++)
                   {
                       Response.Write("<" + dt_temp.Rows[j]["column_id"].ToString() + "></" + dt_temp.Rows[j]["column_id"].ToString() + ">");
                   }
                   Response.Write("</detail></textarea>");
               }
               else
               {
                   Response.Write("<input id=\"txt_" + column_id + "\"  name=\"colv\"  type=\"text\" value=\"\"/>");
               }
               Response.Write("</td>");
               Response.Write("</tr></table>");
               Response.Write(Environment.NewLine);
               Response.Write("</li>");
           }
          
       }
       %>
</div>
<div style=" width:1024px;"></div>
<div style="width:99%; float:left;">
<table>
<tr>
<td>
发送报文
</td>
<td>
<%
    REQURL = "http://117.184.99.162:8080";
 %>
<input  type="text"  style="width:200px;" value="<%=REQURL %>" id="txturl"/>
<input  type="button" value="发送报文" onclick="set_xml()"/>
</td>
<td>
接收报文
</td>
</tr>
<tr>
<td colspan=2>
<textarea style="height:300px;width:500px;" id="sendxml"><%= Reqxml %></textarea>
</td>
<td>
<textarea style="height:300px;width:500px;" id="receivexml" ><%= Responsexml %></textarea>
</td>
</tr>
</table>

</div>
</div>
</body>
</center>
</html>
