<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MenuNew.aspx.cs" Inherits="MenuNew" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>菜单管理</title>
        <script type="text/javascript" src ="js/http.js?ver=20130114"></script>	
        <script src="js/jquery-1.9.1.js"></script>
        <link rel="stylesheet" href="ztree/css/demo.css" type="text/css">
	    <link rel="stylesheet" href="ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	    <script type="text/javascript" src="ztree/js/jquery.ztree.core-3.5.js"></script>
        <script language=javascript>
         var setting = {
                check: {
                    enable: true
                },

                data: {
                    simpleData: {
                        enable: true
                    },
                    key: {
                    title:"title"//1 json中要有一个key是 title就可以了
                    }
                },
                view: {
                        showTitle : true,// 2 这个开关也要打开，默认是关闭的
				        nameIsHTML: true,
                        dblClickExpand:false                        
                }

              };
         
            function showmenu(menu_id,menu_name)
            {
                parent.main.addtab(menu_id, menu_name);         
            }
             
        </script>
</head>
<body style=" margin:0 0 0 0; padding:0 0 0 0;">
<div  style=" margin:0 0 0 0; padding:0 0 0 0;">
<ul id="treeDemo" class="ztree"></ul>
</div>
</body>
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
     var    zNodes =[<%=str_json %>]; 
        $(document).ready(function () {		                                  
            var menuh = parent.get_mainheight();
            var menuw = parent.get_menuwidth();
            $("#treeDemo").height(menuh  - 3);    
            $("#treeDemo").width(menuw - 3);
            $("#treeDemo").css("margin", "0");
            $("#treeDemo").css("padding", "0");
            $.fn.zTree.init($("#treeDemo"), setting, zNodes); 
        } ) 


</script>
</html>
