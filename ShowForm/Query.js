// JScript 文件

var A10001_LIST = new Array();
var ifchoose ="0";
function adda10001(a10001_key,column_id,col_type)
{
    var len = A10001_LIST.length;
    var row = new Array();
    row[0] = a10001_key;
    row[1] = "like"; //符号
    row[2] = "" ; //值

    row[3] = column_id;
    row[4] = col_type;
    A10001_LIST[len] = row;
}
//全选

function selectqueryall( obj , a10001_key)
{
    var v= obj.value;
     objlist = document.getElementsByName("value"+ a10001_key) ;

     for (var r = 0 ; r < objlist.length ;r++ )
     {
             if (objlist[r].type == "checkbox")
             {
                if  (v == "0")
                {

                objlist[r].checked = true ;
                }
                else
                {
                      objlist[r].checked = false ;
                }
             }

         
     }
     if (v=="0")
     {
        obj.value = "1";
     }
     else
     {
        obj.value = "0" ;
     }
     
}
function clear_conditon()
{
    for(var i=0;i< A10001_LIST.length;i++)
    {
         var a10001_key = A10001_LIST[i][0];         
         var all_obj = document.getElementById("all" +a10001_key); 
         if (all_obj != null)
         {
            all_obj.value ="0";
            all_obj.checked = false ;
         }  
         clearitem(a10001_key);
    
    }
    
}
//根据查询的编码显示查询

function show_condition(select_obj)
{
    

    clear_conditon();
    query_id= select_obj.options[select_obj.selectedIndex].value;
    var column_id;
    var column_i;
     var obj_select;
    if (query_id != "")
    {
        var sql = "Select t.* from A006 t  where user_id='" + A007_KEY + "' AND query_id  ='" +  query_id  + "'and table_id='"+ table_id +"' and menu_id='" + menu_id +"'" ;
       var dt =  BasePage.getDtBySql(sql).value;
       
       SetItemByxml(dt);
    }
}
function SetItemByxml(dt)
{

    for(var i=0 ;i<dt.Rows.length;i++ )
    {
         a10001_key = dt.Rows[i]["COL_NAME"];
         CALC =  dt.Rows[i]["COL_RELA"];

         col_type =  dt.Rows[i]["COL_TYPE"];
         col_sort =   dt.Rows[i]["COL_SORT"];
         obj_select = document.getElementById("CALC" + a10001_key);
        if   ( obj_select != null)
         {
             for(var j=0;j< obj_select.options.length ;j++ )
             {
                if (obj_select.options[j].value== CALC)
                {
                    obj_select.selectedIndex = j;
                    break;
                }
             }
         }

         
            obj_sort = document.getElementById("sort_" + a10001_key);
            if   ( obj_sort != null)
             {
             
                 for(var j=0;j< obj_sort.options.length ;j++ )
                 {
                    if (obj_sort.options[j].value == col_sort)
                    {
                        obj_sort.selectedIndex = j;
                        break;
                    }
                 }
             }
        
         objlist = document.getElementsByName("value"+ a10001_key) ;
         vlist  = dt.Rows[i]["COL_VALUE"];
         if (vlist == "" || vlist== null)
         {
            continue;
         }
         if (objlist.length == 0)
         {
            continue;
         }
  
         if  (CALC == "SQL"  )
         {
            calc_change(obj_select);
            document.getElementById("vsql_" + a10001_key).value = vlist;
            continue;
         }
         
         
         for (var r = 0 ; r < objlist.length ;r++ )
         {
             if (objlist[r].type == "checkbox")
             {
                if (vlist.indexOf(objlist[r].value + "|") >=0)
                {
                     objlist[r].checked = true ;
                }
                else
                {
                     objlist[r].checked = false ;
                }
               
             }   
             if (objlist[r].type == "text")
             {
                if (CALC == "BETWEEN" && ( col_type =="date" ||  col_type =="datetime"  ) )
                {
                    var vv =vlist.split("|");
                    objlist[r].value = vv[r] ;
                }
                else
                {
                    if (CALC == "BETWEEN" )
                    {
                        vo = s_replace(vlist,'|','..') ;         
                        objlist[r].value = vo.substr(0,vo.length -2) ;   
                        objlist[r].style.color = "red";
                    }
                    else
                    {
                       objlist[r].value = s_replace(vlist,'|','') ;
                       objlist[r].style.color = "red";
                    }
                }
             }              
         }
    }
}

