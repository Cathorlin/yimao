<%@ Page language="C#" Inherits="Custom.BaseForm.QueryCondition" CodeFile="QueryCondition.aspx.cs" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server"> 
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<meta http-equiv="x-ua-compatible" content="IE=EmulateIE7" />
<title>查询条件</title>
<script language=javascript src ="../js/option.js"></script>
<script language=javascript src="../Js/datetime.js"></script>
<script language=javascript src ="<%=http_url %>/js/BasePage.js"></script>	
<script language=javascript src="Query.js"></script>
<script type="text/javascript" src="../js/jquery.min.js"></script>
<link href="../css/QueryCondition.css"  rel="stylesheet"  type="text/css" />
<link href="../Css/BasePage.css" rel="stylesheet" type="text/css" />
<style>
input._button
{
    font-size:9pt;
}

</style>
<script  language=javascript>
//清除输入的条件
a00201_key="<%=a00201_key %>";
A007_KEY = "<%=A007_KEY %>"
menu_id = '<%= dt_a00201.Rows[0]["menu_id"].ToString()%>'
table_id = '<%= dt_a00201.Rows[0]["table_id"].ToString()%>'
ifchoose = "<%=ifchoose %>"
</SCRIPT>
</head>

<body  style="margin-right:0px;">
<form id="form2" runat="server">

<%if (ifchoose=="0"){ %>
<div  style="margin:0 0 0 20px; width:95%; ">  
<table style="font-size:9pt;font-family: 宋体; color: black;" class="head">
        <tr>

        <td style="width: 63px">
         <input id="query_id" value=""  type="text" style="width: 74px" />
        </td>
          
       <td class="a_button" style="width: 74px" >
             <input type="button" value="保 存" onclick ="javascript:save_()" class="btn blue" />
        </td> 
        <td style="width: 80px">
            <nobr><a class="saved_">已保存</a>
        <select   id="Select_query"  style="font-size:9pt; width:120px;" onchange="show_condition(this)"> 
             <option  selected="selected" value=""></option>
             <option  value="最近的查询" >最近的查询</option>
             <%
                 for (int i = 0; i < dt_a006.Rows.Count; i++)
                 {
                     string query_id = dt_a006.Rows[i]["query_id"].ToString();
                     if (query_id == "最近的查询")
                     {
                         continue;
                     }
                     string a006_key = dt_a006.Rows[i]["query_id"].ToString();
                    %>
                       <option   value="<%=a006_key %>"><%=query_id%></option>
                    <%
                 }             
              %>
         </select>  
    </nobr>
        </td>   
      <td class="a_button" >
             <input type="button" value="删 除"  onclick="javascript:delete_conditon()" class="btn blue" />
        </td> 
                <td class="a_button" >
             <input  type="button" value="清除条件"onclick ="javascript:clear_conditon()" class="btn blue" />
        </td> 
        
              <td class="a_button" >
             <input type="button" value="取 消" onclick ="javascript:cancel_window()" class="btn blue" />
        </td> 
        
                      <td class="a_button" style="width: 74px" >
             <input type="button" value="确 定"  onclick ="javascript:get_condition()" class="btn blue" />
        </td> 
        </tr>
</table>
</div>
<%} %>

<div  style="margin:0 0 0 10px;width:95%;">
<table width="100%"  border="1" cellpadding="0" class="showcol" cellspacing="0" bgcolor="#EEF2FB" style="font-size:9pt;	font-family: 宋体;">
<tr class="tr_head">
<td style="width: 28px; ">
序号
</td>
<td style="width: 18px; ">
&nbsp;
</td>
<td style="width: 120px">
列名
</td>
<td style="width: 77px">
关系
</td>
<td style="width:300px;">
值
</td>
<td style="width:48px;">
 排序
</td>
</tr>

