<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Head.aspx.cs" Inherits="BaseForm_Head" %>

<%
     
    string[] MAIN_TAB_LIST = new string[20];
    int[] tab_count = new int[20];
    for (int i = 0; i < tab_count.Length; i++)
    {
        tab_count[i] = 0;
    }
    int MAIN_TAB_COUNT = 0;
    string itemchange = "";
    string bslist_ = "";
    StringBuilder html_ = new StringBuilder();
    for (int j = 0; j < dt_a013010101.Rows.Count; j++)
    {
        if (GlobeAtt.LANGUAGE_ID != "CN")
        {
            dt_a013010101.Rows[j]["COL_TEXT"] = dt_a013010101.Rows[j][GlobeAtt.LANGUAGE_ID + "_COL_TEXT"].ToString();
            dt_a013010101.Rows[j]["MAIN_TAB"] = dt_a013010101.Rows[j][GlobeAtt.LANGUAGE_ID + "_MAIN_TAB"].ToString();
        }
        
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
        string col_child = dt_a013010101.Rows[j]["COL_CHILD"].ToString();
        Boolean if_itemchange = false;
        if (col_child.Length >= 1)
        {
            if_itemchange = true;
        }
        if (if_itemchange == false)
        {
            string CALC_FLAG = dt_a013010101.Rows[j]["CALC_FLAG"].ToString();
            string FORMULA = dt_a013010101.Rows[j]["FORMULA"].ToString();
            if (CALC_FLAG == "1" )
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
        string A10001_KEY = dt_a013010101.Rows[j]["A10001_KEY"].ToString();
             if (if_itemchange == true)
        {
            itemchange += A10001_KEY + ',';
        }
        string bs_list = dt_a013010101.Rows[j]["BS_LIST"].ToString();
        if (bs_list == "1")
        {
            bslist_ += A10001_KEY + ',';
        }
    }
   
    
 %>
<%
StringBuilder ls_hidden =  new StringBuilder();
string form_init = "";
string data_index = GlobeAtt.DATA_INDEX;
if (option == "I")
{
    form_init = Fun.getJson(json, "P10");

    form_init = form_init.Replace("[REQUESTURL]", "REQUESTURL|" + RequestURL + data_index);
    if (form_init.Length > 5)
    {
        form_init = data_index +  Fun.getProcData(form_init, dt_a00201.Rows[0]["TABLE_ID"].ToString());
    }
    else
    {
        form_init = "";
    }
}
if (IFSHOW == "1")
{
    a00201_key = "S" + a00201_key;
}
ls_hidden.Append("<input id='itemchange_" + a00201_key + "'  type=\"hidden\" value='" + itemchange + "'/>");
ls_hidden.Append("<input id='Init_" + a00201_key + "'  type=\"hidden\" value='" + form_init + "'/>");
 ls_hidden.Append("<input id='bslist_" + a00201_key + "'  type=\"hidden\" value='" + bslist_ + "'/>");    

string table_key = dt_a00201.Rows[0]["TABLE_KEY"].ToString();
string main_key = dt_a00201.Rows[0]["main_key"].ToString();
int bs_cols = int.Parse(dt_a00201.Rows[0]["BS_COLS"].ToString());
int use_cols = 0;



string pkg_name = dt_a00201.Rows[0]["PKG_NAME"].ToString();

for(int r=0 ; r < dt_data.Rows.Count; r ++)
{
    string objid = "";
   
    string rowid = r.ToString();
    if (IFSHOW == "1")
    {
        rowid = ROWID;
    }
    objid = dt_data.Rows[r]["objid"].ToString();
    string objversion = "";
    try
    {
        if (dt_a00201.Rows[0]["TBL_TYPE"].ToString() == "V")
        {
            objversion = dt_data.Rows[r]["objversion"].ToString();
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
    if (IFSHOW == "1")
    {
        objid = BaseFun.getStrByIndex(rowlist,  "OBJID|", data_index);
        objversion = BaseFun.getStrByIndex(rowlist, "OBJVERSION|", data_index);
    }
    
    
    string rowlist_ = "OBJID|" + objid + data_index +"OBJVERSION|" + objversion + data_index +  "USER_ID|" + GlobeAtt.A007_KEY + data_index;
    if (pkg_name != "")
    {
        for (int j = 0; j < dt_a013010101.Rows.Count; j++)
        {
            string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
            string bs_list = dt_a013010101.Rows[j]["BS_LIST"].ToString();
            string col_value__ = dt_a013010101.Rows[j]["col_init"].ToString();

            string a10001_key = dt_a013010101.Rows[j]["a10001_key"].ToString();
                     
            if (r >= 0)
            {
                col_value__ = dt_data.Rows[r][column_id].ToString();
            }
            if (option == "I")
            {
                string col_value_init = BaseFun.getStrByIndex(form_init, data_index + column_id + "|", data_index);
                if (col_value_init.Length > 0 && col_value_init != "" && col_value_init != null)
                {
                    col_value__ = col_value_init;

                }
            }
            
            if (IFSHOW == "1")
            {
                col_value__ = BaseFun.getStrByIndex(rowlist, data_index + a10001_key + "|", data_index);
            }
            if (bs_list == "1")
            {
                rowlist_ += column_id + "|" + col_value__ + data_index;
            }
        }
    }
    ls_hidden.Append("<input id='objid_" + a00201_key + "_" + rowid + "'  type=\"hidden\" value='" + objid + "'/>");
    ls_hidden.Append("<input id='objversion_" + a00201_key + "_" + rowid + "'  type=\"hidden\" value='" + objversion + "'/>");
%>
<%
  html_.Append("<table class=\"head0\" id=\"R"+ a00201_key +"_"+ r.ToString()+"\">");
  string classname = "tr_tab_head_hover";
  for (int kk = 0; kk < MAIN_TAB_COUNT; kk++)
  {
      StringBuilder trhtml_ = new StringBuilder();
        
      trhtml_.Append("<td width=\"100%\" onclick=\"showmaintab('"+a00201_key +"','"+kk.ToString()+"')\">");
      trhtml_.Append("<div>");
      if (MAIN_TAB_COUNT == 1)
      {
           trhtml_.Append(dt_a00201.Rows[0]["tab_name"].ToString());
      }
      else
      {
           trhtml_.Append(MAIN_TAB_LIST[kk]);
      }
      trhtml_.Append("</div>");
      trhtml_.Append("</td>");
     

      StringBuilder trchildhtml_ = new StringBuilder();
     
        trchildhtml_.Append("<td width=\"100%\">");
        trchildhtml_.Append(Environment.NewLine);
        string display = " id=\"maintable_" + a00201_key + "_" + kk.ToString() + "\" style=\"display:none;\"";
        if (IFSHOW == "1")
        {
            display = "id=\"maintable_" + a00201_key + "_" + kk.ToString() + "\" style=\"display:;\"";
        }
        else
        {
            if (kk == 0)
            {
                display = "id=\"maintable_" + a00201_key + "_" + kk.ToString() + "\" style=\"display:;\"";
            }
        }
        trchildhtml_.Append("<table class=\"mainhead\" width=\"100%\" " + display + ">");
        trchildhtml_.Append(Environment.NewLine);
        trchildhtml_.Append("<tr style=\"height:1px;\">");
        trchildhtml_.Append(Environment.NewLine);
        for (int rr = 0; rr < bs_cols; rr++)
        {
            trchildhtml_.Append("<td width=\" "+ (100 / bs_cols).ToString() + "px\" height=\"1px\"></td>");
        }
        trchildhtml_.Append(" </tr>");
        trchildhtml_.Append(Environment.NewLine);
        use_cols = 0;

        string old_select_sql_ = "";
%>      
<%        for (int j = 0; j < dt_a013010101.Rows.Count; j++)
        {
            if (j > 0)
            {
                dt_a013010101.Rows[j - 1]["SELECT_SQL"] = old_select_sql_;
            }
            string select_sql_ = dt_a013010101.Rows[j]["SELECT_SQL"].ToString();
            old_select_sql_ = select_sql_;
            if (select_sql_.Length > 5)
            {
                select_sql_ = select_sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                select_sql_ = select_sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                select_sql_ = select_sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                if (select_sql_.IndexOf("[") >= 0 && select_sql_.IndexOf("]") >= 0)
                {
                    for (int cc = 0; cc < dt_data.Columns.Count; cc++)
                    {
                        string column_id__ = dt_data.Columns[cc].ColumnName.ToUpper();
                        if (select_sql_.IndexOf("[" + column_id__ + "]") >= 0)
                        {
                            string col_data = dt_data.Rows[r][column_id__].ToString();
                            if (col_data == null)
                            {
                                col_data = "";
                            }
                            if (col_data == "")
                            {
                                if (option == "I")
                                {
                                    col_data = BaseFun.getStrByIndex(form_init, data_index + column_id__ + "|", data_index);
                                }
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
                }
                dt_a013010101.Rows[j]["SELECT_SQL"] = select_sql_;

            }
                  
            string MAIN_TAB = dt_a013010101.Rows[j]["MAIN_TAB"].ToString();
            if (MAIN_TAB != MAIN_TAB_LIST[kk])
            {
                continue;
            }
            int COL_BS_COLS = int.Parse(dt_a013010101.Rows[j]["BS_COLS"].ToString());
            if (COL_BS_COLS > bs_cols)
            {
                COL_BS_COLS = bs_cols;
            }
            string column_id = dt_a013010101.Rows[j]["COLUMN_ID"].ToString();
            string col_value = dt_data.Rows[r][column_id].ToString();
            string a10001_key = dt_a013010101.Rows[j]["A10001_KEY"].ToString();
            
            //获取objid的值
            if (IFSHOW == "1")
            {
                col_value = BaseFun.getStrByIndex(rowlist, data_index + a10001_key + "|", data_index);
                if (column_id == table_key || column_id == main_key)
                {
                    dt_a013010101.Rows[j]["COL_VISIBLE"] = "0";
                }
            }
            string col_edit = dt_a013010101.Rows[j]["col_edit"].ToString();
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
              
              
            if ((column_id == table_key || column_id == main_key) && option !="I")
            {
                dt_a013010101.Rows[j]["COL_ENABLE"] = "0";
            }


            string col_visible = dt_a013010101.Rows[j]["COL_VISIBLE"].ToString();
            if ((option != "I" && option != "M") || col_visible=="0")
            {
                dt_a013010101.Rows[j]["COL_ENABLE"] = "0";
            }
            string COL_ENABLE = dt_a013010101.Rows[j]["COL_ENABLE"].ToString();
            if (COL_ENABLE == "1")
            {    /*IFENABLE*/
                if (pkg_name != "")
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
      
            string sys_visible = dt_a013010101.Rows[j]["SYS_VISIBLE"].ToString();
            string col_text = dt_a013010101.Rows[j]["COL_TEXT"].ToString();
            string ls_showcolumn = "";

            ls_showcolumn = Fun.ShowColumn(option, a00201_key, dt_a013010101.Rows[j], rowid, col_value, "main", form_init);
            if (sys_visible == "1")
            {
                if (col_visible == "1")
                {
                    tab_count[kk] = tab_count[kk] + 1;
                }
                if (use_cols == 0)
                {
                    trchildhtml_.Append("<tr class=\"rmain\"> ");
                    trchildhtml_.Append(Environment.NewLine);                    
                }
                /*余下的列不够 当前列显示*/
                if ((bs_cols - use_cols) < COL_BS_COLS && (bs_cols - use_cols) > 0)
                {
                    if ((bs_cols - use_cols) > 1)
                    {
                        trchildhtml_.Append("<td colspan=\"" + (bs_cols - use_cols).ToString() + "\" >&nbsp;</td> ");
                    }
                    else
                    {
                        trchildhtml_.Append("<td >&nbsp;</td> ");
                    }
                    trchildhtml_.Append(Environment.NewLine);
                    trchildhtml_.Append("</tr> ");
                    trchildhtml_.Append(Environment.NewLine);
                    trchildhtml_.Append("<tr class=\"rmain\"> ");
                    trchildhtml_.Append(Environment.NewLine);
                    use_cols = 0; 
                }
                
                string BS_HTML = dt_a013010101.Rows[j]["BS_HTML"].ToString();
                if (BS_HTML.IndexOf(">[" + column_id + "]<") > 0 && col_value.Length > 0)
                {
                    BS_HTML = BS_HTML.Replace(">[" + column_id + "]<", ">" + col_text + "<");
                    BS_HTML = BS_HTML.Replace("[" + column_id + "]", col_value);
                    BS_HTML = BS_HTML.Replace("[JUMPA002KEY]", dt_a00201.Rows[0]["MENU_ID"].ToString());
                    BS_HTML = BS_HTML.Replace("[JUMPA00201KEY]", dt_a00201.Rows[0]["A00201_KEY"].ToString());
                    col_text = Fun.ShowListHtml(BS_HTML, dt_data, 0, column_id, col_value);
                }
            
                string showcol = "<table class=\"showcol\"><tr><td   class=\"h\">" + col_text + " </td></tr><tr><td class=\"d\">" + ls_showcolumn + "</td></tr></table>";
                
                // 横向显示 列
                string col07 = dt_a013010101.Rows[j]["col07"].ToString();
                if (col07 == "1")
                {
                    string TEXT_ORIGINAL = dt_a013010101.Rows[j]["TEXT_ORIGINAL"].ToString();
                    if (TEXT_ORIGINAL == "" || TEXT_ORIGINAL == null)
                    {
                        TEXT_ORIGINAL = "&nbsp;";
                    }
                    showcol = "<table class=\"showcol_\"><tr><td  class=\"h\">" + col_text + "：&nbsp;</td><td class=\"d\"><div class='dd'>" + ls_showcolumn + " <span class='sd'>" + TEXT_ORIGINAL + "</span><div></td></tr></table>";
                      
                
                }
                // end  横向显示 列
                if (COL_BS_COLS > 1)
                {
                    trchildhtml_.Append("<td colspan=\"" + COL_BS_COLS.ToString() + "\"> " + showcol + "</td>");
                    trchildhtml_.Append(Environment.NewLine);
                }
                else
                {
                    trchildhtml_.Append("<td> " + showcol + "</td>");
                    trchildhtml_.Append(Environment.NewLine);
                }
                use_cols = use_cols + COL_BS_COLS;
                if (use_cols == bs_cols)
                {
                    trchildhtml_.Append("</tr> ");
                    trchildhtml_.Append(Environment.NewLine);
                    use_cols = 0;
                }
                
            }
            else
            {
                ls_hidden.Append(ls_showcolumn);
            }
            
        }
        if (use_cols > 0)
        {
            if ((bs_cols - use_cols) > 1)
            {
                trchildhtml_.Append("<td  colspan=\"" + (bs_cols - use_cols).ToString() + "\">&nbsp;</td> ");
            }
            else
            {
                trchildhtml_.Append("<td>&nbsp;</td> ");
            }
            trchildhtml_.Append("</tr> ");
            trchildhtml_.Append(Environment.NewLine);
            use_cols = 0;
        }
        trchildhtml_.Append("</table></td>");
       
        //主档
        if (tab_count[kk] > 0)
        {
            

            html_.Append("<tr id=\"tr_tab_head" + a00201_key + kk.ToString() + "\" class=\"" + classname + "\">");
            html_.Append(Environment.NewLine);
            html_.Append(trhtml_.ToString());
            html_.Append(Environment.NewLine);
            html_.Append("</tr>");
            html_.Append(Environment.NewLine);


            html_.Append("<tr id=\"tr_tab_detail" + a00201_key + kk.ToString() + "\" class=\"tr_tab_detail\">");
            html_.Append(Environment.NewLine);
            html_.Append(trchildhtml_.ToString());
            html_.Append(Environment.NewLine);
            html_.Append("</tr>");
            html_.Append(Environment.NewLine);
            if (classname == "tr_tab_head_hover")
            {
                classname = "tr_tab_head";
            }
        }
        else
        {
            html_.Append("<tr id=\"tr_tab_head" + a00201_key + kk.ToString() + "\" style=\"display:none;\">");
            html_.Append(Environment.NewLine);
            html_.Append(trhtml_.ToString());
            html_.Append(Environment.NewLine);
            html_.Append("</tr>");
            html_.Append(Environment.NewLine);
            html_.Append("<tr id=\"tr_tab_detail" + a00201_key + kk.ToString() + "\" style=\"display:none;\">");
            html_.Append(Environment.NewLine);
            html_.Append(trchildhtml_.ToString());
            html_.Append(Environment.NewLine);
            html_.Append("</tr>");
            
        }
  }

  html_.Append("</table>"); 
%>

<%}
    
     %>
<%
    Response.Write(html_.ToString());
    Response.Write(ls_hidden.ToString()); %>
