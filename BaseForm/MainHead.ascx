<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MainHead.ascx.cs" Inherits="BaseForm_MainHead" EnableViewState="false" %>
<% 
    string[] MAIN_TAB_LIST = new string[20];
    int[] main_use_head_list =  new int[20];
    int[] tab_height = new int[20];
    int MAIN_TAB_COUNT = 0 ;
    string tablength ="" ;
    for (int j = 0; j < dt_a013010101.Rows.Count; j++)
    {
        string MAIN_TAB = dt_a013010101.Rows[j]["MAIN_TAB"].ToString();
        Boolean lb_exist = false;
        for (int r = 0; r < MAIN_TAB_COUNT; r++)
        {
            if (MAIN_TAB_LIST[r] == MAIN_TAB)
            {
                lb_exist = true;
                break;
            }
        }
        if (lb_exist == false)
        {
            MAIN_TAB_LIST[MAIN_TAB_COUNT] = MAIN_TAB;
            MAIN_TAB_COUNT += 1;     
        }        
    }
    string tabhtml = "<div class=\"maintab\"><ul>";
    for (int j = 0; j < MAIN_TAB_COUNT; j++)
    {

        tabhtml += "<li id=\"maintab"+ j.ToString() +"\" class=\"\" onclick=\"showmaintab(" + j.ToString() + ")\" ><a >" + MAIN_TAB_LIST[j] + "</a></li>";
    }
    tabhtml += "</ul></div>";
    tabhtml = "";
%>

