// JScript 文件
var dt_cline ;
function setrbdt(a00201_key_)
{
   dt_cline  =  BasePage.getDtBySql("select t.*   from a00201_v02 t  where a00201_key ='"+a00201_key_ +"' order by sort_by").value ;
}
function get_rb_html__(v)
{
    var html_ = "";
    var html_m = "" ;//多行操作菜单
    try
    {
     if (dt_cline.Rows.length >  0 && v   != "" )
        {
            
            trallcount = dt_cline.Rows.length;
            for(var i=0 ;i < dt_cline.Rows.length;i++)
            {
              var name_ = dt_cline.Rows[i]["A014_NAME"];
              var id_  = dt_cline.Rows[i]["A014_ID"];
              var table__ = dt_cline.Rows[i]["TABLE_ID"];
              var if_first = dt_cline.Rows[i]["IF_FIRST"];
              var a00201_key____ =  dt_cline.Rows[i]["A00201_KEY"];
              if (if_first == "0" || if_first == "1")
              {
                  var v1 = BasePage.getStrBySql("select pkg_show.geta014Use('"+a00201_key____+"','"+ id_+"','"+ v  +"', '[USER_ID]') as c from dual ").value;
                  v1 = v1.split("<V></V>")[0];              
                  if (v1 == "0")
                  {  
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"disable\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'l');\" ><td><a>"+name_+"</a></tr>";
                  }
                  else
                  {
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick =\"doa014(this,'" + id_  + "','" +  v  + "','"+table__+"')\"><td><a >"+name_+"</a></tr>";
                  }
              }
              if ( if_first == "2")
              {
                  var v1 = BasePage.getStrBySql("select pkg_show.geta014Use('"+a00201_key____+"','"+ id_+"','"+ v  +"', '[USER_ID]') as c from dual ").value;
                  v2 = v1.split("<V></V>")[0];              
                  if (v2 == "0")
                  {  
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"disable\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'l');\" ><td ><a>"+name_+"</a></tr>";
                  }
                  else
                  {
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick =\"doa014(this,'" + id_  + "','" +  v + "','"+table__+"')\"><td><a >"+name_+"</a></tr>";
                  }
              }  
              
              if ( if_first == "3")
              {
                  var v1 = BasePage.getStrBySql("select pkg_show.geta014Use('"+a00201_key____+"','"+ id_+"','"+ v  +"', '[USER_ID]') as c from dual ").value;
                  v2 = v1.split("<V></V>")[0];              
                  if (v2 == "0")
                  {  
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"disable\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'l');\" ><td><a>"+name_+"</a></tr>";
                  }
                  else
                  {
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick =\"doa014(this,'" + id_  + "','" +  v + "','"+table__+"')\" ><td ><a >"+name_+"</a></tr>";
                  }
              }  
             if ( if_first == "4" || if_first == "5" )
              {
                  var v1 = BasePage.getStrBySql("select pkg_show.geta014Use('"+a00201_key____+"','"+ id_+"','"+ v  +"', '[USER_ID]') as c from dual ").value;
                  v2 = v1.split("<V></V>")[0];              
                  if (v2 == "0")
                  {  
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"disable\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'l');\" ><td><a>"+name_+"</a></tr>";
                  }
                  else
                  {
                       html_ += "<tr id=\"tr"+ String(i) +"\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick =\"showrbwindow(this,'" + id_  + "','" +  v + "','"+table__+"')\" ><td ><a >"+name_+"</a></tr>";
                  }
              }  
              if ( if_first == "7"  )
              {
                
                 var v1 = BasePage.getStrBySql("select pkg_show.geta014Use('"+a00201_key____+"','"+ id_+"','"+ v  +"', '[USER_ID]') as c from dual ").value;
                  v2 = v1.split("<V></V>")[0];              
                  if (v2 == "0")
                  {  
                       html_m += "<tr id=\"tr"+ String(i) +"\" class=\"disable\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'l');\" ><td><a>"+name_+"</a></tr>";
                  }
                  else
                  {
                       html_m += "<tr id=\"tr"+ String(i) +"\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick =\"doqueryrb(this,'" + id_  + "','" +  v + "','"+table__+"')\" ><td ><a >"+name_+"</a></tr>";
                  }
              }
              
               if ( if_first == "6"  )
               {
                  var v1 = BasePage.getStrBySql("select pkg_show.geta014Use('"+a00201_key____+"','"+ id_+"','"+ v  +"', '[USER_ID]') as c from dual ").value;
                  v2 = v1.split("<V></V>")[0];              
                  if (v2 == "0")
                  {  
                     html_ += "<tr id=\"tr"+ String(i) +"\" class=\"disable\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'l');\" ><td><a>"+name_+"</a></tr>";
                  }
                  else
                  {
                         var A014_SQL = dt_cline.Rows[i]["NEXT_DO"];
                         A014_SQL = replaceAll(A014_SQL,"[ROWID]",v);
                       
                         var v3 = BasePage.getStrBySql(A014_SQL).value;
                         var vlist__= v3.split("<V></V>"); 
                         url__ = vlist__[0]; 
                         menu_id__ = vlist__[1]; 
                         con__ = vlist__[2]; 
                         html_ += "<tr id=\"tr"+ String(i) +"\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\")  onclick =\"showtabwindow('"+url__+"','"+menu_id__+"','"+con__+"')\"><td ><a>"+ name_ +"</a></tr>";
                  }
               }   
              
            }

            if (html_m != "")
            {
                html_m = "<tr  class=\"lines\"><td><div></div></td></tr>"+ html_m+  "<tr  class=\"lines\"><td><div></div></td></tr>";
            }
            html_  =  "<table>"+ html_m + html_ +"</table>";
        }
    }
    catch(e)
    {
        //alert(e);
    }

    
    return  html_;
}
function getRbButton(ttid)
{
    //获取控件的右键
    var trobj;
    if  (ttid.tagName=="TR")
    {
        trobj = ttid;
    }
    var i = 0 ;
    trobj = ttid;
    while(trobj.tagName!="TD" && i < 20)
    {   
         trobj=trobj.parentElement;
         i = i + 1 ;
    }
   
    trobj=trobj.parentElement;
    var html_ = "";
    if (trobj == null)
    {
        html_ +=  getSysRbHtml()  
        return "";
    }
    if (trobj.id == null ||  trobj.id == "")
    {
         html_ +=  getSysRbHtml()  
        return "";
    }
    if (trobj.id.indexOf('row') != 0)
    {
        html_ +=  getSysRbHtml()  
        return "";
    }
    var rownum =     trobj.id.substr(3);
    var objid_ = document.getElementById('objid_'+rownum).value;
    html_ = get_rb_html__(objid_);   
    html_ +=  getSysRbHtml()  
    return html_;
}

 document.onmouseup = function(oEvent)
 { 
       
       if (!oEvent) oEvent=window.event;   
       source=event.srcElement;
       tt = source;
       var ifrb="0";
       while (tt = tt.offsetParent){
          if (tt.id=="div_show")
          {
            ifrb ="1";
            break;
          }
       }
       if (ifrb != "1")
       {
        DivClose();
       }
       if (oEvent.button==2 &&  if_showDialog=="0")
       {     
            document.body.style.cursor = 'wait ';
            source=event.srcElement;
            html_ = getRbButton(source);  
            if (html_ == "")  
                return;
            event_x_ = event.clientX;
            event_y_ = event.clientY;
        
            html_ =  rb_head  + html_ + rb_foot;
            alert_rbdiv(source,html_,'',200,event_x_,event_y_);  
            document.body.style.cursor="";
       }
      
  }
