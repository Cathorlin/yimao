<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MainWinF.aspx.cs" Inherits="MainWinF" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title><%=Fun.db.db_oracle.data_source%>  - <%=BaseMsg.getMsg("M0062")%> (<%= GlobeAtt.A007_NAME %>) </title>
    <link rel="stylesheet" href="jquery-ui-1.10.3/themes/base/jquery.ui.all.css">
	<script src="jquery-ui-1.10.3/jquery-1.9.1.js"></script>
	<script src="jquery-ui-1.10.3/ui/jquery.ui.core.js"></script>
	<script src="jquery-ui-1.10.3/ui/jquery.ui.widget.js"></script>
	<script src="jquery-ui-1.10.3/ui/jquery.ui.mouse.js"></script>
	<script src="jquery-ui-1.10.3/ui/jquery.ui.resizable.js"></script>
    <link rel="stylesheet" href="Css/BasePage.css"  type="text/css">
    <link rel="stylesheet" href="ztree/css/demo.css" type="text/css">
	<link rel="stylesheet" href="ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="ztree/js/jquery.ztree.core-3.5.js"></script>
    <script language=javascript>
    //
       
        function get_mainheight() {
            //获取当前框架中间的高度

            var h = $("#wleft").height();
            return h;
        }
        function get_menuwidth() {
            var w = $("#wleft").width();
            return w;
        }
        var setting = {
            check: {
                enable: true
            },

            data: {
                simpleData: {
                    enable: true
                },
                key: {
                    title: "title"//1 json中要有一个key是 title就可以了
                }
            },
            view: {
                showTitle: true, // 2 这个开关也要打开，默认是关闭的
                nameIsHTML: true,
                dblClickExpand: false
            }

        };

      
    </script>
</head>
<body style="margin:0 0 0 0;">
<div style="width:100%;margin:0 0 0 0;" id="wmain">
<table style="width:100%;margin:0 0 0 0;">
<tr style=" margin:0 0 0 0;">
<td style=" margin:0 0 0 0; ">
<div id="wleft" style="margin:0 0 0 0;float:left; border: sliod 1px red" class="ui-widget-content">
<ul id="wtree" class="ztree"></ul>
</div>
</td>
<td  style="margin:0 0 0 0; text-align:right;"  >
<div id="wright" style="margin:0 0 0 0;float:right;" class="ui-widget-content">

</div>
</td>
</tr>
</table>
</div>
<script language=javascript>
<%
             string  str_json = "";
             for(int i=0 ; i < dt_all.Rows.Count;i++)
             {
                 string menu_id=  dt_all.Rows[i]["MENU_ID"].ToString();
                  string a002_key=  dt_all.Rows[i]["a002_key"].ToString();
                 string menu_name_ =  dt_all.Rows[i]["MENU_NAME"].ToString();
                 string parent_id = dt_all.Rows[i]["parent_id"].ToString();
                 string LAST_LEVEL = dt_all.Rows[i]["LAST_LEVEL"].ToString();
                 string Useable =  dt_all.Rows[i]["Useable"].ToString();
                 string menu_name = "<span class=_m_>"+menu_name_+"</span>";
                 if ( Useable == "1")
                 {
                     if (parent_id =="00")
                     {
                        parent_id = "-1";
                     }
                     if (LAST_LEVEL == "1")
                     {
                        str_json = str_json + "{id:"+ menu_id + ", pId:"+ parent_id +", name:\""+ menu_name +"\",title:\"" + menu_id +"|"+ menu_name_ +"\",click:\"showmenu('"+ a002_key +"','"+menu_name_ +"');\"},";
                     }
                     else
                     {
                     str_json = str_json + "{id:"+ menu_id + ", pId:"+ parent_id +", name:\""+ menu_name +"\",title:\"" + menu_id +"|"+ menu_name_ +"\"},";
                     }   
                     str_json +=   Environment.NewLine;    
                }
               }
               if (dt_all.Rows.Count >0 )
               {
                   str_json = str_json.Substring(0,str_json.Length - 2);
               }
             %> 
            function showmenu(menu_id,menu_name)
            {
                fmain.addtab(menu_id, menu_name);         
            }
     var    zNodes =[<%=str_json %>]; 
         $(function () {
            var w = $("#wmain").width();// screen.width;
            var h = screen.height;
            var useh = parent.get_mainheight() - 5 ;
            var menuw = 190;
            var pw = 5;
            $("#wleft").width(menuw);
            $("#wright").width(w - menuw - pw);
            $("#wleft").height(useh);
            $("#wright").height(useh);
            //$("#fmain").height(useh);
            $("#wleft").resizable({
                maxHeight: useh,
                maxWidth: 350,
                minHeight: useh,
                minWidth: 100,
                distance :2,
                resize: function( event, ui ) {
                     $("#wtree").width(ui.size.width);
                     $("#wtree").height(ui.size.height);
                     $("#wright").width(w - ui.size.width - pw);
                    // $("#fmain").width(w - ui.size.width - pw);
                }
            });
            $("#wtree").height(useh);    
            $("#wtree").width(menuw - 3);
            $("#wtree").css("margin", "0");
            $("#wtree").css("padding", "0");
            $.fn.zTree.init($("#wtree"), setting, zNodes); 
        
        });
</script>

</body>
</html>
