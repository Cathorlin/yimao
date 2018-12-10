// JScript 文件

function clear_conditon()
{
    for(i=0;i<300;i++)
    {
        obj= document.getElementById("column" + String(i));
         if (obj == null) 
         {
            break;
         }   
         obj_select= document.getElementById("CALC" + String(i));    
         obj_select.selectedIndex =0;
         
         obj_v= document.getElementById("v_" + String(i));
         obj_v.value=""; 
         setitem(i,"");
    
    }
    
}
//选择日期
function rbselectchange(obj)
{
     line_no=obj.name.replace('SELECT_','');
     obj_ = document.getElementById("v_" + String(line_no));
     obj_.value= obj.value;
}
function selectchange(obj)
{
     line_no=obj.id.replace('SELECT_','');
     obj_ = document.getElementById("v_" + String(line_no));
     obj_.value= obj.value;
}
function selectDate_m(event,dt_obj)
{
     setday(dt_obj);
}
//根据查询的编码显示查询
function show_condition(select_obj)
{
    
 //   alert("dddd");
    clear_conditon();
    query_id= select_obj.options[select_obj.selectedIndex].value;
    var column_id;
    var column_i;
         var obj_select
    //从数据库中提取数据
    if (query_id != "")
    {
        var dt=BaseDoPage.getSqlData("Select * from A006 Where user_id='"+user_id+"' and query_id='"+query_id+"' and table_id='"+table_id+"' and menu_id='"+menu_id+"'").value;
        for (var i=0;i<dt.Rows.length;i++)
       {
          column_id = dt.Rows[i]["COL_NAME"]; 
          column_i = get_column_i(column_id);
          if (column_i  != "-1")
          {
            col_value = dt.Rows[i]["COL_VALUE"]; 
            col_rela = dt.Rows[i]["COL_RELA"]; 
            document.getElementById("v_" + column_i).value =  col_value; 
            
            setitem(column_i,col_value);
            
            obj_select = document.getElementById("CALC" + column_i);
            
             for(var j=0;j< obj_select.options.length ;j++ )
             {
                if (obj_select.options[j].value== col_rela)
                {
                    obj_select.selectedIndex = j;
                    break;
                }
             }
            
          }
        }
    }


}

function setitem(col_i,col_value)
{
      b = document.getElementById("v_" + col_i +"_b");
      if (b != null)
      {
        v= col_value;
        b.value = v.substring(0,v.indexOf('..'));
        document.getElementById("v_" + col_i +"_e").value = v.substring(v.indexOf('..') + 2, v.length);
      }
        s = document.getElementById("SELECT_" + col_i );
       if (s != null)
       {

        if (s.type =="radio")
        {
            obj_list= document.getElementsByName(s.id);              
            for (var i =0;i<obj_list.length;i++)
            {
            
                    if  (obj_list[i].value == col_value)
                    {
                         obj_list[i].checked=true;
                    
                    }
                    else
                    {
                         obj_list[i].checked=false;
                    }
                
            }
            
        
        }
        else
        {
            for (var i =0;i<s.options.length;i++)
            {
            
                    if  (s.options[i].value == col_value)
                    {
                         s.options[i].selected=true;
                    
                    }
                    else
                    {
                         s.options[i].selected=false;
                    }
                
        
            }
        }
       }

}



function get_column_i(column_id)
{
     obj_list =      document.getElementsByTagName("input");
	    for (var i =0;i<obj_list.length;i++)
	    {
	        if (obj_list[i].type=='hidden')
	        {
	            if (obj_list[i].value==column_id)
	            {
	                return obj_list[i].name;
	            }
	        
	        }
	    
	    }

    return "-1";
}
//保存条件
function save_condition()
{
    var query_id_obj = document.getElementById("query_id");
    if (query_id_obj.value =="")
    {
        alert("请输入保存的查询名称！");
        query_id_obj.focus();
    }
    else
    {   
        query_id = query_id_obj.value;
        save_= save_condition_(query_id);
        if (save_=="-1")
        {
            alert("保存查询（"+query_id+"）失败！");
        }
        else
        {
             alert("保存查询（"+query_id+"）成功！");
              var select_obj = document.getElementById("Select_query");
              var if_exist='0';
                for(i=0;i<select_obj.options.length;i++)
                {
                    v = select_obj.options[i].value;
                    if (v == query_id)
                    {
                        if_exist ='1';
                        break;
                    
                    }
                
                    
                }
                if (if_exist=='0')
                {
                fnAdd(select_obj,query_id,query_id);
                }
                
             
        }
    }
}
function delete_conditon()
{   
     var select_obj = document.getElementById("Select_query");
     
     var  query_id= select_obj.options[select_obj.selectedIndex].value;
     if (query_id =="" || query_id=="最近的查询")
     {
        return ;
     }
     
     var del=delete_conditon_(query_id);
     if (del=="-1")
        {
            alert("删除查询（"+query_id+"）失败！");
        }
        else
        {
             alert("删除查询（"+query_id+"）成功！");
        }

}

