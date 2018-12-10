<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MenuLeft.aspx.cs" Inherits="MenuLeft" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>menu</title>
<link rel="stylesheet" href="skin/css/base.css" type="text/css" />
<link rel="stylesheet" href="skin/css/menu.css" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<script language='javascript'>var curopenItem = '1';</script>
<script language="javascript" type="text/javascript" src="skin/js/frame/menu.js"></script>
<SCRIPT language=JavaScript>
var old_idt="";
var old_idstr ="";
function tupian(idt){
    var nametu="xiaotu"+idt;
    var tp = document.getElementById(nametu);
    tp.src="../images/ico05.gif";//图片ico04为白色的正方形
	if (idt != old_idt)
	{
	  var tp2=document.getElementById('xiaotu'+old_idt);
	  if(tp2!=undefined)
	    {tp2.src="../images/ico06.gif";}//图片ico06为蓝色的正方形 
	    old_idt = idt;
	 }
	/*
	for(var i=1;i<30;i++)
	{
	  
	  var nametu2="xiaotu"+i;
	  if(i!=idt*1)
	  {
	    var tp2=document.getElementById('xiaotu'+i);
		if(tp2!=undefined)
	    {tp2.src="../images/ico06.gif";}//图片ico06为蓝色的正方形
	  }
	}
	*/
}

function list(idstr){
	var name1="subtree"+idstr;
	var name2="img"+idstr;
	var objectobj=document.all(name1);
	var imgobj=document.all(name2);
	


	if (old_idstr == idstr)
	{
	    if(objectobj.style.display=="none")
            {
                objectobj.style.display="";
	            imgobj.src="../images/ico03.gif";


            }
            else
            {
            	objectobj.style.display="none";
	          	imgobj.src="../images/ico04.gif";
                
            }	
	    		
	    old_idstr =idstr; 
	}
	else
	{   
		objectobj.style.display="";
		imgobj.src="../images/ico03.gif";
	    var name3="img"+old_idstr;
			var name="subtree"+old_idstr;
			var o=document.all(name);
			if(o!=undefined){
			
					o.style.display="none";
				var image=document.all(name3);
				//alert(image);
				image.src="../images/ico04.gif";
			
			}
	
	
	}

    old_idstr =idstr; 
}
function showmenu(menu_id,menu_name)
{
    parent.main.addtab(menu_id, menu_name);
}
function myheight() {
    return  document.documentElement.clientHeight;
}
function setmainh() {
    try
    {
     parent.main.setH();
    }catch(e)
    {}
}

