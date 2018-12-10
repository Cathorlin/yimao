<%@ Control Language="C#" AutoEventWireup="true" CodeFile="QueryList.ascx.cs" Inherits="BaseForm_QueryList"  EnableViewState="false" %>
<script language=javascript>
A00201LIST  +=  '<%=a00201_key %>,'
</script>
<script>

</script>
<div style="margin-left:1px; margin-top:0px;">
<% Response.Flush(); %>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="30">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="15" height="30"></td>
        <td width="400"><img src="../images/a1.gif" width="16" height="16" />
         <span class="STYLE4"><%=BaseMsg.getMsg("M0011") %>：<select id="query_select"><% 
                                                                                          
           string ls_btn = dt_a00204.Rows[0][0].ToString();
           int pos1 = ls_btn.IndexOf("<PARM>");
           int pos2 = ls_btn.IndexOf("</PARM>");
           string ls_parm = ls_btn.Substring(pos1 + 6, pos2 - pos1 - 6);
           string ls_btn0 = ls_btn.Substring(0, pos1);
          for (int i = 0; i < dt_a006.Rows.Count; i++)
          {
              string query_id = dt_a006.Rows[i]["query_id"].ToString();
              string o_html = "<option  value=\"" + query_id + "\">" + query_id + "</option>";
              if (select_id == query_id)
              {
                  o_html = "<option  value=\"" + query_id + "\" selected>" + query_id + "</option>";
              }
          %>
         <%=o_html %>
         <%}%></select>
         <input type="button"  class="btn blue" value="<%=BaseMsg.getMsg("M0012") %>"  onclick="query('<%=a00201_key %>')"   />
         <input type="button" class="btn blue"  value="<%=BaseMsg.getMsg("M0013") %>" onclick="gjquery('<%=a00201_key %>')"   />
         
 </span>
     </td>
        <td width="800">
        <%=ls_btn0 %>
</td>
        <td width="14"></td>
      </tr>
    </table></td>
  </tr>
    <tr>
    <td>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td  style="width: 9px;">&nbsp;</td>
        <td>
        <div style="display:block; overflow:visible;">
    