function delete_conditon_(query_id)
{
     var sql="{delete from A006 Where user_id='"+user_id+"' and query_id='"+query_id+"' and table_id='"+table_id+"' and menu_id='"+menu_id+"'}";
     var execsql=BaseDoPage.execSqlList(sql).value;
        if (execsql=="1")
        {
            
             var select_obj = document.getElementById("Select_query");
            for(i=0;i<select_obj.options.length;i++)
            {
                v = select_obj.options[i].value;
                if (v == query_id)
                {
                    select_obj.remove(i)
                    select_obj.selectedIndex =0;
                    break;
                
                }
            
                
            }
        
             return 1 ;
        
        }
        
        else
        
        {
            return  "-1";
        
        }

}

function save_condition_(query_id)
{
    var con= "" ;

    var sql="{delete from A006 Where user_id='"+user_id+"' and query_id='"+query_id+"' and table_id='"+table_id+"' and menu_id='"+menu_id+"'}";
    for(i=0;i<300;i++)
    {
         obj= document.getElementById("column" + String(i));
         if (obj == null) 
         {
            break;
         }   
         column_id= obj.value;
         
         obj_v= document.getElementById("v_" + String(i));
         v = trim(obj_v.value);
         obj_v_b=  document.getElementById("v_" + String(i)+"_b");
         if  (obj_v_b !=null)
         {
             b= obj_v_b.value;
             if( b=="")
             {
                 b='2000-01-01';                       
             }
             e =  document.getElementById("v_" + String(i)+"_e").value;
             if( e=="")
             {
                e='2029-12-31';
                
             }                    
             v = b +'..' + e;         
         }
     
         if ( v != ""  &&  v != "2000-01-01..2029-12-31")
         {
                         
             obj_select= document.getElementById("CALC" + String(i));    
             calc= obj_select.options[obj_select.selectedIndex].value;
             obj_col_type = document.getElementById("col_type" + String(i));
             col_type = obj_col_type.value;
            
            
             if (calc=="")
             {
                calc = "Like";
             }

             sql_insert ="Insert into A006(  MENU_ID , user_id,table_id,query_id,col_name,col_rela,col_value,enter_user,enter_date,RESULTROW,COL_TYPE)";
             sql_insert =sql_insert + " Select '"+menu_id+"','"+user_id+"','"+table_id+"','"+query_id+"','"+column_id+"','"+calc+"','"+v+"','"+user_id+"',sysdate,0,'"+col_type+"' from dual" ;
             sql = sql +  "{"+sql_insert +"}" ;
           if (calc.toLowerCase() =="like"  ||  calc.toLowerCase()== "not like" )
            {
                v ='%' + v+'%' ;
            }


            
            if (calc.toLowerCase()=="between")
            {
                
                v1 = v.substring(0,v.indexOf('..'));
                v2 = v.substring(v.indexOf('..') + 2, v.length);
                v= v.replace('..'," AND ");
                if ( col_type == "int" || col_type == "decimal" || col_type == "number")
                {
                     con = con +  " AND ("+column_id + ">=" +v1 +" AND "+column_id+" <= "+v2+" )" ;
                        
                }
                else
                {
                                if (col_type=='date' || col_type=='datetime')
                                {
                                      
                                    con = con +  " AND ("+column_id + ">= " +format_date(v1) +" AND "+column_id+" <= "+format_date(v2)+" )" ;
                                }
                                else
                                {
                                
                                     con = con +  " AND ("+column_id + ">= '" +v1 +"' AND "+column_id+" <= '"+v2+"' )" ;
                                }
                }
   
            }
            else
            {

                 con = con +  " AND "+column_id + "  " + calc +" '" +v +"'" ;
            }
            
         }
     
    }
  // alert(con);

    var execsql=BaseDoPage.execSqlList(sql).value;
    if (execsql=="1")
    {
       return con ;
    
    }
    
    else
    
    {
        return  "-1";
    
    }
}
function format_date(str_dt )
{
var v_date = str_dt;
       if (v_date.length > 10)
       {
        v_date = "to_date('" + v_date +"','YYYY-MM-DD HH24:MI:SS')" ;
        
       }
       else
       {
        v_date  = "to_date('" + v_date +"','YYYY-MM-DD')" ;
       
       }
       
       return v_date;

}

function checkv(col_type,obj)
{
    v = obj.value;
    if( col_type == "datetime" || col_type == "date" || col_type == "int" || col_type == "decimal" || col_type=="number")
     {
            if (v.indexOf('..') < 0 )
            {
                v =  v + '..';
                obj.value =  v;
            }
     
     }
    
}


//获取条件
function get_condition()
{
    var  query_id = "最近的查询";
    con = save_condition_(query_id);
    if (con=="-1")
    {
        alert("获取查询条件失败！");
    }
    else
    {   
          var   v   =   new   Object();   
          v.DataId  =   con;   
          v.condition  = "0"; 
          v.Para    =   window.dialogArguments;      
          window.returnValue   =   v;   
          window.close();    
         
         
        return con ;
    }
}
function  cancel_window()
{
         window.close();  

}
function dataitemchage(obj)
{
    
}