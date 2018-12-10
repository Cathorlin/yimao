<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChooseDataChild.aspx.cs" Inherits="ShowForm_ChooseDataChild" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
 <link href="../css/basePage.css"  rel="stylesheet"  type="text/css" />
    <title>无标题页</title>
    <script language=javascript>
        var re_v = "";
        function Selectv(v_)
        {
            re_v = v_;
        
        }

        function select_data()
        {
            if  (re_v != "")
            {
               returnv(re_v);
               return  ;
            } 
            var v_="";
             obj_list =  document.getElementsByTagName("input");
            for (var i =0;i<obj_list.length;i++)
            {
                if (obj_list[i].id.indexOf('cbx_') == 0   )
                {
                    if ( obj_list[i].checked == true)
                    {
                    
                        v_ += obj_list[i].value+"<V></V>";
                    }
                
                }
             }
             
             returnv(v_);    
           
             
        }
        function returnv(v_)
        {
             var   v   =   new   Object();   
             v.DataId  =   v_ +"<V></V>";   
             v.condition  = "0"; 
             v.Para    =   window.dialogArguments;      
             window.returnValue   =   v;   
             window.close();   
        }
          function SelectAll(obj)
          {
  	            obj_list =  document.getElementsByTagName("input");
  	          //alert(obj_list.length);
                for (var i =0;i<obj_list.length;i++)
                {
                    if (obj_list[i].id.indexOf('cbx_') == 0   )
                    {
                        if (obj.value=="1")
                        {
                            obj_list[i].checked = true;
                        }
                        else
                        {
                             obj_list[i].checked = false;
                        }
	                
                    }
                }
                  if (obj.value=="1")
                        {
                            obj.value="0"
                        }
                        else
                        {
                         obj.value="1"
                        
                        }
  
          }
    
    
    
    </script>
</head>
<body class="BaseBody" style="margin-left:5px;" >
    <form id="form1" runat="server">

<table   class="ShowTable"  border="0" cellpadding="4" cellspacing="1" bgcolor="#464646" >
 <tr class="tr_ShowTableHead">
<td style="width:25px;" class="td_ShowHead" >
  #
</td>
<td style="width:20px;" class="td_ShowHead" >
 <% if (result_rows == "1") { 
   %>
   <input id="CheckAll" type="checkbox"   value ="1" onclick="SelectAll(this)"/>
   <%}%>
</td>
<%    
    for (int i = 0; i < dt_data.Columns.Count; i++)
    {
        int r = a01301_row[i];
        if (r > 0)
        {
            Response.Write("<td class=\"td_ShowHead\" style=\"width:" + dt_a013010101.Rows[r - 1]["bs_width"].ToString() + "px;\">" + dt_a013010101.Rows[r - 1]["col_text"].ToString() + "</td>");
        }
        else
        {
            Response.Write("<td class=\"td_ShowHead\" style=\"width:80px;\">" + dt_data.Columns[i].ColumnName + "</td>");
        }
    }
 %>

</tr>
<%
    for (int r = 0; r < dt_data.Rows.Count; r++)
    {
        string rowkey = dt_data.Rows[r][col_exist].ToString();
  %>  
 <% if (r % 2 == 0)
     {
     %>
      <tr  class="r0" ondblclick="returnv('<%=rowkey %>')">
     <%
     }
     else
     { 
     %>
      <tr  class="r1" ondblclick="returnv('<%=rowkey %>')">
     <%} %>
    
 <td class="td_Show"> <%=(r+1).ToString() %></td>  
 <td class="td_Show">
 <% if (result_rows == "1")
    { 
   %>
   <input id="cbx_<%=r.ToString() %>" value="<%=rowkey %>" type="checkbox" />
 <%}
   else {
     
    %>
     <input id="Radio<%=r.ToString() %>" type="radio"  name="radio0" onclick="Selectv('<%=rowkey %>')"/>
    <%}%>
</td>
 <% 
  for (int i = 0; i < dt_data.Columns.Count; i++)
    {
        Response.Write("<td class=\"td_Show\">" + dt_data.Rows[r][i].ToString() + "</td>");

    }
 %>
  </tr>      
<% }
    
 %>

</table>

    </form>
</body>
</html>
