<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowA403List.aspx.cs" Inherits="ShowForm_ShowA403List" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 <title></title>
<link  href="../jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
<link  href="../Css/BasePage.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery-ui-1.10.3/jquery-1.9.1.js"></script>
<script  src="../jquery-ui-1.10.3/ui/jquery-ui.js"></script>
<script src="../js/http.js"></script>
<script src="../js/BasePage.js"></script>
<script language=javascript>
    //
    function get_show_html(id_) { 
        //定时获取内容
    }
</script>
</head>
<body scroll=yes>
<form id="form1" runat="server">
<div style="<%=dt_a403.Rows[0]["div_attr"].ToString()%>margin-top:<%=dt_a403.Rows[0]["DIV_TOP"].ToString() %>px; margin-left:<%=dt_a403.Rows[0]["DIV_LEFT"].ToString()%>px;width:<%=dt_a403.Rows[0]["div_width"].ToString()%>px; height:<%=dt_a403.Rows[0]["div_height"].ToString()%>px; ">
<%
    int max_ = 0;
    double main_width = double.Parse(dt_a403.Rows[0]["div_width"].ToString());
    double main_height = double.Parse(dt_a403.Rows[0]["div_height"].ToString());
    for (int i = 0; i < dt_a40301.Rows.Count; i++)
    {
        string ref_second = dt_a40301.Rows[i]["ref_second"].ToString();
        if (ref_second == "" || ref_second == null || int.Parse(ref_second) < 3)
        {
            ref_second = (60 * 60 * 24 * 30).ToString();
        }
        if (max_ == 0)
        {
            max_ = int.Parse(ref_second);
        }
        else
        {
            int num = int.Parse(ref_second);
            max_ = max(num, max_);
        }
    }
 for (int i = 0; i < dt_a40301.Rows.Count; i++)
      {
          string id_ = "S" + a403_id + "-" + dt_a40301.Rows[i]["line_no"].ToString();
          string width_ = Math.Round((double.Parse(dt_a40301.Rows[i]["DIV_WIDTH"].ToString()) * main_width / 100),0).ToString();
          string height_ = Math.Round((double.Parse(dt_a40301.Rows[i]["DIV_HEIGHT"].ToString()) * main_height / 100),0).ToString();
          string left_ = Math.Round((double.Parse(dt_a40301.Rows[i]["DIV_LEFT"].ToString()) * main_width / 100),0).ToString();
          string top_ = Math.Round((double.Parse(dt_a40301.Rows[i]["DIV_TOP"].ToString()) * main_height / 100), 0).ToString();
          string z_index =( 8000 + int.Parse(dt_a40301.Rows[i]["line_no"].ToString())).ToString();
          string title_ = dt_a40301.Rows[i]["line_no"].ToString();
          string ref_second = dt_a40301.Rows[i]["ref_second"].ToString();
          if (ref_second == "" || ref_second == null || int.Parse(ref_second) < 3 )
          {
              ref_second = (60*60*24*30).ToString();
          }
          ref_second = (int.Parse(ref_second) / max_).ToString();
      %>
      
    <div id="<%=id_ %>"  name="sdiv"  time="<%=ref_second %>" objid="<%= dt_a40301.Rows[i]["OBJID"].ToString() %>" style="overflow:auto; border:solid 1px Red; margin-left:<%=left_%>px; margin-top:<%=top_ %>px; width:<%=width_%>px; height:<%=height_%>px;position:absolute; z-index:<%=z_index%>;">
    </div>
  <%    
  }
 %>
     </div>
     <script language=javascript>
         //处理数据
         $(function () {
             refsh_html();

         })
         var ss = 0;
         function refsh_html() {            
             var divlist = $("[name=sdiv]");
             for (var i = 0; i < divlist.length; i++) {
                 id = divlist[i].id;
                 var stime = $("#" + id).attr("time");
                 if (ss % parseInt(stime) == 0) {
                     //开始刷新数据
                     get_a403_html(id);
                 }                 
             }             
             setTimeout("refsh_html()", 1000 * <%= max_ %>);
             ss = ss + 1;
         }
         function get_a403_html(id_) {
             var parm = formatparm();
             var objid__ = $("#" + id_).attr("objid");
             parm = addParm(parm, "A002ID", "");
             parm = addParm(parm, "A00201KEY", "0");
             parm = addParm(parm, "REQID", "GET_A403");
             parm = addParm(parm, "KEY", "<%=a403_id %>");
             parm = addParm(parm, "ID", id_);
             parm = addParm(parm, "OBJID", objid__);
             parm = addParm(parm, "URL", location.href);
             parm = parm + endformatparm();
             url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
             FunGetHttp(url, "div_req" , parm); 
            
         }
      
     </script>
    </form>
</body>
</html>
