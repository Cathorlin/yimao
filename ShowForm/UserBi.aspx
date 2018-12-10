<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserBi.aspx.cs" Inherits="ShowForm_UserBi" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
	<link rel="stylesheet" href="../jquery-ui-1.10.3/themes/base/jquery.ui.all.css">
	<script src="../jquery-ui-1.10.3/jquery-1.9.1.js"></script>
    <script  src="../jquery-ui-1.10.3/ui/jquery-ui.js"></script>
    <script src="../js/http.js"></script>
    <script src="../js/basepage.js"></script>
    <link rel="stylesheet" href="../Css/BasePage.css">
     
    <script language=javascript>
    document.write('<div id="loader_container"><div id="loader"><div align="center" style="font-size:9pt;">页面正在加载中……</div><div align="center"><img src="../images/loading.gif" alt="loading" /></div></div></div>');
    data_index = "<%=GlobeAtt.DATA_INDEX %>";
    var column0 =  new Array();
    var column1 =  new Array();
    var column2 =  new Array();
    var col_groups = new Array();
    var MAXROW = 2;
    function set_group(group_,group_name) {
        var if_exists = false;
        for (var i = 0; i < col_groups.length; i++) {
            if (col_groups[i][0] == group_) {
                if_exists = true;
                break;
            }
        }
        if (if_exists == false) {
            col_groups[col_groups.length] = [group_,group_name];
        }
    }
    </script>
    <style>
    body {
	font-size: 62.5%;
	font-family: "Trebuchet MS", "Arial", "Helvetica", "Verdana", "sans-serif";
}

table {
	font-size: 1em;
}

#main div td{border:solid  #add9c0; border-width:0px 1px 1px 0px; padding:0px 0px;}
#main div table{border:solid  #add9c0; border-width:1px 0px 0px 1px;}
.ui-dialog-titlebar { display:none; } 
.demo-description {
	clear: both;
	padding: 12px;
	font-size: 1.3em;
	line-height: 1.4em;
}

h3#A1
{
    -moz-border-radius:10px;
    -webkit-border-radius:10px;
    border-radius:10px;
    behavior:url(../js/border-radius.htc);
    background-color:Red;
}
.ui-draggable, .ui-droppable {
	background-position: top;
}
#sortable { list-style-type: none; margin: 0; padding: 0; width: 100%; }
	#sortable li { margin: 0 5px 5px 5px; padding: 5px; font-size: 1.2em; height: 1.1em; }
	html>body #sortable li { height: 1.5em; line-height: 0.9em; }
	.ui-state-highlight { height: 1.1em; line-height: 0.9em; }
    
    </style>
</head>



<script>
<%
    for (int i = 0; i < dt_a40401.Rows.Count; i++)
    {
        string col_type = dt_a40401.Rows[i]["col_type"].ToString();
        string column_id = dt_a40401.Rows[i]["COLUMN_ID"].ToString();
        string col_text = dt_a40401.Rows[i]["col_text"].ToString();
        string col_group = dt_a40401.Rows[i]["col_group"].ToString();
        string col_group_name = dt_a40401.Rows[i]["col_group_name"].ToString();
        // '0' as id,'分组列'   '1','统计列' '2','固定分组列'  '-','不显示' 
        if (col_type == "0")
        {
            Response.Write("column0[column0.length] = ['" +  col_group   + "','"+column_id + "','"+col_text+"'];");    
        }
        if (col_type == "1")
        {
            string col01  = dt_a40401.Rows[i]["col01"].ToString();
            //小数点位数
            if (col01 =="" || col01 == null)
            {
                col01 = "8";
            }
            Response.Write("column1[column1.length] = ['" +  col_group   + "','"+column_id  + "','"+col_text+"','" + col01 + "'];");       
        }
        if (col_type == "2")
        {
            Response.Write("column2[column2.length] = ['" +  col_group   + "','"+column_id  + "','"+col_text+"'];"); 
        }
        Response.Write(System.Environment.NewLine);
        if (col_group != "-")
        {
           Response.Write("set_group('" +  col_group   + "','"+col_group_name+"');");  
        }
        
        Response.Write(System.Environment.NewLine);
    }
