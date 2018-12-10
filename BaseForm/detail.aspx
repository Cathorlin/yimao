<%@ Page Language="C#" AutoEventWireup="true" CodeFile="detail.aspx.cs" Inherits="BaseForm_detail" %>
<% //SaveLog.Verification("------开始DETAIL");
    string table_key = dt_a00201.Rows[0]["TABLE_KEY"].ToString();
    string main_key = dt_a00201.Rows[0]["main_key"].ToString();
    string table_id = dt_a00201.Rows[0]["table_id"].ToString();
    string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
    string itemchange = "";
    string showcolor = BaseMsg.getMsg("M0019");
    string bslist_ = "";
    ArrayList ddd_list = new ArrayList();    
    string data_index = GlobeAtt.DATA_INDEX;
    StringBuilder inserthtml = new StringBuilder();
    StringBuilder trhead_html = new StringBuilder();
    StringBuilder sum_html = new StringBuilder();
    string if_show_sum = "0"; //是否显示合计列
    string form_init = "";
    if (option == "T")
    {
        inserthtml.Append(" var rowdata_ = new Array();");

        //var str_ = "1|<a onclick=add_row('2028-1',10,'')> dddddddd</a>" + data_index;
        //for (var i = 2; i < 20; i++)
        //{
        //    str_ += String(i) + "|" + String(i) + data_index;
        //}
        int  ver = int.Parse( BaseFun.getAllHyperLinks(RequestXml, "<VER>", "</VER>")[0].Value);
        for (int i = 0; i < dt_data.Rows.Count; i++)
        {
            string rowlist_ = "";
            string objid = dt_data.Rows[i]["objid"].ToString();
            rowlist_ = "OBJID|" + objid + data_index;
            for (int j = 0; j < dt_a013010101.Rows.Count; j++)
            {
                string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
                string bs_list = dt_a013010101.Rows[j]["BS_LIST"].ToString();
                if (bs_list == "1")
                {
                string col_value = dt_data.Rows[i][column_id].ToString();
                string A10001_KEY = dt_a013010101.Rows[j]["A10001_KEY"].ToString();
                string BS_HTML = dt_a013010101.Rows[j]["BS_HTML"].ToString();
                string col_edit = dt_a013010101.Rows[j]["col_edit"].ToString();
                if (col_value == null)
                {
                    col_value = "";
                }

                BS_HTML = BS_HTML.Replace("[JUMPA002KEY]", dt_a00201.Rows[0]["MENU_ID"].ToString());
                BS_HTML = BS_HTML.Replace("[JUMPA00201KEY]", dt_a00201.Rows[0]["A00201_KEY"].ToString());
                BS_HTML = BS_HTML.Replace("[ROWNUM]", "[ROW]");
                BS_HTML = BS_HTML.Replace("[TREENODE]", (ver + 1).ToString());                    
                if ((col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0) && col_value != "")
                {
                    string select_sql = dt_a013010101.Rows[j]["select_sql"].ToString();
                    select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                    select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                    select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
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
                if ((col_edit == "datelist" || col_edit == "datetimelist") && col_value.Length > 10)
                {

                    if (col_value.IndexOf(".") > 0)
                    {
                        col_value = col_value.Substring(0, 10) + " " + col_value.Substring(11).Replace(".", ":");
                    }

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
                string ls_showcolumn = "";
                if (BS_HTML == "[" + column_id + "]")
                {
                    BS_HTML = col_value.Replace(Environment.NewLine, "");
                    ls_showcolumn = BS_HTML;
                }
                else
                {
                    BS_HTML = BS_HTML.Replace("[" + column_id + "]", col_value);

                    ls_showcolumn = Fun.ShowListHtml(BS_HTML, dt_data, i, column_id, col_value);
                }
                if (j == 0)
                {
                    ls_showcolumn = "<div style=\"margin-left:" + (10 * ver ).ToString()+ "px;\">" + ls_showcolumn + "</div>";
                }
               
                    rowlist_ += A10001_KEY + "|" + ls_showcolumn + data_index;
                }
            }
            rowlist_ = rowlist_.Replace("\"", "\\\"");
            inserthtml.Append("rowdata_[" + i.ToString() + "] = \"" + rowlist_ + "\";");            
        }
        string rownum_ = BaseFun.getAllHyperLinks(RequestXml, "<PageNum>", "</PageNum>")[0].Value;
        inserthtml.Append("add_row_(\"" + a00201_key + "\",\"" + rownum_ + "\",rowdata_);");
        Response.Write(inserthtml.ToString());
        
        return;
    }
    
    
    if ((option == "M" || option == "V") && dt_a00201.Rows[0]["if_main"].ToString() == "1")
    {
        trhead_html.Append("<select    id=\"sh_" + a00201_key + "\" onchange=\"query_select(this,'"+ main_key_value + "');\" >");
        trhead_html.Append(Environment.NewLine);
        if (dt_data.Rows.Count == 0)
        {
            trhead_html.Append("<option    value=\"\"></option>");
        }
        string col01 = "";
        try
        {
            col01 = dt_a00201.Rows[0]["COL01"].ToString();
        }
        catch
        {
            col01 = main_key;
        }
        if (col01 == null || col01 == "")
        {
            col01 = main_key;
        }
        for (int i = 0; i <  dt_data.Rows.Count; i++)
        {
            string v_ = dt_data.Rows[i][main_key].ToString();
            string n_ = dt_data.Rows[i][col01].ToString();
            if (i == 0)
            {
                trhead_html.Append("<option  selected  value=\"" + v_ + "\">" + n_ + "</option>");
            }
            else
            {
                trhead_html.Append("<option   value=\"" + v_ + "\">" + n_ + "</option>");
            }
            trhead_html.Append(Environment.NewLine);
        }
            
        trhead_html.Append("</select>");
        string h = trhead_html.ToString().Replace("\"", "\\\"").Replace(Environment.NewLine,"");
        Response.Write("$(\"#showquery_" + a00201_key + "\").html(\"" + h + "\");");
        if (dt_data.Rows.Count > 0)
        {
            Response.Write("change_url_key( main_key_value ,'"+ dt_data.Rows[0][main_key].ToString() + "');");        
        }
        else
        {
            Response.Write("set_mainquery(\"" + h + "\");");
        }        
        return;
    }
    //初始化
    if (option == "I" || option == "M"  ) 
    {
        form_init = Fun.getJson(json, "P10"); 
        if (form_init.Length > 5 )
        {
            //ORDER_NOB24546LINE_ITEM_NO0
            form_init = form_init.Replace("[REQUESTURL]", "REQUESTURL|" + RequestURL + data_index);
            form_init = form_init.Replace("[MAINPARM]", main_key + "|" + main_key_value + GlobeAtt.DATA_INDEX + "LINE_ITEM_NO|0" + GlobeAtt.DATA_INDEX);
            form_init = data_index +  Fun.getProcData(form_init, dt_a00201.Rows[0]["TABLE_ID"].ToString());
        }
        else
        {
            form_init = "";
        }
    }
%>

<div id="btn_<%=a00201_key %>" class="detail_toolbar">
<%//已有 的查询
 if (option == "Q")
 {
        string a006_sql = "Select  distinct  query_id  from A006 t  where user_id='" + GlobeAtt.A007_KEY + "' AND a00201_key ='" + a00201_key + "'";
        dt_temp = Fun.getDtBySql(a006_sql);
   %>      
<%=BaseMsg.getMsg("M0011")%>：
    <select id="Select_query_0"  style="font-size:9pt;height:20px; margin-top:0px;"> 
    <option  value=""></option>
    <option  value="最近的查询" ><%=BaseMsg.getMsg("M0023")%></option>
    <%
    for (int i = 0; i < dt_temp.Rows.Count; i++)
    {
        string query_id = dt_temp.Rows[i]["query_id"].ToString();
        if (query_id == "最近的查询")
        {
            continue;
        }
        string DEF_FLAG = "";
        if (QUERYID == query_id)
        {
            DEF_FLAG = "selected=\"selected\"";
        }
        else
        { 
            DEF_FLAG ="";
        }
        string a006_key = dt_temp.Rows[i]["query_id"].ToString();
        %>
        <option <%=DEF_FLAG %>  value="<%=query_id %>"><%=query_id%></option>
        <%
    } %>
</select> 
<input id="Q<%=a00201_key %>" type="button" class="btn blue" value="<%=BaseMsg.getMsg("M0024")%>"  onclick="QueryById('<%=a00201_key %>','<%=DIVID %>')"/> 
<input id="QUERY<%=a00201_key %>" type="button" class="btn blue" value="<%=BaseMsg.getMsg("M0012") %>"  onclick="QueryData('<%=a00201_key %>','<%=DIVID %>')"/>
<%}
else
{ 
%>
<input  id="QUERY<%=a00201_key %>"  type="button" class="btn blue" value="<%=BaseMsg.getMsg("M0012")%>"  onclick="QueryData('<%=a00201_key %>','<%=DIVID %>')"/>
<%}     
%>
<%=dt_a00204.Rows[0][0].ToString()%>
<%
if (pagecount > 1)
{
        int showpagenum = 5;
        for (int i = 0; i < pagecount; i++)
        {
            if (i == (pagecount - 1) && PageNum < pagecount - (showpagenum - 1))
            {
          %>
<input  class="pagebtn"  type=button value=".." />
   <%}
            if ((i + 1) != PageNum)
            {
                if (i == 0 || i == (pagecount - 1) || (i > PageNum - showpagenum + 1 && i < PageNum + showpagenum - 1))
                {
          %>   
 <input  class="pagebtn"  type=button value="<%=(i+1).ToString() %>" onclick="loaddetail('<%=dt_a00201.Rows[0]["a00201_key"].ToString()%>','<%=dt_a00201.Rows[0]["a00201_key"].ToString()%>','<%=main_key_value %>','<%=option %>','1','<%=(i+1).ToString() %>','<%=QUERYID %>')"/>
  <%}
            }
            else
            { %>
 <input  class="pagebtncurr"  type=button value="<%=(i+1).ToString() %>" />
  <%}
              if (i == 0 && PageNum > 2 && pagecount > showpagenum)
            {
           %>
  <input  class="pagebtn"  type=button value=".." />
 <%}
        }
    }  %>
<%string showchild = "";
  string if_showdetail = "1";
  try
  {
      if_showdetail = dt_a00201.Rows[0]["if_showdetail"].ToString();
  }
  catch
  {
      if_showdetail = "0";
  }
  if (option == "Q" && if_showdetail == "1")
  {
      dt_temp = Fun.getDtBySql("select t.* from a00201 t where  t.menu_id='" + dt_a00201.Rows[0]["MENU_ID"].ToString() + "'");
      if (dt_temp.Rows.Count > 0)
      {
          //if showchild ==
           showchild = GlobeAtt.GetValue("SHOWCHILD_" + a00201_key);
          if (showchild == "")
          {
              Session["SHOWCHILD_" + a00201_key] = "0";
              showchild = "0";
          }
          
          if (showchild == "0")
          {
              Response.Write("<input type=checkbox id=\"showchild_"+ a00201_key +"\"  value=\"0\" onclick=\"setshowchild(this,'"+a00201_key +"')\" />");
          }
          else
          {
              Response.Write("<input type=checkbox id=\"showchild_" + a00201_key + "\" value=\"1\"  checked  onclick=\"setshowchild(this,'" + a00201_key + "')\" />");          
          }
          Response.Write("显示明细");
      }
  }
 %>
</div>




<div id="d_main_<%=a00201_key %>">
<%
    //SaveLog.Verification("------开始循环");
   StringBuilder str_div = new StringBuilder();
   Boolean lb_haver = false;    
   str_div.Append("<div style=\"OVERFLOW:hidden;\"   id=\"scroll_" + a00201_key + "_x\" onscroll=\"scroll_x(this)\">");
   str_div.Append(Environment.NewLine);
   str_div.Append("<table  class=\"ShowTable\" style=\"width:[_DIV_WIDTH_]px;\" >");
   str_div.Append(Environment.NewLine);
   str_div.Append("<tr class=\"tr_ShowTableHead\">");
   str_div.Append("<th style=\"width:40px;\">");
   str_div.Append("<input  type=\"checkbox\"  id=\"cbx_"+a00201_key+"\" value=\"0\" onclick=\"cbx_selectall(this,'"+ a00201_key+"')\" />#");
   str_div.Append("</th>");
   StringBuilder str_s = new StringBuilder();
   str_s.Append("<div style=\"OVERFLOW:hidden;\"   id=\"scroll0_" + a00201_key + "_x\" onscroll=\"scroll_x(this)\">");
   str_s.Append(Environment.NewLine);
   str_s.Append("<table  class=\"ShowTable\" style=\"width:[_S_WIDTH_]px;\" >");
   str_s.Append(Environment.NewLine); 
   str_s.Append("<tr class=\"tr_ShowTableHead\">");
   str_s.Append("<th style=\"width:20px;\">");
   str_s.Append("#");
   str_s.Append("</th>");   
    if (option != "Q")
    {    
      str_div.Append("<th style=\"width:35px;\">&nbsp;</th>");
    }
    int bs_div_width =20;
    int bs_s_width = 20;
  
    for (int j = 0; j < dt_a013010101.Rows.Count; j++)
    {      
        string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
        string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
        string col_child = dt_a013010101.Rows[j]["COL_CHILD"].ToString();
        
        if (GlobeAtt.LANGUAGE_ID != "CN")
        {
            dt_a013010101.Rows[j]["COL_TEXT"] = dt_a013010101.Rows[j][GlobeAtt.LANGUAGE_ID + "_COL_TEXT"].ToString();
            
            dt_a013010101.Rows[j]["MAIN_TAB"] = dt_a013010101.Rows[j][GlobeAtt.LANGUAGE_ID + "_MAIN_TAB"].ToString();
        }
        string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
        if (col_text.ToUpper().IndexOf("SELECT ") == 0  )
        {
            col_text = col_text.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            col_text = col_text.Replace("[MAIN_KEY]",  main_key_value);           
            dt_temp = Fun.getDtBySql(col_text);
            col_text = dt_temp.Rows[0][0].ToString();
            if (col_text != "" && col_text != null && col_text.Length > 1)
            {
                dt_a013010101.Rows[j]["COL_TEXT"] = col_text;
            }
            else
            {
                dt_a013010101.Rows[j]["COL_TEXT"] = column_id;
            }
        }
        
        Boolean if_itemchange = false; 
        if (col_child.Length >= 1)
        {
            if_itemchange = true;
        }
        if (if_itemchange == false)
        {
            string CALC_FLAG = dt_a013010101.Rows[j]["CALC_FLAG"].ToString();
            string FORMULA = dt_a013010101.Rows[j]["FORMULA"].ToString();
            if (CALC_FLAG == "1")
            {
                if_itemchange = true;
            }
        }
        if (if_itemchange == false)
        {

            string SELECT_FLAG = dt_a013010101.Rows[j]["SELECT_FLAG"].ToString();
            string TABLE_SELECT = dt_a013010101.Rows[j]["TABLE_SELECT"].ToString();
            if (SELECT_FLAG == "1" && TABLE_SELECT.Length > 2)
            {
                if_itemchange = true;
            }
        }


        if (option != "Q")
        {
            if (option != "V")
            {
                if (main_key == column_id || table_key == column_id)
                {
                    dt_a013010101.Rows[j]["COL_VISIBLE"] = "0";
                    col_visible = "0";
                    if (main_key == column_id)
                    {
                        dt_a013010101.Rows[j]["COL_INIT"] = main_key_value;
                    }
                }
            }
            else
            {
                dt_a013010101.Rows[j]["COL_VISIBLE"] = "1";
                col_visible = "1";
            }
            
        }
        else
        {
            string IFQUERYSHOW = dt_a013010101.Rows[j]["IFQUERYSHOW"].ToString();
            if (IFQUERYSHOW != "1")
            {
                dt_a013010101.Rows[j]["COL_VISIBLE"] = "0";
                col_visible = "0";             
            }
          
        
        }
        string A10001_KEY = dt_a013010101.Rows[j]["A10001_KEY"].ToString();
         col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
        string bs_width = dt_a013010101.Rows[j]["BS_WIDTH"].ToString();
        
        if (if_itemchange == true)
        {
            itemchange += A10001_KEY + ',';
        }
        string bs_list = dt_a013010101.Rows[j]["BS_LIST"].ToString();
        if (bs_list == "1")
        {
            bslist_ += A10001_KEY + ',';
        }
        string sum_flag = dt_a013010101.Rows[j]["sum_flag"].ToString();
        if (sum_flag == "SUM")
        {
            if_show_sum = "1";
            dt_a013010101.Rows[j]["ORDER_BY"] = 0; 
        }



        string col_init = "";
        col_init = BaseFun.getStrByIndex(form_init, data_index + column_id + "|", data_index);    
        if (col_init == null  || col_init == "")
        {
            col_init = dt_a013010101.Rows[j]["col_init"].ToString();    
        }
        /*把col_init转换为数据*/
        if (col_init != "" && col_init != null && (option == "I" || option == "M") )
        {
             
            string col_init_sql;
            string col_type = dt_a013010101.Rows[j]["col_type"].ToString();
            col_init_sql = col_init.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            col_init_sql = col_init_sql.Replace("[user_id]", GlobeAtt.A007_KEY);
            col_init_sql = col_init_sql.Replace("[MENU_ID]", GlobeAtt.A002_KEY);
            col_init_sql = col_init_sql.Replace("[user_name]", GlobeAtt.A007_NAME);
            col_init_sql = col_init_sql.Replace("[USER_NAME]", GlobeAtt.A007_NAME);
            col_init_sql = col_init_sql.Replace("GETDATE()", "sysdate");
            if (col_init_sql.IndexOf("FUN_") == 0)
            {
                col_init_sql = col_init_sql.Substring(4);
                col_init_sql = "Select " + col_init_sql + "  as c from dual ";
            }
            else
            {
                if (col_init_sql == "sysdate")
                {
                    col_init_sql = "Select " + col_init_sql + "  as c from dual ";
                }
                else
                {
                    col_init_sql = "Select '" + col_init_sql.Replace("'","''") + "'  as c from dual ";
                }
            }
            dt_temp = Fun.getDtBySql(col_init_sql);
            string v = "";
            if (dt_temp.Rows.Count == 0)
            {
                Response.Write(column_id + "  " + col_init_sql);

            }
            else
            { 
                v=   dt_temp.Rows[0][0].ToString();
            }
           
            if (col_type.IndexOf("date") == 0)
            {
                if (v.IndexOf(".") > 0)
                {
                    v = v.Substring(0, 10) + " " + v.Substring(11).Replace(".",":");
                }
            }
            dt_a013010101.Rows[j]["col_init"] = v ;
            
            
        }

        if (col_visible != "1")
        {
            dt_a013010101.Rows[j]["COL_ENABLE"] = '0';
            continue;
        }

       string col_edit = dt_a013010101.Rows[j]["col_edit"].ToString().ToLower();
       string  COL_ENABLE = dt_a013010101.Rows[j]["COL_ENABLE"].ToString();
       if (option == "V")
       {
           COL_ENABLE = "0";
           dt_a013010101.Rows[j]["COL_ENABLE"] = "0";
       }
       if (COL_ENABLE == "1" && col_edit == "checkbox" && option== "M")
       {
           col_text = "<input id=\"CBX_ALL_"+ a00201_key + "_"+ A10001_KEY + "\" type=\"checkbox\"  value=\"0\"   />"+ col_text;
       }
        
        //判断是否有动态列
       string col00 = dt_a013010101.Rows[j]["col00"].ToString();//
       if (col00 == "1")
       {
           lb_haver = true;
           str_s.Append("<th style=\"width:"+ bs_width+"px;\">" + col_text +"</th>");
           bs_s_width = bs_s_width + int.Parse(bs_width);
       }       
   //
        
        if (col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0) 
        {
                string select_sql = dt_a013010101.Rows[j]["select_sql"].ToString();
                select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                dt_temp = Fun.getDtBySql(select_sql);
                string[] col = new string[2];
                col[0] = column_id;
                col[1] = Fun.DataTable2Json(dt_temp);
                ddd_list.Add(col);
        }
        
    str_div.Append("<th style=\"width:"+ bs_width+"px;\">" + col_text +"</th>");
    bs_div_width = bs_div_width + int.Parse(bs_width);
  }
  str_div.Append("<th style=\"display:none;\"></th>");
  str_div.Append(Environment.NewLine);
  str_div.Append("</tr>");
  str_div.Append(Environment.NewLine);
  str_div.Append("</table>");
  str_div.Append(Environment.NewLine);
  str_div.Append("</div>");
  str_div.Append(Environment.NewLine);

  str_s.Append(Environment.NewLine);
  str_s.Append("</tr>");
  str_s.Append(Environment.NewLine);
  str_s.Append("</table>");
  str_s.Append(Environment.NewLine);
  str_s.Append("</div>");
  str_s.Append(Environment.NewLine);
  int detailheight = dt_data.Rows.Count * 20;
  if (dt_data.Rows.Count < 10)
  {
       detailheight = 20 * 10;
  } 
    
   string pkg_name = dt_a00201.Rows[0]["PKG_NAME"].ToString();
    //打印表头
   StringBuilder str_divd = new StringBuilder();
   StringBuilder str_show = new StringBuilder();
   str_divd.Append("<div style=\"OVERFLOW:scroll; height:" + detailheight + "px;\"  id=\"scroll_" + a00201_key + "\" onscroll=\"scroll_x(this)\">");
   str_divd.Append(Environment.NewLine);
   str_divd.Append("<table  class=\"ShowTable\"   style=\"width:" + bs_div_width .ToString()+ "px\"  id=\"T"+a00201_key +"\">");
   str_divd.Append(Environment.NewLine);
   str_show.Append("<div style=\"OVERFLOW-x:scroll; OVERFLOW-y:hidden;height:" + detailheight + "px;width:" + bs_s_width .ToString() +"px\"  id=\"scroll0_" + a00201_key + "\" onscroll=\"scroll_x(this)\">");
   str_show.Append(Environment.NewLine);
   str_show.Append("<table  class=\"ShowTable\"  style=\"width:" + bs_s_width.ToString() + "px\"   id=\"LT" + a00201_key + "\">");
   str_show.Append(Environment.NewLine);
   //SaveLog.Verification("------开始循环1");
   for (int i = 0; i <= dt_data.Rows.Count; i++)
   {
      StringBuilder hidden_html = new StringBuilder();
      string rowid = (i + (PageNum - 1) * PageRow).ToString();
      //SaveLog.Verification("------循环开始"+(i).ToString());

      if (i == 0)
      {
          rowid = "[ROW]";
      }
      if (i == 0 && option == "Q")
      {
          continue;
      }
      string objid = "";
      string objv = "";
      if (i > 0)
      {
          try
          {
              objid = dt_data.Rows[i - 1]["objid"].ToString();
          }
          catch
          {
              objid = "";   
          }
          //显示明细
          if (showchild == "0" || showchild == "1")
          {
              try
              {
                  if (dt_a00201.Rows[0]["MAIN_KEY"].ToString() != "")
                  {
                      objv = dt_data.Rows[i - 1][dt_a00201.Rows[0]["MAIN_KEY"].ToString()].ToString();
                  }
              }
              catch
              {
                  objv = "";
              }
          }
          
      }
      else
      {
          objid = "NULL";
      }
      hidden_html.Append("<input  type=\"hidden\"  id=\"objid_" + a00201_key + "_" + rowid + "\" value='" + objid + "'/>");
      string objversion = "";
      try
      {
         
          if (dt_a00201.Rows[0]["TBL_TYPE"].ToString() == "V")
          {
              objversion =  dt_data.Rows[i - 1]["objversion"].ToString();
          }
          else
          {
              objversion = "";
          }
          
          
      }
      catch
      {
          objversion = "";
      }


       
      hidden_html.Append("<input  type=\"hidden\"  id=\"objversion_" + a00201_key + "_" + rowid + "\" value='" + objversion + "'/>");
      string rowlist_ = "OBJID|" + objid + data_index + "USER_ID|" + GlobeAtt.A007_KEY + data_index;
      if (pkg_name != "" && (option == "I" || option == "M"))
      {
          for (int j = 0; j < dt_a013010101.Rows.Count; j++)
          {
              string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
              string bs_list = dt_a013010101.Rows[j]["BS_LIST"].ToString();
              string col_value__ = dt_a013010101.Rows[j]["col_init"].ToString();
              if (i > 0)
              {
                  col_value__ = dt_data.Rows[i-1][column_id].ToString();
              }
              if (bs_list == "1")
              {
                  rowlist_ += column_id + "|" + col_value__ + data_index;
              }
          }
      }
      if (i == 0)
      {
          str_divd.Append("<tr id=R" + a00201_key + "_" + rowid + "  value=\"" + objv + "\"  op=\""+ option+"\"  style=\"display:none;\" >");

          str_divd.Append(Environment.NewLine);
          str_show.Append("<tr id=L" + a00201_key + "_" + rowid + "  value=\"" + objv + "\"  op=\"" + option + "\"  style=\"display:none;\" >");
          str_show.Append(Environment.NewLine);         
      }
      else
      {
          if (i % 2 == 0)
          {
              str_divd.Append("<tr id=\"R" + a00201_key + "_" + rowid + "\"   value=\"" + objv + "\"  op=\"" + option + "\"  class=\"r0\">");
              str_divd.Append(Environment.NewLine);
              str_show.Append("<tr id=\"L" + a00201_key + "_" + rowid + "\"   value=\"" + objv + "\"  op=\"" + option + "\"  class=\"r0\">");
              str_show.Append(Environment.NewLine);   
          }
          else
          {
              str_divd.Append("<tr id=\"R" + a00201_key + "_" + rowid + "\"  value=\"" + objv + "\" op=\"" + option + "\" class=\"r1\" >");
            str_divd.Append(Environment.NewLine);
            str_show.Append("<tr id=\"L" + a00201_key + "_" + rowid + "\"  value=\"" + objv + "\" op=\"" + option + "\" class=\"r1\" >");
            str_show.Append(Environment.NewLine);   
          }
      }
      //显示行号
      str_show.Append("<td style=\"width:20px; vertical-align:middle;\"><nobr>" + rowid + "</nobr></td>");
       
     str_divd.Append("<td style=\"width:40px; vertical-align:middle;\"  id=\"td_checkbox_"+ rowid +"\"><nobr>");
     str_divd.Append("<input  type=\"checkbox\"  id=\"cbx_"+a00201_key +"_"+ rowid +"\" name=\"cbx_"+a00201_key+"\" value=\"0\" />");
    if (option == "Q")
       { 
         str_divd.Append(rowid);
       }        
       str_divd.Append("</nobr></td>");
     if (option != "Q")
     { 
        str_divd.Append("<td style=\"width:35px;\" id=\"d"+ rowid +"\"  class=\"rowdo\">");
        str_divd.Append("<a onclick=\"endrowbyfrom('"+a00201_key +"_"+ rowid +"')\">"+ BaseMsg.getMsg("M0009")+"</a>");
        str_divd.Append("</td>");
     } 
     string old_select_sql_ = "";
     //SaveLog.Verification("------循环开始列" + (i).ToString());
    for (int j = 0; j < dt_a013010101.Rows.Count; j++)
    {
        if (j > 0)
        {
            dt_a013010101.Rows[j - 1]["SELECT_SQL"] = old_select_sql_;
        }
        
        string select_sql_ = dt_a013010101.Rows[j]["SELECT_SQL"].ToString();
        string col01 = dt_a013010101.Rows[j]["col01"].ToString();
        //重复不显示
        string col02 = dt_a013010101.Rows[j]["col02"].ToString();
        old_select_sql_ = select_sql_;
        if (select_sql_.Length > 5 && col01 != "1")
        {
            select_sql_ = select_sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
            select_sql_ = select_sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
            select_sql_ = select_sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            if (select_sql_.IndexOf("[") >= 0 && select_sql_.IndexOf("]") >= 0)
            {
                for (int cc = 0; cc < dt_data.Columns.Count; cc++)
                {
                    string column_id__ = dt_data.Columns[cc].ColumnName.ToUpper();
                    string col_data = BaseFun.getStrByIndex(data_index + rowlist_, data_index + column_id__ + "|", data_index);            
                    if (col_data == null)
                    {
                        col_data = "";
                    }
                    select_sql_ = select_sql_.Replace("[" + column_id__ + "]", col_data);
                    if (select_sql_.IndexOf("[") >= 0 && select_sql_.IndexOf("]") >= 0)
                    { }
                    else
                    {
                        break;
                    }

                }
            }
            dt_a013010101.Rows[j]["SELECT_SQL"] = select_sql_;

        }
        
        string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
        string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
        string A10001_KEY = dt_a013010101.Rows[j]["A10001_KEY"].ToString();
        string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
        string bs_width = dt_a013010101.Rows[j]["BS_WIDTH"].ToString();
        string col_value = dt_a013010101.Rows[j]["COL_INIT"].ToString();
        string col_necessary = dt_a013010101.Rows[j]["COL_NECESSARY"].ToString();
        string base_COL_ENABLE = dt_a013010101.Rows[j]["COL_ENABLE"].ToString();
        string IFQUERYSHOW = dt_a013010101.Rows[j]["IFQUERYSHOW"].ToString();
        //SaveLog.Verification("------循环开始列" + (i).ToString() + "." + j.ToString() + ":"+ column_id);
        if (i > 0)
        {
            if (option != "Q")
            {
                col_value = dt_data.Rows[i - 1][column_id].ToString();
             
            }
            else
            { 
                col_value = "";
                if (IFQUERYSHOW == "1")
                {
                    col_value = dt_data.Rows[i - 1][column_id].ToString();
                }                
            }
      
        }
        string COL_ENABLE = dt_a013010101.Rows[j]["COL_ENABLE"].ToString();
        if (COL_ENABLE == "1" )
        {    /*IFENABLE*/

            if (pkg_name != "" && (option == "I" || option == "M") )
            {
          
                string IFENABLE = "Select " + pkg_name + ".checkUseable('" + option + "','" + column_id + "','" + rowlist_.Replace("'","''") + "') as c from dual ";
                try
                {
                    dt_temp = Fun.getDtBySql(IFENABLE);
                    IFENABLE = dt_temp.Rows[0][0].ToString();
                }
                catch
                {
                    IFENABLE = "1";
                }
                dt_a013010101.Rows[j]["COL_ENABLE"] = IFENABLE;
            }
        }


     
        string col_enable = dt_a013010101.Rows[j]["COL_ENABLE"].ToString();
        string COL_WIDTH = dt_a013010101.Rows[j]["COL_WIDTH"].ToString();
        string col_edit = dt_a013010101.Rows[j]["col_edit"].ToString().ToLower();
        string IFQUERYEDIT = dt_a013010101.Rows[j]["IFQUERYEDIT"].ToString().ToLower();
        string ls_showcolumn = "";
        string ls_showcolumn0 = "";
        //检测小数点的位数
        //小数点的精度
        
        if (col_edit == "u_number")
        {
            
            if (col_value.Length > 0)
            {
                string col_precision = dt_a013010101.Rows[j]["col_precision"].ToString();

                if (col_precision == null || col_precision == "")
                {
                    col_precision = "9";
                } 
                col_value = Fun.format_u_name(col_value, col_precision);
            }
        }
        if (col_edit == "u_thousands")
        {
                string col_precision = dt_a013010101.Rows[j]["col_precision"].ToString();

                if (col_precision == null || col_precision == "")
                {
                    col_precision = "2";
                }      
                if (col_value.Length > 0)
                {
                    col_value = decimal.Parse(col_value).ToString("N" + col_precision);
                }
           
        }
        if ((col_edit == "datelist" || col_edit == "datetimelist") && col_value.Length >= 10)
        {

            if (col_value.IndexOf(".") > 0)
            {
                col_value = col_value.Substring(0, 10) + " " + col_value.Substring(11).Replace(".", ":");
            }

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
        
        string col_id = a00201_key + "_" + rowid + "_" + A10001_KEY;
        if (col_visible != "1")
        {            

            hidden_html.Append("<input name=\"" + a00201_key + "_" + rowid + "\"   type=\"hidden\" id=\"TXT_" + col_id + "\" value=\"" + col_value + "\"/>");
            continue;
        }
        if (option != "Q")
        {

            if (col_enable == "0")
            {
                hidden_html.Append("<input name=\"" + a00201_key + "_" + rowid + "\"  type=\"hidden\" id=\"TXT_" + col_id + "\" value=\"" + col_value + "\"/>");
                string BS_HTML = dt_a013010101.Rows[j]["BS_HTML"].ToString();

                if (col_value == null)
                {
                    col_value = "";
                }
                if (i == 0)
                {
                    BS_HTML = "["+ column_id+"]";
                }
                if ((col_edit == "datelist" || col_edit == "datetimelist") && col_value.Length > 10)
                {

                    if (col_value.IndexOf(".") > 0)
                    {
                        col_value = col_value.Substring(0, 10) + " " + col_value.Substring(11).Replace(".", ":");
                    }

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

                }
              
                BS_HTML = BS_HTML.Replace("[JUMPA002KEY]", dt_a00201.Rows[0]["MENU_ID"].ToString());
                BS_HTML = BS_HTML.Replace("[JUMPA00201KEY]", dt_a00201.Rows[0]["A00201_KEY"].ToString());
                BS_HTML = BS_HTML.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                BS_HTML = BS_HTML.Replace("[ROWNUM]", rowid);
                BS_HTML = BS_HTML.Replace("[TREENODE]", "1");  
                if ((col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0) && col_value != "")
                {
                    //string select_sql = dt_a013010101.Rows[j]["select_sql"].ToString();
                    //select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                    //select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                    //select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                    ////执行一次SQL
                   
                    for (int kk = 0; kk < ddd_list.Count; kk++)
                    {
                        string[] col = (string[]) ddd_list[kk];
                        if (column_id == col[0])
                        {
                            dt_temp = Fun.getdtByJson(col[1]);
                        }
                    }

                        //dt_temp = Fun.getDtBySql(select_sql);
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
                if (BS_HTML == "[" + column_id + "]")
                {
                    BS_HTML = col_value.Replace(Environment.NewLine, "");
                    ls_showcolumn = BS_HTML;
                }
                else
                {
                    BS_HTML = BS_HTML.Replace("[" + column_id + "]", col_value.Replace(Environment.NewLine, ""));
                    if (i > 0)
                    {
                        ls_showcolumn = Fun.ShowListHtml(BS_HTML, dt_data, i - 1, column_id, col_value);
                    }
                    else
                    {

                        ls_showcolumn = BS_HTML;
                    }
                }
                ls_showcolumn = "<div id=\"div_" + col_id + "\">" + ls_showcolumn + "</div>";
                if (col02 == "1")
                {
                    if (i > 1)
                    {
                        //j < dt_a013010101.Rows.Count; j++)
                        Boolean lb_col02 = false;//默认显示
                        if (dt_data.Rows[i - 1][column_id].ToString() == dt_data.Rows[i - 2][column_id].ToString())
                        {
                            lb_col02 = true;         
                            for (int t = 0; t < j; t++)
                            {
                                string col02_ = dt_a013010101.Rows[t]["COL02"].ToString();

                                if (col02_ == "1")
                                {
                                    string col__ = dt_a013010101.Rows[t]["COLUMN_ID"].ToString();
                                    if (dt_data.Rows[i - 1][col__].ToString() != dt_data.Rows[i - 2][col__].ToString())
                                    {
                                        lb_col02 = false;
                                        break;
                                    }
                                }
                                else
                                {
                                    lb_col02 = false;
                                    break;
                                }
                            }
                        }
                        if (lb_col02 == true)
                        {
                            ls_showcolumn = "&nbsp;";
                        }
                    }      
                               
                }
                
                ls_showcolumn0 = ls_showcolumn;
               
            }
            else
            {
                ls_showcolumn0 = col_value;
                ls_showcolumn = Fun.ShowColumn(option, dt_a00201.Rows[0]["A00201_KEY"].ToString(), dt_a013010101.Rows[j], rowid, col_value, "detail");
            }
           
        }
        else
        {

            if (IFQUERYEDIT == "1" && col_enable == "1")
            {
                ls_showcolumn0 = col_value;
                ls_showcolumn = Fun.ShowColumn("M", dt_a00201.Rows[0]["A00201_KEY"].ToString(), dt_a013010101.Rows[j], rowid, col_value, "querydata");
            }
            else
            {
                if (IFQUERYEDIT == "1")
                {
                    hidden_html.Append("<input name=\"" + a00201_key + "_" + rowid + "\"  type=\"hidden\" id=\"TXT_" + col_id + "\" value=\"" + col_value + "\"/>");
                }
                string BS_HTML = dt_a013010101.Rows[j]["BS_HTML"].ToString();
                if (col_value == null)
                {
                    col_value = "";
                }

                BS_HTML = BS_HTML.Replace("[JUMPA002KEY]", dt_a00201.Rows[0]["MENU_ID"].ToString());
                BS_HTML = BS_HTML.Replace("[JUMPA00201KEY]", dt_a00201.Rows[0]["A00201_KEY"].ToString());
                BS_HTML = BS_HTML.Replace("[ROWNUM]", rowid);
                BS_HTML = BS_HTML.Replace("[TREENODE]", "1");                
                if ((col_edit.IndexOf("ddd_") == 0 || col_edit.IndexOf("rb_") == 0) && col_value != "")
                {
                    string select_sql = dt_a013010101.Rows[j]["select_sql"].ToString();
                    select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                    select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                    select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
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
                if ((col_edit == "datelist" || col_edit == "datetimelist") && col_value.Length > 10)
                {

                    if (col_value.IndexOf(".") > 0)
                    {
                        col_value = col_value.Substring(0, 10) + " " + col_value.Substring(11).Replace(".", ":");
                    }

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
                if (BS_HTML == "[" + column_id + "]")
                {
                    BS_HTML = col_value.Replace(Environment.NewLine, "");
                    ls_showcolumn = BS_HTML;
                }
                else
                {
                    BS_HTML = BS_HTML.Replace("[" + column_id + "]", col_value);

                    ls_showcolumn = Fun.ShowListHtml(BS_HTML, dt_data, i - 1, column_id, col_value);
                }
                ls_showcolumn = "<div id=\"div_" + col_id + "\"  style=\"height:16px;float:left;vertical-align:middle;\">" + ls_showcolumn + "</div>";
                if (col02 == "1")
                {
                    if (i > 1)
                    {
                        if (dt_data.Rows[i - 1].ToString() == dt_data.Rows[i - 2].ToString())
                        {
                            ls_showcolumn = "&nbsp;";
                        }
                    }
                }
                
                ls_showcolumn0 = ls_showcolumn;
            }
        }  
        /*新增*/
        string sum_flag = dt_a013010101.Rows[j]["sum_flag"].ToString();
        if (sum_flag == "SUM" && i > 0)
        {
            decimal ldec_v = 0;
            try
            {
                 ldec_v = decimal.Parse(col_value.Replace(",",""));                 
            }
            catch
            {
                ldec_v =0 ;
            }
            dt_a013010101.Rows[j]["ORDER_BY"] = decimal.Parse(dt_a013010101.Rows[j]["ORDER_BY"].ToString()) + ldec_v;
        }
        string col00 = dt_a013010101.Rows[j]["col00"].ToString();
        if (col00 == "1")
        {
            if (col_edit == "u_number" || col_edit == "u_thousands")
            {
                str_show.Append("<td style=\"width:" + bs_width + "px;text-align:right;" + showcolor + "\" >");
                str_show.Append("<div style=\"margin-right:5px;\" >");
                str_show.Append(ls_showcolumn0);
                str_show.Append("</div></td>");

            }
            else
            {
                str_show.Append("<td style=\"width:" + bs_width + "px;" + showcolor + ";\">");
                str_show.Append(ls_showcolumn0);
                str_show.Append("</td>");
            }        
        }

        if (col_edit == "u_number" || col_edit == "u_thousands")
           {
               str_divd.Append(" <td style=\"width:" + bs_width + "px;text-align:right;" + showcolor + "\" >");
               str_divd.Append("<div style=\"margin-right:5px;\" >");
            str_divd.Append(ls_showcolumn);
            str_divd.Append("</div></td>");


            }
           else
           {
             str_divd.Append("<td style=\"width:" + bs_width + "px;" + showcolor + "\">");
             str_divd.Append(ls_showcolumn);         
             str_divd.Append("</td>");            
           }
           dt_a013010101.Rows[j]["COL_ENABLE"] = base_COL_ENABLE;
    }
      
    str_divd.Append("<td style=\"display:none;\">");
    str_divd.Append(hidden_html.ToString()); 
    str_divd.Append("</td>");
    str_divd.Append("</tr>");
   
    str_show.Append("</tr>");
    str_divd.Append(Environment.NewLine);
    str_show.Append(Environment.NewLine);
    //SaveLog.Verification("------循环结束" + (i).ToString());
  }
  // Response.Write(str_divd.ToString());
 if (if_show_sum == "1" && dt_data.Rows.Count > 0 )
   {
     
     str_divd.Append("<tr><td style=\"width:40px;\">小计</td>");
     str_show.Append("<tr><td style=\"width:40px;\">小计</td>");
     str_show.Append(Environment.NewLine);
     str_divd.Append(Environment.NewLine);   
     if (option != "Q")
     {    
          str_divd.Append(" <th style=\"width:35px;\"> &nbsp;</th>");

     }
    for (int j = 0; j < dt_a013010101.Rows.Count; j++)
    {
        string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
        if (col_visible != "1")
        {
            continue;
        }
        string sum_flag = dt_a013010101.Rows[j]["sum_flag"].ToString();
        string col_v = "" ;
        if (sum_flag == "SUM")
        {
            if_show_sum = "1";
            col_v = dt_a013010101.Rows[j]["ORDER_BY"].ToString();
            string col_edit = dt_a013010101.Rows[j]["col_edit"].ToString();
            if (col_edit == "u_thousands")
            {
                string col_precision = dt_a013010101.Rows[j]["col_precision"].ToString();
                if (col_precision == "" || col_precision == null)
                {
                    col_precision = "2";
                }
                col_v = decimal.Parse(col_v).ToString("N" + col_precision);
            }
            // decimal.Parse(dt_a013010101.Rows[j]["ORDER_BY"].ToString()) + decimal.Parse(col_value);
        }

        str_divd.Append("<td  style=\"text-align:right;\">");
        str_divd.Append("<div style=\"margin-right:5px;\">");
        str_divd.Append(col_v);  
        str_divd.Append("</div>");    
        str_divd.Append("</td>");
        string col00 = dt_a013010101.Rows[j]["col00"].ToString();
        if (col00 == "1")
        {
            str_show.Append("<td  style=\"text-align:right;\">");
            str_show.Append("<div style=\"margin-right:5px;\">");
            str_show.Append(col_v);
            str_show.Append("</div>");
            str_show.Append("</td>");
        }
    }   
    str_divd.Append("<td style=\"display:none;\"></td></tr>");
    str_show.Append("</tr>");
    str_show.Append(Environment.NewLine);
    str_divd.Append(Environment.NewLine); 
  }
   
    str_divd.Append("</table>");  
    str_divd.Append(Environment.NewLine); 
    str_divd.Append("<input id=\"beginrow_"+a00201_key +"\"  type=\"hidden\"  value='"+((PageNum - 1) * PageRow).ToString() +"'/>");
    str_divd.Append("<input id='itemchange_"+a00201_key +"'  type=\"hidden\" value='"+itemchange +"'/>");
    str_divd.Append("<input id='Init_"+a00201_key +"'  type=\"hidden\" value='"+form_init +"'/>");
    str_divd.Append("<input id='bslist_"+a00201_key +"'  type=\"hidden\" value='"+bslist_ +"'/>");
    str_divd.Append("</div>");


    str_show.Append("</table>");
    str_show.Append(Environment.NewLine);
    str_show.Append("  </div>");
    str_show.Append(Environment.NewLine);
  

%>
<div id="d_l_<%=a00201_key %>" style="float:right;">
<%
    //  str_div.ToString().Replace("[_DIV_WIDTH_]",bs_div_width.ToString());
  //  str_s.ToString().Replace("[_S_WIDTH_]", bs_s_width.ToString());
    string ls_html = str_div.ToString().Replace("[_DIV_WIDTH_]", bs_div_width.ToString() );
    ls_html = ls_html.Replace("[_S_WIDTH_]", bs_s_width.ToString());
    Response.Write(ls_html);
    Response.Write(str_divd.ToString());
%> 
</div>
<%if (lb_haver == false)
  {
      Response.Write("<div id=\"d_lr_" + a00201_key + "\"  style=\"float:right; table-layout:fixed;display:none;\" onclick=\"showleft__('" + a00201_key + "')\">");  
      Response.Write("<input  type=\"hidden\" id=\"showl_" + a00201_key + "\" value=\"0\"/>");
      Response.Write("<input  type=\"hidden\" id=\"showld_" + a00201_key + "\" value=\"0\"/>");
      Response.Write("<a style=\"width:0px; padding-top:0px;\"></a>");
      Response.Write("</div>");
  }
  else
  {
  
      Response.Write("<div id=\"d_lr_"+ a00201_key +"\"  style=\"float:right;width:20px; table-layout:fixed;\" onclick=\"showleft__('"+ a00201_key +"')\">");  
      Response.Write("<input  type=\"hidden\" id=\"showl_" + a00201_key + "\" value=\"1\"/>");
      Response.Write("<input  type=\"hidden\" id=\"showld_" + a00201_key + "\" value=\"18\"/>");
      Response.Write("<a style=\"width:18px; padding-top:2px;\"><img  width=\"18px\" height=\"18px\" id=\"imgsl_" + a00201_key + "\" alt=\"收起\" src=\"../images/21.png\"/></a>");
      Response.Write("</div>");
  } %>
<div id="d_r_<%=a00201_key %>" style="float:left;">
<%
    if (lb_haver == true)
    {
        string ls_html_ = str_s.ToString().Replace("[_S_WIDTH_]", bs_s_width.ToString());
        Response.Write(ls_html_);
        Response.Write(str_show.ToString());
    }
    //SaveLog.Verification("------结束");
%>
</div>

</div>