<%          int all_width = 30;
            int col_count = 0;
            string tr_head = "";
            string if_show_sum = "0";
            string table_id___ = "";
            string foot_html = " <tr class=\"tr_ShowTableHead\"><td style=\"width:30px;\">小计</td>";
            tr_head += "<tr class=\"tr_ShowTableHead\">";
            tr_head += "<td style=\"width:30px;\">#</td>";
            all_width = all_width + 20;
            foot_html += "<td>&nbsp;</td>";
            tr_head += "<td style=\"width:20px;\"><input id=\"Cbx_all\" type=\"checkbox\" value=\"0\" onclick=\"cbx_selectall(this,'row')\" /></td>";
            tr_head += Environment.NewLine;
         for (int j = 0; j < dt_a013010101.Rows.Count; j++)
         {
         table_id___ = dt_a013010101.Rows[j]["table_id"].ToString();
         string bs_width = dt_a013010101.Rows[j]["BS_WIDTH"].ToString();
         string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
         string bs_list = "1";// dt_a013010101.Rows[j]["BS_LIST"].ToString();
         string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
         string sum_flag = dt_a013010101.Rows[j]["sum_flag"].ToString();
         if (col_visible == "1" && bs_list == "1")
         {
             tr_head += "<td style=\"width:" + bs_width + "px;\">" + col_text + "</td>";
             tr_head += Environment.NewLine;
             col_count = col_count + 1;
         }
         if (sum_flag.Length  > 1 )
         {
             if_show_sum = "1";
             dt_a013010101.Rows[j]["ORDER_BY"] = 0;
         }
         if (col_visible == "1" && bs_list =="1")
         {
            all_width = all_width + int.Parse(bs_width) + 0;
         }
        
       }
            
       %>
         <div style="OVERFLOW:hidden;float:left; margin-left:1px; margin-right:1px;" id="div_flow_x">
  
         <%
             Response.Write("<table   class=\"ShowTable\"  width=\"" + (all_width).ToString() + "px;\">");
             Response.Write(tr_head);
             Response.Write(Environment.NewLine);


             Response.Write("</table>");
          %>
         
         </div>
         <script>
        
         </script>
         <div style="OVERFLOW-y:scroll;overflow-x:auto;height:<%=SH - 385 %>px; float:left;margin-left:1px; margin-right:1px;" id="div_flow" >        
        <%  
           
           Response.Write("<table   class=\"ShowTable\"  width=\"" + (all_width).ToString() + "px;\"  onmouseover=\"changeto()\"  onmouseout=\"changeback()\">" );
           //Response.Write(tr_head);
           for (int i = 0; i < dt_data.Rows.Count; i++)
           {
               string tr_html = "";
               string rowid = ((currentpage - 1) * PageRow + i + 1).ToString();
               if (i % 2 == 0)
               {
                   tr_html += "<tr id='row" + rowid + "' class=\"r0\" onclick=\"selectrow(this,'r2','r0')\">";
               }
               else
               {
                   tr_html += "<tr id='row" + rowid + "' class=\"r1\" onclick=\"selectrow(this,'r2','r1')\">";
               }
               tr_html += Environment.NewLine;
               tr_html += "<td style=\"width:30px;\">" + rowid + "</td>";
               tr_html += Environment.NewLine;
               string key = "";
               try
               {
                   key = dt_data.Rows[i][dt_a00201.Rows[0]["table_id"].ToString() + "_KEY"].ToString();
               }
               catch
               {
                   key = "-100";
               }
               tr_html += "<td style=\"width:20px;\"><input  type=\"checkbox\"  id=\"cbx_row" + rowid + "\" name=\"cbx_row\"   /></td>";
               tr_html += Environment.NewLine;
               string rowparm = ls_parm;
               string objid = "";
               for (int j = 0; j < dt_a013010101.Rows.Count; j++)
               {

                   string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
                   string col_value = dt_data.Rows[i][column_id].ToString();
                   //根据编辑方式显示不同的数据
                   string col_edit = dt_a013010101.Rows[j]["col_edit"].ToString();
                   string IFQUERYEDIT = dt_a013010101.Rows[j]["IFQUERYEDIT"].ToString();
                   if ((col_edit == "datelist" || col_edit == "datetimelist") && col_value.Length > 10)
                   {
                       DateTime dt = DateTime.Parse(col_value);
                       col_value = string.Format("{0:u}", dt);//2005-11-05 14:23:23Z
                       if (col_edit == "datelist")
                       {
                           col_value = col_value.Substring(0, 10);
                       }
                       else
                       {
                           col_value = col_value.Substring(0, 19);
                       }
                       // col_value = col_value.Substring(0, 10);

                   }
                   string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
                   string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
                   string bs_width = dt_a013010101.Rows[j]["BS_WIDTH"].ToString();
                   string ls_showcolumn = dt_a013010101.Rows[j]["BS_HTML"].ToString();
                   string sum_flag = dt_a013010101.Rows[j]["sum_flag"].ToString();
                   if (IFQUERYEDIT == "1")
                   {
                       ls_showcolumn = Fun.ShowColumn("M", a00201_key, dt_a013010101.Rows[j], (i + 1 ).ToString(), col_value, "querydata");
                   }
                   else
                   {
                          if ((col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0) && col_value != "")
                           {
                               string select_sql = dt_a013010101.Rows[j]["select_sql"].ToString();
                               select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                               select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                               dt_temp = Fun.getDtBySql(select_sql);
                               for (int p = 0; p < dt_temp.Rows.Count; p++)
                               {
                                   if (dt_temp.Rows[p][0].ToString() == col_value)
                                   {
                                       col_value = dt_temp.Rows[p][1].ToString();
                                       break;
                                   }
                               }

                           }
                           if ((col_edit.IndexOf("checkbox") == 0))
                           {
                               if (col_value == "1")
                               {
                                   col_value = "<input type=\"checkbox\" checked disabled>";
                               }
                               else
                               {
                                   col_value = "<input type=\"checkbox\" disabled>";
                               }
                           }
                           if (ls_showcolumn == "" || ls_showcolumn == null)
                           {
                               ls_showcolumn = "[" + column_id.ToUpper() + "]";
                           }
                           ls_showcolumn = ls_showcolumn.Replace("[JUMPA002KEY]", dt_a002.Rows[0]["MENU_ID"].ToString());
                           ls_showcolumn = ls_showcolumn.Replace("[JUMPA00201KEY]", dt_a00201.Rows[0]["A00201_KEY"].ToString());
                           rowparm = rowparm.Replace("[" + column_id.ToUpper() + "]", col_value);
                           ls_showcolumn = Fun.ShowListHtml(ls_showcolumn, dt_data, i, column_id, col_value); // ShowColumn(option, dt_a00201.Rows[0]["A00201_KEY"].ToString(), dt_a013010101.Rows[j], i.ToString(), column_id, col_value, "list");
                    }
                   if (col_visible == "1")
                   {

                       if (i == 0)
                       {
                           tr_html += "<td  style=\"width:" + bs_width + "px\" > " + ls_showcolumn + "</td>";
                       }
                       else
                       {
                           tr_html += "<td> " + ls_showcolumn + "</td>";

                       }
                       tr_html += Environment.NewLine;
                       if (sum_flag == "SUM")
                       {

                           dt_a013010101.Rows[j]["ORDER_BY"] = decimal.Parse(dt_a013010101.Rows[j]["ORDER_BY"].ToString()) + decimal.Parse(col_value);
                       }

                   }

               }

               tr_html += "<td style=\"display:none;\"><input type=\"hidden\" id=\"v_" + rowid + "\" value=\"" + rowparm + "\" />";

               try
               {
                   objid = dt_data.Rows[i]["objid"].ToString();
               }
               catch
               {
                   objid = "";
               }
               tr_html += "<input type=\"hidden\" id=\"objid_" + rowid + "\" value=\"" + objid + "\" />";
               tr_html += "</tr>";
               tr_html += Environment.NewLine;
               Response.Write(tr_html);
               Response.Flush(); 
           }
           if (if_show_sum == "1")
           {
               for (int j = 0; j < dt_a013010101.Rows.Count; j++)
               {
                   string bs_width = dt_a013010101.Rows[j]["BS_WIDTH"].ToString();
                   string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
                   string bs_list = "1";// dt_a013010101.Rows[j]["BS_LIST"].ToString();
                   string col_value = dt_a013010101.Rows[j]["ORDER_BY"].ToString();
                   string sum_flag = dt_a013010101.Rows[j]["sum_flag"].ToString();


                   if (col_visible == "1" && bs_list == "1")
                   {
                       if (sum_flag == "SUM")
                       {
                           if (col_value == "0")
                           {
                               col_value = "0";
                           }
                           foot_html += "<td>" + col_value + "</td>";
                       }
                       else
                       {
                           foot_html += "<td>&nbsp;</td>";
                       }
                   }

               }
               foot_html += "<td style=\"display:none;\"></td></tr>";
               if (dt_data.Rows.Count > 0)
               {
                   Response.Write(foot_html);
               }
           }
           Response.Write(Environment.NewLine); 
            
            
           Response.Write("</table>");
