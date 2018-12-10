<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ItemChange.aspx.cs" Inherits="BaseForm_ItemChange" %>
<%
    try
    {
        //根据传入的表来获取 A00201_KEY
        string COLID = BaseFun.getAllHyperLinks(RequestXml, "<COLID>", "</COLID>")[0].Value;
        string ROWID = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
        //当前行的数据
        string data_index = GlobeAtt.DATA_INDEX;
        string ROWLIST = data_index + BaseFun.getAllHyperLinks(RequestXml, "<ROWLIST>", "</ROWLIST>")[0].Value;
        //主档的数据
        string MAINROWLIST = data_index + BaseFun.getAllHyperLinks(RequestXml, "<MAINROWLIST>", "</MAINROWLIST>")[0].Value;
        StringBuilder str_html = new StringBuilder();
        for (int i = 0; i < dt_a013010101.Rows.Count; i++)
        {
            string a10001_key = dt_a013010101.Rows[i]["A10001_KEY"].ToString();
            string this_column_id = dt_a013010101.Rows[i]["COLUMN_ID"].ToString();
            string check_exist = dt_a013010101.Rows[i]["CHECK_EXIST"].ToString();
            if (COLID == a10001_key)
            {
                //判断当前列会不会影响其他列
                //数据选择
                //判断有没有itemchange的包
                string pkg_name = dt_a00201.Rows[0]["PKG_NAME"].ToString();

                if (pkg_name != "")
                {
                    //把包转换为column_id的包
                    string rowdata__ = ROWLIST.Substring(1); //BaseFun.getAllHyperLinks(RequestXml, "<ROWLIST>", "</ROWLIST>")[0].Value;
                    string mainrowlist = MAINROWLIST.Substring(1);
                    string oldrowdata__ = "";
                    for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                    {

                        string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                        string a10001key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                        rowdata__ = rowdata__.Replace(data_index + a10001key + "|", data_index + column_id + "|");

                    }
                    rowdata__ += "_ROWID_|" + ROWID + data_index;
                    oldrowdata__ = rowdata__;

                    rowdata__ = rowdata__.Replace("'", "''");
                    string sql__ = pkg_name + ".ITEMCHANGE__('" + this_column_id + "','" + rowdata__ + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";
                    if (dt_a00201.Rows[0]["if_main"].ToString() != "1")
                    {
                        string a00201_key_ = dt_a00201.Rows[0]["MENU_ID"].ToString() + "-0";
                        string rowjson = Session["JSON_" + a00201_key_].ToString();
                        dt_temp = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));

                        for (int c = 0; c < dt_temp.Rows.Count; c++)
                        {

                            string column_id = dt_temp.Rows[c]["COLUMN_ID"].ToString();
                            string a10001key = dt_temp.Rows[c]["A10001_KEY"].ToString();
                            mainrowlist = mainrowlist.Replace(data_index + a10001key + "|", data_index + column_id + "|");
                        }
                        mainrowlist = mainrowlist.Replace("'", "''");
                        sql__ = pkg_name + ".ITEMCHANGE__('" + this_column_id + "','" + mainrowlist + "','" + rowdata__ + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";

                    }
                    else
                    {
                        mainrowlist = "";
                    }
                    try
                    {
                        rowdata__ = Fun.ItemChange(pkg_name, this_column_id, mainrowlist, rowdata__, GlobeAtt.A007_KEY);
                        //  rowdata__ = Fun.getProcData(sql__, dt_a00201.Rows[0]["table_id"].ToString());
                        int pos_ = rowdata__.IndexOf(data_index);
                        //获取编辑属性
                        // string enable_attr = BaseFun.getStrByIndex(rowdata__, data_index +  "10001|", data_index);
                        // string disable_attr = BaseFun.getStrByIndex(rowdata__, data_index + "10000|", data_index);
                        while (pos_ >= 0)
                        {
                            string v = rowdata__.Substring(0, pos_);
                            int pos1_ = v.IndexOf("|");
                            string column_id = v.Substring(0, pos1_);

                            if (column_id.IndexOf("1000") == 0)
                            {
                                if (column_id == "10001" || column_id == "10000")
                                {
                                    string col_enable = "0";
                                    if (column_id == "10001")
                                    {
                                        col_enable = "1";
                                    }
                                    string col_v = "," + v.Substring(pos1_ + 1);
                                    for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                                    {
                                        string column_id_ = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                                        if (col_v.IndexOf("," + column_id_ + ",") >= 0)
                                        {
                                            string COLID_ = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                                            //   Response.Write("SetEnable('" + ROWID + "_" + COLID_ + "','" + col_enable + "');");
                                            str_html.Append("SetEnable('" + ROWID + "_" + COLID_ + "','" + col_enable + "');");
                                        }
                                    }
                                }
                                //新增按钮
                                if (column_id == "10003")
                                {
                                    string col_v = v.Substring(pos1_ + 1);
                                    if (col_v == "0")
                                    {
                                        // Response.Write("setbtndisable('btn_addrow_" + a00201_key + "')");
                                        str_html.Append("setbtndisable('btn_addrow_" + a00201_key + "');");
                                    }
                                    else
                                    {
                                        // Response.Write("setbtnenable('btn_addrow_" + a00201_key + "')");
                                        str_html.Append("setbtnenable('btn_addrow_" + a00201_key + "');");
                                    }
                                }
                                //删除按钮
                                if (column_id == "10004")
                                {
                                    string col_v = v.Substring(pos1_ + 1);
                                    if (col_v == "0")
                                    {
                                        //  Response.Write("setbtndisable('btn_delrow_" + a00201_key + "')");
                                        str_html.Append("setbtndisable('btn_delrow_" + a00201_key + "');");
                                    }
                                    else
                                    {
                                        //  Response.Write("setbtnenable('btn_delrow_" + a00201_key + "')");
                                        str_html.Append("setbtndisable('btn_delrow_" + a00201_key + "');");
                                    }
                                }

                                //执行JS代码
                                if (column_id == "10005")
                                {
                                    string col_v = v.Substring(pos1_ + 1);
                                    if (col_v != "")
                                    {
                                        str_html.Append(col_v);
                                    }

                                }


                            }
                            else
                            {
                                if (column_id.Length > 5 && column_id.Substring(0, 5) == "MAIN_")
                                {
                                    for (int c = 0; c < dt_temp.Rows.Count; c++)
                                    {

                                        string column_id_ = "MAIN_" + dt_temp.Rows[c]["COLUMN_ID"].ToString();
                                        string COLID_ = dt_temp.Rows[c]["A10001_KEY"].ToString();
                                        if (column_id_ == column_id)
                                        {
                                            string col_v = v.Substring(pos1_ + 1);
                                            col_v = col_v.Replace("'", "\\'");
                                            col_v = col_v.Replace("\r\n", "<BR>");
                                            col_v = col_v.Replace("\r", "<BR>");
                                            col_v = col_v.Replace("\n", "<BR>");
                                            //  Response.Write("SetItem('" + dt_a00201.Rows[0]["MENU_ID"].ToString() + "-0_0" + "_" + COLID_ + "','" + col_v + "');");
                                            str_html.Append("SetItem('" + dt_a00201.Rows[0]["MENU_ID"].ToString() + "-0_0" + "_" + COLID_ + "','" + col_v + "');");

                                            break;
                                        }
                                    }
                                }
                                else
                                {
                                    for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                                    {

                                        string column_id_ = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();

                                        if (column_id_ == column_id)
                                        {
                                            string col_v = v.Substring(pos1_ + 1);
                                            string COLID_ = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                                            col_v = col_v.Replace("'", "\\'");
                                            col_v = col_v.Replace("\r\n", "<BR>");
                                            col_v = col_v.Replace("\r", "<BR>");
                                            col_v = col_v.Replace("\n", "<BR>");
                                            str_html.Append("SetItem('" + ROWID + "_" + COLID_ + "','" + col_v + "');");
                                            break;
                                        }

                                    }
                                }


                            }
                            rowdata__ = rowdata__.Substring(pos_ + 1);
                            pos_ = rowdata__.IndexOf(data_index);
                        }


                    }
                    catch (Exception ex)
                    {
                        Response.Write("alert('" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
                        return;
                    }
                    if (rowdata__.IndexOf(data_index + this_column_id) < 0)
                    {
                        rowdata__ += this_column_id + "|" + BaseFun.getStrByIndex(data_index + oldrowdata__, data_index + this_column_id + "|", data_index) + data_index;
                    }
                    if (ROWID.IndexOf("-0_0") > 0)
                    {
                        //刷新下拉列表
                        StringBuilder ddd_html = new StringBuilder();
                        for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                        {
                            string col_edit_ = dt_a013010101.Rows[c]["col_edit"].ToString().ToLower();
                            if (col_edit_.IndexOf("ddd_") == 0)
                            {
                                string select_sql = dt_a013010101.Rows[c]["select_sql"].ToString();
                                select_sql = select_sql.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                                select_sql = select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                                select_sql = select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                                Boolean lb_do = false;
                                if (select_sql.IndexOf("[") > 0 && select_sql.IndexOf("]") > 0)
                                {
                                    int pos1_ = select_sql.IndexOf("[");
                                    int pos2_ = select_sql.IndexOf("]");
                                    while (pos1_ > 0 && pos2_ > 0 && pos2_ > pos1_)
                                    {
                                        string column_id__ = select_sql.Substring(pos1_ + 1, pos2_ - pos1_ - 1);


                                        if ((data_index + rowdata__).IndexOf(data_index + column_id__ + "|") >= 0)
                                        {
                                            //表示有变化
                                            lb_do = true;
                                            string new__ = BaseFun.getStrByIndex(data_index + rowdata__, data_index + column_id__ + "|", data_index);
                                            select_sql = select_sql.Replace("[" + column_id__ + "]", new__);
                                        }
                                        else
                                        {
                                            string old__ = BaseFun.getStrByIndex(data_index + oldrowdata__, data_index + column_id__ + "|", data_index);
                                            select_sql = select_sql.Replace("[" + column_id__ + "]", old__);
                                        }
                                        pos1_ = select_sql.IndexOf("[");
                                        pos2_ = select_sql.IndexOf("]");
                                    }
                                }
                                if (lb_do == true)
                                {
                                    string COLID_ = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                                    dt_temp = Fun.getDtBySql(select_sql);
                                    //移除selecte 
                                    ddd_html.Append(" var sv = $('#DDD_" + ROWID + "_" + COLID_ + "').val() ;$('#DDD_" + ROWID + "_" + COLID_ + "').empty();");
                                    for (int rr = 0; rr < dt_temp.Rows.Count; rr++)
                                    {
                                        string id_ = dt_temp.Rows[rr][0].ToString();
                                        string name_ = id_;
                                        if (dt_temp.Columns.Count > 1)
                                        {
                                            name_ = dt_temp.Rows[rr][1].ToString();
                                        }
                                        ddd_html.Append("$('#DDD_" + ROWID + "_" + COLID_ + "').append(\"<option value='" + id_ + "'>" + name_ + "</option>\");");

                                    }
                                    ddd_html.Append("$('#DDD_" + ROWID + "_" + COLID_ + "').val(sv);");
                                }
                            }
                        }
                        Response.Write(ddd_html.ToString());
                    }




                    if (check_exist != "1")
                    {
                        Response.Write(str_html.ToString());
                        return;
                    }
                }



                string BS_SELECT_SQL = dt_a013010101.Rows[i]["BS_SELECT_SQL"].ToString();

                if (BS_SELECT_SQL == null || BS_SELECT_SQL.Length < 2)
                {
                    Response.Write(str_html.ToString());
                    return;
                }
                //选取
                string COL_WHITHER = dt_a013010101.Rows[i]["COL_WHITHER"].ToString();
                if (check_exist == "0" && (COL_WHITHER == null || COL_WHITHER.Length < 2))
                {
                    Response.Write(str_html.ToString());
                    return;
                }
                // string check_exist = dt_a013010101.Rows[i]["CHECK_EXIST"].ToString();      
                if (BS_SELECT_SQL.Length > 10)
                {

                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[", "<PARM>");
                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("]", "</PARM>");
                    MatchCollection col = BaseFun.getAllHyperLinks(BS_SELECT_SQL, "<PARM>", "</PARM>");
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
                        string sql = BS_SELECT_SQL.Replace("<PARM>" + COLID_ + "</PARM>", v);
                        BS_SELECT_SQL = sql;
                    }

                    dt_data = Fun.getDtBySql(BS_SELECT_SQL);
                    if (dt_data.Rows.Count <= 0)
                    {
                        string bs_msg = dt_a013010101.Rows[i]["BS_MSG"].ToString();
                        string v = BaseFun.getStrByIndex(ROWLIST, data_index + COLID + "|", data_index);
                        bs_msg = bs_msg.Replace("[" + COLID + "]", v);
                        bs_msg = bs_msg.Replace("'", "\\'");
                        Response.Write("alert('" + bs_msg + "');");
                        Response.Write("SetItem('" + ROWID + "_" + COLID + "','');");
                        Response.Write("setfocus('TXT_" + ROWID + "_" + COLID + "');");
                        return;
                    }
                    else
                    {
                        if (str_html.Length > 0)
                        {
                            Response.Write(str_html.ToString());
                            return;
                        }

                        //赋值
                        string BS_COL_WHITHER = dt_a013010101.Rows[i]["BS_COL_WHITHER"].ToString();
                        BS_COL_WHITHER = BS_COL_WHITHER.Replace("[", "<PARM>");
                        BS_COL_WHITHER = BS_COL_WHITHER.Replace("]", "</PARM>");
                        col = BaseFun.getAllHyperLinks(BS_COL_WHITHER, "<PARM>", "</PARM>");
                        for (int c = 0; c < col.Count; c++)
                        {
                            string COLID_ = col[c].Value;
                            if (dt_data.Columns.Count > c)
                            {
                                string v = dt_data.Rows[0][c].ToString();
                                v = v.Replace("'", "\\'");
                                Response.Write("SetItem('" + ROWID + "_" + COLID_ + "','" + v + "');");
                            }
                        }

                    }
                } 
              
                
                
                
                %>
         <%  //计算公式
    if (str_html.Length > 10)
    {
        return;
    }
    string bs_formula_num = dt_a013010101.Rows[i]["BS_FORMULA_NUM"].ToString();
    int pos1 = bs_formula_num.IndexOf("}");
    int kk = 0;
    while (pos1 > 0 && kk < 100)
    {
        string f = BaseFun.getStrByIndex(bs_formula_num, "{", "}");
        bs_formula_num = bs_formula_num.Substring(pos1 + 1);
        /*解析数据
        */
        int pos2 = f.IndexOf("=");
        string RCOLID_ = f.Substring(1, pos2 - 2);
        string f_sql = f.Substring(pos2 + 1);
        f_sql = "Select " + f_sql + " as c from dual ";
        string COLID_ = BaseFun.getStrByIndex(f_sql, "[", "]");
        while (COLID_ != "" && COLID_ != null)
        {
            string v = "";
            if (COLID_.IndexOf("MAIN_") == 0)
            {
                v = BaseFun.getStrByIndex(MAINROWLIST, data_index + COLID_ + "|", data_index);
            }
            else
            {
                v = BaseFun.getStrByIndex(ROWLIST, data_index + COLID_ + "|", data_index);
            }
            f_sql = f_sql.Replace("[" + COLID_ + "]", v);
            COLID_ = BaseFun.getStrByIndex(f_sql, "[", "]");
        }
        dt_temp = Fun.getDtBySql(f_sql);
        string vv = dt_temp.Rows[0][0].ToString();
        Response.Write("SetItem('" + ROWID + "_" + RCOLID_ + "','" + vv + "');");

        pos1 = bs_formula_num.IndexOf("}");
        kk = kk + 1;
    }
                
                 %>
                  
         <%       break;
            }



        }
    }
    catch(Exception ex)
    {
        Response.Write("alert(\"" + ex.Message + "\");");
    }
 %>

