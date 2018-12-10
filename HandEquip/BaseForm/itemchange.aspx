<%@ Page Language="C#" AutoEventWireup="true" CodeFile="itemchange.aspx.cs" Inherits="HandEquip_BaseForm_itemchange" %>

<%
    string data_index = GlobeAtt.DATA_INDEX;
    string menu_id = Request.QueryString["menu_id"].ToString();
    //string menu_id = BaseFun.getAllHyperLinks(RequestXml, "<MENU_ID>", "</MENU_ID>")[0].Value;
    string rowid = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
    string rowlist = BaseFun.getAllHyperLinks(RequestXml, "<ROWLIST>", "</ROWLIST>")[0].Value;
    string mainrowlist = "";//BaseFun.getAllHyperLinks(RequestXml, "<MAINROWLIST>", "</MAINROWLIST>")[0].Value;
    string colid = BaseFun.getAllHyperLinks(RequestXml, "<COLID>", "</COLID>")[0].Value;
    string pkg_name = dt_a00201.Rows[0]["PKG_NAME"].ToString();
    string table_id = dt_a00201.Rows[0]["TABLE_ID"].ToString();
    string column_id = string.Empty;
    string bs_select_sql = string.Empty;
    string bs_col_whither = string.Empty;
    string col_whither = string.Empty;
    string check_exist = string.Empty;
    string bs_msg = string.Empty;
    string rowdate_ = string.Empty;
    StringBuilder strhtml = new StringBuilder();
    try
    {
        
        rowdate_ = rowlist;
        string sql = "Select * From a10001 t Where t.table_id='" + table_id + "'";
        dt_a10001 = Fun.getDtBySql(sql);
        for (int i = 0; i < dt_a10001.Rows.Count; i++)
        {
            if (dt_a10001.Rows[i]["LINE_NO"].ToString() == colid)
            {
                column_id = dt_a10001.Rows[i]["COLUMN_ID"].ToString();
                bs_select_sql = dt_a10001.Rows[i]["bs_select_sql"].ToString();
                bs_col_whither = dt_a10001.Rows[i]["bs_col_whither"].ToString();
                col_whither = dt_a10001.Rows[i]["col_whither"].ToString();
                check_exist = dt_a10001.Rows[i]["check_exist"].ToString();
                bs_msg = dt_a10001.Rows[i]["bs_msg"].ToString();
            }
            rowdate_ = rowdate_.Replace(data_index + dt_a10001.Rows[i]["LINE_NO"] + "|", data_index + dt_a10001.Rows[i]["COLUMN_ID"] + "|");
        }
        if (column_id != null)
        {
            rowdate_ = rowdate_.Replace("'", "''");
            //执行后台itemchange函数
            rowdate_ = Fun.ItemChange(pkg_name, column_id, mainrowlist, rowdate_, GlobeAtt.A007_KEY);
            //返回值解析
            int pos_ = rowdate_.IndexOf(data_index);
            while (pos_ >= 0)
            {
                string v = rowdate_.Substring(0, pos_);
                int pos1_ = v.IndexOf("|");
                string column_id_ = v.Substring(0, pos1_);//字段ID
                string column_value_ = v.Substring(pos1_ + 1);//字段值
                if (column_id_.IndexOf("1000") == 0)
                {
                    //执行JS代码
                    if (column_id_ == "10005")
                    {
                        if (column_value_ != "")
                        {
                            strhtml.Append(column_value_);
                        }

                    }
                }
                else
                {
                    if (column_id.Length > 5 && column_id.Substring(0, 5) == "MAIN_")
                    {

                    }
                    else if (column_id == "A002KEY")
                    {
                        strhtml.Append("set_colvalue('" + column_id + "','" + column_value_ + "');");
                    }
                    else
                    {
                        for (int i = 0; i < dt_a10001.Rows.Count; i++)
                        {
                            column_id = dt_a10001.Rows[i]["COLUMN_ID"].ToString();
                            if (column_id == column_id_)
                            {
                                strhtml.Append("set_colvalue('" + rowid + "_" + dt_a10001.Rows[i]["LINE_NO"].ToString() + "','" + column_value_ + "');");
                                break;
                            }
                        }
                    }
                }

                rowdate_ = rowdate_.Substring(pos_ + 1);
                pos_ = rowdate_.IndexOf(data_index);
            }
        }
    }
    catch (Exception ex)
    {
        Response.Write("alert('" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
        return;
    }

    if (bs_select_sql == null || bs_select_sql.Length < 2)
    {
        Response.Write(strhtml.ToString());
        return;
    }
    if (check_exist == "0" || col_whither == null || col_whither.Length < 2)
    {
        Response.Write(strhtml.ToString());
        return;
    }
    if (bs_select_sql.Length > 10)
    {
        bs_select_sql = bs_select_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
        bs_select_sql = bs_select_sql.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
        bs_select_sql = bs_select_sql.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
        bs_select_sql = bs_select_sql.Replace("[", "<PARM>");
        bs_select_sql = bs_select_sql.Replace("]", "</PARM>");
        MatchCollection col = BaseFun.getAllHyperLinks(bs_select_sql, "<PARM>", "</PARM>");
        for (int c = 0; c < col.Count; c++)
        {
            string COLID_ = col[c].Value;
            string v = "";
            if (COLID_.IndexOf("MAIN_") == 0)
            {
                v = BaseFun.getStrByIndex(mainrowlist, data_index + COLID_.Replace("MAIN_", "") + "|", data_index);
            }
            else
            {
                v = BaseFun.getStrByIndex(rowlist, data_index + COLID_ + "|", data_index);
            }
            string sql = bs_select_sql.Replace("<PARM>" + COLID_ + "</PARM>", v);
            bs_select_sql = sql;
        }
        dt_data = Fun.getDtBySql(bs_select_sql);
        if (dt_data.Rows.Count <= 0)
        {
            //string bs_msg = dt_a013010101.Rows[i]["BS_MSG"].ToString();
            string v = BaseFun.getStrByIndex(rowlist, data_index + colid + "|", data_index);
            bs_msg = bs_msg.Replace("[" + colid + "]", v);
            bs_msg = bs_msg.Replace("'", "\\'");
            Response.Write("alert('" + bs_msg + "');");
            Response.Write("set_colvalue('" + rowid + "_" + colid + "','');");
           // Response.Write("setfocus('TXT_" + rowid + "_" + colid + "');");
            return;
        }
        else
        {
            if (strhtml.Length > 0)
            {
                Response.Write(strhtml.ToString());
                return;
            }

            //赋值
            //string BS_COL_WHITHER = dt_a013010101.Rows[i]["BS_COL_WHITHER"].ToString();
            bs_col_whither = bs_col_whither.Replace("[", "<PARM>");
            bs_col_whither = bs_col_whither.Replace("]", "</PARM>");
            col = BaseFun.getAllHyperLinks(bs_col_whither, "<PARM>", "</PARM>");
            for (int c = 0; c < col.Count; c++)
            {
                string COLID_ = col[c].Value;
                if (dt_data.Columns.Count > c)
                {
                    string v = dt_data.Rows[0][c].ToString();
                    v = v.Replace("'", "\\'");
                    Response.Write("set_colvalue('" + rowid + "_" + COLID_ + "','" + v + "');");
                }
            }

        }
    }

    //Response.Write(strhtml.ToString());
    //return;
%>