%>        
        </div>
   <script language=javascript>

    
    document.getElementById("div_flow_x").style.width =  win_Width - 22  ;
    document.getElementById("div_flow_x").style.height = 20  ;
    document.getElementById("div_flow").style.width =  win_Width - 22  ;
    document.getElementById("div_flow").style.height = win_Height - 138;
    document.getElementById("div_flow").onscroll = function()
    {
        //alert(this.scrollLeft);
         document.getElementById("div_flow_x").scrollLeft = this.scrollLeft;
         closeLayer();

    }
    setrbdt('<%=a00201_key %>');
   </script>
            </div>
        </td>
        <td width="9">&nbsp;</td>
      </tr>
    </table>
    
    </td>
  </tr>
  <tr>
    <td height="29">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="15" height="29"></td>
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="25%" height="29" nowrap="nowrap"><span class="STYLE1">共<%=rowscount %>条纪录，当前第<%=currentpage %>/<%=pagecount %>页，每页<%=PageRow %>条纪录</span></td>
            <td width="75%" valign="top" class="STYLE1"><div align="right">
              <table width="352" height="20" border="0" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="62" height="29" valign="middle"><div align="right"><img src="../images/first.gif" width="37" height="15"  style="cursor:hand;"onclick="showquerypage('<%=a00201_key %>',1)" /></div></td>
                  <%
                    if (currentpage > 1)
                    {
                   %>
                  <td width="50" height="29" valign="middle"><div align="right" ><img src="../images/back.gif" width="43" height="15" style="cursor:hand;" onclick="showquerypage('<%=a00201_key %>',<%=currentpage - 1 %>)"/></div></td>
                  <%}
                    if (currentpage < pagecount && pagecount > 0 )
                    {
                   %>
                  <td width="54" height="29" valign="middle"><div align="right"><img src="../images/next.gif" width="43" height="15"  style="cursor:hand;" onclick="showquerypage('<%=a00201_key %>',<%=currentpage + 1 %>)" /></div></td>
                 <%
                    }
                     if ( pagecount > 0)
                     {
                  %>
                  
                  <td width="49" height="29" valign="middle"><div align="right" ><img src="../images/last.gif" width="37" height="15" style="cursor:hand;" onclick="showquerypage('<%=a00201_key %>',<%=pagecount %>)" /></div></td>
                 <%
                    }
                 %>
                  <td width="59" height="29" valign="middle"><div align="right">转到第</div></td>
                  <td width="25" height="29" valign="middle"><span class="STYLE7">
                    <input name="textfield" id="showpagenum" type="text" value="<%=currentpage %>"  style="height:15px; width:25px; margin-top:0;" size="5" />
                  </span></td>
                  <td width="23" height="29" valign="middle">页</td>
                  <td width="30" height="29" valign="middle"><img src="../images/go.gif" width="37" height="15" style="cursor:hand;" onclick="show_page('<%=a00201_key %>',<%=pagecount %>)"/></td>
                </tr>
              </table>
            </div></td>
          </tr>
        </table></td>
        <td width="14"></td>
      </tr>
    </table></td>
  </tr>
</table>
</div>




