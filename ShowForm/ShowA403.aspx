<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ShowA403.aspx.cs" Inherits="ShowForm_ShowA403" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
<title>编辑 - <%=dt_a403.Rows[0]["A403_NAME"].ToString()%></title>
<link  href="../jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
<link  href="../Css/BasePage.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../jquery-ui-1.10.3/jquery-1.9.1.js"></script>
<script  src="../jquery-ui-1.10.3/ui/jquery-ui.js"></script>
<script src="../js/http.js"></script>
<script src="../js/BasePage.js"></script>
 <style>
 .ui-dialog {
	position: absolute;
	top: 0;
	left: 0;
	padding: .2em;
	outline: 0;
}
.ui-dialog .ui-dialog-titlebar {
	padding: .4em 1em;
	position: relative;
}
.ui-dialog .ui-dialog-title {
	float: left;
	margin: .1em 0;
	white-space: nowrap;
	width: 90%;
	overflow: hidden;
	text-overflow: ellipsis;
}
.ui-dialog .ui-dialog-titlebar-close {
	position: absolute;
	right: .3em;
	top: 50%;
	width: 21px;
	margin: -10px 0 0 0;
	padding: 1px;
	height: 20px;
}
.ui-dialog .ui-dialog-content {
	position: relative;
	border: 0;
	padding: .5em 1em;
	background: none;
	overflow: auto;
}
.ui-dialog .ui-dialog-buttonpane {
	text-align: left;
	border-width: 1px 0 0 0;
	background-image: none;
	margin-top: .5em;
	padding: .3em 1em .5em .4em;
}
.ui-dialog .ui-dialog-buttonpane .ui-dialog-buttonset {
	float: right;
}
.ui-dialog .ui-dialog-buttonpane button {
	margin: .5em .4em .5em 0;
	cursor: pointer;
}
.ui-dialog .ui-resizable-se {
	width: 12px;
	height: 12px;
	right: -5px;
	bottom: -5px;
	background-position: 16px 16px;
}
.ui-dialog-titlebar { display:; } 
.test
  {
     color:Red;     
  }
 .ui-dialog {
    font-size: 12px;
  }
  </style>
  <%
      
    %>
<script language=javascript>
    var main_width = "<%=dt_a403.Rows[0]["div_width"].ToString() %>";
    var main_height = "<%=dt_a403.Rows[0]["div_height"].ToString() %>";
    var max_line_no = 0;
    var list_  = new Array();
    var newlist_ = new Array();
    data_index = "<%=GlobeAtt.DATA_INDEX %>";
    function show_div(id_, width_ ,height_, left_ , top_ , div_html_,title_,dotype_,lineno_,objid_)
    {
     var barHtml = '<div data-role="dialog" id="' + id_ + '">';
         barHtml += div_html_ ;
         barHtml += '</div>';
     var bodywidth =  $('body').width(); 
 
     var bodyheight =  getPheight() - $("#btable").height() - 5;  
     var div_width_ =  Math.round( parseFloat(width_) * bodywidth / 100,0) ;
     var div_height_ = Math.round(parseFloat(height_) * bodyheight / 100,0) ;
     var div_left_  =  Math.round(parseFloat(left_) * bodywidth / 100  ,0) ;
     var div_top_  = $("#btable").height()+ $("#btable").position().top  + 5  +   Math.round(parseFloat(top_) * bodyheight / 100,0) ;
     var dialog = $(barHtml).hide();
    
     var dialogOptions ={
                bgiframe: true,
                height: div_height_,
                width: div_width_,
                position: [div_left_, div_top_],
                modal: false,
                closeOnEscape: false,
                minHeight:0,
                minWidth:0,
                dialogClass: 'test',
                title: title_,
                dotype: dotype_, //操作类型
                lineno: lineno_, //行的关键字
                objid : objid_,  //行的objid
                draggable: true, //拖动
                resizable: true, //调整大小
                overlay: {
                    backgroundColor: '#000',
                    opacity: 0.5
                },
                beforeClose: function () {
                    set_del_type(this);
                    return true;
                },
                open: function () {

                } //,
                //                  show: {
                //                      effect: "blind",
                //                      duration: 5000
                //                  },
                //                  hide: {
                //                      effect: "explode",
                //                      duration: 1000
                //                  }

            } ;
       $('body').append(dialog);
       $("#" + id_).dialog(dialogOptions);
       var showid = new Array();
        showid[0] = id_;
        showid[1] = dialogOptions;
       var if_exists = false ;
       for (var i=0;i < list_.length ;i++)
       {
            if  (showid[0] ==  list_[0][0])    
            {
                if_exists = true;
                break;
            }
            
       }
       if ( if_exists == false)
       {
          list_[list_.length] = showid ;
       }
    }
    function save_div()
    {
          var parm = formatparm();
            parm = addParm(parm, "A002ID", "");
            parm = addParm(parm, "A00201KEY", "0");
            parm = addParm(parm, "REQID", "SAVE_A403"); 
            parm = addParm(parm, "KEY", "<%=a403_id %>");
             parm = parm + "<ROWDATA>";
     var bodywidth =  $('body').width();  
     var bodyheight =  getPheight() - $("#btable").height() - 5;  
  
        for(var i=0;i < list_.length;i++)
        {            
            //
            if ( list_[i][1].dotype == "I")
            {
                max_line_no = max_line_no + 1;
                list_[i][1].lineno = max_line_no ;                
            }
            //记录长 宽 左边的坐标 右边的坐标
            var w = $("#" + list_[i][0]).dialog('option', 'width') * 100 / bodywidth;
            var h = $("#" + list_[i][0]).dialog('option', 'height')  * 100 / bodyheight;
            x = $("#" + list_[i][0]).dialog('option', 'position');
            var l = x[0]  * 100 / bodywidth ; 
            var t = (x[1] - $("#btable").height() - 5   -  $("#btable").position().top )  * 100 / bodyheight  ;
            parm = parm + "<ROW>";             
            var rowlist = "OBJID|" + list_[i][1].objid + data_index; 
            rowlist += "DOACTION|" +  list_[i][1].dotype  + data_index; 
            rowlist += "A403_ID|" +  "<%=a403_id %>" + data_index; 
            rowlist += "LINE_NO|" +  list_[i][1].lineno + data_index; 
            rowlist += "DIV_WIDTH|" +  w  + data_index; 
            rowlist += "DIV_HEIGHT|" +  h  + data_index; 
            rowlist += "DIV_LEFT|" +  l  + data_index; 
            rowlist += "DIV_TOP|" +  t  + data_index;          
         
            parm = addParm(parm, "ROWID", list_[i][1].objid );
            parm = addParm(parm, "ROWLIST", rowlist);
            parm = addParm(parm, "I", i);         
            if ( list_[i][1].dotype == "I")
            {
                list_[i][1].dotype = 'M';
            }
            parm = parm + "</ROW>";
        }
        parm = parm + "</ROWDATA>";
        parm = addParm(parm, "URL", location.href);
        parm = parm + endformatparm(); 
        url = http_url + "/BaseForm/HtmlReq.aspx?ver=" + getClientDate();
        FunGetHttp(url, "div_req", parm); 
    }

    function add_div() {
        var id_ = 'I<%=a403_id %>-' + newlist_.length ;         
        show_div(id_,'20','30', '0','0', '','新增'+ id_,'I','0',"");
        newlist_[newlist_.length] = id_;
        return;
    }
    function set_del_type(obj)
    {
         for (var i=0;i < list_.length ;i++)
         {
             if ( list_[i][0] ==  obj.id)
             {
                list_[i][1].dotype = "D";
                break ;
             }
         }   
    }
    function saveattr(obj) {
        //记录长 宽 左边的坐标 右边的坐标
        var w = $("#" + obj.id).width();
        var h = $("#" + obj.id).height();
        x = $("#" + obj.id).position();
        var l = x.left;
        var t = x.top;
        var parm = formatparm();
        parm = addParm(parm, "A002ID", "");
        parm = addParm(parm, "A00201KEY", "0");
        parm = addParm(parm, "KEY", obj.id);
        parm = addParm(parm, "W", w);
        parm = addParm(parm, "H", h);
        parm = addParm(parm, "L", l);
        parm = addParm(parm, "T", t);
        parm = addParm(parm, "OPTION", "M");
        parm = addParm(parm, "VER", "");
        parm = addParm(parm, "ROWID", "");
        parm = addParm(parm, "URL", location.href);
        alert(parm);
        parm = parm + endformatparm();        

    }


