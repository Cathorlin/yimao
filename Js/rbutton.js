var rb_head ="<table class=\"rb_table\" >";
rb_head +="<tr  class=\"rb_do\" id=\"tr_up0\" onclick=\"moverb('UP')\"><td><a>▲</a></td></tr>";
rb_head +="<tr  class=\"disable\" id=\"tr_up1\" ><td><a>▲</a></td></tr>";
rb_head +="</table>";
var systemtr = 3;
var rb_html= "<table class=\"rb_table\" >";
rb_html +="<tr  class=\"lines\"><td><div></div></td></tr>";
//rb_html += "<tr id=\"tr_sys0\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick=\"showback();\"><td><a>返回</a></tr>";
rb_html += "<tr id=\"tr_sys1\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick=\"location.reload();\" ><td ><a>刷新</a></tr>";
rb_html +="<tr class=\"lines\"><td><div></div></td></tr>";
rb_html +="</table>";

var rb_foot ="<table class=\"rb_table\" >";
rb_foot +="<tr  class=\"rb_do\"  id=\"tr_down0\" onclick=\"moverb('DOWN')\"><td><a>▼</a></td></tr>";
rb_foot +="<tr  class=\"disable\"  id=\"tr_down1\" ><td><a>▼</a></td></tr>";
rb_foot +="</table>";

function showback()
{
   var v = BasePage.getSession(a002_key + "_QUERY").value ;
   location.href= v;
}

function getCopyHtml(rowid__)
{
    var copy_html= "<table class=\"rb_table\" >";
        copy_html +="<tr  class=\"lines\"><td><div></div></td></tr>";
        copy_html += "<tr id=\"tr_sys3\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick=\"CopyRow('"+rowid__+"');\"><td><a>复制对象</a></tr>";
       var a20001_key____ = rowid__.split("_")[0];
       var v = BasePage.getSession("COPY_" + a20001_key____,"000000").value;
       if (v != "")
       {
              var row ;
              for(var i = 0 ;i < rowList.length ;i++ )
              {
                    if (rowList[i][0] == rowid__)
                    {
                        row = rowList[i] ;
                        break ;
                    }
              }
             
              //判断是否是新增行
              if ( row[2] == "I")
              {
                 copy_html += "<tr id=\"tr_sys4\" class=\"rb_do\" onmousemove=\"move(this,'m');\" onmouseout=\"move(this,'o');\" onclick=\"PasteRow('"+ rowid__ +"');\" ><td ><a>粘贴对象</a></tr>";

              } 
              else
              {
                 copy_html += "<tr id=\"tr_sys4\" class=\"disable\"><td ><a>粘贴对象</a></tr>";
              }
       
       
       }
       else
       {

       
          copy_html += "<tr id=\"tr_sys4\" class=\"disable\"><td ><a>粘贴对象</a></tr>";

       } 
        copy_html +="<tr class=\"lines\"><td><div></div></td></tr>";
        copy_html +="</table>";

    return copy_html;
}

function getSysRbHtml()
{
    return   rb_html ;
}

function showtxt()
{
    location.replace("view-source:"+location);
}



function move(obj,mo)
{
 if (mo=='m') obj.className='m_blue' ;
 if (mo=='o') obj.className='m_white' ;
 if (mo=='l') obj.className='m_disable'
 return true;
}
var showtrcount = 16;
var currtr = 0 ;
var trallcount = 0;

function moverb(type_)
{

    if (trallcount + systemtr <=showtrcount)
    {
        document.getElementById("tr_up0").style.display ="none";
        document.getElementById("tr_up1").style.display ="none";
        document.getElementById("tr_down0").style.display ="none";
        document.getElementById("tr_down1").style.display ="none";   
        return;
    }   
        
    if (type_ == 'UP')
    {
        currtr = currtr - 1 ;
    }
    if (type_ == 'DOWN') 
    {
        currtr = currtr + 1 ;
    }  
    if (currtr  <=  0 )
    {
        document.getElementById("tr_up0").style.display ="none";
        document.getElementById("tr_up1").style.display ="";
        currtr =  0 ;
    }
    else
    {
        document.getElementById("tr_up0").style.display ="";
        document.getElementById("tr_up1").style.display ="none";
        
    }
    var max_tr = trallcount - (showtrcount -  systemtr) ;
    if (currtr  >=  max_tr )
    {
        currtr = max_tr ;
        document.getElementById("tr_down0").style.display ="none";
        document.getElementById("tr_down1").style.display ="";        
    }
    else
    {
        document.getElementById("tr_down0").style.display ="";
        document.getElementById("tr_down1").style.display ="none";
    }
    
    for(var i= 0 ;i< trallcount ; i++)
    {
        obj  = document.getElementById("tr" + String(i));
        if (obj == null)
        {
            break;
        }
        if (i>= currtr  &&    i <  currtr + showtrcount -  systemtr  )
        {
            obj.style.display ="";
        }
        else
        {
             obj.style.display ="none";
        }        
    }
    
    for(var i= 0 ;i< systemtr ; i++)
    {
        obj  = document.getElementById("tr_sys" + String(i));
        if (obj == null)
        {
            break;
        }
        if (  i + trallcount  >= currtr  &&    i + trallcount  <  currtr +showtrcount )
        {
            obj.style.display ="";
        }
        else
        {
             obj.style.display ="none";
        }        
    }

}