function showtree()
{
    obj = document.getElementById("div_tree" );
    if ( obj.style.display =="")
    {
        obj.style.display ="none";
    }
    else
    {
        obj.style.display =""
    }
    obj = document.getElementById("table_tree" );
    if ( obj.style.display =="")
    {
        obj.style.display ="none";
    }
    else
    {
         obj.style.display ="";
    }
}
</SCRIPT>
</head>
<body scroll= auto class="bodystyle">
<form runat=server>
<table width='100%' class="menuleftstyle" height="100%" border='0' cellspacing='0' cellpadding='0'>
  <tr>
    <td style='padding-left:2px;padding-top:8px' valign="top">
     <%
         string parend_id = "00";
          for (int i = 0; i < dt_all.Rows.Count; i++)
          {
              string menu_id_ = dt_all.Rows[i]["menu_id"].ToString();
              string parend_id_ = dt_all.Rows[i]["parent_id"].ToString();
              if (parend_id_ != parend_id )
              {
                  continue;
              }
            string menu_name_ = dt_all.Rows[i]["show_name"].ToString();           
   %>      <dl class='bitem'>
           <dt onClick='showHide("items<%=menu_id_%>")'><b style="margin-left:4px;"> <%=menu_name_%></b><img src="skin/images/frame/a1.png" style="float:right;margin-top:7px;margin-right:10px;"/></dt>
           <dd style='display:none' class='sitem' name="items"  id='items<%=menu_id_%>'>
           <ul class='sitemu'>
           <% for (int j = 0; j < dt_all.Rows.Count; j++)
             {
                string parend_id__ = dt_all.Rows[j]["parent_id"].ToString();

                if (menu_id_ != parend_id__)
                {
                    continue;
                }
                string menu_id___ = dt_all.Rows[j]["menu_id"].ToString();
                string a002_key___ = dt_all.Rows[j]["a002_key"].ToString();
                string menu_name___ = dt_all.Rows[j]["show_name"].ToString();
                string last_level___ = dt_all.Rows[j]["LAST_LEVEL"].ToString();

                if (last_level___ == "1")
                {          
              %>  <li class="item0">
                    <div style="text-align:left;margin : 0 0 0 0;" >
                          <a  style="text-align:left;margin:0;" title="<%=a002_key___%>|<%=menu_name___ %>"  href="javascript:showmenu('<%=a002_key___%>','<%=menu_name___ %>')"  ><%=menu_name___%></a>
                    </div> 
                  </li>
                  <%}
                   else
                   { 
                   %>
                  <li class="title0" onclick="showChild('items<%=menu_id___ %>')">
                   <div style="text-align:left;margin:0;">
                      <a  style="text-align:left;margin:0;" title="<%=menu_id___%>|<%=menu_name___ %>"><%=menu_name___%></a>
                   </div> 
                  </li>     
                    <%  int num = 0;
                       //dt_child_child = Fun.getDtBySql(sql.Replace("[PARENT_ID]", menu_id___));
                     for (int k = 0; k < dt_all.Rows.Count; k++)
                     {
                         string parend_id___ = dt_all.Rows[k]["parent_id"].ToString();
                         if (parend_id___ != menu_id___)
                         {
                             continue;
                         }
                         string menu_id____ = dt_all.Rows[k]["a002_key"].ToString();
                         string menu_name____ = dt_all.Rows[k]["show_name"].ToString();
                                  string last_level____ = dt_all.Rows[k]["LAST_LEVEL"].ToString();
                                  if (last_level____ == "1")
                                  {  
                     %> <li class="item1" style='display:none' id="items<%=menu_id___ %>_<%=num%>" name="items<%=menu_id___ %>">
                        <div style="text-align:left;">
                          <a title="<%=menu_id____%>|<%=menu_name____ %>" href="javascript:showmenu('<%=menu_id____%>','<%=menu_name____ %>')"  ><%=menu_name____%></a>
                        </div> 
                        </li>                         
                     <%
}
                                  else
                                  {
                                      menu_id____ = dt_all.Rows[k]["menu_id"].ToString();
                                  %>
                                  <li class="title1" style='display:none;' v="<%=menu_id____ %>" id="items<%=menu_id___ %>_<%=num%>" name="items<%=menu_id___ %>"  onclick="showChild('items<%=menu_id____%>')">
                                    <div style="text-align:left;">
                                    <a title="<%=menu_id____%>|<%=menu_name____ %>"><%=menu_name____%></a>
                                    </div> 
                                  </li> 
                                  <% int pp =  -1;
                                     
                                    for (int p = 0; p < dt_all.Rows.Count; p++)
                                    {
                                        string parend_id____ = dt_all.Rows[p]["parent_id"].ToString();
                                        if (parend_id____ != menu_id____)
                                        {
                                            continue;
                                        }
                                        pp = pp + 1;
                                        string menu_id_____ = dt_all.Rows[p]["a002_key"].ToString();
                                        string menu_name_____ = dt_all.Rows[p]["show_name"].ToString();
                                                  
                                   %> 
                                    <li class="item2" style='display:none;'  id="items<%=menu_id____ %>_<%=pp%>" name="items<%=menu_id____ %>">
                                    <div style="text-align:left;">
                                    <a title="<%=menu_id_____%>|<%=menu_name_____ %>" href="javascript:showmenu('<%=menu_id_____%>','<%=menu_name_____ %>')"  ><%=menu_name_____%></a>
                                    </div> 
                                    </li>
                                    <%}                                      
                                    %>
                                   
                                  <%}
                                           
                         num = num + 1;
                     }%>
                   <%
                   
                   }   
               }             
            %>
           </ul>
           </dd>
           </dl>
        <% 
          }
       %>

	  </td>
  </tr>
  
</table>
</form>

</body>

<script>
    setmainh();
</script>
</html>