</script>
</head>


<body  scroll=no>             
<table id="btable">
<tr>
<td>
 <input  type=button  style="width: 81px; height: 23px" value="添加块"  onclick="add_div()" />
 <input  type=button style="width: 81px; height: 23px" value="保存"  onclick="save_div()" />
</td>
</tr>
</table>  
 <% if (dt_a40301.Rows.Count > 0)
    {
        Response.Write("<script language=javascript>");
        Response.Write(Environment.NewLine);
        Response.Write("$(function () {");
        Response.Write(Environment.NewLine);
        for (int i = 0; i < dt_a40301.Rows.Count; i++)
        {

            string id_ = "M" + a403_id + "-" + dt_a40301.Rows[i]["line_no"].ToString();
            string width_ = dt_a40301.Rows[i]["DIV_WIDTH"].ToString();
            string height_ = dt_a40301.Rows[i]["DIV_HEIGHT"].ToString();
            string left_ = dt_a40301.Rows[i]["DIV_LEFT"].ToString();
            string top_ = dt_a40301.Rows[i]["DIV_TOP"].ToString();
            string div_html_ = dt_a40301.Rows[i]["SHOW_HTML"].ToString();
            div_html_ = div_html_.Replace("'", "\\'");
            string title_ = dt_a40301.Rows[i]["line_no"].ToString() +  "-"  + dt_a40301.Rows[i]["div_title"].ToString();
            string dojs = "show_div('" + id_ + "','" + width_ + "','" + height_ + "', '" + left_ + "','" + top_ + "', '" + div_html_ + "','" + title_ + "','M','" + dt_a40301.Rows[i]["line_no"].ToString() + "','" + dt_a40301.Rows[i]["objid"].ToString() + "');";
            //(id_, width_ ,height_, left_ , top_ , div_html_,title_)
            Response.Write(dojs);
            Response.Write(Environment.NewLine);
        }
        // border-bottom-color:Red;
        Response.Write("$(\"#btable\").css(\"border\",\"solid 1px #000000 \");");
        Response.Write(Environment.NewLine);
        Response.Write("$(\"#btable\").css(\"width\",\"100% \");");
        Response.Write(Environment.NewLine);

        Response.Write(" } );");
        Response.Write(Environment.NewLine);
        Response.Write("max_line_no=" + dt_a40301.Rows[dt_a40301.Rows.Count - 1]["line_no"].ToString() + ";");
        Response.Write(Environment.NewLine);

        Response.Write("</script>");
    }
   %>     
</body>


</html>
