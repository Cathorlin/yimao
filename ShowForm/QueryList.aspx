<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QueryList.aspx.cs" Inherits="ShowForm_QueryList" %>
<% 
    string table_key = dt_a00201.Rows[0]["TABLE_KEY"].ToString();
    string main_key = dt_a00201.Rows[0]["main_key"].ToString();
    string table_id = dt_a00201.Rows[0]["table_id"].ToString();
    string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
    string itemchange = "";
    string showcolor = BaseMsg.getMsg("M0019");
    string bslist_ = "";
    string data_index = GlobeAtt.DATA_INDEX;
    StringBuilder inserthtml = new StringBuilder();
    StringBuilder trhead_html = new StringBuilder();
    StringBuilder sum_html = new StringBuilder();
    string if_show_sum = "0"; //是否显示合计列
    string form_init = "";
    if ((option == "M" || option == "V") && dt_a00201.Rows[0]["if_main"].ToString() == "1")
    {
        trhead_html.Append("<select    id=\"sh_" + a00201_key + "\" onchange=\"query_select(this,'"+ main_key_value + "');\" >");
        trhead_html.Append(Environment.NewLine);
        if (dt_data.Rows.Count == 0)
        {
            trhead_html.Append("<option    value=\"\"></option>");
        }
        for (int i = 0; i <  dt_data.Rows.Count; i++)
        {
            string v_ = dt_data.Rows[i][main_key].ToString();
            if (i == 0)
            {
                trhead_html.Append("<option  selected  value=\"" + v_ + "\">" + v_ + "</option>");
            }
            else
            {
                trhead_html.Append("<option   value=\"" + v_ + "\">" + v_ + "</option>");
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

<div id="btn_<%=a00201_key %>">
<%//已有 的查询
    if (option == "Q")
    {
        string a006_sql = "Select  distinct  query_id  from A006 t  where user_id='" + GlobeAtt.A007_KEY + "' AND a00201_key ='" + a00201_key + "'";
        dt_temp = Fun.getDtBySql(a006_sql);
   %>      
    <%=BaseMsg.getMsg("M0011")%>：<select   id="Select_query_0"  
        style="font-size:9pt;height:20px; margin-top: 0px;"> 
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
    }             
              %>
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




