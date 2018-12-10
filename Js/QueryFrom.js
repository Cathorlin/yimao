// JScript 文件
function selectDate_m(obj)
{
    selectDate(obj);
}
function dosql(sql,key)
{
   var v = BaseDoPage.execSql(sql).value;
    if (v  != "0")
    {
       alert(v)
    } 
    else
    {
         alert("操作成功") 
        trobj = document.getElementById('row'+key);
        if (trobj !=null)
        {
            trobj.style.display = "none";
        }
    }  
}
function doproc(sql,key)
{
  var  this_sql =  BaseDoPage.getDecryptData("",sql).value;
  
  var v = BaseDoPage.execSql(this_sql).value;
 
  
  
  if (v  == "-1" || v==null)
  {
     alert("执行操作失败！")
    
  }
  else
  {
   // alert("执行操作成功！")
   if (v =="0")
   {
   
    trobj = document.getElementById('row'+key);
    
    if (trobj !=null)
    {
        trobj.style.display = "none";
    }
    }
    else
    {
        alert(v);
    }
    
  }
  
  
  
  
}


  function update(tableid)
    {
        //获取页面所有v_id的值     
         var controls = document.getElementsByTagName('input');
         var str="";
          for(var i=0; i<controls.length; i++)
          {
            if(controls[i].id.indexOf("v_") ==0 && controls[i].value != "" )
            {
                //controls[i].value='';
                //如果输入的值不为空
                //
                str = str + "{"+controls[i].id+"="+ controls[i].value+"}"
            
                
            }
          }   
          var obj_key= document.getElementById(tableid+"_KEY");
          var key = obj_key.value;
          //    public String  saveData(string t_id,string datalist,string pk_key)
          var v= BaseDoPage.saveData(tableid,str,key).value;
          if (v !="Error")
          {
             obj_key.value = v;
          
          }
          alert(v);
          
    }

    
    function sousuo(){
	window.open("gaojisousuo.htm","","depended=0,alwaysRaised=1,width=800,height=510,location=0,menubar=0,resizable=0,scrollbars=0,status=0,toolbar=0");
}

function dropdown_change(sel)
{
        var v_id="";
        for(var i= 0 ; i < sel.length; i++)
        {//最上面的一个不需要移动，所以直接从i=1开始            if(sel.options[i].selected)
            {
                v_id = sel.options[i].value;
                break;
            }
        }
        if (v_id == "UCID")
        {
            
            
        }
    
}



function selectAll(){
	var obj = document.fom.elements;
	for (var i=0;i<obj.length;i++){
		if (obj[i].name == "delid"){
			obj[i].checked = true;
		}
	}
}

function unselectAll(){
	var obj = document.fom.elements;
	for (var i=0;i<obj.length;i++){
		if (obj[i].name == "delid"){
			if (obj[i].checked==true) obj[i].checked = false;
			else obj[i].checked = true;
		}
	}
}

function link(){
    document.getElementById("fom").action="addrenwu.htm";
   document.getElementById("fom").submit();
}

function getCardData()
{
    var cardno =  GetCardNum('SeraCtr');
    //alert(cardno)
    if (cardno.length > 5)
    {
        v = BaseDoPage.setSession("queryCondtion"," AND UCID='"+cardno +"'")
        
        location.href =  location.href;
        
    }

}


function GetCardNum(objid)
{
	
	    var   SeraCtr = document.getElementById(objid);
	    if (SeraCtr != null)
	    {
	        try
		    {
			        if(SeraCtr.isOnline()!= 0)
			        {
			         alert("请将您的手机通宝读头插入计算机!");
			         return "-1" ;
			        }
		    }
		    catch(err)
		    {
			    alert("您有中国移动手机通宝控件没有成功安装，请允许安装控件！");
			    return "-1";
		    }
	            v="";
            try
            {
                v = Trim(SeraCtr.getCardInfo());	
                if (v.length < 5)
                {
                  alert("获取卡的信息失败！")
		          return "-1";
                }
            }
	        catch(err)
	        {
	            alert("获取卡的信息失败！" + err.description )
		        return "-1";
	        }
	        //判断签名返回数据
        		
		        return v;
        }
        		
	}