function delete_conditon( )
{
   var select_obj = document.getElementById("Select_query");
   var  query_id= select_obj.options[select_obj.selectedIndex].value;
   var query_text = select_obj.options[select_obj.selectedIndex].text;
    var column_id;
    var column_i;
    //从数据库中提取数据

    if (query_id != "")
    {
       var v =  BasePage.execsql("delete from  A006  where query_id='" + query_id + "'").value;
       if (v== "0")
       {
            for(i=0;i<select_obj.options.length;i++)
            {
                v = select_obj.options[i].value;
                if (v == query_id)
                {
                    select_obj.remove(i);
                    select_obj.selectedIndex =0;
                    break;
                
                }
            
                
            }
         alert("删除查询（"+query_text+"）成功！");
        }
       else
       {
         alert(v);
       }
    }
   

}
function cancel_window()
{
      window.close();  
}
function get_condition()
{
    //保存最近的查询
      query_id  ="最近的查询";
      var a006_key = save_condition(query_id);
      if (ifchoose=="0")
      {
          var   v   =   new   Object();   
          v.DataId  =   a006_key;   
          v.condition  = "0"; 
          v.Para    =   window.dialogArguments;      
          window.returnValue   =   v;   
          window.close();  
      }
}
function save_()
{
    var query_id_obj = document.getElementById("query_id");
    if (query_id_obj.value =="")
    {
        alert("请输入保存的查询名称！");
        query_id_obj.focus();
        return ;
    }
        query_id  = query_id_obj.value ;
    //判断名称是否存在
     var select_obj = document.getElementById("Select_query");
     var if_exist='0';
     for(i=0;i<select_obj.options.length;i++)
     {
            var this_v = select_obj.options[i].text;
            if (this_v == query_id)
            {
                if_exist ='1';
                break;
            
            }
 
     }
     if (if_exist=='1')
     {
           
          alert("保存的查询名称"+ query_id +"已经存在！");
          return  ;
     }
    
    
   var v =  save_condition(query_id);

   if (v  == query_id )
   {
       alert("保存查询（"+query_id+"）成功！");
   }
   else
   {
        if (v== "-100")
        {
            alert("没有条件，无需保存");
            return  ;
        }
       alert("保存查询（"+query_id+"）失败！");
       return  ;
   }
   
       if_exist='0';
        for(i=0;i<select_obj.options.length;i++)
        {
            var this_v = select_obj.options[i].value;
            if (this_v == query_id)
            {
                if_exist ='1';
                break;
            
            }
        
            
        }
        if (if_exist=='0')
        {
             fnAdd(select_obj,v,query_id);
        }
}
function calc_change(obj)
{
     var a10001_key__ = obj.id.substr(4);
    if (obj.options[obj.selectedIndex].value == "SQL")
    {
       document.getElementById("input_" +a10001_key__).style.display = "none" ;    
       document.getElementById("inputsql_" +a10001_key__).style.display = "" ; 
    }
    else
    {
        document.getElementById("input_" +a10001_key__).style.display = "" ;    
        document.getElementById("inputsql_" +a10001_key__).style.display = "none" ; 
    }
}
function clearitem(a10001_key__)
{
     var all_obj = document.getElementById("all" +a10001_key__); 
     if (all_obj != null)
     {
        all_obj.value ="0";
        all_obj.checked = false ;
     }  
     obj_select= document.getElementById("CALC" +a10001_key__);    
     obj_select.selectedIndex =0;
     calc_change(obj_select);
  
     obj_select= document.getElementById("sort_" +a10001_key__);  
     obj_select.selectedIndex =0;
     
   
     objlist = document.getElementsByName("value"+ a10001_key__) ;
        
     for (var r = 0 ; r < objlist.length ;r++ )
     {
         if (objlist[r].type == "checkbox")
         {
            objlist[r].checked = false ;
         }   
         if (objlist[r].type == "text")
         {
            objlist[r].value = "" ;
         }              
     }    
    document.getElementById("vsql_" +a10001_key__).value = "";  

}
function save_condition( query_id_ )
{
    var str_v =  formatxml() ;  
    var  v_all = 0; 
    for(var i=0;i< A10001_LIST.length;i++)
    {
         var a10001_key = A10001_LIST[i][0];         
         var all_obj = document.getElementById("all" +a10001_key); 
         if (all_obj != null)
         {
            all_obj.value ="0";
            all_obj.checked = false ;
         }  
         obj_select= document.getElementById("CALC" +a10001_key);    
          obj_sort= document.getElementById("sort_" +a10001_key);  
        var vcount  = false ;
        var rowxml = "" ;
        var COL_TYPE = A10001_LIST[i][4] ;
         objlist = document.getElementsByName("value"+ a10001_key) ;
         rowxml +=  "<ROW>";
         rowxml +=  "<A10001_KEY>"+A10001_LIST[i][0] +"</A10001_KEY>";
         rowxml +=  "<COLUMN_ID>"+A10001_LIST[i][3] +"</COLUMN_ID>";
         rowxml +=  "<COL_TYPE>"+A10001_LIST[i][4] +"</COL_TYPE>";
         rowxml +=  "<CALC>"+ obj_select.options[obj_select.selectedIndex].value +"</CALC>";
         rowxml +=  "<SORT>"+ obj_sort.options[obj_sort.selectedIndex].value +"</SORT>";  
         if (obj_sort.selectedIndex > 0 )
         {
            vcount = true ; 
         }   
         v ="" ;
         rowxml += "<VALUE>";
          var calc_v = obj_select.options[obj_select.selectedIndex].value;
          if (calc_v== "SQL" )
          { /*判断有没有值*/
            var sql_v  = document.getElementById("vsql_"+a10001_key).value;
            if (sql_v != "")
            {
                vcount = true ;
                rowxml +=  sql_v ;
            }
            
          }
          else
          {
             for (var r = 0 ; r < objlist.length ;r++ )
             {
                     
                 if (objlist[r].type == "checkbox")
                 {
                    if  (objlist[r].checked == true)
                    {
                        rowxml += objlist[r].value + "|";
                        vcount = true ; 
                    }
                 }   
                 if (objlist[r].type == "text")
                 {
                    if (objlist[r].value != ""  || calc_v ==  "BETWEEN")
                    {
                        rowxml += objlist[r].value + "|"  ;
                        if  (objlist[r].value != "" )
                        {
                            vcount = true ;
                        }  
                    }                 
                 }              
             }
             if (calc_v ==  "BETWEEN" )
             {
                rowxml = s_replace(rowxml,'..','|'); 
             }
         }    
         rowxml += "</VALUE>";
         rowxml += "</ROW>";         
         
         if (vcount == true)
         {
            v_all = v_all+ 1 ;
            str_v+= rowxml;
         }
    
    }
    str_v +=  endformatxml();
    if (v_all  > 0)
    {
        var v = BasePage.SaveA006(a00201_key,query_id_,str_v).value;
    /*把对应的条件xml存放到数据库中*/
        return v ;
    }
    else
    {
        return  "-100" ;
    }

}