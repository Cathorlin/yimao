	
		var sqllist=Array();//��¼sql
		var chagerowlist = Array();//��¼�޸ĵ���
		var lb_hide = false;
		function hide(obj)
		{//���ز��ܱ༭����
	    	var table = document.getElementById("T_REPORT");//��ȡ�������Ϣ

              for(var row= 1 ; row< table.rows.length ; row++)
              {  
		        rowedit = trim(document.getElementById(row + "_ROWEDIT").value);
		        if (rowedit=="0")
		        {
		        	if (lb_hide == false)		            
		                  document.getElementById("row"+row).style.display = "none";
		            else
		                  document.getElementById("row"+row).style.display="";     
		        }
		       }
		       if (lb_hide == false)
		       {
		           lb_hide=true;
		           obj.innerText ="��ʾ���ܱ༭��";
		        }
		       else
		       {
		           lb_hide = false;  
		           obj.innerText ="���ز��ܱ༭��";
		           }
		     // alert( lb_hide);   

		}
		
		
		function changedata(obj)
		{
		 //
		  if (trim(obj.value) == trim(obj.name))
		        return false ;
		    var com_list = document.getElementById("com_list");
            
            var c002_id = com_list.options[com_list.selectedIndex].value;
		    var yyyy_list = document.getElementById("yyyy_list");
	        var yyyy= yyyy_list.options[yyyy_list.selectedIndex].value;		
			
			var c003_list = document.getElementById("c003_list");
			var c003_id;
			var c003_name;
			if (c003_list.options.length > 0)
			{
			c003_id = c003_list.options[c003_list.selectedIndex].value;
			c003_name = c003_list.options[c003_list.selectedIndex].text;
			}
			else
			{
			c003_id ="";
			return false ;
			}
		 
		 
		  var   id = obj.id;
		  var rownum = id.substring(0,id.indexOf("_"));
		  var  c001_id= document.getElementById( rownum +"_C100_C001_ID").value;
          var  c004_id= document.getElementById( rownum +"_C100_C004_ID").value;
		  var  ACTUAL = document.getElementById( rownum +"_C101_ACTUAL").value;
		  var  TARGET = document.getElementById( rownum +"_C101_TARGET").value;
		   GET_MODE =  document.getElementById( rownum +"_C100_GET_MODE").value;
          var   TARGET_V = " '" + c001_id + "','" + c002_id + "','" + c004_id + "','" + yyyy +"','" + GET_MODE +"','" + ACTUAL +"','" + TARGET+"'" ;
          var   ACTUAL_V = " '" + c001_id + "','" + c002_id + "','" + c004_id + "','" + yyyy +"','" + GET_MODE +"','" + ACTUAL +"','" + TARGET+"'" ;
           //data =C101_DO.get_valu(TARGET_V).value;
  
           if ( ACTUAL ==""  )
                data = "0";
           else
                data =C101_DO.get_valu(TARGET_V).value;
                
           TARGET_V = data;
           ACTUAL_V = data ;           
           var TARGET_V_old = trim(document.getElementById( rownum +"_C101_TARGET_V").value) ;//��ֵ
           var ACTUAL_V_old = trim(document.getElementById( rownum +"_C101_ACTUAL_V").value) ;//��ֵ
           document.getElementById( rownum +"_C101_TARGET_V").value = String(parseFloat("0"+TARGET_V));
           document.getElementById( rownum +"_C101_ACTUAL_V").value = String(parseFloat("0"+ACTUAL_V));
           //��ȡ���ڵ����
           //��ʾ��ǰ�б��༭��
           document.getElementById( rownum +"_C101_ROWTYPE").name = "E";  //EDIT ��ʾ�༭
           obj.name  = obj.value;
           //��ȡ���ڵ��嵥
           //
           var lb_exit= false ;
           for (var i = 0 ;i< chagerowlist.length;i ++)
               {    
                  if (rownum==chagerowlist[i])
                  {
                    lb_exit = true;
                    break;
                  }               
               
               }

           if (lb_exit==false)
            {
                  chagerowlist[chagerowlist.length] = rownum;
            }  
           
           var parentlist ;
           var p_list;
           var weightlist;
           var w_list;
           
          if ( TARGET_V_old  != TARGET_V  || ACTUAL_V_old != ACTUAL_V )
           { //���������һ�� �޸ĸ��ڵ��ֵ         
                        
                parentlist = trim(document.getElementById( rownum +"_PARENTLIST").value);
                weightlist = trim(document.getElementById( rownum +"_WEIGHTLIST").value);
 
                weight =  trim(document.getElementById( rownum +"_C101_WEIGHT").value); 
                w_list = weightlist.split(",");
                p_list = parentlist.split(",");
                
                for ( i = 0;i<p_list.length;i++)
                {
                   if ( p_list[i] != "" && p_list[i] != null)
                    {  //�޸ĸ��ڵ��ֵ
                        rownum =  p_list[i] ;  
                        data = document.getElementById( rownum +"_C101_TARGET_V").value  ;
                        //alert(( parseFloat("0"+TARGET_V) - parseFloat("0" + TARGET_V_old) ) * parseFloat("0"+w_list[i]));
                        document.getElementById( rownum +"_C101_TARGET_V").value =    String( parseFloat("0"+data) +  ( parseFloat("0"+TARGET_V) - parseFloat("0" + TARGET_V_old) ) * parseFloat("0"+w_list[i]))
                        data = document.getElementById( rownum +"_C101_ACTUAL_V").value  ;
                        document.getElementById( rownum +"_C101_ACTUAL_V").value =    String( parseFloat("0"+data) + ( parseFloat("0"+ACTUAL_V) - parseFloat("0" + ACTUAL_V_old) ) * parseFloat("0"+w_list[i]))
                        document.getElementById( rownum +"_C101_ROWTYPE").name = "E";
                         lb_exit= false ;
                         for ( j = 0 ;j< chagerowlist.length;j ++)
                               {    
                                  if (rownum==chagerowlist[j])
                                  {
                                    lb_exit = true;
                                    break;
                                  }               
                               
                               }

                       if (lb_exit==false)
                        {
                              chagerowlist[chagerowlist.length] = rownum;
                        }  
                        
                        
                        
                    }
                }
           }
          

          
          
             //return false ;
		 }
		 function sumDataN(c001_id,row)
		 {����//�ϼ����� ��3��c001_id��line_no��
		   �� //��ȡ c001_id���ж��ٸ���
		   ��var colcount= document.getElementById("d_"+c001_id+"_COLCOUNT").value;
		   ��var rowcount= document.getElementById("d_"+c001_id+"_ROWCOUNT").value;
		   ��
		   ��//d_1111
		     var  weight= document.getElementById("weight_d_"+c001_id+"_"+row).value;
		   ��
		   ��//��ʾ��score_id���Ƿ�����
		   ��alert(score_id);
		 
		 }

		 
		 function sumdata() //id_��ʾ ��ǰ�޸ĵ��е�c001_id ��ֵ
		 {
		 
		     var table = document.getElementById("T_REPORT");//��ȡ�������Ϣ
		     var c001_id = Array();
		     var TARGET_V_row = Array();
		     var TARGET_V_val = Array();
		     var ACTUAL_V_val = Array();
		     var WEIGHT_val = Array();
		     var k ;
		     var i ;
             for(var row= 1 ; row< table.rows.length ; row++)
              {  
                 obj= document.getElementById(row +"_C101_TARGET_V");      
                  
                     c004_id= document.getElementById( row +"_C100_C004_ID").value; 
                     TARGET_V = trim(document.getElementById( row +"_C101_TARGET_V").value); 
                     ACTUAL_V = trim(document.getElementById( row +"_C101_ACTUAL_V").value); 
                     if  ( TARGET_V == "" || TARGET_V ==null )
                          TARGET_V = "0";                       
                     
                      if  (ACTUAL_V =="" || ACTUAL_V==null )
                          ACTUAL_V = "0";  
                     lb_exist = false ;
                     if (trim(c004_id) =="-")//��ʾ��Ҫ�ϼ�
                     {
                             WEIGHT = document.getElementById( row +"_C101_WEIGHT").value; 
                             if  (trim(WEIGHT)=="" || WEIGHT==null )
                                  WEIGHT ="1" ;
                             k = c001_id.length;
                             c001_id[k] = trim(document.getElementById( row +"_C100_C001_ID").value)
                             TARGET_V_row[k] = row;
                             TARGET_V_val[k] = 0 ;
                             ACTUAL_V_val[k] = 0 ; 
                             WEIGHT_val[k] =  parseFloat(WEIGHT); 
                     }
                     this_c001_id = trim(document.getElementById( row +"_C100_PARENT_ID").value)
                       for (i = 0 ;i< c001_id.length ;i++)
                         {
                            if ( this_c001_id.indexOf(c001_id[i]) == 0  )
                            {
                                 TARGET_V_val[i] =  TARGET_V_val[i] + parseFloat(TARGET_V)  *  parseFloat(WEIGHT_val[k]) ;
                                 ACTUAL_V_val[i] =  ACTUAL_V_val[i] + parseFloat(ACTUAL_V)  *  parseFloat(WEIGHT_val[k]);
 
                            }
                         }
                         

              }
                for (i = 0 ;i< c001_id.length ;i++)
                {
                     if  (TARGET_V_val[i] ==null)
                        TARGET_V_val[i] =0;
                     if  (ACTUAL_V_val[i] ==null)
                        ACTUAL_V_val[i] =0; 
                     document.getElementById( TARGET_V_row[i] +"_C101_TARGET_V").value =  String(TARGET_V_val[i]) ;
                     document.getElementById( TARGET_V_row[i] +"_C101_ACTUAL_V").value =  String(ACTUAL_V_val[i]) ;
                     document.getElementById( TARGET_V_row[i] +"_C101_ROWTYPE").value ="E"; 
                }
                 
                 
   
		 }
		 
		function savedata()
            {
            var table = document.getElementById("T_REPORT");//��ȡ�������Ϣ
            //��ȡʵ��ֵ��ֵ
            //��ȡĿ��ֵ��ֵ
            //������ֵ���Ӳ�ҵ��˾������
            //��ȡC001_ID
            //��ȡÿһ�еĶ���
            //
            var com_list = document.getElementById("com_list");
            
            var c002_id = com_list.options[com_list.selectedIndex].value;
		    var yyyy_list = document.getElementById("yyyy_list");
	        var yyyy= yyyy_list.options[yyyy_list.selectedIndex].value;		
			
			var c003_list = document.getElementById("c003_list");
			var c003_id;
			var c003_name;
			if (c003_list.options.length > 0)
			{
			c003_id = c003_list.options[c003_list.selectedIndex].value;
			c003_name = c003_list.options[c003_list.selectedIndex].text;
			}
			else
			{
			c003_id ="";
			return false ;
			}
			

	                 var TARGET;//Ŀ��ֵ
	                 var ACTUAL ;//ʵ��ֵ  
	                 var c001_id;//��Ŀ
	                 var TARGET_OLD;
	                 var ACTUAL_OLD;
	                 var c004_id;//��Ʒ
	                 var obj;
	                 var sql;
	                 sql ="";
	                 var id;
	                 var k;
	                 var sql_list = Array();
	                 k = 0;
	                 var num;
	                 num =0 ;
	                 var GET_MODE;
	                 var TARGET_V;
	                 var data;
                     var rowtype ;
            for( i = 0 ;i< chagerowlist.length;i ++ )
            // var row= 1 ; row< table.rows.length ; row++)
              {  
                    row = chagerowlist[i];
                 
                   id= row +"_C101_TARGET";

                    obj= document.getElementById(id);
                    TARGET = obj.value;
                    TARGET_OLD = obj.name;
                    obj = document.getElementById( row +"_C101_ACTUAL");
                    num = num + 1 ;
                    ACTUAL = obj.value;
                    ACTUAL_OLD= obj.name;
                    c001_id= document.getElementById( row +"_C100_C001_ID").value;
                    c004_id= document.getElementById( row +"_C100_C004_ID").value;
                    rowtype =  document.getElementById( row +"_C101_ROWTYPE").value;
                    TARGET_V = document.getElementById( row +"_C101_TARGET_V").value; ;
                    ACTUAL_V = document.getElementById( row +"_C101_ACTUAL_V").value; 
                        if (   rowtype =="A" ) //TARGET_OLD =="" && ACTUAL_OLD=="" )
                        {

                              sql = "INSERT  INTO C101(C001_ID,C001_NAME,C002_ID,C002_NAME,YYYY,C003_ID,C003_NAME,C004_ID,C004_NAME,";
                              sql = sql + "PARENT_ID,LAST_LEVEL,IF_USE,TARGET,TARGET_V,ACTUAL,ACTUAL_V,FINISH_FNC,GET_MODE,WEIGHT,VALU)";
                              sql = sql + " SELECT C001_ID,C001_NAME,C002_ID,C002_NAME,YYYY,'"+c003_id+"' AS C003_ID,'"+c003_name+"'AS C003_NAME,C004_ID,C004_NAME,"
                              sql = sql + " PARENT_ID,LAST_LEVEL,'1' AS IF_USE,'"+TARGET+"' AS TARGET ,'" + TARGET_V + "'  AS TARGET_V,'"+ACTUAL+"' AS ACTUAL,'"+ACTUAL_V+"' AS ACTUAL_V,FINISH_FNC,GET_MODE,WEIGHT,null "
                              sql = sql + " FROM C100 WHERE C001_ID='"+c001_id +"'";
                              sql = sql + " AND C002_ID = '"+c002_id+"'" ;
                              sql = sql + " AND yyyy = '"+yyyy+"'" ;
                              sql = sql + " AND C004_ID = '"+c004_id+"'" ;   
                              sql_list[k] = sql;  
                              k = k + 1 ;  
                        }
                        else
                        {
                            sql = "UPDATE C101 SET TARGET = '" + TARGET +"',";
                            sql = sql + " ACTUAL = '" + ACTUAL+"',";
                            sql = sql + " TARGET_V = '" + TARGET_V + "',";
                            sql = sql + " ACTUAL_V = '" + ACTUAL_V + "'";
                            sql = sql + " WHERE C001_ID = '"+c001_id+"'" ;
                            sql = sql + " AND C002_ID = '"+c002_id+"'" ;
                            sql = sql + " AND yyyy = '"+yyyy+"'" ;
                            sql = sql + " AND c003_id = '"+c003_id+"'" ;
                            sql = sql + " AND C004_ID = '"+c004_id+"'" ;                        
                            sql_list[k] = sql;  
                            k = k + 1 ;               
                        }                    
                    
              }
              sql ="" ;
             for (var i = 0;i< sql_list.length;i++)
	         {
	          sql = sql + "{" + String(sql_list[i])+"}";
             }
 
             var save_type ="";
	            if (sql_list.length > 0 )	
	            {
	               save_type=C101_DO.Save(sql).value;  	
	               if ( save_type =="1")	
	               {
	                alert("���ݱ���ɹ���");
	                 //������ϸ�еı༭����
	     	               for( i = 0 ;i< chagerowlist.length;i ++ )
	                          {
	                                row = chagerowlist[i];
                                    document.getElementById( row +"_C101_ROWTYPE").value ="M" ;              			
	                          }
	                   var list = Array();	                          
            	       chagerowlist = list;
            	       //alert(chagerowlist.length);
            	     
	                }
	                else
	               {
	                 alert("���ݱ���ʧ�ܣ�");
	                }
	             }
	             else
	             {
	                  alert("û���޸ģ����ñ��棡");
	             
	              }
		            return false ;

            }
		
		function changeurl()
		{   //��ȡ��� �Ͳ�ҵ��˾��ֵ
		    var com_list = document.getElementById("com_list");
            
            com = com_list.options[com_list.selectedIndex].value;
		    var yyyy_list = document.getElementById("yyyy_list");
	        yyyy= yyyy_list.options[yyyy_list.selectedIndex].value;
		
			action = document.getElementById("action").value;
			var c003_list = document.getElementById("c003_list");
			if (c003_list.options.length > 0)
			{
			c003_id = c003_list.options[c003_list.selectedIndex].value;}
			else{
			c003_id ="";
			}
			var url = "C101_DO.aspx?Action="+action+"&c002_id="+com+"&yyyy=" + yyyy+"&c003_id="+c003_id;
			//alert(url);
		    location.href=url
		    
		    
		    
		    
		    return true ;
		
		
		
		}
    function changeurlN()
		{   //��ȡ��� �Ͳ�ҵ��˾��ֵ
		    
		    var com_list = document.getElementById("com_list");
            
            com = com_list.options[com_list.selectedIndex].value;
  
		    var yyyy_list = document.getElementById("yyyy_list");
	        yyyy= yyyy_list.options[yyyy_list.selectedIndex].value;
		
			action = document.getElementById("action").value;
		
			var c003_list = document.getElementById("c003_list");
			if (c003_list.options.length > 0)
			{
			c003_id = c003_list.options[c003_list.selectedIndex].value;}
			else{
			c003_id ="";
			}
			
			var url = "C101list.aspx?Action="+action+"&c002_id="+com+"&yyyy=" + yyyy+"&c003_id="+c003_id;
			//alert(url);
		    location.href=url
		    
		    return true ;
		
		
		
		}