<% if (if_showrow == "1")
   {
%>
 
 <script>
  document.getElementById("td_main_button").innerHTML ='<%=tabhtml %>' +  '<div class="main_btn"><input id="Button1" type="button" value="确定"  onclick ="set_parent_value(\'<%=a00201_key%>_0\')"/>  </div>';
  main_height += 25;
 </script>

 <% 
}
else
{ 
 %>

<%
    if (dt_a00204.Rows[0][0].ToString().Length > 20)
    { 
  %>    
    <div id="hidden_btn_<%=a00201_key %>_0" style="display:none;"> 
       
       <%if (MAIN_TAB_COUNT > 1)
             Response.Write(tabhtml);%>
       <input id="btn_showmain" type="button"  class="btn blue" value="隐藏"  onclick ="showmian()"/>
       <%=dt_a00204.Rows[0][0].ToString()%>
    </div>
   <script>
    var str_ =  document.getElementById("hidden_btn_<%=a00201_key %>_0").innerHTML ;
    document.getElementById("td_main_button").innerHTML = "<div class=\"main_btn\">"+ str_ +"</div>";
    main_height += 25;
   </script>

   <% }
} %>
<div style="width:100%; height:1px;"></div>
<%
    string ls_hidden = "";
    string table_key = dt_a00201.Rows[0]["TABLE_KEY"].ToString();
    string main_key = dt_a00201.Rows[0]["main_key"].ToString()  ;
    int main_use_head = 0;
    int bs_cols = int.Parse(dt_a00201.Rows[0]["BS_COLS"].ToString());
    int showrows = 0;
    int trhead = 45; //一个tr的高度

    int utext = 22;// 1个 u_text的高度

    int utextcount = 0;//1个tr有几个text
    if (if_showrow == "1")
    {
        main_key = table_key;
    }
    string table_id = dt_a00201.Rows[0]["table_id"].ToString(); 
    for(int i=0 ;i <dt_data.Rows.Count; i++)
    {
        string key = "";
        try
        {
            key = dt_data.Rows[i][table_key].ToString();
        }
        catch
        {
           key = "-100";
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
        ls_hidden += "<input id='objid_" + a00201_key + "_" + (i).ToString() + "'  type=\"hidden\" value='" + objid + "'/>";
            

    %>
    <script language =javascript>
    AddrowList('<%=a00201_key%>_<%=i.ToString()%>','<%=table_key %>','<%=main_key %>','<%=key %>','<%=table_id %>',0,'<%=option %>')
    </script>    
    <table class="head0" id="table0">
  <% 
  int use_cols = 0;
  for (int kk =0 ; kk < MAIN_TAB_COUNT ;kk++)
  {
      main_use_head = 0;
      if (MAIN_TAB_COUNT > 1)
      {
          Response.Write("<tr id='tr_tab_head" + kk.ToString() + "' class=\"tr_tab_head\"><td width=\"100%\" onclick=\"showmaintab(" + kk.ToString() + ")\"><div>" + MAIN_TAB_LIST[kk] + "</div></td></tr>");
          Response.Write(Environment.NewLine);
      }
      Response.Write("<tr id=\"tr_tab_detail" + kk.ToString() + "\" class=\"tr_tab_detail\"><td>");
      Response.Write(Environment.NewLine);
      Response.Write("<table class=\"mainhead\" width=\"100%\" id=\"maintable_" + kk.ToString() + "\" style=\"display:none;\">");
      Response.Write(Environment.NewLine);
      Response.Write("<tr style=\"display:none;\">");
      Response.Write(Environment.NewLine);
      for (int r = 0; r < bs_cols; r++)
      {
          Response.Write("<td width=\"" + (100 / bs_cols).ToString() + "%\">&nbsp;</td>");
      }
      Response.Write("</tr>");
      Response.Write(Environment.NewLine);
      use_cols = 0;
      for (int j = 0; j < dt_a013010101.Rows.Count; j++)
      {
        string MAIN_TAB = dt_a013010101.Rows[j]["MAIN_TAB"].ToString();
        if (MAIN_TAB  !=  MAIN_TAB_LIST[kk] )     
        {
            continue;
        }
         
        int COL_BS_COLS = int.Parse( dt_a013010101.Rows[j]["BS_COLS"].ToString());
        if (COL_BS_COLS > bs_cols)
        {
            COL_BS_COLS = bs_cols;
        }
        string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
        string col_value = dt_data.Rows[i][column_id].ToString();
        string col_edit = dt_a013010101.Rows[j]["col_edit"].ToString();
    
        string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
        string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
       // string col_edit = dt_a013010101.Rows[j]["COL_EDIT"].ToString();
        string ls_showcolumn= "" ;
         /*新增*/
         if ( option == "I")
         {
             if (column_id == table_key)
             {
                 
                  dt_temp = Fun.getDtBySql("select pkg_a.getTableKey('" +  dt_a002.Rows[0]["MENU_ID"].ToString()  + "','INIT') as c from dual ");
                  col_value = dt_temp.Rows[0][0].ToString();
                
                  //dt_a013010101.Rows[j]["COL_ENABLE"] ="0";
             } 
                    
        }
        if (option == "M")
        {
            if (column_id == table_key || column_id == main_key)
            {
                dt_a013010101.Rows[j]["COL_ENABLE"] = "0";
            }
        }
        if (option != "I" && option != "M")
        {
            dt_a013010101.Rows[j]["COL_ENABLE"] = "0";
        }
        if (col_edit.ToUpper().IndexOf("U_TEXT") == 0)
        { 
            int u_count = 0;
            try
            {
                u_count = int.Parse(col_edit.ToUpper().Substring(5));
            }
            catch
            {
                u_count = 1 ;
            }
            if (u_count >  0 )
            {
                utextcount = u_count ;
            }
        }
        ls_showcolumn = Fun.ShowColumn(option, dt_a00201.Rows[0]["A00201_KEY"].ToString(), dt_a013010101.Rows[j], i.ToString(),  col_value, "main");
        if (col_visible == "1")
        {
            if (use_cols == 0)
            {
                Response.Write("<tr class=\"rmain\"> ");
                Response.Write(Environment.NewLine);
                showrows = showrows + 1;
                main_use_head += trhead;
                if (utextcount > 1)
                {
                    main_use_head += (utextcount - 1) * utext;
                }
                utextcount = 0;
            }
            
            /*余下的列不够 当前列显示*/
            if ((bs_cols - use_cols) < COL_BS_COLS && (bs_cols - use_cols) > 0 )
            {
                if ((bs_cols - use_cols) > 1)
                {
                    Response.Write("<td colspan=\"" + (bs_cols - use_cols).ToString() + "\">&nbsp;</td> ");
                }
                else
                {
                    Response.Write("<td >&nbsp;</td> ");
                }
                Response.Write("</tr> ");
                Response.Write(Environment.NewLine);
                Response.Write("<tr class=\"rmain\"> ");
                Response.Write(Environment.NewLine);
                showrows = showrows + 1;
                use_cols = 0;
                main_use_head += trhead;
                if (utextcount > 1)
                {
                    main_use_head += (utextcount - 1) * utext;
                }
                utextcount = 0;
            
            }
            //col_text + ":" + ls_showcolumn + "
            string showcol = "<table class=\"showcol\"><tr><td   class=\"h\">" + col_text + " </td></tr><tr><td class=\"d\">" + ls_showcolumn + "</td></tr></table>";
            if (COL_BS_COLS > 1)
            {
                Response.Write("<td colspan=\"" + COL_BS_COLS.ToString() + "\" class=\"dmain\"> " +  showcol +  "</td>");
                Response.Write(Environment.NewLine); 
            }
            else
            {
                Response.Write("<td class=\"dmain\"> " + showcol  + "</td>");
                Response.Write(Environment.NewLine);    
            }
            use_cols = use_cols + COL_BS_COLS;
            if (use_cols == bs_cols)
            {
                Response.Write("</tr> ");
                Response.Write(Environment.NewLine);
                use_cols = 0;           
            }
                        
        }
        else
        {
            ls_hidden += ls_showcolumn;
        }

     }
     if (use_cols > 0)
     {
         if ((bs_cols - use_cols) > 1)
         {
             Response.Write("<td colspan=\"" + (bs_cols - use_cols).ToString() + "\">&nbsp;</td> ");
         }
         else
         {
             Response.Write("<td >&nbsp;</td> ");
         }
         Response.Write("</tr> ");
         Response.Write(Environment.NewLine);
         use_cols = 0;
     }
      Response.Write("</table></td></tr>");
      Response.Write(Environment.NewLine);
      main_use_head_list[kk] = main_use_head;
      tablength += main_use_head.ToString() +",";
      
  }
}
       
          %>

<%  if (PARENTROWID != "-1")
    {
        Response.Write("<script>get_parent_value('" + a00201_key + "_0','" + PARENTROWID + "')</script>");

    }
   Response.Flush();

 %>
   </table>
<%=ls_hidden %>

<script language=javascript>
A00201LIST  +=  '<%=a00201_key %>,';
tablength =  '<%=tablength %>' ;
getA0130101('<%=a00201_key%>','<%=table_key %>','<%=main_key %>','<%=table_id %>');
option ="<%=option %>";
IFA309="<%=IFA309 %>";
</script>
