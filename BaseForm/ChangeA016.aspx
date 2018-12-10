<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangeA016.aspx.cs" Inherits="BaseForm_ChangeA016" %>
<%string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
  string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;
%>
<table style="font-size:9pt;font-family: 宋体; color: black;" class="queryhead">
 <tr>
  <td class="a_button" style="width: 100%" >
    <input type="button" value="保 存" onclick ="javascript:savea016_('<%=a00201_key %>')" class="btn" />
  </td> 
 </tr>
</table>
<div style="overflow:auto; height:340px;">
<table  class="query" >
<tr class="h">
<td  style="width:22px;">
序号
</td>
<td style="width:200px;">
列名
</td >
<td style="width:80px;">
顺序
</td>
<td style="width:50px;">
可见
</td>
<td style="width:50px;">
可用
</td>
<td style="width:50px;">
必填
</td>
<td style="width:160px;">
宽度
</td>
</tr>

<%
    for (int i = 0; i < dt_a013010101.Rows.Count; i++)
    {
        string a10001_key = dt_a013010101.Rows[i]["column_id"].ToString();
        string column_id = dt_a013010101.Rows[i]["column_id"].ToString();
        string col_text = dt_a013010101.Rows[i]["col_text"].ToString();
        string col_type = dt_a013010101.Rows[i]["col_type"].ToString();
        string col_edit = dt_a013010101.Rows[i]["col_edit"].ToString();
        string line_no = dt_a013010101.Rows[i]["line_no"].ToString();
        string select_sql = dt_a013010101.Rows[i]["select_sql"].ToString();
        string col_visible = dt_a013010101.Rows[i]["col_visible"].ToString();
        string col_necessary = dt_a013010101.Rows[i]["col_necessary"].ToString();
        string col_enable = dt_a013010101.Rows[i]["col_enable"].ToString();
        string a016_visible = dt_a013010101.Rows[i]["a016_visible"].ToString();
        string a016_necessary = dt_a013010101.Rows[i]["a016_necessary"].ToString();
        string a016_enable = dt_a013010101.Rows[i]["a016_enable"].ToString();
        if (col_visible == "0")
        {
            a016_visible = "0";
        }
        if (col_enable == "0")
        {
            a016_enable = "0";
        }
        if (col_necessary == "1")
        {
            a016_necessary = "1";
        }
        string bs_query = dt_a013010101.Rows[i]["bs_query"].ToString();
        string bs_width = dt_a013010101.Rows[i]["bs_width"].ToString();
        string col_x = dt_a013010101.Rows[i]["col_x"].ToString();
        string  a016_col_x =dt_a013010101.Rows[i]["a016_col_x"].ToString();
        if (a016_col_x != null && a016_col_x != "")
        {

            col_x = a016_col_x;
        }

        string a016_bs_width = dt_a013010101.Rows[i]["a016_bs_width"].ToString();
        if (a016_bs_width != null && a016_bs_width != "" )
        {
            bs_width = a016_bs_width;
        }
        if (col_visible == "0")
        {
            continue;
        }


        string ls_col_visible = "<INPUT  TYPE=\"checkbox\"  disabled name=\"value" + a00201_key + "\"    id=\"V_" + a10001_key + "\"  checked  value=\"0\"  >";
        if (a016_visible == "0")
        {
            ls_col_visible = "<INPUT  TYPE=\"checkbox\"  disabled  name=\"value" + a00201_key + "\"    id=\"V_" + a10001_key + "\"    value=\"0\"  >";
        }

        //必填     
        string ls_col_necessary = "";
        if (col_enable == "1")
        {
            if (col_necessary == "1")
            {

                ls_col_necessary = "<INPUT  TYPE=\"checkbox\" name=\"value" + a00201_key + "\" disabled  id=\"N_" + a10001_key + "\"  checked   value=\"0\"  >";

            }
            else
            {

                if (a016_necessary == "1")
                {
                    ls_col_necessary = "<INPUT  TYPE=\"checkbox\"  disabled name=\"value" + a00201_key + "\"    id=\"N_" + a10001_key + "\"  checked   value=\"0\"  >";
                }
                else
                {
                    ls_col_necessary = "<INPUT  TYPE=\"checkbox\"  disabled name=\"value" + a00201_key + "\"    id=\"N_" + a10001_key + "\"     value=\"0\"  >";

                }
            }
        }
        else
        {
            ls_col_necessary = "<INPUT  TYPE=\"checkbox\" name=\"value" + a00201_key + "\"   disabled  id=\"N_" + a10001_key + "\"     value=\"0\"  >";
        }
        string ls_col_enble = "<INPUT  TYPE=\"checkbox\" name=\"value" + a00201_key + "\"  id=\"E_" + a10001_key + "\"  checked   value=\"1\"  >";
        if (col_enable == "0")
        {
            ls_col_enble = "<INPUT  TYPE=\"checkbox\" name=\"value" + a00201_key + "\"   disabled  id=\"E_" + a10001_key + "\"   value=\"0\" >";
        }
        else
        {

            if (a016_enable == "0")
            {
                ls_col_enble = "<INPUT  TYPE=\"checkbox\"  disabled name=\"value" + a00201_key + "\"  id=\"E_" + a10001_key + "\"     value=\"0\"  >";
            }
            else
            {
                ls_col_enble = "<INPUT  TYPE=\"checkbox\"  disabled name=\"value" + a00201_key + "\"  id=\"E_" + a10001_key + "\"  checked    value=\"0\"  >";
            }
        }
         %>
      <tr >
    <td>
    <%= (i + 1).ToString()%>
    </td>
        <td >
     <%=col_text%>
    </td >
       <td >
      <input  type="text" style="width:70px;"  name="value<%=a00201_key %>" id="X_<%=a10001_key %>"  value="<%=col_x %>"/>
    </td>
    <td>
    <%=ls_col_visible%>    
    </td>
    <td >
     <%= ls_col_enble%>
    </td>
     <td>
     <%=ls_col_necessary%>
     </td>
 
    <td>
     <input  type="text"  name="value<%=a00201_key %>" id="W_<%=a10001_key %>"  value="<%=bs_width %>"/>
    </td>
</tr>
<%  
    }     
%>
</table>