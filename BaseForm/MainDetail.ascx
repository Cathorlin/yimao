<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MainDetail.ascx.cs" Inherits="BaseForm_MainDetail" EnableViewState="false"   %>

<div id="show_<%=a00201_key %>"  style="display:none;">
 <% 
       Response.Flush();
       string ls_hidden = "";
       string table_key = dt_a00201.Rows[0]["TABLE_KEY"].ToString();
       string main_key = dt_a00201.Rows[0]["main_key"].ToString();
       string table_id = dt_a00201.Rows[0]["table_id"].ToString();
       string td_html = "";

       int width_all = 55;
       string hidden_tr = "";
       string inserthtml = "<tr id=\"R" + a00201_key + "_[ROW]\" style=\"display:none;\">";
        for (int j = 0; j < dt_a013010101.Rows.Count; j++)
       {
         string bs_width = dt_a013010101.Rows[j]["BS_WIDTH"].ToString();
         string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
         string column_id = dt_a013010101.Rows[j]["column_id"].ToString();
         string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
         if (bs_width =="" || bs_width == null)
         {
             bs_width = "80"; 
         }
         if (main_key == column_id)
         {
             dt_a013010101.Rows[j]["COL_VISIBLE"] = "0";
             col_visible = "0";
         }
            
        if (col_visible == "1")
        {
           width_all = width_all + 2 + int.Parse(bs_width);
           td_html += "<td style=\"width:" + bs_width + "px;\"> " + col_text + "</td>";
           hidden_tr += "<td style=\"width:" + bs_width + "px;height:0px;\"></td>";
        }
       }
       inserthtml += Fun.getRowHtml(a00201_key, dt_data.NewRow(), dt_a013010101, "[ROW]", "1", "0", option);
  
       inserthtml += "</tr>";
       Response.Flush();
%>
<script language=javascript>
A00201LIST  +=  '<%=a00201_key %>,'
getA0130101('<%=a00201_key%>','<%=table_key %>','<%=main_key %>','<%=table_id %>')

</script>
<%if (dt_a00204.Rows[0][0].ToString().Length > 20 || pagecount > 1)
  {%>
<div id="div_btn_<%=a00201_key%>" class= "detail_btn">
<%=dt_a00204.Rows[0][0].ToString()%>
 <script>if_btn[if_btn.length] = "<%=a00201_key %>";</script>
    <%if (pagecount > 1)
    {
for (int i = 0; i < pagecount; i++)
{   
    if (i == (pagecount - 1) && PageNum < pagecount- 4)
    {
    %>
     <input  class="_pagebutton"  type=button value=".." />
    <%}
  %> 
    <% if (i != PageNum)
       {
           if (i == 0 || i == (pagecount - 1) || (i > PageNum - 4 && i < PageNum + 4))
           { 
          %>   
            <input  class="_pagebutton"  type=button value="<%=(i+1).ToString() %>" onclick="setdetailpagenum('<%=a00201_key %>',<%=i.ToString() %>)"/>
     <%
        }}
        else {
        %>
           <input  class="_pagebuttoncurr"  type=button value="<%=(i+1).ToString() %>" />
       <%}
    if  (i==0 && PageNum > 3)
    {
    %>
     <input  class="_pagebutton"  type=button value=".." />
    <%}

    %>
<%}
}
    %>
</div>
<%}
else { 
  %>
 <script> if_btn[if_btn.length] = "0";</script>  
<%} %>



<div style="OVERFLOW:hidden; height:26px;"   id="scroll_height_<%=a00201_key %>_x">
<table  class="ShowTable"  id="Table1">
<tr class="tr_ShowTableHead">
 <td style="width:40px;">
   <input  type="checkbox"  id="cbx_<%=a00201_key%>" value="0" onclick="cbx_selectall(this,'<%= a00201_key%>')" />
      #
 </td>
 <td style="width:35px;">
    &nbsp;
 </td>
  <%=td_html %>
</tr>
</table>
</div>
<div style="OVERFLOW:auto;"  id="scroll_height_<%=a00201_key %>">
<table  class="ShowTable"  id="T<%=a00201_key %>" >
<tr class="tr_ShowTableHead" style=" height:0px;">
 <td style="width:40px;height:0px;"> </td>
 <td style="width:35px;height:0px;"></td>
  <%=hidden_tr%>
</tr>
<%=inserthtml %>
<%
for(int i=0 ;i <dt_data.Rows.Count; i++)
{
    if (i < PageNum * PageRow)
    {
        continue;
    }
    if (i >= (PageNum + 1) * PageRow)
    {
        break;
    }
    string key = "";
    string line_no = "";
    string rowid = a00201_key + "_" + (i + 1).ToString();
    
    try
    {
        key = dt_data.Rows[i][main_key].ToString();
       line_no = dt_data.Rows[i]["LINE_NO"].ToString();
    }
    catch
    {
       key = "-100";
    }
    try
    {
      
       line_no = dt_data.Rows[i]["LINE_NO"].ToString();
    }
    catch
    {
       line_no = "0";
    }
      string objid = "";  
       try
       {
           objid = dt_data.Rows[i]["objid"].ToString();
       }
       catch
       {
           objid = "";
       }
       ls_hidden += "<input id='objid_" + a00201_key + "_" + (i + 1).ToString() + "' type=\"hidden\" value='" + objid + "'/>";
    
    

        string rowhtml = "";
        if (i % 2 == 0)
        {
            rowhtml += "<tr id=\"R" + a00201_key + "_" + (i + 1).ToString() + "\" class=\"r0\"  onclick=\"selectrow(this,'r2','r0')\">";
        }
        else
        {
            rowhtml += "<tr id=\"R" + a00201_key + "_" + (i + 1).ToString() + "\" class=\"r1\"  onclick=\"selectrow(this,'r2','r1')\">";
        }
      
     rowhtml += Fun.getRowHtml(a00201_key, dt_data.Rows[i], dt_a013010101, (i + 1).ToString(), "1",key,option);
     rowhtml += "</tr>";
     if (line_no == "")
     {
         line_no = "0";
     }
 %>
<script language =javascript>
AddrowList('<%=rowid%>','<%=table_key %>','<%=main_key %>','<%=key %>','<%=table_id %>',<%=line_no%>,'<%=option %>')
</script>
<%=rowhtml %>
<%
    Response.Flush();
}
//Response.Write(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff") + "   ");
    %>

</table>


<%
    string vvvv = "";
    Response.Write(ls_hidden);
 %>
</div>
<script language=javascript>   
   document.getElementById("scroll_height_<%=a00201_key %>_x").style.height = 20  ;
        document.getElementById("scroll_height_<%=a00201_key %>").onscroll = function()
        {
             document.getElementById("scroll_height_<%=a00201_key %>_x").scrollLeft = this.scrollLeft;
        }

      
</script>
</div>