%>
</script>
<body>
<%if (dt_a404.Rows[0]["if_con"].ToString() == "1")
  { %>
<div style="font-family:@宋体; font-size:larger;">
<label><input  type="hidden" id="date_col" value="<%=dt_a404.Rows[0]["date_col"].ToString() %>"/>日期范围:</label>
<label for="from">From</label>
<input type="text" id="from" name="from"/>
<span id="t_form"></span>
<label for="to">to</label>
<input type="text" id="to" name="to"/>
<span id="t_to"></span>
<button id="btn0">确定</button>
</div>
<%} %>
<div style="width:100%; text-align:center;">
<div  id="main" style="width:98%;" >
	<ul>
		<li><table><tr><td onclick="change_c('','1')"> <span class='ui-icon'  v="">Show Con</span></td><td> <a href="#tabs-1"><span><%=dt_a404.Rows[0]["A404_NAME"].ToString()%> </span></a> </td></tr></table></li>
	</ul>
	<div id="tabs-1">
    </div>
</div>
</div>


</body>

<script language=javascript>

    //显示输入条件

    $(function () {
         var tabs =$("#main").tabs({
			    collapsible: true
		    });

         $("#loader_container").hide();
         <% 
         if (dt_a404.Rows[0]["col_type"].ToString()== "DATE")
         {
         %>

         $( "#from" ).datepicker({
			defaultDate: "+1w",
			changeMonth: true,
            changeYear: true,
			numberOfMonths: 3,
            dateFormat :"yy-mm-dd",
			onClose: function( selectedDate ) {
				$( "#to" ).datepicker( "option", "minDate", selectedDate );
			}
		});
		$( "#to" ).datepicker({
			defaultDate: "+1w",
			changeMonth: true,
            changeYear: true,
			numberOfMonths: 3,
            dateFormat :"yy-mm-dd",
			onClose: function( selectedDate ) {
				$( "#from" ).datepicker( "option", "maxDate", selectedDate );
			}
		});
        <%} %>
        $(function() {
		$( "#btn0" )
			.button()
			.click(function() {
                var from =  $("#from").val();
                var to =  $("#to").val();
                if (from =="") 
                {
                    alert("请选择日期范围！");
                    return ;
                }

                if (to =="") 
                {
                    alert("请选择日期范围！");
                    return ;
                }
				show_query("","1");
                this.disabled = true;
                        $("#btn0").hide();
                $("#from").hide();
                $("#t_form").html(from);
                $("#to").hide();
                $("#t_to").html(to);
			});
	    });

   <%if (dt_a404.Rows[0]["if_con"].ToString() != "1")
  { %>
      show_query("","1");
        
  <%} %>          

        //show_query("","1");        
     }
    )
    var tabCounter = 1;
    function change_c(rowstr,divid_)
    {
        show_query(rowstr,divid_);   
    }

    function show_data(rowstr,divid_) {
           id = "tabs-" + divid_;
        if ( $("#" + id).length == 0)
        {
            var label ="Tab " + divid_;
		     id = "tabs-" + divid_;
             tabTemplate = "<li><table><tr><td onclick=\"change_c(\'"+ rowstr +"','"+divid_+"')\"> <span class='ui-icon'  v=\""+rowstr+"\">Show Con</span></td><td><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close' role='presentation'>Remove Tab</span></td></tr></table></li>";
	         li = $( tabTemplate.replace( /#\{href\}/g, "#" + id ).replace( /#\{label\}/g, label ) );

            var tabs =$("#main").tabs({
			    collapsible: true
		    });
		    tabs.find( ".ui-tabs-nav" ).append( li );
		    tabs.append( "<div id='" + id + "'>&nbsp;</div>" );
		    
            tabs.delegate( "span.ui-icon-close", "click", function() {
			    var panelId = $( this ).closest( "li" ).remove().attr( "aria-controls" );
			    $( "#" + panelId ).remove();
			    tabs.tabs( "refresh" );
		    });

		    tabs.bind( "keyup", function( event ) {
			    if ( event.altKey && event.keyCode === $.ui.keyCode.BACKSPACE ) {
				    var panelId = tabs.find( ".ui-tabs-active" ).remove().attr( "aria-controls" );
				    $( "#" + panelId ).remove();
                    tabCounter--;
				    tabs.tabs( "refresh" );
			    }
		    });
           
            tabs.tabs( "refresh" );
            var li_list =  $("#main ul li").length;
            tabs.tabs( "option", "active", (li_list  - 1)); 
            tabCounter++;
        }
        else
        {
            var tabs =$("#main").tabs({
			    collapsible: true
		    });
            var li_list =  $("#main ul li");
            for(var i=0 ;i < li_list.length;i++)
            {
               if (li_list[i].attributes("aria-controls").value == id)
               {
                 tabs.tabs( "option", "active", i); 
                 break;
               }
            }
        }
        
        url = http_url + "/BaseForm/ShowList.aspx?A00201KEY=KEY=&option=&A002ID=&ver=" + getClientDate();
        var parm = formatparm();
        parm = addParm(parm, "A002ID", "-");
        parm = addParm(parm, "A00201KEY", "");
        parm = addParm(parm, "KEY", "<%=a404_id %>"); //关键字
        parm = addParm(parm, "OPTION", "");//获取当前的分组信息
        parm = addParm(parm, "VER", "");
        parm = addParm(parm, "GROUPCOL", get_group_col());
        parm = addParm(parm, "SUMCOL", get_sum_col());
        parm = addParm(parm, "CONCOL", get_con());
        parm = addParm(parm, "TABLE_ID", "<%=dt_a404.Rows[0]["table_id"].ToString() %>");    
        parm = addParm(parm, "URL", location.href);
        parm = addParm(parm, "DIVID", id);
        parm = addParm(parm, "QUERYID", "");
        parm = addParm(parm, "TREENUM", $("#"+ divid_).attr("treenum"));
        
        parm = addParm(parm, "MAXROW", MAXROW);
        parm = parm + endformatparm();
       
        FunGetHttp(url, "div_req", parm);
    }
    function show_child(rowstr,id_)
    {       
        show_query(rowstr, id_);   
    }
    function show_hide_child(obj,id_)
    {
        if (obj.value == "+")
        {
            obj.value = "-";
            $("#r_" + id_).hide();
        }
        else 
        {
            obj.value = "+";
            $("#r_" + id_).show();
        }
    }
    // 把字符串转换为数组
    function set_row_data(rowstr) {
        var slist = new Array();
        if (rowstr == "" || rowstr == null) {
            return slist;
        }
        var sr = rowstr.split(data_index);
        for (var i = 0; i < sr.length; i++) {
            slist[i] = sr[i].split('|');
        }
        return slist;
    }
    function get_item_value(rowdata,column_id) {
        for (var i = 0; i < rowdata.length; i++) {
            if (rowdata[i][0] == column_id) {
                return rowdata[i][1];
            }
        }
        return "";
    }
    function get_group_col() {
        var str_ ="";
        var toArray = $( "#sortable li.ui-state-disabled" );
       
        for(var j=0 ; j < toArray.length;j++)
        {
             var id_ =  toArray[j].id.substr(3);
             var cbx_obj = document.getElementById("cbx_" +  id_);
             if (cbx_obj != null && cbx_obj.checked == true)
             {
                 str_ += id_ + ",";
             }
            
        } 
        toArray = $( "#sortable li:not(.ui-state-disabled)" );
       
        for(var j=0 ; j < toArray.length;j++)
        {
            var id_ =  toArray[j].id.substr(3);
             var cbx_obj = document.getElementById("cbx_" +  id_);
             if (cbx_obj != null && cbx_obj.checked == true)
             {
                 str_ += id_ + ",";
             }
            
        } 

        return  str_;

    }
    function get_sum_col() {
        var str_ = "";
        //合计列
        for (var j = 0; j < column1.length; j++) {
            if (j == column1.length - 1) {
                str_ += "Round(SUM(" + column1[j][1] + ")," +  column1[j][3] +") as " + column1[j][1];
            }
            else {
                str_ += "Round(SUM(" + column1[j][1] + ")," +  column1[j][3] +") as " + column1[j][1] + " ,";
            }
        }
        return str_;
    }
    function get_con() {
        <%if (dt_a404.Rows[0]["if_con"].ToString() != "1")
  { 
  %>
     return "";
  <%
  }
  %>
        var str_ = "";
        var date_col = $("#date_col").val();
        var from =  $("#from").val();
        var to =  $("#to").val();
        str_ = " AND (" + date_col  + " >= to_date('"+ from+"','yyyy-mm-dd')";
        str_ += "  AND " + date_col  + " <= to_date('"+ to+"','yyyy-mm-dd'))";

        //固定分组列
        for (var j = 0; j < column2.length; j++) {
            var cbx_obj = document.getElementById("cbx_" + column2[j][1]);
            if (cbx_obj != null && cbx_obj.checked == true) {
                var v_obj = document.getElementById("v_" + column2[j][1]);
                if (v_obj != null) {
                    var v_ = v_obj.value;
                    if (v_ != null && v_obj.value != "") {
                        str_ += " AND " + column2[j][1] + "='" + v_obj.value + "'";
                    }
                }
            }
        }
        //选择的分组列
        for (var j = 0; j < column0.length; j++) {
            var cbx_obj = document.getElementById("cbx_" + column0[j][1]);
            if (cbx_obj != null && cbx_obj.checked == true) {
                var v_obj = document.getElementById("v_" + column0[j][1]);
                if (v_obj != null) {
                    var v_ = v_obj.value;
                    if (v_ != null && v_obj.value != "") {
                        str_ += " AND " + column0[j][1] + "='" + v_obj.value + "'";
                    }
                }
            }
        }
        return str_;


    }
    function get_li_html(col_id_,col_name_,v_,type_)
    {
        var lihtml_=  "<li class=\"ui-state-default\" id=\"li_"+ col_id_+"\"> ";
        if (v_ != "")
        {
             lihtml_= "<li class=\"ui-state-default ui-state-disabled\" id=\"li_"+ col_id_+"\"> ";
        }
            lihtml_ += " <table><tr><td style=\"width:5%;\"> ";
            if (type_ == "2") //固定分组列
            {
                 lihtml_ += "<input disabled type=checkbox value=\"1\" checked id=\"cbx_" + col_id_ + "\"/>";              
            }
            else
            {            
                if (v_ != "" && v_ != null)
                {
                     lihtml_ += "<input disabled type=checkbox value=\"1\" checked id=\"cbx_" + col_id_ + "\"/>";              
                }
                else
                {
                     lihtml_ += "<input  type=checkbox value=\"0\"  id=\"cbx_" + col_id_ + "\"/>";              
                }
            }
            lihtml_ += "</td>";
            lihtml_ += "<td style=\"width:40%;\">"+ col_name_ +"</td>" ;
            lihtml_ += "<td style=\"width:50%;\">";
            if (v_ != "" && v_ != null)
            {
                    lihtml_ += "=<input  type=\"text\" disabled  value=\"" + v_ + "\"  id=\"v_" + col_id_ + "\"/>";          
            }
            else
            {
                    lihtml_ += "<input  type=\"hidden\"   value=\"\"  id=\"v_" + col_id_ + "\"/>";
            }
           
            lihtml_ += "</td></tr></table>";
            lihtml_ +="</li>";
       return  lihtml_;
    }
    function show_query(rowstr,divid_) {
        var id_ = "t100";
        if ( $("#" + id_).length > 0)
        {
             $("#" + id_).remove();
        }
        var barHtml = '<div  data-role="dialog" id="' + id_ + '">';
        var slist = set_row_data(rowstr);
        barHtml += "<ul id=\"sortable\">"
        var nullhtml="";
        for( k = 0;k< slist.length;k++ )
        {
             if (slist[k][1] != "")
             {
               for (var j = 0; j < column2.length; j++) {
                if  (slist[k][0] == column2[j][1])
                {
                      barHtml += get_li_html(column2[j][1],column2[j][2] ,slist[k][1],'2'); 
                      break;
                }
               } 
              for (var j = 0; j < column0.length; j++) {
                if  (slist[k][0] == column0[j][1])
                {
                      barHtml += get_li_html(column0[j][1],column0[j][2] ,slist[k][1],'0'); 
                      break;
                }
               } 


             }               
          
        
        }

        for (var j = 0; j < column2.length; j++) {
                var v_ = get_item_value(slist, column2[j][1]);
                if (v_ != "") {
                    barHtml += "";                     
                } 
                else 
                {
                    nullhtml += get_li_html(column2[j][1],column2[j][2] ,v_,'2');
                }                 
    
        }
        for (var j = 0; j < column0.length; j++) {
               var v_ = get_item_value(slist, column0[j][1]);
            if (v_ != "") {
                barHtml += "";                     
            }  
             else 
            {
                nullhtml += get_li_html(column0[j][1],column0[j][2] ,v_,'0');
            }  
    
        }

        barHtml += nullhtml;

        barHtml += "</ul>"

        barHtml += '</div>';
        var bodywidth = $('body').width();
        var div_width_ = 400;
        var div_height_ = 400;
        var dialog = $(barHtml).hide();
        var div_left_ = (bodywidth - div_width_) / 2;
        var div_top_ = 100;
        var dialogOptions = {
            bgiframe: true,
            height: div_height_,
            width: div_width_,
            minHeight: 100,
            minWidth: 100,
            title: "维度",
            draggable: true,
            resizable: true,
            buttons: {
                "确定": function () {
                    show_data(rowstr,divid_);
                    $(this).dialog("close");
                }
            }
        };
        $('body').append(dialog);
        // $("#" + id_).dialog('option', 'position', 'top');

        $("#" + id_).dialog(dialogOptions);

        $( "#sortable" ).sortable({
			placeholder: "ui-state-highlight"
		});
		

        $( "#sortable" ).sortable({
			items: "li:not(.ui-state-disabled)"
		});

		$( "#sortable" ).sortable({
			cancel: ".ui-state-disabled"
		});

        $( "#sortable" ).disableSelection();
    }

</script>

</html>