<%
    int j = 0;
    for (int i = 0; i < dt_A10001.Rows.Count; i++)
    {
        string a10001_key = dt_A10001.Rows[i]["column_id"].ToString();
        string column_id = dt_A10001.Rows[i]["column_id"].ToString();
        string col_text = dt_A10001.Rows[i]["col_text"].ToString();
        string col_type = dt_A10001.Rows[i]["col_type"].ToString();
        string col_edit = dt_A10001.Rows[i]["col_edit"].ToString();
        string line_no = dt_A10001.Rows[i]["line_no"].ToString();
        string select_sql = dt_A10001.Rows[i]["select_sql"].ToString();
        string col_visible = dt_A10001.Rows[i]["col_visible"].ToString();
        if (col_visible == "0")
        {
            continue;
        }
        if (ifchoose=="1" && choosecolumn.IndexOf("[" + column_id + "]") < 0)
        {
            continue; 
        }
        j = j + 1;
 %>       
        
        <tr id="tr_<%=a10001_key %>">
            <td id="tdrow" style="width:38px;" >
                <script language=javascript>adda10001("<%=a10001_key %>",'<%=column_id %>','<%=col_type %>')</script>
                 <%=j.ToString()%>
            </td>
            <td>
               <a onclick="clearitem('<%=a10001_key %>')"><img  title="清除条件" src="../images/114.gif" alt="清除条件"></a> 
            </td>
            <td style="width: 120px;">
                <%=col_text%>
            </td>
            <td style="width: 77px; font-size:9pt;font-family: 宋体;">
                      <%   string ls_calc ="";
                            if (col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_")  == 0 || col_edit.IndexOf("checkbox") == 0 )
                            {
                                ls_calc = "<INPUT  TYPE=\"checkbox\"  id=\"all" + a10001_key + "\"   value=\"0\"  onclick=\"selectqueryall(this,'"+ a10001_key+"')\" >全部";

                                ls_calc += "<select  style=\"font-size:9pt;font-family: 宋体;display:none;\" id=\"CALC" + a10001_key + "\" onchange=\"calc_change(this)\" >";
                               ls_calc += "<option  selected value=\"IN\">IN</option>";                      
                            }   
                            else
                            {
                                ls_calc = "<select  style=\"font-size:9pt;font-family: 宋体;\" id=\"CALC" + a10001_key + "\" onchange=\"calc_change(this)\">";
                                if (col_edit.IndexOf("datetimelist") == 0 || col_edit.IndexOf("datelist") == 0)
                                {
                                       ls_calc += "<option value=\"BETWEEN\">在..之间</option>";
                                }
                                
                                else
                                {
                               ls_calc += "<option  selected value=\"\"></option>";
                               ls_calc += "<option   value=\"=\"> 等于</option> ";
                               ls_calc += "<option   value=\">\"> 大于</option> ";
                               ls_calc += "<option value=\"<\">小于</option>";
                               ls_calc += "<option value=\"LIKE\">包含</option>";
                               ls_calc += "<option value=\"NOT LIKE\">不包含</option>";
                               ls_calc += "<option value=\"IN\">IN</option>";
                               ls_calc += "<option value=\"BETWEEN\">在..之间</option>";
                               }
 
                            }
                           ls_calc += "<option value=\"SQL\">SQL语法</option>";
                           ls_calc +="</select>" ;

                                    
                   %>
                      <%=ls_calc %>
      
            </td>
            <td >
              <%  //|| col_edit.IndexOf("rb_") == 0 || col_edit.IndexOf("checkbox") == 0
                      select_sql = select_sql.Replace("[A007_KEY]", A007_KEY);
                      select_sql = select_sql.Replace("[A30001_KEY]", A30001_KEY);
                      select_sql = select_sql.Replace("[A00201_KEY]", a00201_key);
                      string ls_html = "";
                      ls_html = "<div id=\"input_" + a10001_key + "\">";    
                      if (col_edit.IndexOf("checkbox") == 0 || col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0)
                      {
                          if (col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0)
                          {
                              dt_data = Fun.getDtBySql(select_sql);
                              for (int r = 0; r < dt_data.Rows.Count; r++)
                              {
                                  ls_html += "<INPUT  TYPE=\"checkbox\" name=\"value" + a10001_key + "\" id=\"value" + a10001_key + "_" + r.ToString() + "\"   value=\"" + dt_data.Rows[r][0].ToString() + "\">" + dt_data.Rows[r][1].ToString();
                              }

                          }
                          if (col_edit.IndexOf("checkbox") == 0)
                          {
                              ls_html += "<INPUT  TYPE=\"checkbox\" name=\"value" + a10001_key + "\" id=\"value" + a10001_key + "_1\"   value=\"1\">选中";
                              ls_html += "<INPUT  TYPE=\"checkbox\" name=\"value" + a10001_key + "\" id=\"value" + a10001_key + "_0\"   value=\"0\">未选中";
                          }
                      }
                      else
                      {  /*日期*/
                          if (col_edit.IndexOf("datetimelist") == 0 || col_edit.IndexOf("datelist") == 0)
                          {
                              ls_html += "<input  type=\"text\" readonly=\"readonly\"  name=\"value" + a10001_key + "\" id=\"value" + a10001_key + "_b\" onclick=\"selectDate_m0(this)\"  />";
                              ls_html += "..<input  type=\"text\" readonly=\"readonly\"  name=\"value" + a10001_key + "\" id=\"value" + a10001_key + "_e\" onclick=\"selectDate_m0(this)\"  />";
                          }
                          else
                          {
                              ls_html += "<input   type=\"text\" name=\"value" + a10001_key + "\"  id=\"value" + a10001_key + "\" onBlur=\"input_onBlur(this,'"+col_type + "')\" />";

                          } 
                      }
                      ls_html += "</div>";
                      ls_html += "<div id=\"inputsql_" + a10001_key + "\" style=\"display:none;width:80%;\"><input  style=\"width:100%;\" type=\"text\" name=\"v_" + a10001_key + "\"  id=\"vsql_" + a10001_key + "\" onBlur=\"input_onBlur(this,'" + col_type + "')\" />";
                      ls_html += "</div>"; 
           
                      %>  
              <%=ls_html %>
            </td>
            <td >
            <select  style="font-size:9pt;font-family: 宋体;" id="sort_<%=a10001_key %>" >
             <option  selected value=""></option>
              <option   value="A">升序</option>
               <option   value="D">降序</option>
            </select>                       
           </td>
        </tr>
        
        
        
   <%
    
    }

 %>
  
</table>
  </div>
    </form>
</body>
</html>
