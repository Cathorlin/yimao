<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BaseQuery.aspx.cs" Inherits="BaseForm_BaseQuery" %>
<%string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
  string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;
    //输入条件
  if (req_id == "INPUT")
  {  
%>
<table style="font-size:9pt;font-family: 宋体; color: black;  " class="queryhead">
 <tr>
 <td style="width: 63px; "  >
 <input id="input_query_id" value=""  type="text" style="width: 74px" />
 </td>
 <td class="a_button" style="width: 74px" >
 <input type="button" value="<%=BaseMsg.getMsg("M0025")%>" onclick ="javascript:save_('<%=a00201_key %>')" class="btn blue" />
 </td> 
 <td style="width:80px" >
 <a class="saved_"><nobr><%=BaseMsg.getMsg("M0026")%></nobr></a>
 </td>   
 <td>
  <select   id="Select_query"  style="font-size:9pt; width:120px;" onchange="show_condition(this,'<%=a00201_key %>')"> 
  <option  selected="selected" value=""></option>
  <option  value="最近的查询" ><%=BaseMsg.getMsg("M0023")%></option>
  <%
  string a006_sql = "Select  distinct  query_id,DEF_FLAG from A006 t  where user_id='" + GlobeAtt.A007_KEY + "' AND a00201_key ='" + a00201_key + "'";
  dt_temp = Fun.getDtBySql(a006_sql);
  for (int i = 0; i < dt_temp.Rows.Count; i++)
  {
    string query_id = dt_temp.Rows[i]["query_id"].ToString();
    if (query_id == "最近的查询")
    {
        continue;
    }
    string DEF_FLAG = dt_temp.Rows[i]["DEF_FLAG"].ToString();
    if (DEF_FLAG == "1")
    {
        DEF_FLAG = "style=\"color: #FFFFFF; background-color: red;\"";
    }
    else
    {
        DEF_FLAG = "";
    }
    string a006_key = dt_temp.Rows[i]["query_id"].ToString();
  %>
   <option   <%=DEF_FLAG %> value="<%=query_id %>"><%=query_id%></option>
  <%
}             
%>
</select>  
</td>
<td class="a_button" >
 <input type="button" value="<%=BaseMsg.getMsg("M0027")%>"  onclick="javascript:delete_conditon('<%=a00201_key %>')" class="btn blue" />
</td> 
<td class="a_button" >
   <input  type="button" value="<%=BaseMsg.getMsg("M0028")%>"onclick ="javascript:clear_conditon()" class="btn blue" />
</td> 
<td class="a_button" >
<input type="button" value="<%=BaseMsg.getMsg("M0029")%>" onclick ="javascript:cancel_window()" class="btn blue" />
</td>
<td class="a_button" >
<input type="button"  id="query_id_submit" value="<%=BaseMsg.getMsg("M0030")%>"  onclick ="javascript:get_condition('<%=a00201_key %>','最近的查询','<%=DIVID %>')" class="btn blue" />
</td> 
<td class="a_button">
<input type="button"  id="query_id_setdef" value="<%=BaseMsg.getMsg("M0031")%>"  onclick ="javascript:set_con_default('<%=a00201_key %>','<%=DIVID %>')" class="btn blue" />
</td>  
</tr>
</table>
<div style="overflow:auto; height:340px;">
<table  class="query" >
<tr class="h">
<td  style="width:22px;">
序号
</td>
<td style="width:20px;">
&nbsp;
</td>
<td style="width:80px;">
列名
</td >
<td style="width:50px;">
关系
</td>
<td style="width:240px;">
值
</td>
<td style="width:40px;">
 排序
</td>
<td style="width:30px;">
 分组
</td>
<td style="width:30px;">
 -
</td>
</tr>
<%
int j = 0;
StringBuilder collist = new StringBuilder();
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
    string bs_query = dt_a013010101.Rows[i]["bs_query"].ToString();
    if (col_edit == "datelist" || col_edit == "datetimelist")
    {
        col_type = "date";
    }
    if (col_visible == "0" || bs_query != "1")
    {
        continue;
    }
    collist.Append(a10001_key + ",");
    j = j + 1;
 %>       
 <tr >
 <td >
    <%=j.ToString()%>
 </td>
 <td align=center>
 <img onclick="clearitem('<%=a10001_key %>')" alt="清除条件" title="清除条件" src="../images/114.gif" >
 </td>
 <td >
     <%=col_text%>
 </td>
 <td>
       <%   string ls_calc = "";
            if (col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0 || col_edit.IndexOf("checkbox") == 0)
            {
                ls_calc = "<INPUT  TYPE=\"checkbox\"  id=\"all" + a10001_key + "\"   value=\"0\"  onclick=\"selectqueryall(this,'" + a10001_key + "')\" >全部";

                ls_calc += "<select  style=\"font-size:9pt;font-family: 宋体;display:none;\" id=\"CALC" + a10001_key + "\" onchange=\"calc_change(this)\" >";
                ls_calc += "<option  selected value=\"IN\">IN</option>";
            }
            else
            {
                ls_calc = "<select  style=\"font-size:9pt;font-family: 宋体;width:55px;\" id=\"CALC" + a10001_key + "\" onchange=\"calc_change(this)\">";
                if (col_edit.IndexOf("datetimelist") == 0 || col_edit.IndexOf("datelist") == 0)
                {
                    ls_calc += "<option value=\"BETWEEN\">" + BaseMsg.getMsg("M0042") + "</option>";
                }

                else
                {
                    ls_calc += "<option  selected value=\"\"></option>";
                    ls_calc += "<option   value=\"=\"> =</option> ";
                    ls_calc += "<option   value=\" != \"> !=</option> ";
                    ls_calc += "<option   value=\">\"> ></option> ";
                    ls_calc += "<option value=\"<\"><</option>";
                    ls_calc += "<option value=\"LIKE\">" + BaseMsg.getMsg("M0040") + "</option>";
                    ls_calc += "<option value=\"NOT LIKE\">" + BaseMsg.getMsg("M0041") + "</option>";
                    ls_calc += "<option value=\"IN\">IN</option>";
                    ls_calc += "<option value=\"NOT IN\">NOT IN</option>";
                    ls_calc += "<option value=\"BETWEEN\">" + BaseMsg.getMsg("M0042") + "</option>";
                }

            }
            ls_calc += "<option value=\"SQL\">SQL"+ BaseMsg.getMsg("M0032") +"</option>";
            ls_calc += "<option value=\"NULL\">"+ BaseMsg.getMsg("M0033") +"</option>";
            ls_calc += "<option value=\"NOT NULL\">" + BaseMsg.getMsg("M00331") + "</option>";
            ls_calc += "</select>";

                                    
                   %>
                      <%=ls_calc%>
      
            </td>
    <td >
        <%      select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
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
                        ls_html += "<INPUT  TYPE=\"checkbox\" name=\"value" + a10001_key + "\" id=\"value" + a10001_key + "_1\"   value=\"1\">" + BaseMsg.getMsg("M0034")  + "";
                        ls_html += "<INPUT  TYPE=\"checkbox\" name=\"value" + a10001_key + "\" id=\"value" + a10001_key + "_0\"   value=\"0\">"+  BaseMsg.getMsg("M0035")  ;
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
                        ls_html += "<input   type=\"text\" style=\"width:95%;\" name=\"value" + a10001_key + "\"  id=\"value" + a10001_key + "\"  />";

                    }
                }
                ls_html += "</div>";
                ls_html += "<div id=\"inputsql_" + a10001_key + "\" style=\"display:none;width:80%;\"><input  style=\"width:100%;\" type=\"text\" name=\"v_" + a10001_key + "\"  id=\"vsql_" + a10001_key + "\"  />";
                ls_html += "</div>"; 
           
                %>  
        <%=ls_html%>
    </td>
    <td >
    <select  style="font-size:9pt;font-family: 宋体;width:33px;" id="sort_<%=a10001_key %>" onchange="sort_change(this)" >
        <option  selected value=""></option>
        <option   value="A"><%=BaseMsg.getMsg("M0036")%></option>
        <option   value="D"><%=BaseMsg.getMsg("M0037")%></option>
    </select>                       
    </td>
    <td align=center >
    <% if (col_edit.ToLower() == "u_number")
       { 
       %>
         <input  type="hidden"   id="group_<%=a10001_key %>"  value=""  />
         <select  style="font-size:9pt;font-family: 宋体;width:30px;" id="s_group_<%=a10001_key %>" onchange="document.getElementById('group_<%=a10001_key %>').value= this.options[this.options.selectedIndex].value;" >
            <option   selected value=""></option>
            <option   value="SUM">SUM</option>
            <option   value="AVG">AVG</option>
        </select> 
       <%
       }
       else
       { 
    %> 
          <input  type="checkbox"   id="group_<%=a10001_key %>"  value="0"  onclick="if (this.value=='0') this.value='1'; else this.value='0';" />
              
     <% } %>
    
    </td>
    <td >
    <select  name="bysort"  disabled  style="font-size:9pt;font-family: 宋体;width:30px;" id="bysort_<%=a10001_key %>" >       
         <option  value="00"></option> 
         <%
            for (int jj = 101; jj < 199; jj++)
            { 
         %>   
          <option   value="<%=jj.ToString().Substring(1) %>"><%=jj.ToString().Substring(1)%></option>
          <%} %>       
          <option  selected value="99"></option>
    </select>                       
    </td>

