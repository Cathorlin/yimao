<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="css/Model.css"  rel="stylesheet"  type="text/css" />
    <script type="text/javascript" src="../js/jquery.min.js"></script>
    <script language=javascript>
        function selectpic(divid, id, obj) {
            //上传文件 alert(divid);
            var pic = "c-01.jpg"; //打开上传的窗口 把数据写入数据库 返回 pic 的文件名称 
            var v = Bpage.SaveText(divid, id, "PIC", e.value).value;

            $("#" + divid + "_spic_" + id).attr("src", "images/" + pic);
        }
        function addtr(divid,  obj) {
            //string if_show_or_edit = "1";//是显示 还是编辑 0 显示 1 编辑
            var itype = $("#select_" + divid).val();
            var id = Bpage.GetId(divid, itype).value;
            var html_ = Bpage.GetHtml(itype, divid, id, '<%=if_show_or_edit %>', "", "").value;
            //客户端动态添加行
            //行号是从0开始，最后一行是新增、删除、保存按钮行 故减去2
            var rownum = $("#t_" + divid + " tr").length - 2;
            var row = "<tr id=\"" + divid + "_"+id+"\"><td width=\"100%\">" + html_ + "</td></tr>";
            $(row).insertAfter($("#t_" + divid + " tr:eq(" + rownum + ")"));
        }
        function edittext(divid, id, obj) {
            var e = document.getElementById(divid + "_etext_" + i);
            var s = document.getElementById(divid + "_stext_" + i);
            if (e.style.display == "none") {
                e.style.display = "";
                $("#" + e.id).css("width", $("#" + s.id).width());
                $("#" + e.id).css("height", $("#" + s.id).height() + 20 );
                s.style.display = "none";                
            }
            else {
                e.style.display = "none";
                s.style.display = "";
                s.innerHTML = e.value;
                //把数据提交给数据库
                var v = Bpage.SaveText(divid, id,"TEXT" ,e.value).value;
            }
            
        }
    </script>
</head>

<body>
<center>
<form id="form1" runat="server" >
<%
    StringBuilder str_main = new StringBuilder();
    //先设置表格 为左右 格局
    //整体编码 
    string divid = "main";
    int allwidth = 1024;
    str_main.Append("<div id=\"d" + divid + "\" style=\"width:" + allwidth.ToString() + "px;\" classname=\"main\">");
    str_main.Append(Environment.NewLine);
    //左
    int leftwith = 800;

    str_main.Append("<div id=\"dl" + divid + "\" style=\"width:" + leftwith.ToString() + "px;\" class=\"mleft\">");
    str_main.Append(Environment.NewLine);
    //左table
    //int i = 0;    
    str_main.Append("<table class=\"tmain\" id=\"t_" + divid + "\" >");
    str_main.Append(Environment.NewLine);

    for (int i = 0; i < 10; i++)
    {
        string id = i.ToString();
        StringBuilder str_tr = new StringBuilder();
        str_tr.Append("<tr id=\"" + divid + "_" + id + "\">");
        str_tr.Append(Environment.NewLine);
        
        str_tr.Append("<td width=\"100%\">");
        str_tr.Append(Environment.NewLine);
        //只显示内容 图片 或者文字 
        
        string itype = "img";       
        if (i <= 3)
        {
            itype = "img_text" + i.ToString();
        }
        else
        {
            if (i % 2 == 0)
            {
                itype = "img";
            }
            else
            {
                itype = "text";
            }
            
        }
        
        string ipic= "images/b-02.jpg"; //图片路径 或者 文本内容
        string itext =  "测试图片的内容测试图片的内容测试图片的内容测试图片的内容测试图片的内容测试图片的内容测试图片的内容测试图片的内容";
        itext = itext + "的内容测试图片的内容测试图片的内容测试图片的内容测试图片的内的内容测试图片的内容测试图片的内容测试图片的内容测试图片的内容";
        itext = itext + "容测试图片的内容测试图片的内容测试图片的内容测试图片的内容的内容测试图片的内容测试图片的内容测试图片的内容测试图片的内容";
        
        string html_ = GetHtml(itype, divid, id, if_show_or_edit, ipic, itext);        
        str_tr.Append(html_);
        
        str_tr.Append("</td>");
        str_tr.Append(Environment.NewLine);        
        //如果只是显示         
        str_tr.Append("</tr>");
        str_tr.Append(Environment.NewLine);
        str_main.Append(str_tr.ToString());
    }


    if (if_show_or_edit == "1")
    {
        str_main.Append("<tr>");
        str_main.Append(Environment.NewLine);
        //如果只是显示         
        str_main.Append("<td>");
        str_main.Append(Environment.NewLine);
        str_main.Append("<div style=\"width:95%;\" >");
        str_main.Append("<select id=\"select_"+divid+"\" >");
        str_main.Append("<option value=\"img\">图片</option>");
        str_main.Append("<option value=\"text\">文字</option>");
        str_main.Append("<option value=\"img_text0\">上图下文字</option>");
        str_main.Append("<option value=\"img_text1\">左图右文字</option>");
        str_main.Append("<option value=\"img_text2\">上文字下图</option>");
        str_main.Append("<option value=\"img_text3\">右图左文字</option>");
        str_main.Append("</select>");
        str_main.Append("<input id=\"" + divid + "_add\" type=\"button\" value=\"添加\" onclick=\"javascript:addtr('" + divid + "','" + if_show_or_edit + "',this)\"/>");
        str_main.Append("</div>");
        str_main.Append("</td>");
        str_main.Append(Environment.NewLine);
        //如果只是显示         
        str_main.Append("</tr>");
        str_main.Append(Environment.NewLine);
    }

    str_main.Append("</table >");
    str_main.Append(Environment.NewLine);
    str_main.Append("</div>");
    str_main.Append(Environment.NewLine);
    //右
    str_main.Append("<div id=\"dr" + divid + "\" style=\"width:" + (allwidth - leftwith - 10).ToString() + "px;\" class=\"mleft\">");
    str_main.Append(Environment.NewLine);

    
    
    str_main.Append("</div>");
    str_main.Append(Environment.NewLine);
    
    //main 结束
    str_main.Append("</div>");
    str_main.Append(Environment.NewLine);

    Response.Write(str_main.ToString());
%>




<script language=javascript>
    //定义宽度
    $("#dmain").css("width", "1024px");
    $("#dmleft").css("width", "800px");
    $("#dmright").css("width", "210px");
</script>
    </form>
</center>
</body>

</html>
