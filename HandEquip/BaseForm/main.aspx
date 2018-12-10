<%@ Page Language="C#" AutoEventWireup="true" CodeFile="main.aspx.cs" Inherits="HandEquip_BaseForm_main" %>

<%
    string data_index = GlobeAtt.DATA_INDEX;
    StringBuilder strHtml = new StringBuilder();
    string sql = string.Empty;
    strHtml.Append("<table class=\"main_tb\"><tbody>");
    if (dt_A002.Rows[0]["TABLE_ID"].ToString().Equals(""))
    {
        strHtml.Append("<tr><td>菜单表配置有异常，请联系管理员...</td></tr>");
    }
    else
    {

        //新增调用后台初始化
        string form_init = dt_A002.Rows[0]["form_init"].ToString();
        if (form_init!="")
        {
            form_init = data_index + Fun.getProcData(form_init, dt_A002.Rows[0]["table_id"].ToString());
            // BaseFun.getStrByIndex(form_init, data_index + column_id + "|", data_index)
            string mainkeyvalue = BaseFun.getStrByIndex(form_init, data_index + dt_A002.Rows[0]["MIAN_KEY"].ToString() + "|", data_index);
            Response.Write("main_keyvalue='" + mainkeyvalue + "';");
        }        
        //加载表单主表
        sql = "select * from a100 t where t.table_id='" + dt_A002.Rows[0]["TABLE_ID"].ToString() + "'";
        dt_A100 = Fun.getDtBySql(sql);
        //加载表单字段明细
        sql = "Select t.* From a10001 t where t.table_id='" + dt_A002.Rows[0]["TABLE_ID"].ToString() + "'  Order By t.COL_X";
        dt_A10001 = Fun.getDtBySql(sql);
        //页面显示一行字段总数
        int col_all = int.Parse(dt_A100.Rows[0]["bs_cols"].ToString());
        int col_num = 0;
        //设置菜单属性字段
        strHtml.Append("<input type='hidden' id='" + menu_id + "_0_0'/>");
        //当option='I'时加载空字段；当option='M'加载具体值
        for (int i = 0; i < dt_A10001.Rows.Count; i++)
        {
            string column_id = dt_A10001.Rows[i]["COLUMN_ID"].ToString();
            string init_value = BaseFun.getStrByIndex(form_init, data_index + column_id + "|", data_index);
            if (column_id == "OBJID")
            {
                //strHtml.Append("<input type='hidden' id='" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' value ='" + init_value + "'/>");
                strHtml.Append("<input type=\"hidden\" id='TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' value ='" + init_value + "' />");
            }
            //控制显示、隐藏
            if (dt_A10001.Rows[i]["SYS_VISIBLE"].ToString() == "0" || column_id == "OBJID")
            {
                strHtml.Append("<input type='hidden' name='" + menu_id + "_0_0' id='TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' value ='" + init_value + "'/>");
            }
            else
            {
                int col_lbl = 1;
                if (dt_A10001.Rows[i]["COL08"].ToString() != "")
                {
                    col_lbl = Int32.Parse(dt_A10001.Rows[i]["COL08"].ToString());
                }
                else
                {
                    col_lbl = 1;
                }
                if (col_num == 0 || col_num + col_lbl > col_all)
                {
                    strHtml.Append("<tr>");
                }

                if (col_lbl > 0)
                {
                    strHtml.Append("<td colspan='" + col_lbl.ToString() + "' style=' overflow:hidden;'>");//width:50px;
                    strHtml.Append(dt_A10001.Rows[i]["col_text"].ToString());
                    strHtml.Append("</td>");
                }

                col_num = col_num + col_lbl;

                col_lbl = Int32.Parse(dt_A10001.Rows[i]["bs_cols"].ToString());

                if (col_num == 0 || col_num + col_lbl > col_all)
                {
                    strHtml.Append("</tr>");
                    strHtml.Append("<tr>");
                    col_num = 0;
                }

                strHtml.Append("<td colspan='" + dt_A10001.Rows[i]["bs_cols"].ToString() + "'>");

                string col_edit = dt_A10001.Rows[i]["COL_EDIT"].ToString();
                string SELECT_FLAG = dt_A10001.Rows[i]["SELECT_FLAG"].ToString();
                string select_sql = dt_A10001.Rows[i]["select_sql"].ToString();
                string strStyle = "style='width:" + dt_A10001.Rows[i]["BS_EDIT_WIDTH"].ToString() + "px; margin:1px 0 0 2px; display:inline-block; border:1px solid #AACAEE;'";
                if (SELECT_FLAG == "1")
                {
                    //表选
                    strHtml.Append("<input type='text' name='" + menu_id + "_0_0' id='TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' value ='" + init_value + "' "+ strStyle +" onfocus='javascript:this.select();'");
                    //触发后台itemchange
                    if (dt_A10001.Rows[i]["CALC_FLAG"] == "1")
                    {
                        strHtml.Append(" onchange=\"heq_itemchange(this.id);\" ");
                    }
                    //控制可用不可用
                    if (dt_A10001.Rows[i]["SYS_ENABLE"].ToString() == "0")
                    {
                        strHtml.Append(" readonly='true'");
                    }
                    strHtml.Append(" />");
                    strHtml.Append("<img class='img_choose' id='IMG_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' src=\"../images/choose.png\" onclick=\"javascript:show_choose(this.id);\" />");

                }
                else
                {
                    //下拉框
                    if (col_edit.IndexOf("ddd_") >= 0)
                    {
                        strHtml.Append("<select name='" + menu_id + "_0_0' id=\"TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "\" " + strStyle);
                        //触发后台itemchange
                        if (dt_A10001.Rows[i]["CALC_FLAG"] == "1")
                        {
                            strHtml.Append(" onchange=\"heq_itemchange(this.id);\" ");
                        }
                        if (dt_A10001.Rows[i]["SYS_ENABLE"].ToString() == "0")
                        {
                            strHtml.Append(" disabled='true'");
                        }
                        strHtml.Append(">");
                        if (select_sql.Length > 10)
                        {
                            select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                            dt_data = Fun.getDtBySql(select_sql);
                            for (int j = 0; j < dt_data.Rows.Count; j++)
                            {
                                strHtml.Append("<option value=\"" + dt_data.Rows[j]["ID"].ToString() + "\"");
                                if (dt_data.Rows[j]["ID"].ToString()==init_value)
                                {
                                   strHtml.Append(" selected=\"selected\" ");
                                }
                                strHtml.Append(">" + dt_data.Rows[j]["NAME"].ToString() + "</option>");
                            }
                        }
                        strHtml.Append("</select>");
                    }
                    if (col_edit == "checkbox")
                    {
                        strHtml.Append("<input type='checkbox' name='" + menu_id + "_0_0' id='TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "'");
                        //触发后台itemchange
                        if (dt_A10001.Rows[i]["CALC_FLAG"] == "1")
                        {
                            strHtml.Append(" onchange=\"heq_itemchange(this.id);\" ");
                        }
                        if (dt_A10001.Rows[i]["SYS_ENABLE"].ToString() == "0")
                        {
                            strHtml.Append(" disabled='true'");
                        }
                        if (init_value=="1")
                        {
                            strHtml.Append(" checked=\"checked\" ");
                        }
                        strHtml.Append("/>");
                    }
                    if (col_edit == "datelist")
                    {
                        strHtml.Append("<input type='text' name='" + menu_id + "_0_0' id='TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' value='" + init_value + "' " + strStyle + " onfocus='javascript:this.select();' onclick=\"SelectDate(this,'yyyy-MM-dd')\"");
                        //触发后台itemchange
                        if (dt_A10001.Rows[i]["CALC_FLAG"] == "1")
                        {
                            strHtml.Append(" onfocus='javascript:this.select();' ");
                        }
                        //控制可用不可用
                        if (dt_A10001.Rows[i]["SYS_ENABLE"].ToString() == "0")
                        {
                            strHtml.Append(" readonly='true'");
                        }
                        strHtml.Append(" />");
                    }
                    if (col_edit == "datetimelist")
                    {
                        strHtml.Append("<input type='text' name='" + menu_id + "_0_0' id='TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' value='" + init_value + "' " + strStyle + " onfocus='javascript:this.select();' onclick=\"SelectDate(this,'yyyy-MM-dd hh:mm:ss')\"");
                        //触发后台itemchange
                        if (dt_A10001.Rows[i]["CALC_FLAG"] == "1")
                        {
                            strHtml.Append(" onchange=\"heq_itemchange(this.id);\" ");
                        }
                        //控制可用不可用
                        if (dt_A10001.Rows[i]["SYS_ENABLE"].ToString() == "0")
                        {
                            strHtml.Append(" readonly='true'");
                        }
                        strHtml.Append(" />");
                    }

                    if (col_edit == "u_edit" || col_edit == "u_number" || col_edit == "u_thousands")
                    {
                        strHtml.Append("<input type='text' name='" + menu_id + "_0_0' id='TXT_" + menu_id + "_0_0_" + dt_A10001.Rows[i]["line_no"].ToString() + "' value='" + init_value + "' " + strStyle + " onfocus='javascript:this.select();'");
                        //触发后台itemchange
                        if (dt_A10001.Rows[i]["CALC_FLAG"] == "1")
                        {
                            strHtml.Append(" onchange=\"heq_itemchange(this.id);\" ");
                        }
                        //控制可用不可用
                        if (dt_A10001.Rows[i]["SYS_ENABLE"].ToString() == "0")
                        {
                            strHtml.Append(" readonly='true'");
                        }
                        strHtml.Append(" />");
                    }

                }
                strHtml.Append("</td>");

                col_num = col_num + col_lbl;

                if (col_num == col_all)
                {
                    strHtml.Append("</tr>");
                    col_num = 0;
                }
            }
            if (col_num > 0 && col_num != col_all && i == dt_A10001.Rows.Count - 1)
            {
                strHtml.Append("</tr>");
            }
        }
    }

    strHtml.Append("</tbody></table>");
    Response.Write("$(\"#div_main\").html(\"" + strHtml.Replace("\"", "\\\"") + "\");");
    Response.Write("if(main_keyvalue!=\"\" && nowdetail_index!=\"0\"){loaddetaillist(nowdetail_index, menu_id, main_keyvalue);}");
%>