</tr>
        
        
        
   <%
    
}

 %>
  
</table>
 <input id="querycol" type="hidden"  value="<%=collist.ToString() %>"/>
<% 
//查询条件
   
%>

</div>
<%} %>
<% if (req_id == "SHOW") {
       //获取当前的sql
     string COLID = BaseFun.getAllHyperLinks(RequestXml, "<COLID>", "</COLID>")[0].Value;
     string MAINROWLIST = BaseFun.getAllHyperLinks(RequestXml, "<MAINROWLIST>", "</MAINROWLIST>")[0].Value;
     string ROWLIST = BaseFun.getAllHyperLinks(RequestXml, "<ROWLIST>", "</ROWLIST>")[0].Value;
     string ROWID = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
     string data_index = GlobeAtt.DATA_INDEX;
     StringBuilder str_html = new StringBuilder();
     StringBuilder str_conhtml = new StringBuilder();
      
     for (int i = 0; i < dt_a013010101.Rows.Count; i++)
     {
         string a10001_key = dt_a013010101.Rows[i]["A10001_KEY"].ToString();
         if (COLID == a10001_key)
         {
             string BS_CHOOSE_SQL = dt_a013010101.Rows[i]["BS_CHOOSE_SQL"].ToString();
             string col03 = dt_a013010101.Rows[i]["col03"].ToString();
             string col04 = dt_a013010101.Rows[i]["col04"].ToString();
             string col05 = dt_a013010101.Rows[i]["col05"].ToString();
             string col06 = dt_a013010101.Rows[i]["col06"].ToString();
             string tree_html = "";
             int  data_width = 620;
             int  all_width  = 620;
             int  tree_width = 50;
             if (col06 != "" && col06 != null)
             {
                 tree_width = int.Parse(col06);
             }
             if (col03 == "1")
             {
                 data_width = all_width - tree_width ; 
             }
             BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[USER_ID]", GlobeAtt.A007_KEY);
             BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
             BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
             BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[", "<PARM>");
             BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("]", "</PARM>");
             if (col03 == "1")
             {
                 col04 = col04.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                 col04 = col04.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                 col04 = col04.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                 col04 = col04.Replace("[", "<PARM>");
                 col04 = col04.Replace("]", "</PARM>");        
             }
             MatchCollection col = BaseFun.getAllHyperLinks(BS_CHOOSE_SQL, "<PARM>", "</PARM>");
             for (int c = 0; c < col.Count; c++)
             {
                 string COLID_ = col[c].Value;
                 string v = "";
                 if (COLID_.IndexOf("MAIN_") == 0)
                 {
                     v = BaseFun.getStrByIndex(MAINROWLIST, data_index + COLID_.Replace("MAIN_", "") + "|", data_index);
                 }
                 else
                 {
                     v = BaseFun.getStrByIndex(ROWLIST, data_index + COLID_ + "|", data_index);
                 }
                 string sql = BS_CHOOSE_SQL.Replace("<PARM>" + COLID_ + "</PARM>", v);
                 BS_CHOOSE_SQL = sql;
                 if (col03 == "1" && col04.IndexOf("<PARM>" + COLID_ + "</PARM>") > 0)
                 {
                     sql = col04.Replace("<PARM>" + COLID_ + "</PARM>", v);
                     col04 = sql;
                 }
             }
             
            // BS_CHOOSE_SQL = BS_CHOOSE_SQL ;

             string CHOOSE_SORT = dt_a013010101.Rows[i]["CHOOSE_SORT"].ToString();
             if (CHOOSE_SORT.Length > 5)
             {

                 
                 dt_data = Fun.getDtBySql(BS_CHOOSE_SQL + " and rownum  <=  " + GlobeAtt.GetValue("RESULTROWS") + " " + CHOOSE_SORT);
                 BS_CHOOSE_SQL = BS_CHOOSE_SQL + CHOOSE_SORT;
             }
             else
             {
                 dt_data = Fun.getDtBySql(BS_CHOOSE_SQL + " and rownum  <=  " + GlobeAtt.GetValue("RESULTROWS"));
             }
             
             /*获取列名称*/
             //输入条件
             str_conhtml.Append("<div id=\"div_con\" style=\"display:none;\"><table>");                 
             //结果        
             string RESULT_ROWS = dt_a013010101.Rows[i]["RESULT_ROWS"].ToString();
             string COL_EXIST = dt_a013010101.Rows[i]["COL_EXIST"].ToString();
             str_html.Append("<div style=\"OVERFLOW:hidden;height:25px;width:" + data_width.ToString()+ "px;\"   id=\"alert_con" + COLID + "_x\" ><table class=\"showdata\">");
             str_html.Append("<tr>");
             str_html.Append("<th style=\"width:25px;\">#</th>");
             if (RESULT_ROWS =="1")
             {
                 str_html.Append("<th style=\"width:20px;\"><input id=\"" + COLID + "_CheckAll\" type=\"checkbox\" name =\"con" + COLID + "\"  value =\"1\" onclick=\"ChooseAll(this)\"/></th>");
             }
             else
             {
                 str_html.Append("<th style=\"width:20px;\">&nbsp;</th>");
             }
          
             int h = 365 - 45 - dt_data.Columns.Count * 23;
             if (h < 0)
             {
                 h = 0;
             }        
             string TABLE_SELECT = dt_a013010101.Rows[i]["TABLE_SELECT"].ToString();
             string[] bs_width = new string[dt_data.Columns.Count];
             string[] bs_edit = new string[dt_data.Columns.Count];
             string widthl = "";
             for (int c = 0; c < dt_data.Columns.Count; c++)
             {
                 string column_name = dt_data.Columns[c].ColumnName;
                 dt_temp = Fun.getDtBySql("select t.* from A10001 t where t.table_id ='" + TABLE_SELECT + "' and t.column_id ='"+column_name + "' and rownum  = 1");
                 bs_width[c] = "80";
                 string col_text = column_name;
                 string col_edit = "u_edit";
                 if (dt_temp.Rows.Count > 0)
                 {
                     bs_width[c] = dt_temp.Rows[0]["BS_WIDTH"].ToString();
                     bs_edit[c] = dt_temp.Rows[0]["COL_EDIT"].ToString();
                     col_text = dt_temp.Rows[0]["col_text"].ToString();
                     str_html.Append("<th style=\"width:" + bs_width[c] + "px;\">" + col_text + "</th>");
                     col_edit = dt_temp.Rows[0]["col_edit"].ToString();
                 }
                 else
                 {
                     str_html.Append("<th style=\"width:80px;\">" + column_name + "</th>");
                 }
                 widthl += c.ToString() + "|" + bs_width[c] + data_index;
                 
                   string ls_calc = "";                    
                   string a10001_key_ = c.ToString()  + COLID;
            if (col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0 || col_edit.IndexOf("checkbox") == 0)
            {
                ls_calc = "<INPUT  TYPE=\"checkbox\"  id=\"all" + a10001_key_ + "\"   value=\"0\"  onclick=\"selectqueryall(this,'" + a10001_key_ + "')\" >全部";

                ls_calc += "<select  style=\"font-size:9pt;font-family: 宋体;display:none;width:100%;\" id=\"CALC" + a10001_key_ + "\" >";
                ls_calc += "<option  selected value=\"IN\">IN</option>";
            }
            else
            {
                ls_calc = "<select  style=\"font-size:9pt;font-family: 宋体;width:100%;\" id=\"CALC" + a10001_key_ + "\" >";
                if (col_edit.IndexOf("datetimelist") == 0 || col_edit.IndexOf("datelist") == 0)
                {
                    ls_calc += "<option value=\"BETWEEN\">" + BaseMsg.getMsg("M0042") + "</option>";
                }

                else
                {
                    ls_calc += "<option  selected value=\"\"></option>";
                    ls_calc += "<option   value=\"=\"> =</option> ";
                    ls_calc += "<option   value=\" != \"> !=</option> ";
                    ls_calc += "<option   value=\">\"> ></option> ";
                    ls_calc += "<option value=\"<\"><</option>";
                    ls_calc += "<option value=\"LIKE\">" + BaseMsg.getMsg("M0040") + "</option>";
                    ls_calc += "<option value=\"NOT LIKE\">" + BaseMsg.getMsg("M0041") + "</option>";
                    ls_calc += "<option value=\"IN\">IN</option>";
                    ls_calc += "<option value=\"NOT IN\">NOT IN</option>";
                    ls_calc += "<option value=\"BETWEEN\">" + BaseMsg.getMsg("M0042") + "</option>";
                }
            }
            ls_calc += "<option value=\"SQL\">SQL"+ BaseMsg.getMsg("M0032") +"</option>";
            ls_calc += "<option value=\"NULL\">"+ BaseMsg.getMsg("M0033") +"</option>";
            ls_calc += "<option value=\"NOT NULL\">" + BaseMsg.getMsg("M00331") + "</option>";
            ls_calc += "</select>";



            str_conhtml.Append("<tr><td width=\"50px\">" + col_text + "</td><td width=\"50px\">" + ls_calc + "</td><td width=\"250px\"><input style=\"width:100%;\" type=\"text\"  name =\"con" + COLID + "\" id=\"con_" + c.ToString() + COLID + "\"></td>");
             }
             str_conhtml.Append("</tr></table></div><div id=\"div_input\" style=\"OVERFLOW:hidden;height:25px;width:" + all_width .ToString()+ "px;\"><table><tr><td >");

             str_conhtml.Append("<input type=\"button\" class=\"btn\"  value=\"显示条件\" id=\"Selectdata_" + COLID + "\" onclick=\"showcon(this,'alert_con" + COLID + "_x'," + h + ")\">");
            
             BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("\r", "");
             BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("\n", "");
             str_conhtml.Append("<input type=\"button\" class=\"btn blue\"  value=\"查询\"  id=\"query_btnshow\"  onclick=\"showdataquery('con" + COLID + "','" + BS_CHOOSE_SQL.Replace("'", "\\'") + "','" + RESULT_ROWS + "','" + widthl + "','"+ ROWID+"','"+ COL_EXIST+"','')\">");

             str_conhtml.Append("<input type=\"button\" class=\"btn\"  value=\"取消\" onclick=\"rbclose()\">");
             if (RESULT_ROWS == "1")
             {
                 str_conhtml.Append("<input type=\"button\" class=\"btn\"  value=\"选定\" id=\"Select_" + COLID + "\" onclick=\"chooseselects('"+ROWID+"','"+COLID+"')\">");
             }

             str_conhtml.Append("</td><td><div id=\"querydiv\"></div></td><td style=\"text-align:right;\">");
             str_conhtml.Append("显示条数(可改):<input type=\"text\" style=\"height:20px;width:80px;\" id=\"SHOWROWS_con" + COLID + "\"  value=\"" + GlobeAtt.GetValue("RESULTROWS") + "\">");
            
             str_conhtml.Append("</td></tr>");
             str_conhtml.Append("</table></div>");
             if (col03 == "1")
             {
                 str_html.Append("</tr></table></div><div style=\"OVERFLOW:scroll;height:305px;width:" + data_width.ToString() + "px;\"  id=\"alert_con" + COLID + "\" onscroll=\"scroll_x(this)\">");
             }
             else
             {
                 str_html.Append("</tr></table></div><div style=\"OVERFLOW:auto;height:310px;width:" + data_width.ToString() + "px;\"  id=\"alert_con" + COLID + "\" onscroll=\"scroll_x(this)\">");
             }
              str_html.Append("<table class=\"showdata\">");
             string onclick_ = " onclick=\"showdataquery('con" + COLID + "','" + BS_CHOOSE_SQL.Replace("'", "\\'") + "','" + RESULT_ROWS + "','" + widthl + "','" + ROWID + "','" + COL_EXIST + "','[ONCLICK]')\"";
             if (col03 == "1")
             {
                 tree_html = get_tree_html(col04, col05, tree_width.ToString(), onclick_);
             }

             for (int r = 0; r < dt_data.Rows.Count; r++)
             {
                 string v = dt_data.Rows[r][COL_EXIST].ToString();
                 if (r % 2 == 0)
                 {
                     str_html.Append("<tr class=\"r0\">");
                 }
                 else
                 {
                     str_html.Append("<tr class=\"r1\">");
                 }
                 str_html.Append("<td style=\"width:25px;\">"+  (r + 1 ).ToString()+"</td>");
                 if (RESULT_ROWS == "1")
                 {
                     str_html.Append("<td style=\"width:20px;\"><input id=\"con" + COLID + "_" + (r + 1).ToString() + "\" type=\"checkbox\" name =\"con" + COLID + "\"  value=\""+ v +"\"  /></td>");
                 }
                 else
                 {
                     str_html.Append("<td style=\"width:20px;\"><input id=\"con" + COLID + "_" + (r + 1).ToString() + "\" type=\"radio\"  name=\"" + COLID + "radio\" onclick=\"chooseselect('" + ROWID + "_" + COLID + "','" + v + "')\" /></td>");
                 }
                 for (int c = 0; c < dt_data.Columns.Count; c++)
                 {
                    string col_text = dt_data.Rows[r][c].ToString();
                    if (col_text == null)
                    {
                        col_text = "";
                    }
                    if (dt_data.Columns[c].DataType.Name == "DateTime")
                    {
                        if (col_text.Length > 12)
                        {
                            col_text = col_text.Substring(0, 10);
                        }
                    }
                    if (bs_edit[c] == "checkbox")
                    {
                        if (col_text == "1")
                        {
                            col_text = "<input  type=\"checkbox\"  disabled value=\"1\" checked  />";
                        }
                        else
                        {
                            col_text = "<input  type=\"checkbox\"  disabled value=\"0\"   />";
                        }
                    }
                    if (dt_data.Columns[c].DataType.Name == "Decimal")
                    {
                        //style=" 
                        col_text = "<div style=\"text-align:right;margin-right:5px;\">" + col_text + "</div>";
                        if (r == 0)
                        {
                            str_html.Append("<td style=\"width:" + bs_width[c] + "px;\">" + col_text + "</td>");
                        }
                        else
                        {
                            str_html.Append("<td >" + col_text + "</td>");
                        }
                    }
                    else
                    {
                        if (r == 0)
                        {
                            str_html.Append("<td style=\"width:" + bs_width[c] + "px;\">" + col_text + "</td>");
                        }
                        else
                        {
                            str_html.Append("<td><span>" + col_text + "</span></td>");
                        }
                    }
                 }
                 str_html.Append("</tr>");
             }
             
             
             str_html.Append("</table>");
             
             
             str_html.Append("</DIV>");
       
             
             if (col03 == "1")
             {
                 Response.Write("<div id=\"div_choose\" style=\"overflow:hidden;\">");
                 Response.Write(str_conhtml.ToString());
                 Response.Write("<div id=\"div_data_tree\" style=\"height:" + (310).ToString() + "px;\"><div  style=\"width:" + (tree_width - 10).ToString() + "px;height:" + (305).ToString() + "px;float:left;margin:20px 0 0 0 ; overflow:scroll;\">");              
                 Response.Write( tree_html);
                 Response.Write("</div><div style=\"overflow:hidden;height:" + (330).ToString() + "px;width:" + (data_width).ToString() + "px;float:right;\">");
                 Response.Write("<div id=\"div_data\" style=\"height:"+ (310).ToString()+"px\">" + str_html.ToString() + "</div>");
                 Response.Write("</div>");
                 Response.Write("</div>");
                 Response.Write("</div>");
             }
             else
             {
                 Response.Write("<div id=\"div_choose\">");
                 Response.Write(str_conhtml.ToString());
                 Response.Write("<div id=\"div_data\" style=\"height:" + (h).ToString() + "px\">" + str_html.ToString() + "</div>");
                 Response.Write("</div>");
             }
      
             break;            
         }
     }

   }%>