var  highlightcolor='#eafcd5';
var  clickcolor='#51b2f6';
function  changeto(){
source=event.srcElement;
if  (source.tagName=="TR"||source.tagName=="TABLE")
return;
while(source.tagName!="TD")
source=source.parentElement;
source=source.parentElement;
cs  =  source.children;
//alert(cs.length);
if  (cs[1].style.backgroundColor!=highlightcolor&&source.id!="nc"&&cs[1].style.backgroundColor!=clickcolor)
for(i=0;i<cs.length;i++){
	cs[i].style.backgroundColor=highlightcolor;
}
}

function  changeback(){
if  (event.fromElement.contains(event.toElement)||source.contains(event.toElement)||source.id=="nc")
return
if  (event.toElement!=source&&cs[1].style.backgroundColor!=clickcolor)
//source.style.backgroundColor=originalcolor
for(i=0;i<cs.length;i++){
	cs[i].style.backgroundColor="";
}
}

function  clickto(){
source=event.srcElement;
if  (source.tagName=="TR"||source.tagName=="TABLE")
return;
while(source.tagName!="TD")
source=source.parentElement;
source=source.parentElement;
cs  =  source.children;
//alert(cs.length);
if  (cs[1].style.backgroundColor!=clickcolor&&source.id!="nc")
for(i=0;i<cs.length;i++){
	cs[i].style.backgroundColor=clickcolor;
}
else
for(i=0;i<cs.length;i++){
	cs[i].style.backgroundColor="";
}
} 
  
  
  