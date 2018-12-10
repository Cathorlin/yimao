<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChooseData.aspx.cs" Inherits="ShowForm_ChooseData" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title><%=title %></title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
  		<script language=javascript>
           window.dialogWidth=50;
  	       var keydata="";
           result_rows ="<%=result_rows %>"           
            function getcon()
            {
                 obj =  document.getElementById("Iframe1");
                 obj.contentWindow.get_condition();    
                 var con = BasePage.getCondition("最近的查询",'<%=A00201KEY %>').value;
                 v = BasePage.setSession("Bs_Choose_Sql_CON",con).value;
                // alert(v)
                 obj =  document.getElementById("child");
                 obj.src = obj.src +"0"
            }
                   
           
           function selectrow(obj,row)
           {
           
             if ( result_rows =="1")
             {
                   if (obj.value =="1")
                   {
                      obj.value ="0"
                   }
                   else
                   {
                      obj.value ="1"
                   }
            }
            else
            {
                  var   v   =   new   Object();   
                  v.DataId  =   obj.name+"{}";   
                  v.condition  = "0"; 
                  v.Para    =   window.dialogArguments;      
                  window.returnValue   =   v;   
                  window.close();   
                
            }
            
       }

    function query()
    {
        condition = document.getElementById("query_id_text").value;
        obj =  document.getElementById("child");
        obj.contentWindow.query(condition);    
    
    }
    function SelectAll()
    {
         obj =  document.getElementById("child");
        obj.contentWindow.SelectAll();    
    
    }
    
    
    	function select_data()
		{
            obj = document.getElementById("child");
            obj.contentWindow.select_data();
		}
		
		function closereturn()
		{
		// alert(keydata);
		  var   v   =   new   Object();   
          v.DataId  =   keydata;   
         
          v.Para    =   window.dialogArguments;      
          window.returnValue   =   v;   
          window.close(); 
		    
		}
		<% if (dt_a00201.Rows.Count > 0)   { 		 
		 %>
		ifshowquery = false ;
		function showquery(obj)
		{
		    if (ifshowquery == false)
		    {
		        if  ( document.getElementById("Iframe1").src =="")
		        {
		            document.getElementById("Iframe1").src="querycondition.aspx?A00201KEY=<%=A00201KEY %>&ifchoose=1"
		        }
		   
		        document.getElementById("Iframe1").style.display = "" ;
		        ifshowquery = true;
		        obj.value = "隐藏条件"
		        document.getElementById("btn_query").style.display = "" ;
		    }
		    else
		    {
		        document.getElementById("Iframe1").style.display = "none" ;
		        document.getElementById("btn_query").style.display = "none" ;
		        ifshowquery = false;
		        obj.value = "显示条件"
		    }
		    
		  //  ifshowquery=
		}
		<%} %>
      </script>
  </HEAD>

<body topmargin="0" class="bd"  scroll=auto>

<form id="Form" method="post" runat="server" target="">
<% if (dt_a00201.Rows.Count > 0)   {    
   %> 
   <iframe id="Iframe1" src=""  frameborder="0" scrolling="no" style="width: 100%; margin:0 0 0 0; display:none;height:<%=(conrow + 1) * 22    %>px;"   ></iframe>
   <input name="" type="button"  style="font:9pt;"  value="显示条件" onclick="showquery(this)"  />
   <input name="" type="button"  style="font:9pt;"  value="查询" onclick="getcon()"  id="btn_query"   style="display:none;" />
 <%} %>

<input name="" type="button"  value="确定"   onclick="select_data()">
<iframe id="child" src="" scrolling="auto" style="width: 100%; height: 94%;"  ></iframe>

<script language="javascript">
  var child_src=  window.location.href;
 document.getElementById("child").src = child_src.replace("ChooseData.aspx","ChooseDataChild.aspx")  + "&A00201KEY=<%=A00201KEY %>"   ;
</script>


</form>

    </body>
	
	
</HTML>

