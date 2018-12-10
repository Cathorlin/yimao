<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyReq.aspx.cs" Inherits="BaseForm_MyReq" %>

<%   try
    {
        
        string req_url = BaseFun.getAllHyperLinks(RequestXml, "<URL>", "</URL>")[0].Value;
        string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;
        string SELECTEDROWLIST = "";
         
        if (req_id == "EXEC")
        {

                string rowkey = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
                string a014_id_ = BaseFun.getAllHyperLinks(RequestXml, "<MAINKEY>", "</MAINKEY>")[0].Value;
               
                string rowid = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
                string objid = "";
                try
                {
                    objid = BaseFun.getAllHyperLinks(RequestXml, "<OBJID>", "</OBJID>")[0].Value;
                }
                catch
                {
                    objid = "";
                }
                string DOMAINKEY = "";
                try
                {
                    DOMAINKEY = BaseFun.getAllHyperLinks(RequestXml, "<DOMAINKEY>", "</DOMAINKEY>")[0].Value;
                }
                catch
                {
                    DOMAINKEY = "";
                }
                string a00201_key_ = dt_a00201.Rows[0]["A00201_KEY"].ToString();
               
                string table____ = dt_a00201.Rows[0]["TABLE_ID"].ToString();
                string e_sql = "pkg_a.doa014('" + a014_id_ + "','" + table____ + "','" + rowkey.Replace("'","''''") + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";
                e_sql = Fun.execSql(e_sql, GlobeAtt.A007_KEY, a00201_key_, "A014_ID=" + a014_id_, table____, objid, DOMAINKEY);
                if (e_sql != "0")
                {
                    Response.Write("rbclose();doNext('" + e_sql.Replace("\n", ";").Replace("'", "\"") + "');");
                    return;
                }
                else
                {
                    Response.Write("rbclose();");
                }
       
          
 
            return;
        }
        if (req_id == "DOWNALL")
        {
               
            string uploadfilepath = HttpContext.Current.Request.MapPath("../data/Blank.xls");
            string model_file = uploadfilepath;
            if (System.IO.File.Exists(uploadfilepath) == false)
            {
                Response.Write("alert('下载文件失败！');");
                return;
            }
            string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath); // Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath);
            uploadfilepath = "../temp";
            string table_id__ = dt_a00201.Rows[0]["TABLE_ID"].ToString();
            string vpsh = uploadfilepath + "/" + table_id__ + "/" + filename;
            string psh = HttpContext.Current.Request.MapPath(vpsh);
            if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(psh)))
            {
                System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(psh));
            }

            string ls_xls = GlobeAtt.HTTP_URL + "/temp/" + table_id__ + "/" + filename;

            string outfilename = HttpContext.Current.Request.MapPath("../temp/" + table_id__ + "/" + filename);
            
            dt_a00201 = Fun.getdtByJson(Fun.getJson(json, "P9"));

            string MAINKEY = BaseFun.getAllHyperLinks(RequestXml, "<MAINKEY>", "</MAINKEY>")[0].Value;
             
            ArrayList parm = new ArrayList();
            
            for (int l = 0; l < dt_a00201.Rows.Count; l++)
            {
                string a00201_key_ = dt_a00201.Rows[l]["a00201_key"].ToString();
                string data_Sql = Get_Query_Sql(a00201_key_,false);
                if (data_Sql.IndexOf("'[MAINKEY]'") <= 0)
                {
                    Response.Write("alert('请先刷新以后再导出！');");
                    return;
                }
                data_Sql = data_Sql.Replace("'[MAINKEY]'", "'" + MAINKEY + "'");
               
                //, MAINKEY
                //
                //获取下载的SQL
                dt_data = Fun.getDtBySql(data_Sql);               
                string[] column_id_ = new string[250];
                string[] col_text_ = new string[250];
                string[] remove_col = new string[250];
                int col_num = 0;
                int remove_num = 0;
                string[] Removecol = new string[250];
                //获取每个节点的值
                string rowjson = Session["JSON_" + a00201_key_].ToString();
                dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));
                
                for (int j = 0; j < dt_a013010101.Rows.Count; j++)
                {
                    string col_text = dt_a013010101.Rows[j]["col_text"].ToString();
                    string column_id = dt_a013010101.Rows[j]["column_id"].ToString().ToUpper();
                    string col_visible = dt_a013010101.Rows[j]["col_visible"].ToString();
                    if (col_visible != "1")
                    {
                        continue;
                    }
                    string col01 = dt_a013010101.Rows[j]["col01"].ToString();
                    //动态列
                    if (col01 == "1")
                    {
                        for (int c = 0; c < dt_data.Columns.Count; c++)
                        {
                            if (dt_data.Columns[c].ColumnName.ToUpper().IndexOf(column_id) == 0)
                            {
                                //dt_data.Columns[c].Caption = col_text;

                                column_id_[col_num] = dt_data.Columns[c].ColumnName;
                                col_text_[col_num] = dt_data.Columns[c].ColumnName;
                                col_num = col_num + 1;
                            }
                        }

                    }
                    else
                    {
                        for (int c = 0; c < dt_data.Columns.Count; c++)
                        {
                            if (dt_data.Columns[c].ColumnName == column_id)
                            {
                                dt_data.Columns[c].Caption = col_text;
                                break;
                            }
                        }
                        column_id_[col_num] = column_id;
                        col_text_[col_num] = col_text;
                        col_num = col_num + 1;
                    }



                    //for (int c = 0; c < dt_data.Columns.Count; c++)
                    //{
                    //    if (dt_data.Columns[c].ColumnName == column_id)
                    //    {
                    //        dt_data.Columns[c].Caption = col_text;
                    //        break;
                    //    }
                    //}

                    //column_id_[col_num] = column_id;
                    //col_text_[col_num] = col_text;
                    //col_num = col_num + 1;
                }
                for (int c = 0; c < dt_data.Columns.Count; c++)
                {
                    string column_id = dt_data.Columns[c].ColumnName.ToUpper();
                    string col_visible = "0";
                    for (int j = 0; j < col_num; j++)
                    {
                        if (column_id == column_id_[j])
                        {
                            col_visible = "1";
                            break;
                        }
                    }
                    if (col_visible != "1")
                    {
                        remove_col[remove_num] = column_id;
                        remove_num = remove_num + 1;
                        continue;
                    }
                }
                for (int i = 0; i < remove_num; i++)
                {

                    dt_data.Columns.Remove(remove_col[i]);
                }
                ArrayList thisparm = new ArrayList();
                thisparm.Add(dt_data);
                thisparm.Add(column_id_);
                thisparm.Add(col_text_);
                thisparm.Add(dt_a00201.Rows[l]["Tab_Original"].ToString());
                parm.Add(thisparm);
              
            }
            ExcelFunc exc = new ExcelFunc();

            string li_exc = exc.AddExeclByColumns(parm,  model_file, outfilename);
            if (li_exc == "0")
            {
                Response.Write("alert('下载文件失败！');");
                return;
            }
            //WriteExeclByColumns_Ole
            Response.Write("openwin('" + ls_xls + "')");
            //记录日志   
            string sql_ = " pkg_log.save_export('" + GlobeAtt.A007_KEY + "','" + a00201_key + "','" + table_id__ + "/" + filename + "','" + GlobeAtt.A30001_KEY + "','"+ MAINKEY+"')";
            Fun.execSqlOnly(sql_);
            return;
        }
        if (req_id == "DOWNXLS" )
        {
            //下载文档
            string data_Sql = Get_Query_Sql(a00201_key,true);
                //
            //获取下载的SQL
                
            dt_data = Fun.getDtBySql(data_Sql);
            string uploadfilepath = HttpContext.Current.Request.MapPath("../data/Blank.xls");
            string model_file = uploadfilepath;
            if (System.IO.File.Exists(uploadfilepath) == false)                
            {
                Response.Write("alert('下载文件失败！');");
                return;
            }
                string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath); // Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath);
                uploadfilepath = "../temp";
                string table_id__ = dt_a00201.Rows[0]["TABLE_ID"].ToString();
                string vpsh = uploadfilepath + "/" + table_id__ + "/" + filename;
                string psh = HttpContext.Current.Request.MapPath(vpsh);
                if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(psh)))
                {
                    System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(psh));
                }

                string ls_xls = GlobeAtt.HTTP_URL + "/temp/" + table_id__ + "/" + filename;


                string outfilename = HttpContext.Current.Request.MapPath("../temp/" + table_id__ + "/" + filename);
                string[] column_id_ = new string[250];
                string[] col_text_ = new string[250];
                string[] remove_col = new string[250];
                int col_num = 0;
                int remove_num = 0;
                string[] Removecol = new string[250];
                for (int j = 0; j < dt_a013010101.Rows.Count; j++)
                {
                    string col_text = dt_a013010101.Rows[j]["col_text"].ToString();
                    string column_id = dt_a013010101.Rows[j]["column_id"].ToString().ToUpper();
                    string col_visible = dt_a013010101.Rows[j]["col_visible"].ToString();
                    if (col_visible != "1")
                    {
                        continue;
                    }
                    string col01 = dt_a013010101.Rows[j]["col01"].ToString();
                    //动态列
                    if (col01 == "1")
                    {
                        for (int c = 0; c < dt_data.Columns.Count; c++)
                        {
                            if (dt_data.Columns[c].ColumnName.ToUpper().IndexOf(column_id) == 0)
                            {
                                //dt_data.Columns[c].Caption = col_text;

                                column_id_[col_num] = dt_data.Columns[c].ColumnName;
                                col_text_[col_num] = dt_data.Columns[c].ColumnName;
                                col_num = col_num + 1;
                            }
                        }
                    
                    }
                    else
                    {
                        for (int c = 0; c < dt_data.Columns.Count; c++)
                        {
                            if (dt_data.Columns[c].ColumnName == column_id)
                            {
                                dt_data.Columns[c].Caption = col_text;
                                break;
                            }
                        }
                        column_id_[col_num] = column_id;
                        col_text_[col_num] = col_text;
                        col_num = col_num + 1;
                    }

            
                }
                for (int c = 0; c < dt_data.Columns.Count; c++)
                {
                    string column_id = dt_data.Columns[c].ColumnName.ToUpper();
                    string col_visible = "0";
                    for (int j = 0; j < col_num; j++)
                    {
                        if (column_id == column_id_[j])
                        {
                            col_visible = "1";
                            break;
                        }
                    }
                    if (col_visible != "1")
                    {
                        remove_col[remove_num] = column_id;
                        remove_num = remove_num + 1;
                        continue;
                    }
                
                }
                for (int i = 0; i < remove_num; i++)
                {

                    dt_data.Columns.Remove(remove_col[i]);
                }

                ExcelFunc exc = new ExcelFunc();
                string li_exc = exc.WriteExeclByColumns_Ole(dt_data, column_id_, col_text_, model_file, outfilename);
                //WriteExeclByColumns_Ole
                if (li_exc == "0")
                {
                    Response.Write("alert('下载文件失败！');");
                    return;
                }

                Response.Write("openwin('" + ls_xls + "')");           
                //记录日志   
                string sql_ = " pkg_log.save_export('" + GlobeAtt.A007_KEY + "','" + a00201_key + "','" + table_id__ + "/" + filename + "','"+ GlobeAtt.A30001_KEY+"')";
                Fun.execSqlOnly(sql_);
             
                return;
        }
         
         
         
         
         
         
         
         
         
        if (req_id == "DELETEA006")
        {
            //user_id,a00201_key,query_id
            string a006_key = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
            string sql = "delete from a006 t where t.user_id='"+ GlobeAtt.A007_KEY+"' and t.a00201_key='" + a00201_key +"' and  t.query_id='" + a006_key + "' ";
            int liexec = Fun.execSqlOnly(sql);
            if (liexec < 0)
            {
                Response.Write("alert('删除" + a006_key + "失败！');");
            }
            else
            {
                Response.Write("delete_a006('"+a006_key + "');");
            }
               
            return;
        }
        if (req_id == "SET_A006_DEF")
        {
            string a006_key = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
            string sql = "update  a006 t set DEF_FLAG ='0' where t.user_id='" + GlobeAtt.A007_KEY + "' and t.a00201_key='" + a00201_key + "'";
            int liexec = Fun.execSqlOnly(sql);
            if (liexec < 0)
            {
                Response.Write("alert('设置" + a006_key + "默认失败！');");
                return;
            }
            sql = "update  a006 t set DEF_FLAG ='1' where t.user_id='" + GlobeAtt.A007_KEY + "' and t.a00201_key='" + a00201_key + "' and  t.query_id='" + a006_key + "' ";
            liexec = Fun.execSqlOnly(sql);
            if (liexec < 0)
            {
                Response.Write("alert('设置" + a006_key + "默认失败！');");
            }
            else
            {
                Response.Write("alert('设置" + a006_key + "默认成功！');");
            }
            return;
        }
         
        if (req_id == "GETA006")
        {
            string a006_key = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
            dt_temp = Fun.getDtBySql("select t.* from a006 t where t.user_id='" + GlobeAtt.A007_KEY + "' and t.a00201_key='" + a00201_key + "' and  t.query_id='" + a006_key + "' ");
            for (int i = 0; i < dt_temp.Rows.Count; i++)
            {
                //function setqueryitem(a10001_key, CALC, col_type, col_sort, vlist) {
                string a10001_key = dt_temp.Rows[i]["COL_NAME"].ToString();
                string CALC = dt_temp.Rows[i]["COL_RELA"].ToString();
                string col_type = dt_temp.Rows[i]["col_type"].ToString();
                string col_sort = dt_temp.Rows[i]["COL_SORT"].ToString();
                string vlist = dt_temp.Rows[i]["COL_VALUE"].ToString();
                Response.Write("setqueryitem(\"" + a10001_key + "\",\"" + CALC + "\",\"" + col_type + "\",\"" + col_sort + "\",\"" + vlist + "\");");
            }
            return;
        }
        if (req_id == "SAVEA006")
        {
             // <?xml version="1.0" encoding="utf-8" ?><DATA><ROW><A10001_KEY>COL22</A10001_KEY><COLUMN_ID>COL22</COLUMN_ID><COL_TYPE>varchar</COL_TYPE><CALC></CALC><VALUE>6261|</VALUE>COL22</ROW></DATA>
            string sql = "Select  s_a006.nextval as c from dual ";
            dt_temp = Fun.getDtBySql(sql);
            string a006_key = dt_temp.Rows[0][0].ToString();
            string query_id = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
            string sql_insert = "delete from  a006 where USER_ID='" + GlobeAtt.A007_KEY + "' and a00201_key='" + a00201_key + "' and  query_id = '" + query_id + "'";
            int li_db =  Fun.execSqlOnly(sql_insert);
            if (li_db < 0)
            {
                Response.Write("alert('保存查询" + query_id + "'失败！);");
                return;
            }
            MatchCollection row_ = BaseFun.getAllHyperLinks(RequestXml, "<ROW>", "</ROW>");
            for (int i = 0; i < row_.Count; i++)
            {
                string A10001_KEY = BaseFun.getAllHyperLinks(row_[i].Value, "<A10001_KEY>", "</A10001_KEY>")[0].Value;
                string column_id = "";
                string COL_TYPE = "";
                for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                {
                    string A10001_key_ = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                    if (A10001_key_ == A10001_KEY)
                    {
                        column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                        COL_TYPE = dt_a013010101.Rows[c]["COL_TYPE"].ToString();
                        break;
                    }
                }
                string CALC = BaseFun.getAllHyperLinks(row_[i].Value, "<CALC>", "</CALC>")[0].Value;
                string VALUE = BaseFun.getAllHyperLinks(row_[i].Value, "<VALUE>", "</VALUE>")[0].Value;
                string sort = BaseFun.getAllHyperLinks(row_[i].Value, "<SORT>", "</SORT>")[0].Value;
                sql_insert = "Insert into A006(MENU_ID,user_id,table_id,query_id,col_name,col_rela,col_value,enter_user,enter_date,RESULTROW,COL_TYPE,COL_SORT,A00201_KEY)";
                sql_insert += "Values('" + dt_a00201.Rows[0]["menu_id"].ToString() + "','" + GlobeAtt.A007_KEY + "','" + dt_a00201.Rows[0]["table_id"].ToString() + "','" + query_id + "','" + column_id + "','" + CALC + "','" + VALUE.Replace("'","''") + "','" + GlobeAtt.A007_KEY + "',sysdate,10000,'" + COL_TYPE + "','" + sort + "','" +  a00201_key + "')";
                li_db = Fun.execSqlOnly(sql_insert);
                if (li_db < 0)
                {
                    Response.Write("alert('保存查询" + query_id + "'失败！);");
                    return;
                }
            }

            string NEXTDO = BaseFun.getAllHyperLinks(RequestXml, "<NEXTDO>", "</NEXTDO>")[0].Value;           
            Response.Write(NEXTDO);       
     
            return;
        }
        
        
        MatchCollection row = BaseFun.getAllHyperLinks(RequestXml, "<ROW>", "</ROW>");
        string data_index = GlobeAtt.DATA_INDEX;
        StringBuilder sqllist = new StringBuilder();
        StringBuilder aftersqllist = new StringBuilder();
        string selectobjlistlist = "";
        //保存A016的数据 
        if (req_id == "SAVEA016")
        {
            for (int i = 0; i < row.Count; i++)
            {

                string sql = "pkg_a016.savea016('" + row[i].Value + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])" ;
                sqllist.Append(sql + "<EXECSQL></EXECSQL>");
            }
            try
            {
                string log_key = "";
                string lsexec = Fun.execSqlList(sqllist.ToString(), GlobeAtt.A007_KEY, a00201_key, GlobeAtt.A007_KEY, "A014_ID=" + req_id, "A016", a00201_key,SELECTEDROWLIST , ref log_key);
                if (lsexec == "0" || lsexec.IndexOf(BaseMsg.getMsg("M0008")) >= 0)
                {
                    Response.Write("rbclose();");
                }
                else
                {
                    Response.Write("doNext('00" + lsexec + "');");
                }                
                
            }
            catch (Exception ex)
            {
                Response.Write("doNext('00" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
            }
            
            return;
        }
        string OPTION = BaseFun.getAllHyperLinks(RequestXml, "<OPTION>", "</OPTION>")[0].Value;
        string mainobjid = "";
        string main_key = "";
        //公共列
        string main_col = dt_a00201.Rows[0]["MAIN_KEY"].ToString();
        string main_col_v = BaseFun.getAllHyperLinks(RequestXml, "<MAINKEY>", "</MAINKEY>")[0].Value;
       
        Boolean if_log = false ;
        string main_table = dt_a00201.Rows[0]["TABLE_ID"].ToString();
        string main_table_type =  dt_a00201.Rows[0]["TBL_TYPE"].ToString();
        //选中的行
     
        try
        {
            SELECTEDROWLIST = BaseFun.getAllHyperLinks(RequestXml, "<SELECTEDROWLIST>", "</SELECTEDROWLIST>")[0].Value;
        }
        catch (Exception ex)
        {
            SELECTEDROWLIST = "";
        }
        if (req_id == "CopyBill")
        {
            Session["COPYBill_" + a00201_key] = "";
        
        }
         
        if (req_id == "SAVE")
        {
            dt_c = Fun.getdtByJson(Fun.getJson(json, "P3"));
            dt_u = Fun.getdtByJson(Fun.getJson(json, "P4"));
            //保存的列表
            dt_a00201 = Fun.getdtByJson(Fun.getJson(json, "P9"));
            for (int t = 0; t < dt_a00201.Rows.Count; t++)
            {
                dt_a00201.Rows[t]["BS_COLS"] = -1;//存放line_no
                string log_flag = dt_a00201.Rows[t]["LOG_FLAG"].ToString();
                if  (log_flag == "1")
                {
                    if_log =true;
                }
            }
        }

        StringBuilder a309_sql = new StringBuilder();
        string a309_id = "";
        int a309_line_no = 1;
         
        if (if_log == true && req_id == "SAVE")
        {
            dt_temp = Fun.getDtBySql("Select s_a309.nextval as c from dual ");
            a309_id = dt_temp.Rows[0][0].ToString();
            string menu_id_ = dt_a00201.Rows[0]["MENU_ID"].ToString();
            string sql_ = "Insert into A309(A309_ID,A309_NAME,KEY_ID,A002_ID,ENTER_DATE,ENTER_USER)";
            sql_ += "Select " + a309_id + ",'" + menu_id_ + "-" + main_col_v + "','" + main_col_v + "','" + menu_id_ + "',sysdate,'" + GlobeAtt.A007_KEY + "' from dual ";
            a309_sql.Append(sql_ + "<EXECSQL></EXECSQL>");
            
        }
        string MAINROWLIST = "";
        string a002_key = dt_a00201.Rows[0]["menu_id"].ToString();
        for (int i = 0; i < row.Count; i++)
        {
            string rowid = BaseFun.getAllHyperLinks(row[i].Value, "<ROWID>", "</ROWID>")[0].Value;
            string rowdata = data_index + BaseFun.getAllHyperLinks(row[i].Value, "<KEY>", "</KEY>")[0].Value;
            //rowdata = rowdata + "ROWNUM|" + (i + 1).ToString() + data_index + "ROWCOUNT|" + row.Count + data_index; 
           
         %>
            <%
            if (req_id == "SAVE")
            {
                MAINROWLIST = BaseFun.getAllHyperLinks(RequestXml, "<MAINROWLIST>", "</MAINROWLIST>")[0].Value;
                string action  = BaseFun.getAllHyperLinks(row[i].Value, "<ACTION>", "</ACTION>")[0].Value;
                string rowalldata = "";
                try
                {
                    if (action == "I")
                    {
                        rowalldata = rowdata;
                    }
                    else
                    {
                        rowalldata = data_index + BaseFun.getAllHyperLinks(row[i].Value, "<ROWALLKEY>", "</ROWALLKEY>")[0].Value;

                    }
                }
                catch
                {
                    rowalldata = rowdata;
                }
                string if_checkold = "1";
                string form_init = "";
                string table_id_ = "";
                string tbl_type = "";
                string objid = "";
                string objversion = "";
                //把数据转换为sql
                //检查当前的行是表还是视图
                for (int t = 0; t < dt_a00201.Rows.Count; t++)
                {
                    string a00201_key_ = dt_a00201.Rows[t]["A00201_KEY"].ToString();              
         
                    if (rowid.IndexOf(a00201_key_ +"_") != 0)
                    {
                        continue;
                    }
                    string pkg_name = dt_a00201.Rows[t]["PKG_NAME"].ToString();
                    if_checkold = dt_a00201.Rows[t]["IF_CHECKOLD"].ToString();
                    table_id_ = dt_a00201.Rows[t]["TABLE_ID"].ToString();
                    string log_flag = dt_a00201.Rows[t]["LOG_FLAG"].ToString();
                    tbl_type = dt_a00201.Rows[t]["TBL_TYPE"].ToString();

                   
                    //组织update 或insert 语句
                    objid = BaseFun.getStrByIndex(rowdata, data_index + "OBJID|", data_index);
                    //组织update 或insert 语句
                    objversion = BaseFun.getStrByIndex(rowdata, data_index + "OBJVERSION|", data_index);
                    
                    string if_main = dt_a00201.Rows[t]["IF_MAIN"].ToString();
                    if (if_main == "1")
                    {
                        mainobjid = objid;
                    }
                    //根据objid_ 获取当前数据的值
                    string get_data_sql = "select t.* from " + table_id_ + " t where 1=2";
                    if (action == "M" || action == "D")
                    {
                        if (tbl_type == "T")
                        {
                            get_data_sql = "select t.* from " + table_id_ + " t where t.rowid='" + objid + "' and " + main_col + "='" + main_col_v + "'";
                        }
                        else
                        {
                            get_data_sql = "select t.* from " + table_id_ + " t where t.objid='" + objid + "'and " + main_col + "='" + main_col_v + "'";
                        }
                        string show_condition = dt_a00201.Rows[t]["SHOW_CONDITION"].ToString();
                        if (show_condition == null)
                        {
                            show_condition = "";
                        }
                        if (show_condition.Length > 1)
                        {
                            show_condition = show_condition.Replace("[MAIN_KEY]", main_col_v);
                            if (show_condition.Trim().ToLower().IndexOf("and") != 0)
                            {
                                show_condition = " AND " + show_condition;
                            }
                            get_data_sql = get_data_sql + show_condition;
                        }

                    }

                    if (if_checkold == "1")
                    {
                        dt_data = Fun.getDtBySql(get_data_sql);
                        try
                        {
                            string old_objversion = dt_data.Rows[0]["objversion"].ToString();
                            if (old_objversion != objversion &&  !string.IsNullOrEmpty(old_objversion) &&  !string.IsNullOrEmpty(objversion))
                            {
                                Response.Write("doNext('00数据已经被修改，请刷新后再操作！');");
                                return;
                            }
                        }
                        catch(Exception ex)
                        {
                                
                        }
                                    
                    }

                    //表
                    if (tbl_type != "T" && log_flag == "0")
                    {
                        break;
                    }
                    StringBuilder exec_sql = new StringBuilder();
                    /*
                    string rowjson = Session["JSON_" + a00201_key_].ToString();
                    dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));
                    string parmrowdata__ = "DOACTION|" + action + data_index + "OBJID|" + objid + data_index;
                    StringBuilder insert_sql = new StringBuilder();
                    insert_sql.Append("INSERT INTO " + table_id_ + "(");
                    StringBuilder insert_sql_v = new StringBuilder();
                    insert_sql_v.Append(" SELECT ");
                    StringBuilder update_sql = new StringBuilder();
                    update_sql.Append("UPDATE " + table_id_ + " Set ");
                    StringBuilder delete_sql = new StringBuilder();
                    string line_no = "";
                    if (action == "I" && tbl_type == "T")
                    {
                        line_no = dt_a00201.Rows[t]["BS_COLS"].ToString();
                        if (a00201_key_ != a00201_key)
                        {
                            if (line_no == "-1")
                            {
                                string sql__ = "Select max(t.line_no) as line_no from " + table_id_  + " t where " + main_col + "='" + main_col_v + "'";
                                dt_temp = Fun.getDtBySql(sql__);
                                try
                                {
                                    line_no = dt_temp.Rows[0][0].ToString();
                                    if (line_no == null || line_no == "")
                                    {
                                        line_no = "0";
                                    }
                                }
                                catch
                                {
                                    line_no = "0";
                                }
                                dt_a00201.Rows[t]["BS_COLS"] = int.Parse(line_no);
                            }
                        }
                        line_no = (int.Parse(line_no) + 1).ToString();
                    }
                    
                    for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                    {
                        string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                        if (BS_LIST != "1")
                        {
                            continue;
                        }
                        string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                        string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                        if (column_id == main_col)
                        {
                            //主档
                            if (a00201_key_ == a00201_key)
                            {
                                if (rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                                {
                                    main_col_v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                }
                                else
                                {
                                    main_col_v = "-1";
                                }
                                //判断主档有没有输入单号
                                if (main_col_v == "-1" || main_col_v == "")
                                {
                                    //生成一个新单号

                                    dt_temp = Fun.getDtBySql("select pkg_a.getTableKey('" + a002_key + "') as c from dual ");

                                    main_col_v = dt_temp.Rows[0][0].ToString();
                                    if (main_col_v == "-1" || main_col_v == "")
                                    {
                                        main_col_v = "";
                                    }
                                }
                            }
                            
                            continue;
                        }
                        
        
                        string v = "";                       
                        if (rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                        {
                            v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                            parmrowdata__ += column_id + "|" + v + data_index;
                            string col_type = dt_a013010101.Rows[c]["COL_TYPE"].ToString();
                            string col_edit = dt_a013010101.Rows[c]["COL_EDIT"].ToString();
                            if (col_edit.ToLower() == "u_password")
                            {
                                v = Fun.ENCRYPT_STR(v, column_id);                            
                            }
                            if (col_type.ToLower().IndexOf("date") == 0)    
                            {
                                v = "to_date('" + v + "','YYYY-MM-DD HH24:MI:SS')";
                            }
                            else
                            {
                                v  = "'" + v.Replace("'", "''") + "'";
                            }
                            insert_sql.Append(column_id + ",");
                            insert_sql_v.Append(v + ",");
                            update_sql.Append(column_id + "=" + v);
                        }
                    }
                    */                   
                             
                              

                    if (action == "D")
                    {
                        if (tbl_type == "T")
                        {
                            sqllist.Append("delete from " + table_id_ + " t where t.rowid='" + objid + "'<EXECSQL></EXECSQL>");
                        }
                        if (log_flag == "1")
                        {
                            string rowdata__ = "";
                            string rowjson = Session["JSON_" + a00201_key_].ToString();
                            dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));
                            rowdata__ = "OBJID|" + BaseFun.getStrByIndex(rowdata, data_index + "OBJID|", data_index) + data_index;
                            for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                            {
                                string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                                string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                                string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                                if (BS_LIST != "1")
                                {
                                    continue;
                                }
                                if (rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                                {
                                    string v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                    rowdata__  +=column_id + "|" + v.Replace("'","''") + data_index;
                                }
                            }
                            string sql_ = "Insert into A30901(A309_ID,LINE_NO,SORT_BY,A00201_KEY,TABLE_ID,DODATA,ENTER_DATE,ENTER_USER,DOTYPE)";
                            sql_ += "Select " + a309_id + "," + a309_line_no.ToString() + "," + a309_line_no.ToString() + ",'" + a00201_key_ + "','" + table_id_ + "','" + rowdata__ + "',sysdate,'" + GlobeAtt.A007_KEY + "','" + action + "' from dual ";
                            a309_sql.Append(sql_ + "<EXECSQL></EXECSQL>");
                            a309_line_no = a309_line_no + 1;
                        }           
                        continue;
                    }
                    if (action == "M")
                    {
                        string rowjson = Session["JSON_" + a00201_key_].ToString();
                        string rowdata__ = "";
                        dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));
                        exec_sql.Append("UPDATE " + table_id_ + " t SET ");
                        if (log_flag == "1")
                        {
                        rowdata__ = "OBJID|" + BaseFun.getStrByIndex(rowdata, data_index + "OBJID|", data_index) + data_index;
                        }
                        for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                        {
                            string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                            
                            if (column_id == "MODI_DATE" || column_id == "MODI_USER")
                            {
                                continue;
                            }
                            string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                            if (BS_LIST != "1")
                            {
                                continue;
                            }
                            string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                            string col_necessary = dt_a013010101.Rows[c]["COL_NECESSARY"].ToString();
                            string col_visible = dt_a013010101.Rows[c]["COL_VISIBLE"].ToString();
                            string col_enable = dt_a013010101.Rows[c]["COL_ENABLE"].ToString();
                            string IFA309 = dt_a013010101.Rows[c]["IFA309"].ToString();
                            if (rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                            {
                                string v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);

                                string col_type = dt_a013010101.Rows[c]["COL_TYPE"].ToString();
                                string col_edit = dt_a013010101.Rows[c]["COL_EDIT"].ToString();
                                if (col_edit.ToLower() == "u_password")
                                {
                                    v = Fun.ENCRYPT_STR(v, column_id);
                                }
                                if (col_type.ToLower().IndexOf("date") == 0)
                                {
                                    exec_sql.Append("t." + column_id + "=to_date('" + v + "','YYYY-MM-DD HH24:MI:SS'),");
                                }
                                else
                                {
                                    exec_sql.Append("t." + column_id + "='" + v.Replace("'", "''") + "',");
                                }
                                if (log_flag == "1")
                                {
                                    rowdata__ += column_id + "|" + v.Replace("'", "''") + data_index;
                                }

                                if (col_visible == "1" && col_enable == "1" && col_necessary == "1")
                                {
                                    if (v == "")
                                    {
                                        string col_text = dt_a013010101.Rows[c]["COL_TEXT"].ToString();
                                        Response.Write("alert('" + col_text + "必须填写！');");
                                        Response.Write("setfocus('TXT_" + rowid + "_" + a10001_key + "');");
                                        return;
                                    }
                                }
                                
                            }

                        }
                        exec_sql.Append("t.MODI_DATE=sysdate,t.MODI_USER='" + GlobeAtt.A007_KEY + "' where t.rowid='" + objid + "'<EXECSQL></EXECSQL>");
                        if (tbl_type == "T")
                        {
                            sqllist.Append(exec_sql);
                        }
                        
                        //把修改行置换为修改以后的全部行
                        rowdata = data_index + BaseFun.getAllHyperLinks(row[i].Value, "<ROWALLKEY>", "</ROWALLKEY>")[0].Value;

                        if (log_flag == "1")
                        {
                            string sql_ = "Insert into A30901(A309_ID,LINE_NO,SORT_BY,A00201_KEY,TABLE_ID,DODATA,ENTER_DATE,ENTER_USER,DOTYPE)";
                            sql_ += "Select " + a309_id + "," + a309_line_no.ToString() + "," + a309_line_no.ToString() + ",'" + a00201_key_ + "','" + table_id_ + "','" + rowdata__ + "',sysdate,'" + GlobeAtt.A007_KEY + "','" + action + "' from dual ";
                            a309_sql.Append(sql_ + "<EXECSQL></EXECSQL>");
                            a309_line_no = a309_line_no + 1;
                        }
                        
                    }
                    if (action == "I")
                    {

                       // rowdata = data_index + BaseFun.getAllHyperLinks(row[i].Value, "<ROWALLKEY>", "</ROWALLKEY>")[0].Value;
                        string rowjson = Session["JSON_" + a00201_key_].ToString();
                        string line_no = dt_a00201.Rows[t]["BS_COLS"].ToString();
                        string rowdata__ = "";
                        //读取idit的值
                        form_init = Fun.getJson(rowjson, "P10");
                        
                        if (log_flag == "1")
                        {
                            rowdata__ = "OBJID|" + BaseFun.getStrByIndex(rowdata, data_index + "OBJID|", data_index) + data_index;
                        }
                   
                        if (a00201_key_ != a00201_key)
                        {
                            
                            if (line_no == "-1")
                            {
                                string sql__ = "Select max(t.line_no) as line_no from " + dt_a00201.Rows[t]["table_id"].ToString() + " t where " + main_col + "='" + main_col_v + "'";
                                dt_temp = Fun.getDtBySql(sql__);
                                try
                                {
                                    line_no = dt_temp.Rows[0][0].ToString();
                                    if (line_no == null || line_no == "")
                                    {
                                        line_no = "0"; 
                                    }
                                }
                                catch
                                {
                                    line_no = "0";                                        
                                }
                                dt_a00201.Rows[t]["BS_COLS"] = int.Parse(line_no);                            
                            }
                        }
                        line_no = (int.Parse(line_no) + 1).ToString();
                        dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));

                        exec_sql.Append("INSERT INTO " + table_id_ + "(");
                        StringBuilder vsql = new StringBuilder();
                        vsql.Append("Select ");
                        for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                        {
                            string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                            string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                            string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                            if (BS_LIST != "1")
                            {
                                continue;
                            }
                            if (column_id == main_col)
                            {
                                //主档
                                if (a00201_key_ == a00201_key)
                                {
                                    if (rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                                    {
                                        main_col_v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                    }
                                    else
                                    {
                                        main_col_v = "-1";
                                    }
                                    //判断主档有没有输入单号
                                    if (main_col_v == "-1" || main_col_v == "")
                                    { 
                                        //生成一个新单号

                                        dt_temp = Fun.getDtBySql("select pkg_a.getTableKey('" +  a002_key + "') as c from dual ");

                                        main_col_v = dt_temp.Rows[0][0].ToString();
                                        if (main_col_v == "-1" || main_col_v == "")
                                        {
                                            //Response.Write("alert('请输入关联号码！')");
                                            //return;
                                            main_col_v = "";
                                        }
                                    }                   
                                }
                                exec_sql.Append(column_id + ",");
                                vsql.Append("'" + main_col_v + "',");
                                if (log_flag == "1")
                                {
                                    rowdata__ += column_id + "|" + main_col_v + data_index;
                                }    
                                continue;
                            }
                             if (tbl_type == "T")
                             {
                                if (column_id == "LINE_NO" || column_id == "SORT_BY")
                                {
                                    exec_sql.Append(column_id + ",");
                                    vsql.Append( line_no + ",");
                                    if (log_flag == "1")
                                    {
                                        rowdata__ += column_id + "|" + line_no.ToString() + data_index;
                                    }                           
                                    continue;
                                }          
                            }                  
                            if (column_id == "ENTER_DATE" || column_id == "ENTER_USER")
                            {
                                continue;
                            }
                            string v = "";
                            if (rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                            {
                                v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                string col_type = dt_a013010101.Rows[c]["COL_TYPE"].ToString();
                                exec_sql.Append(column_id + ",");
                                string col_edit = dt_a013010101.Rows[c]["COL_EDIT"].ToString();
                                if (col_edit.ToLower() == "u_password")
                                {
                                    v = Fun.ENCRYPT_STR(v, column_id);
                                }
                                if (col_type.ToLower().IndexOf("date") == 0)
                                {

                                    vsql.Append("to_date('" + v + "','YYYY-MM-DD HH24:MI:SS'),");
                                }
                                else
                                {
                                    vsql.Append("'" + v.Replace("'","''") + "',");
                                }

                            }
                            else
                            {  //获取默认值

                                string col_init = dt_a013010101.Rows[c]["COL_INIT"].ToString();
                                if (col_init != null && col_init != "")
                                {
                                    string col_init_sql;
                                    col_init_sql = col_init.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                                    col_init_sql = col_init_sql.Replace("[user_id]", GlobeAtt.A007_KEY);
                                    col_init_sql = col_init_sql.Replace("[MENU_ID]", GlobeAtt.A002_KEY);
                                    col_init_sql = col_init_sql.Replace("[user_name]", GlobeAtt.A007_NAME);
                                    col_init_sql = col_init_sql.Replace("[USER_NAME]", GlobeAtt.A007_NAME);
                                    col_init_sql = col_init_sql.Replace("GETDATE()", "sysdate");
                                    if (col_init_sql.IndexOf("FUN_") == 0)
                                    {
                                         col_init_sql = col_init_sql.Substring(4);
                                         exec_sql.Append(column_id + ",");
                                         vsql.Append(col_init_sql + ",");                                       
                                         col_init_sql = "Select " + col_init_sql + "  as c from dual ";    
                                         dt_temp = Fun.getDtBySql(col_init_sql);
                                         col_init_sql = dt_temp.Rows[0][0].ToString(); 
                                         v = col_init_sql;
                                    }
                                    else
                                    {
                                        if (col_init_sql == "sysdate")
                                        {
                                            exec_sql.Append(column_id + ",");
                                            vsql.Append(col_init_sql + ",");
                                            v = "sysdate";
                                        }
                                        else
                                        {
                                            exec_sql.Append(column_id + ",");
                                            string col_edit = dt_a013010101.Rows[c]["COL_EDIT"].ToString();
                                            if (col_edit == "u_password")
                                            {
                                                col_init_sql = Fun.ENCRYPT_STR(col_init_sql, column_id);
                                            }
                                            vsql.Append("'" + col_init_sql + "',");
                                            v = col_init_sql;
                                        }
                                    }

                                }
                            }
                            if (log_flag == "1")
                            {
                                rowdata__ += column_id + "|" + v.Replace("'", "''") + data_index;
                            }
                            string col_necessary = dt_a013010101.Rows[c]["COL_NECESSARY"].ToString();
                            string col_visible = dt_a013010101.Rows[c]["COL_VISIBLE"].ToString();
                            string col_enable = dt_a013010101.Rows[c]["COL_ENABLE"].ToString();
                            if (col_visible == "1" && col_enable == "1" && col_necessary == "1")
                            {
                                if (v == "")
                                {
                                    string col_text = dt_a013010101.Rows[c]["COL_TEXT"].ToString();
                                    Response.Write("alert('" + col_text + "必须填写！');");
                                    Response.Write("setfocus('TXT_" + rowid + "_" + a10001_key + "');");
                                    return;
                                }
                            }
                            
                            
                            
                          
                        }
                        if (tbl_type == "T")
                        {
                            exec_sql.Append("ENTER_DATE,ENTER_USER) ");
                            vsql.Append("Sysdate,'" + GlobeAtt.A007_KEY + "' from dual ");
                            sqllist.Append(exec_sql);
                            sqllist.Append(vsql);
                            sqllist.Append("<EXECSQL></EXECSQL>");
                       
                             dt_a00201.Rows[t]["BS_COLS"] = int.Parse(line_no) ;
                        }
                        if (log_flag == "1")
                        {
                            string sql_ = "Insert into A30901(A309_ID,LINE_NO,SORT_BY,A00201_KEY,TABLE_ID,DODATA,ENTER_DATE,ENTER_USER,DOTYPE)";
                            sql_ += "Select " + a309_id + "," + a309_line_no.ToString() + "," + a309_line_no.ToString() + ",'" + a00201_key_ + "','" + table_id_ + "','" + rowdata__ + "',sysdate,'" + GlobeAtt.A007_KEY + "','"+ action+"' from dual "; 
                            a309_sql.Append(sql_ + "<EXECSQL></EXECSQL>");
                            a309_line_no = a309_line_no + 1;
                        }                      
                    }
                }

                for (int r = 0; r < dt_c.Rows.Count; r++)
                {
                    string this_key = dt_c.Rows[r]["A00201_KEY"].ToString();
                    string rb_sql = dt_c.Rows[r]["RB_SQL"].ToString();
                    rb_sql = rb_sql.Replace("[MAIN_KEY]", main_col_v);
                    if (rowid.IndexOf(this_key) == 0)
                    {
                        string rowdata__ = rowdata;
                        rb_sql = rb_sql.Replace("[ROWLIST]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[rowList]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[rowlist]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[RowList]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[Rowlist]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                        rb_sql = rb_sql.Replace("[A311_KEY]", "{A311_KEY}");
                        string rowjson = Session["JSON_" + this_key].ToString();
                        dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));
                        for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                        {
                            string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                            string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                            string v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                            string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                            if (BS_LIST != "1")
                            {
                                continue;
                            }
                            if (column_id == main_col)
                            {
                                if (rowdata__.IndexOf(data_index + a10001_key + "|") < 0)
                                {
                                    rowdata__ = rowdata__ + data_index + a10001_key + "|" + main_col_v;
                                }
                                if (rowdata__.IndexOf(data_index + a10001_key + "|") < 0)
                                {
                                    rowdata__ = rowdata__ + data_index + a10001_key + "|" + main_col_v;
                                }
                                else
                                {
                                         v = main_col_v;
                                }
                            }
                            
                            rowdata__ = rowdata__.Replace(data_index + a10001_key + "|", data_index + column_id + "|");
                            rb_sql = rb_sql.Replace("[" + column_id + "]", v);
                        }
                        rb_sql = rb_sql.Replace("{rowlist}", rowdata__);
                        rb_sql = rb_sql.Replace("{A311_KEY}", "[A311_KEY]");
                    }

                }
           
                for (int r = 0; r < dt_u.Rows.Count; r++)
                {
                    
                    string this_key = dt_u.Rows[r]["A00201_KEY"].ToString();
                    string rb_sql = dt_u.Rows[r]["RB_SQL"].ToString();
                    rb_sql = rb_sql.Replace("[MAIN_KEY]", main_col_v);
                    if (rowid.IndexOf(this_key + "_") == 0)
                    {
                        string rowdata__ = "";
                        rowdata__ = "DOACTION|" + action + data_index + "OBJID|" + objid + data_index;
                        //rowdata__ = rowdata__ + "OBJVERSION|" + objversion;
                        //8002要传入 ROWTYPE
                        //if (this_key.IndexOf("8002") == 0)
                       // {
                            if (i + 1 == row.Count)
                            {
                                rowdata__ = rowdata__ + "ROWTYPE|1" + data_index;
                            }
                            else
                            {
                                if (i == 0)
                                {
                                    rowdata__ = rowdata__ + "ROWTYPE|0" + data_index;
                                }
                            }
                       // }
                        rb_sql = rb_sql.Replace("[ROWLIST]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[rowList]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[rowlist]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[RowList]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[Rowlist]", "{rowlist}");
                        rb_sql = rb_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                        rb_sql = rb_sql.Replace("[A311_KEY]", "{A311_KEY}");
                        string rowjson = Session["JSON_" + this_key].ToString();
                        dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));
                        
                        for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                        {
                            string v_old = "";
                            string line_no = dt_a013010101.Rows[c]["LINE_NO"].ToString();
                            string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                            string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                            string v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                            string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                            //动态列
                            string col01 = dt_a013010101.Rows[c]["col01"].ToString();
                            if (BS_LIST != "1")
                            {
                                continue;
                            }
                            if (action == "I")
                            {
                                string col_necessary = dt_a013010101.Rows[c]["COL_NECESSARY"].ToString();
                                string col_visible = dt_a013010101.Rows[c]["COL_VISIBLE"].ToString();
                                string col_enable = dt_a013010101.Rows[c]["COL_ENABLE"].ToString();
                                if (col_visible == "1" && col_enable == "1" && col_necessary == "1")
                                {
                                    if (v == "")
                                    {
                                        string col_text = dt_a013010101.Rows[c]["COL_TEXT"].ToString();
                                        Response.Write("alert('" + col_text + "必须填写！');");
                                        Response.Write("setfocus('TXT_" + rowid + "_" + a10001_key + "');");
                                        return;
                                    }
                                }
                            
                            }
                            if (action == "M" )
                            {
                                //读取数据和当前的数据是否一直
                               
                                if (if_checkold == "1")
                                {
                                    v_old = dt_data.Rows[0][column_id].ToString();
                                }
                                else
                                {
                                    v_old = "";
                                }
                                if (col01 == "1")
                                {
                                    string select_sql_ = dt_a013010101.Rows[c]["SELECT_SQL"].ToString();
                                    select_sql_ = select_sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                                    select_sql_ = select_sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                                    select_sql_ = select_sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                                    select_sql_ = select_sql_.Replace("[MAIN_KEY]", main_col_v );
                                    dt_temp = Fun.getDtBySql(select_sql_);
                                    for (int j = 0; j < dt_temp.Rows.Count; j++)
                                    {
                                        string a10001_key_ = (int.Parse(line_no) * 1000 + j).ToString();
                                        v =  BaseFun.getStrByIndex(rowdata, data_index + a10001_key_ + "|", data_index);
                                        if (rowdata.IndexOf(data_index + a10001_key_ + "|") > 0)
                                        {
                                            rowdata__ += column_id + "-" + dt_temp.Rows[j][0].ToString() + "|" + v + data_index;
                                        }
                                    }
                                }
                                
                                
                                string col_edit = dt_a013010101.Rows[c]["col_edit"].ToString();
                                if (rowdata.IndexOf(data_index + a10001_key + "|") > 0)
                                {
                                    if ((col_edit == "datelist" || col_edit == "datetimelist") && v_old.Length > 10 && v != "")
                                    {
                                        DateTime dt = DateTime.Parse(v_old);
                                        DateTime dt_v = DateTime.Parse(v);
                                        v_old = string.Format("{0:u}", dt);//2005-11-05 14:23:23Z
                                        v = string.Format("{0:u}", dt_v);
                                        if (col_edit == "datelist")
                                        {
                                            v_old = v_old.Substring(0, 10);

                                            if (v.Length >= 10)
                                            {

                                                v = v.Substring(0, 10);
                                            }
                                        }
                                        else
                                        {
                                            v_old = v_old.Substring(0, 19);
                                            if (v.Length >= 19)
                                            {
                                                v = v.Substring(0, 19);
                                            }
                                        }
                                        // col_value = col_value.Substring(0, 10);

                                    }
                                    if (col_edit == "u_number" || col_edit == "u_thousands")
                                    {
                                        if (col_edit == "u_thousands")
                                        { 
                                            v = v.Replace(",","");
                                        }
                                        if (v_old == "" || v_old == null)
                                        {

                                            if (v != "" && v != null)
                                            {
                                                rowdata__ += column_id + "|" + v + data_index;
                                            }

                                        }
                                        else
                                        {
                                            if (v != "" && v != null)
                                            {
                                                if (v_old.Length > 0)
                                                {
                                                    int user_dec = int.Parse(GlobeAtt.GetValue("USER_DEC"));
                                                    v_old = Math.Round(double.Parse(v_old), user_dec).ToString();
                                                    if (double.Parse(v_old) != double.Parse(v))
                                                    {
                                                        rowdata__ += column_id + "|" + v + data_index;
                                                    }
                                                }
                                                else
                                                {
                                                     rowdata__ += column_id + "|" + v + data_index;
                                                }

                                            }
                                            else
                                            {
                                                rowdata__ += column_id + "|" + v + data_index;
                                            
                                            }
                                        }    
                                      
                                    }
                                    else
                                    {
                                        if (v_old != v)
                                        {
                                            rowdata__ += column_id + "|" + v + data_index;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                if (column_id == main_col)
                                {
                                    if (main_col_v == "" && rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                                    {
                                        main_col_v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                    }
                                    rowdata__ += column_id + "|" + main_col_v + data_index;
                                }
                                else
                                {
                                    //动态列
                                    if (col01 == "1")
                                    {
                                        string select_sql_ = dt_a013010101.Rows[c]["SELECT_SQL"].ToString();
                                        select_sql_ = select_sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                                        select_sql_ = select_sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                                        select_sql_ = select_sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                                        select_sql_ = select_sql_.Replace("[MAIN_KEY]", main_col_v);
                                        dt_temp = Fun.getDtBySql(select_sql_);
                                        for (int j = 0; j < dt_temp.Rows.Count; j++)
                                        {
                                            string a10001_key_ = (int.Parse(line_no) * 1000 + j).ToString();
                                            v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key_ + "|", data_index);
                                            if (rowdata.IndexOf(data_index + a10001_key_ + "|") > 0)
                                            {
                                                rowdata__ += column_id + "-" + dt_temp.Rows[j][0].ToString() + "|" + v + data_index;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        rowdata__ += column_id + "|" + v + data_index;
                                    }
                                }
                            }
                       //     rowdata__ = rowdata__.Replace(data_index + a10001_key + "|", data_index + column_id + "|");
                            string check_exist = dt_a013010101.Rows[c]["CHECK_EXIST"].ToString();
                            string CALC_FLAG = dt_a013010101.Rows[c]["CALC_FLAG"].ToString();
                            if (CALC_FLAG != "1")
                            {
                                CALC_FLAG = "0";
                            }
                            if (check_exist == "1" && v.Length > 0 && v_old != v && v.Length > 0 && (action == "M" || action == "I") && CALC_FLAG == "0" )
                            {
                                //
                               
                                string BS_SELECT_SQL = dt_a013010101.Rows[c]["BS_SELECT_SQL"].ToString();
                                if (BS_SELECT_SQL.Length > 10)
                                {
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[", "<PARM>");
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("]", "</PARM>");
                                    MatchCollection col = BaseFun.getAllHyperLinks(BS_SELECT_SQL, "<PARM>", "</PARM>");
                                    for (int kk = 0; kk < col.Count; kk++)
                                    {
                                        string COLID_ = col[kk].Value;
                                        string vv = "";
                                        if (COLID_.IndexOf("MAIN_") == 0)
                                        {
                                            v = BaseFun.getStrByIndex(MAINROWLIST, data_index + COLID_.Replace("MAIN_", "") + "|", data_index);
                                        }
                                        else
                                        {
                                            v = BaseFun.getStrByIndex(rowalldata, data_index + COLID_ + "|", data_index);
                                        }
                                        string sql = BS_SELECT_SQL.Replace("<PARM>" + COLID_ + "</PARM>", v);
                                        BS_SELECT_SQL = sql;
                                    }
                                    dt_temp = Fun.getDtBySql(BS_SELECT_SQL);
                                    if (dt_temp.Rows.Count <= 0)
                                    {
                                        string bs_msg = dt_a013010101.Rows[c]["BS_MSG"].ToString();
                                        string vvv = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                        bs_msg = bs_msg.Replace("[" + a10001_key + "]", vvv);
                                        bs_msg = bs_msg.Replace("'", "\\'");
                                        bs_msg = bs_msg.Replace("\r", "");
                                        bs_msg = bs_msg.Replace("\n", "");
                                        Response.Write("alert('" + bs_msg + "');");
                                        Response.Write("SetItem('" + rowid + "_" + a10001_key + "','');");
                                        Response.Write("setfocus('TXT_" + rowid + "_" + a10001_key + "');");
                                        return;
                                    }


                                }
                            }

                            rb_sql = rb_sql.Replace("[" + column_id + "]", v);
                        }
                        /*
                        if (action == "I")
                        {
                            //把在form_init 中的数据加入到字符串中
                            rowjson = Session["JSON_" + this_key].ToString();
                            //读取idit的值
                            form_init = Fun.getJson(rowjson, "P10");
                            int pos_ = form_init.IndexOf(data_index);
                           
                            while (pos_ >= 0)
                            {
                                string v = form_init.Substring(0 , pos_ );
                                int pos1_ = v.IndexOf("|");
                                string column_id = v.Substring(0, pos1_ );
                                Boolean lb_exist = false;
                                for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                                {

                                    string column_id_ = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                                    if (column_id_ == column_id)
                                    {
                                        lb_exist = true;                                        
                                        break;
                                    }
                                }
                                string col_v = v.Substring(pos1_ + 1 );
                                if (lb_exist == false)
                                {
                                    rowdata__ += column_id + "|" + data_index;
                                }
                                form_init = form_init.Substring(pos_ + 1 );
                                pos_ = form_init.IndexOf(data_index);
                            }
                            
                            
                        }
                        */
                        
                        rb_sql = rb_sql.Replace("{rowlist}", rowdata__.Replace("'","''"));
                        rb_sql = rb_sql.Replace("{A311_KEY}", "[A311_KEY]");
                        aftersqllist.Append(rb_sql + "<EXECSQL></EXECSQL>");
                    }

                }

                continue;
            }
            %>
            <%
            if (req_id.IndexOf("A014") == 0)
            {
                //执行A014的动作
                for (int k = 0; k < dt_rb.Rows.Count; k++)
                {
                    string a014_id = "A014" + dt_rb.Rows[k]["A014_ID"].ToString();
                    if (req_id == a014_id)
                    {
                       // req_id = dt_rb.Rows[k]["A014_ID"].ToString();
                        string objid = BaseFun.getStrByIndex(data_index + rowdata, data_index + "OBJID|", data_index);
                        string A014_SQL__ = dt_rb.Rows[k]["A014_SQL"].ToString();
                        string if_first = dt_rb.Rows[k]["IF_FIRST"].ToString();
                        mainobjid = objid;
                        //组织sql语句
                        //流程处理
                        string rowdata__ = rowdata;
                        rowdata__ = data_index + "OBJID|" + objid + data_index;

                        if (i + 1 == row.Count)
                        {
                            rowdata__ = rowdata__ + "ROWTYPE|1" + data_index;
                        }
                        else
                        {
                            if (i == 0)
                            {
                                rowdata__ = rowdata__ + "ROWTYPE|0" + data_index;
                            }
                        }
                        for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                        {
                            string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                            string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                            string PRIMARY_KEY = dt_a013010101.Rows[c]["PRIMARY_KEY"].ToString();
                            string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                            string v ="";
                            if (BS_LIST != "1")
                            {
                                continue;
                            }
                            if (PRIMARY_KEY == "1")
                            {
                                v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                main_key += v;
                            }
                            if (rowdata.IndexOf(data_index + a10001_key + "|") > 0)
                            {
                                v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                rowdata__ += column_id + "|" + v.Replace("'", "''") + data_index;
                            }
                            string check_exist = dt_a013010101.Rows[c]["CHECK_EXIST"].ToString();
                            if (if_first == "7")
                            {
                               
                                string IFQUERYEDIT = dt_a013010101.Rows[c]["IFQUERYEDIT"].ToString();
                                if (IFQUERYEDIT == "1" )
                                {
                                    string COL_NECESSARY = dt_a013010101.Rows[c]["COL_NECESSARY"].ToString();
                                    if ( COL_NECESSARY == "1" && v.Length <= 0)
                                    {
                                        string col_text = dt_a013010101.Rows[c]["col_text"].ToString();
                                        Response.Write("alert('" + col_text + "的数据必须填写！');");
                                        Response.Write("setfocus('TXT_" + rowid + "_" + a10001_key + "');");
                                        return;
                                    }
                                }
                                
                            }
                            
                            if (check_exist == "1" && v.Length > 0 && if_first == "7" )
                            {
                               
                                string BS_SELECT_SQL = dt_a013010101.Rows[c]["BS_SELECT_SQL"].ToString();
                                if (BS_SELECT_SQL.Length > 10 && OPTION =="Q")
                                {
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("[", "<PARM>");
                                    BS_SELECT_SQL = BS_SELECT_SQL.Replace("]", "</PARM>");
                                    MatchCollection col = BaseFun.getAllHyperLinks(BS_SELECT_SQL, "<PARM>", "</PARM>");
                                    for (int kk = 0; kk < col.Count; kk++)
                                    {
                                        string COLID_ = col[kk].Value;
                                        string vv = "";
                                        if (COLID_.IndexOf("MAIN_") == 0)
                                        {
                                            v = BaseFun.getStrByIndex(MAINROWLIST, data_index + COLID_.Replace("MAIN_", "") + "|", data_index);
                                        }
                                        else
                                        {
                                            v = BaseFun.getStrByIndex(rowdata, data_index + COLID_ + "|", data_index);
                                        }
                                        string sql = BS_SELECT_SQL.Replace("<PARM>" + COLID_ + "</PARM>", v);
                                        BS_SELECT_SQL = sql;
                                    }
                                    dt_temp = Fun.getDtBySql(BS_SELECT_SQL);
                                    if (dt_temp.Rows.Count <= 0)
                                    {
                                        string bs_msg = dt_a013010101.Rows[c]["BS_MSG"].ToString();
                                        string vvv = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                        bs_msg = bs_msg.Replace("[" + a10001_key + "]", vvv);
                                        bs_msg = bs_msg.Replace("'", "\\'");
                                        Response.Write("alert('" + bs_msg + "');");
                                        Response.Write("SetItem('" + rowid + "_" + a10001_key + "','');");
                                        Response.Write("setfocus('TXT_" + rowid + "_" + a10001_key + "');");
                                        return;
                                    }


                                }
                            }

                        }
                        /*Select '0' as id,'流程处理' as name from dual
                         union select '1' ,'起始流程'  from dual 
                         union select '2' ,'数据处理' from dual 
                         union select '3','单据操作' from dual
                         UNION SELECT '4','弹出子窗口' from dual 
                         union Select '5','弹出备注' from dual union
                         select '6','打开新窗口'  from dual union
                         select '7','查询右键'  from dual */
                        if (A014_SQL__ == null || A014_SQL__ == "")
                        {
                            if (if_first == "0" || if_first == "1" || if_first == "2" || if_first == "3" || if_first == "7")
                            {
                                Response.Write("rbclose();");
                                Response.Write("alert('没有任何处理！');");
                                return;
                            }
                        
                        }
                        
                        if (if_first == "0")
                        {
                            sqllist.Append("begin pkg_a.doa014('" + dt_rb.Rows[k]["A014_ID"].ToString() + "','" + dt_a00201.Rows[0]["TABLE_ID"].ToString() + "','" + objid + "','" + GlobeAtt.A007_KEY + "',[A311_KEY]);end;<EXECSQL></EXECSQL>");
                        }
                        //起始流程
                        if (if_first == "1")
                        {
                            sqllist.Append("begin pkg_a.doa014('" + dt_rb.Rows[k]["A014_ID"].ToString() + "','" + dt_a00201.Rows[0]["TABLE_ID"].ToString() + "','" + objid + "','" + GlobeAtt.A007_KEY + "',[A311_KEY]);end;<EXECSQL></EXECSQL>");
                        }
                        //数据处理
                        if (if_first == "2")
                        {
                            sqllist.Append("begin pkg_a.doa014('" + dt_rb.Rows[k]["A014_ID"].ToString() + "','" + dt_a00201.Rows[0]["TABLE_ID"].ToString() + "','" + objid + "','" + GlobeAtt.A007_KEY + "',[A311_KEY]);end;<EXECSQL></EXECSQL>");
                        }
                        //单据操作
                        if (if_first == "3")
                        {
                            sqllist.Append("begin pkg_a.doa014('" + dt_rb.Rows[k]["A014_ID"].ToString() + "','" + dt_a00201.Rows[0]["TABLE_ID"].ToString() + "','" + objid + "','" + GlobeAtt.A007_KEY + "',[A311_KEY]);end;<EXECSQL></EXECSQL>");
                        }
                        //弹出子窗口
                        if (if_first == "4")
                        {
                            //获取子窗口的的属性
                            string objid_ = objid;
                                string child_url = dt_rb.Rows[k]["A014_SQL"].ToString();
                                dt_temp = Fun.getDtBySql(child_url.Replace("[ROWID]", objid_));
                                child_url = dt_temp.Rows[0][0].ToString();
                                string width_ = dt_temp.Rows[0][1].ToString();
                                string height_ = dt_temp.Rows[0][2].ToString();
                                if (child_url.ToLower().IndexOf("mainform.aspx?") == 0)
                                {
                                    child_url = GlobeAtt.HTTP_URL + "/ShowForm/" + child_url;
                                }
                                Response.Write("rbclose();");
                                string a014_name = dt_rb.Rows[k]["A014_NAME"].ToString();
                                Response.Write("showtaburl('" + child_url + "','" + a014_name + "')");                            
                            
                        }
                        
                        
                        
                        //弹出备注
                        if (if_first == "5")
                        {
                           
                            int max_width = 0;
                            int max_height = 170; 
                            StringBuilder html_ = new StringBuilder();  
                             html_.Append("<table class=\"ShowTable\">");
                            string  child_url = dt_rb.Rows[k]["NEXT_DO"].ToString();
                            child_url = child_url.Replace("[USER_ID]",GlobeAtt.A007_KEY);
                            string exec_sql = dt_rb.Rows[k]["A014_SQL"].ToString();
                            string objid_ = objid;
                            dt_data = Fun.getDtBySql(child_url.Replace("[ROWID]", objid_));                            
                            
                            for (int c = 0; c < dt_data.Rows.Count; c++)
                            {
                                string id = dt_data.Rows[c]["id"].ToString();
                                string name = dt_data.Rows[c]["name"].ToString();
                                string width = dt_data.Rows[c]["width"].ToString();
                                string height = dt_data.Rows[c]["height"].ToString();
                                if (int.Parse(width)> max_width)
                                {
                                    max_width = int.Parse(width) ;
                                }
                                max_height += int.Parse(height);
                                string data = dt_data.Rows[c]["des"].ToString();
                                html_.Append("<tr class=\"h\"><td>");
                                html_.Append(name);
                                html_.Append("</td></tr>");
                                html_.Append("<tr class=\"d\"><td>");
                               
                                if (dt_data.Columns.Count > 5)
                                {
                                    
                                    //编辑类型 只能是 text , rb, ddd 
                                    string edit_type = dt_data.Rows[c]["edit_type"].ToString().ToLower();
                                    if (edit_type == "rb" || edit_type == "ddd")
                                    {
                                        string edit_sql = dt_data.Rows[c]["edit_sql"].ToString();
                                        dt_temp = Fun.getDtBySql(edit_sql);
                                        html_.Append("<input type=\"hidden\" id=\"T_" + id + "\" name=\"" + dt_rb.Rows[k]["A014_ID"].ToString() + "\"  value=\"" + data + "\">");
                                        if (edit_type == "rb")
                                        {
                                            html_.Append("<div style=\"text-align:left; width:" + width + "px; height:" + height + "px;\">");
                                            for (int cc = 0; cc < dt_temp.Rows.Count; cc++)
                                            {
                                                string v = dt_temp.Rows[cc][0].ToString();
                                                string n = dt_temp.Rows[cc][1].ToString();
                                                if (v == data)
                                                {
                                                    html_.Append("<input  id=\"rb_" + id + i.ToString() + "\" checked  type=\"radio\"  name=\"rb_" + dt_rb.Rows[k]["A014_ID"].ToString() + "_" + id + "\"  onclick=\"javascript:document.getElementById(\\\'T_" + id + "\\\').value=\\\'" + v + "\\\';\">" + n);
                                                }
                                                else
                                                {
                                                    html_.Append("<input  id=\"rb_" + id + i.ToString() + "\"   type=\"radio\"  name=\"rb_" + dt_rb.Rows[k]["A014_ID"].ToString() + "_" + id + "\"  onclick=\"javascript:document.getElementById(\\\'T_" + id + "\\\').value=\\\'" + v + "\\\';\">" + n);
                                                }
                                                html_.Append(Environment.NewLine);
                                            }
                                            html_.Append("</div>");
                                        }
                                        else
                                        {
                                            ////
                                            // obj_txt.value = obj_.options[obj_.selectedIndex].value;
                                            //obj_txt =  document.getElementById("TXT_" + id_ ) ;

                                            html_.Append("<select  onchange=\"javascript:document.getElementById(\\\'T_" + id + "\\\').value= this.options[options.selectedIndex].value;\">");
                                            for (int cc = 0; cc < dt_temp.Rows.Count; cc++)
                                            {
                                                string v = dt_temp.Rows[cc][0].ToString();
                                                string n = dt_temp.Rows[cc][1].ToString();
                                                if (v  == data)
                                                {
                                                    html_.Append("<option  selected  value=\"" + v + "\">");
                                                }
                                                else
                                                {
                                                    html_.Append("<option   value=\"" + v + "\">");
                                                }
                                                html_.Append(n);
                                                html_.Append(" </option> ");
                                                html_.Append(Environment.NewLine);
                                            }
                                            html_.Append("</select>");
                                        }
                                    }
                                    else
                                    {
                                        data = data.Replace("'", "\\\'");
                                        html_.Append("<textarea id=\"T_" + id + "\" name=\"" + dt_rb.Rows[k]["A014_ID"].ToString() + "\"  style=\"text-align:left; width:" + width + "px; height:" + height + "px;\" >" + data + "</textarea>");
                          
                                    }
                                  
                                      
                                    
                                }
                                else
                                {
                                    data = data.Replace("'", "\\\'");
                                    html_.Append("<textarea id=\"T_" + id + "\" name=\"" + dt_rb.Rows[k]["A014_ID"].ToString() + "\"  style=\"text-align:left; width:" + width + "px; height:" + height + "px;\" >" + data + "</textarea>");
                                   
                                }
                                html_.Append("</td></tr>");
                             }
                             html_.Append("<tr class=\"trbtn\"><td><div  class=\"d_bottom\">");
                             html_.Append("<input class=\"btn\" type=button value=\"确定\" id=\"btn_doDes\" onclick=\"doDes(\\\'" + dt_rb.Rows[k]["A014_ID"].ToString() + "\\\',\\\'" + rowid + "\\\',\\\'" + objid_ + "\\\',\\\'" + a00201_key + "\\\')\"/>");
                             html_.Append("<input class=\"btn\" type=button value=\"取消\" id=\"btn_doDes_c\"  onclick=\"rbclose()\"/>");
                             html_.Append("</td></tr>");          
                             html_.Append("</table>");
                             Response.Write("rbclose();");
                             string a014_name = dt_rb.Rows[k]["A014_NAME"].ToString();
                             html_ = html_.Replace("\r", "");
                             html_ = html_.Replace("\n", "");
                             if (dt_data.Columns.Count > 5)
                             {
                                 max_height += 30;
                             }
                             Response.Write("alertWin('" + a014_name + "','" + html_.ToString() + "','0','0','" + (max_width + 15).ToString() + "','" + max_height.ToString()+ "',true);");
                          

                        }
                        //弹出子窗口
                        if (if_first == "6")
                        {
                            //获取子窗口的的属性
                            string objid_ = objid;
                            string child_url = dt_rb.Rows[k]["NEXT_DO"].ToString();
                            dt_temp = Fun.getDtBySql(child_url.Replace("[ROWID]", objid_));
                            child_url = dt_temp.Rows[0][0].ToString();
                            string menu_id_ = dt_temp.Rows[0][1].ToString();
                            string con_ = dt_temp.Rows[0][2].ToString();
                            if (child_url.ToLower().IndexOf("mainform.aspx?") == 0)
                            {
                                child_url = GlobeAtt.HTTP_URL + "/ShowForm/" + child_url;
                            }
                            Response.Write("rbclose();");
                            string a014_name = dt_rb.Rows[k]["A014_NAME"].ToString();
                            Response.Write("showtabwindow('" + child_url + "','" + menu_id_ + "','" + con_ + "')");
                        }
                        //多行处理的右键
                        if (if_first == "7")
                        {
                            Response.Write("rbclose();");
                           // Response.Write("alert('测试多行编辑');");
                            sqllist.Append("begin pkg_a.doa014('" + dt_rb.Rows[k]["A014_ID"].ToString() + "','" + dt_a00201.Rows[0]["TABLE_ID"].ToString() + "','" +rowdata__ + "','" + GlobeAtt.A007_KEY + "',[A311_KEY]);end;<EXECSQL></EXECSQL>");
 
                            
                        }
  
                        
                        //选择数据
                        if (if_first == "8" )
                        {
                             int max_width = 650;
                            int max_height = 500;
                            max_width = 600;
                            max_height = 350;
                            string a014_name = dt_rb.Rows[k]["A014_NAME"].ToString();
                            string child_url = dt_rb.Rows[k]["NEXT_DO"].ToString();
                            dt_data = Fun.getDtBySql(child_url.Replace("[ROWID]", objid));
                            string ls_data = Fun.DataTable2Json(dt_data);
                            string parm = "SQL|" + child_url.Replace("[ROWID]", objid).Replace("'", "\\\'")+data_index;
                            parm += "A014_ID|" + dt_rb.Rows[k]["A014_ID"].ToString() + data_index;
                            StringBuilder html_ = new StringBuilder();
                            html_.Append("<table style=\"width:100%;table-layout:fixed;\">");
                            html_.Append("<tr ><td style=\"height:30\"><div  class=\"d_bottom\">");
                            html_.Append("请输入条件：<input  type=text value=\"\" id=\"rbshowtxt\"/>");
                            html_.Append("<input class=\"btn blue\" type=button value=\"查询\" onclick=\"rbshowdata('rbshowtxt','divrbshow','" + parm + "')\"/>");
                            html_.Append("<input class=\"btn blue\" type=button value=\"确定\" onclick=\"doDes('" + dt_rb.Rows[k]["A014_ID"].ToString() + "','" + rowid + "','" + objid + "','" + a00201_key + "')\"/>");
                            html_.Append("<input class=\"btn blue\" type=button value=\"取消\" onclick=\"rbclose()\"/>");
                            html_.Append("</td></tr><tr><td><div id=\"divrbshow\" style=\"overflow:auto;height:" + (max_height - 65).ToString() + "px\">");
                            html_.Append("<table class=\"a0\">");
                            for (int c = 0; c < dt_data.Rows.Count; c++)
                            {
                                html_.Append("<tr>");                               
                                StringBuilder trhtml_ = new StringBuilder();
                                string rowlist = "";
                                for (int cc = 0; cc < dt_data.Columns.Count; cc++)
                                {
                                   string col_v = dt_data.Rows[c][cc].ToString();
                                   trhtml_.Append("<td>" + col_v + "</td>");
                                   if (col_v.IndexOf("<input") == 0 || col_v.IndexOf("<select") == 0)
                                   {
                                       col_v = "";
                                   }                                    
                                   rowlist += dt_data.Columns[cc].ColumnName + "|" + col_v + data_index;
                                    
                                 
                                }

                                html_.Append("<td><input  type=\"radio\" id=\"T_" + dt_rb.Rows[k]["A014_ID"].ToString() + "_"+ c.ToString()+"\" name=\"" + dt_rb.Rows[k]["A014_ID"].ToString() + "\" value=\"" + rowlist.Replace("\"", "\\\"") + "\" /></td>");
                                html_.Append(trhtml_);
                                html_.Append("</tr>");
                            }
  
                            html_.Append("</table></div>");

                            html_.Append("</td></tr></table>");
                            html_ = html_.Replace("\r", " ");
                            html_ = html_.Replace("\n", " ");

                            string h = HttpUtility.UrlEncode(html_.ToString()).Replace("+","%20");
                                
                            Response.Write("alertWin(\"" + a014_name + "\",\"" + h + "\",\"10px\",\"0\",\"" + max_width.ToString() + "\",\"" + max_height.ToString() + "\",true);");

                        }
                        //SOCKET 监听
                        if (if_first == "9")
                        {
                            string a014_name = dt_rb.Rows[k]["A014_NAME"].ToString();
                            string socket_Sql = dt_rb.Rows[k]["NEXT_DO"].ToString();
                            string a014_id_= dt_rb.Rows[k]["a014_id"].ToString();
                            socket_Sql = socket_Sql.Replace("[ROWID]", objid);
                            socket_Sql = socket_Sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                            dt_data = Fun.getDtBySql(socket_Sql);
                            string serverip = dt_data.Rows[0]["serverip"].ToString();
                            string MessageName = dt_data.Rows[0]["MessageName"].ToString();
                            string key  = dt_data.Rows[0]["Key"].ToString();
                            //处理包
                            string exec_sql = "pkg_socket.request_xml('" + MessageName + "','" + key + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";
                            string log_key= "";
                            string e_sql = Fun.execSql(exec_sql, GlobeAtt.A007_KEY, a00201_key, "A014_ID=" + a014_id_, "", "" , "", ref  log_key);
                            if (e_sql != "0")
                            {
                                Response.Write("rbclose();doNext('" + e_sql.Replace("\n", ";").Replace("'", "\"") + "');");
                                return;
                            }
                            else
                            {
                               //获取处理生成的XML
                                dt_temp = Fun.getDtBySql("Select t.TABLE_OBJID from A311 t where t.a311_key=" + log_key);
                                
                                e_sql = "Select t.line_no , t.Sendxml from A31902 t where t.rowid='" + dt_temp.Rows[0][0].ToString() + "'";
                                dt_temp = Fun.getDtBySql(e_sql);
                                string sendxml = dt_temp.Rows[0][1].ToString();
                                string a31902_line_no = dt_temp.Rows[0][0].ToString();
                                //把数据发送给后台
                                Boolean if_success = false;
                                string receive_xml = Fun.get_scoket_xml(serverip, sendxml, ref if_success);
                                if (if_success == false)
                                {
                                    Response.Write("rbclose();doNext('00" + receive_xml.Replace("\n", ";").Replace("'", "\"") + "');");
                                }
                                else
                                {
                                    try
                                    {
                                        e_sql = "update A31902 set SERVERIP='"+ serverip+"', modi_date = Systimestamp,modi_user='" + GlobeAtt.A007_KEY + "', RECEIVEXML='" + receive_xml.Replace("'", "''") + "' where line_no=" + a31902_line_no;
                                        int li_e_sql = Fun.execSqlOnly(e_sql);
                                        if (li_e_sql != 1)
                                        {
                                            Response.Write("rbclose();doNext('00处理报文失败');");
                                            return;

                                        }
                                        //处理结果
                                        exec_sql = "pkg_socket.Response_Xml('" + a31902_line_no + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";
                                      //  li_e_sql =    string lsexec = Fun.execSqlList(sqllist.ToString(), GlobeAtt.A007_KEY, a00201_key, mainobjid, "A014_ID=" + req_id, main_table,main_col_v, ref log_key);
                                        e_sql = Fun.execSql(exec_sql, GlobeAtt.A007_KEY, a00201_key, "A014_ID=" + a014_id_, "A31902", "", a31902_line_no.ToString());
                                        //if (li_e_sql != 1)
                                        //{
                                        //    Response.Write("rbclose();doNext('00处理报文失败');");
                                        //    return;

                                        //}
                                        if (e_sql != "0")
                                        {
                                            Response.Write("rbclose();doNext('" + e_sql.Replace("\n", ";").Replace("'", "\"") + "');");
                                            return;
                                        }
                                        else
                                        {
                                            //刷新
                                            Response.Write("rbclose();doNext('01操作成功！');");
                                            return;
                                        }
                                        
                                    }
                                    catch (Exception ex)
                                    {

                                        Response.Write("rbclose();doNext('00" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
                                        return;
                                    }
                                    //提示操作成功
                                    Response.Write("rbclose();doNext('01" + BaseMsg.getMsg("M0018") + "');");
                                }
                                
                            }
                            
                        }
                        if (if_first == "A")
                        {
                            selectobjlistlist = selectobjlistlist + objid+",";
                            if (i == row.Count - 1)
                            {
                                int max_width = 650;
                                int max_height = 500;
                                max_width = 600;
                                max_height = 350;
                                string a014_name = dt_rb.Rows[k]["A014_NAME"].ToString();
                                string child_url = dt_rb.Rows[k]["NEXT_DO"].ToString();
                                dt_data = Fun.getDtBySql(child_url.Replace("[ROWID]", selectobjlistlist));
                                string ls_data = Fun.DataTable2Json(dt_data);
                                string parm = "SQL|" + child_url.Replace("[ROWID]", objid).Replace("'", "\\\'") + data_index;
                                parm += "A014_ID|" + dt_rb.Rows[k]["A014_ID"].ToString() + data_index;
                                StringBuilder html_ = new StringBuilder();
                                html_.Append("<table style=\"width:100%;table-layout:fixed;\">");
                                html_.Append("<tr ><td style=\"height:30\"><div  class=\"d_bottom\">");
                                html_.Append("请输入条件：<input  type=text value=\"\" id=\"rbshowtxt\"/>");
                                html_.Append("<input class=\"btn\" type=button value=\"查询\" onclick=\"rbshowdata('rbshowtxt','divrbshow','" + parm + "')\"/>");
                                html_.Append("<input class=\"btn\" type=button value=\"确定\" onclick=\"doDes('" + dt_rb.Rows[k]["A014_ID"].ToString() + "','" + rowid + "','" + selectobjlistlist + "','" + a00201_key + "')\"/>");
                                html_.Append("<input class=\"btn\" type=button value=\"取消\" onclick=\"rbclose()\"/>");
                                html_.Append("</td></tr><tr><td><div id=\"divrbshow\" style=\"overflow:auto;height:" + (max_height - 65).ToString() + "px\">");
                                html_.Append("<table class=\"a0\">");
                                for (int c = 0; c < dt_data.Rows.Count; c++)
                                {
                                    html_.Append("<tr>");
                                    StringBuilder trhtml_ = new StringBuilder();
                                    string rowlist = "";
                                    for (int cc = 0; cc < dt_data.Columns.Count; cc++)
                                    {
                                        string col_v = dt_data.Rows[c][cc].ToString();
                                        trhtml_.Append("<td>" + col_v + "</td>");
                                        if (col_v.IndexOf("<input") == 0 || col_v.IndexOf("<select") == 0)
                                        {
                                            col_v = "";
                                        }
                                        rowlist += dt_data.Columns[cc].ColumnName + "|" + col_v + data_index;


                                    }

                                    html_.Append("<td><input  type=\"radio\" id=\"T_" + dt_rb.Rows[k]["A014_ID"].ToString() + "_" + c.ToString() + "\" name=\"" + dt_rb.Rows[k]["A014_ID"].ToString() + "\" value=\"" + rowlist.Replace("\"", "\\\"") + "\" /></td>");
                                    html_.Append(trhtml_);
                                    html_.Append("</tr>");
                                }

                                html_.Append("</table></div>");

                                html_.Append("</td></tr></table>");
                                html_ = html_.Replace("\r", " ");
                                html_ = html_.Replace("\n", " ");

                                string h = HttpUtility.UrlEncode(html_.ToString()).Replace("+", "%20");

                                Response.Write("alertWin(\"" + a014_name + "\",\"" + h + "\",\"10px\",\"0\",\"" + max_width.ToString() + "\",\"" + max_height.ToString() + "\",true);");
                            }
                        }
                        //处理组合
                        if (if_first == "B")
                        { 
                            // 
                            dt_temp = Fun.getDtBySql("SELECT T.* FROM A01405 t where  t.a014_id='" + dt_rb.Rows[k]["A014_ID"].ToString()  +"' order by t.sort_by,t.line_no");
                            string A311_key_ = "";
                            string e_sql = Fun.execSql("<A014>A014_ID=" + dt_rb.Rows[k]["A014_ID"].ToString() + "</A014>", GlobeAtt.A007_KEY, a00201_key, "A014_ID=" + dt_rb.Rows[k]["A014_ID"].ToString(), dt_rb.Rows[k]["TABLE_ID"].ToString(), objid, main_col_v, ref A311_key_);
                            if (e_sql != "0")
                            {
                                Response.Write("rbclose();doNext('" + e_sql.Replace("\n", ";").Replace("'", "\"") + "');");
                                return;
                            }
                            for (int kkk=0; kkk< dt_temp.Rows.Count;kkk++)
                            {
                                string exec_type = dt_temp.Rows[kkk]["exec_type"].ToString();                                
                                string exec_sql =   dt_temp.Rows[kkk]["exec_sql"].ToString(); 
                                string exec_parm = dt_temp.Rows[kkk]["exec_parm"].ToString();
                                string send_data = exec_parm;
                                string receive_data = "";
                                int li_exec = 0;
                                string EXEC_NEXTSQL = dt_temp.Rows[kkk]["EXEC_NEXTSQL"].ToString();
                                //执行存储过程
                                if (exec_type == "EXEC")
                                { 
                                    //开始处理
                                    exec_sql = exec_sql + "('" + objid + "','" + GlobeAtt.A007_KEY + "'," + A311_key_ +")";
                                    send_data = exec_sql;
                                    receive_data = "-";
                                    //记录
                                    li_exec = Fun.execSqlOnly(exec_sql);
                                    if (li_exec < 0)
                                    {
                                        Response.Write("rbclose();doNext('" + exec_sql.Replace("\n", ";").Replace("'", "\"") + "');");
                                        return;
                                    }
                                }
                                if (exec_type == "WEB_SERVICES")
                                {
                                    try
                                    {
                                        string url = exec_sql + "?wsdl";//wsdl地址
                                        string name = dt_temp.Rows[kkk]["COL02"].ToString(); ;//javaWebService开放的接口  
                                        TPSVService.WebServiceProxy wsd = new TPSVService.WebServiceProxy(url, name);
                                        exec_parm = exec_parm.Replace("[ROWID]", objid);
                                        exec_parm = exec_parm.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                                        exec_parm = exec_parm.Replace("[A311_KEY]", A311_key_);
                                        exec_parm = exec_parm.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                                        dt_temp0 = Fun.getDtBySql(exec_parm);
                                        int ccount = dt_temp0.Columns.Count;
                                       
                                        send_data = "";
                                        receive_data = "";
                                        for (int r_ = 0; r_ < dt_temp0.Rows.Count; r_++)
                                        {
                                            string[] str = new string[ccount];
                                            send_data = send_data + r_.ToString() + "|" ;
                                            for (int j_ = 0; j_ < ccount; j_++)
                                            {
                                                str[j_] = dt_temp0.Rows[r_][j_].ToString();
                                                send_data = send_data + str[j_] + Environment.NewLine;
                                            }


                                            send_data = send_data + GlobeAtt.DATA_INDEX;
                                            try
                                            {
                                                object suc = wsd.ExecuteQuery(name, str);
                                                try
                                                {

                                                    receive_data = receive_data +  r_.ToString() + "|" + suc.ToString() + GlobeAtt.DATA_INDEX;
                                                }
                                                catch
                                                {
                                                    receive_data = receive_data +  r_.ToString() + "|ERROR:格式转换错误" + suc.ToString() + GlobeAtt.DATA_INDEX;
                                                }
                                            }
                                            catch
                                            {

                                                receive_data = receive_data + "-1|ERROR:格式转换错误" + GlobeAtt.DATA_INDEX;
                                            }
                                        }
                                    }
                                    catch
                                    {
                                        receive_data = "ERROR:WEB_SERVICES出错";
                                    }                     
                                
                                }
                                if (exec_type == "SOCKET" || exec_type == "HTTP_GET" || exec_type == "HTTP_POST")
                                {
                                    exec_parm = exec_parm.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                                    exec_parm = exec_parm.Replace("[ROWID]", objid);
                                    exec_parm = exec_parm.Replace("[USER_ID]",GlobeAtt.A007_KEY);
                                    exec_parm = exec_parm.Replace("[A311_KEY]", A311_key_);
                                    exec_parm = exec_parm.Replace("[A30001_KEY]",GlobeAtt.A30001_KEY);
                                    exec_sql = exec_sql.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                                    if (exec_parm.ToUpper().Trim().IndexOf("SELECT ") == 0)
                                    {
                                        dt_temp0 = Fun.getDtBySql(exec_parm);
                                        send_data = dt_temp0.Rows[0][0].ToString();
                                                                       
                                    }
                                     Boolean if_success = false;
                                     if (exec_type == "SOCKET")
                                     {
                                         receive_data = Fun.get_scoket_xml(exec_sql, send_data, ref if_success);
                                         if (if_success == false)
                                         {
                                             Response.Write("rbclose();doNext('00" + receive_data.Replace("\n", ";").Replace("'", "\"") + "');");
                                             return;
                                         }
                                     }
                                     if (exec_type == "HTTP_GET" || exec_type == "HTTP_POST")
                                     {
                                         Bm.HttpRequest http = new Bm.HttpRequest();
                                         http.TimeOut = 1000 * 120;//2分钟
                                         string CharacterSet = dt_temp.Rows[kkk]["COL01"].ToString();
                                         if (CharacterSet != null && CharacterSet.Trim() != "")
                                         {
                                             http.CharacterSet = dt_temp.Rows[kkk]["COL01"].ToString();
                                         }
                                         if (exec_type == "HTTP_GET")
                                         {
                                             string execurl = exec_sql + "?" + send_data;
                                             send_data = execurl;
                                             if_success =  http.OpenRequest(execurl, execurl);
                                         }
                                         else
                                         {
                                             if_success = http.OpenRequest(exec_sql, exec_sql, send_data);                                         
                                         }
                                         
                                         receive_data = http.HtmlDocument;
                                         if (if_success == false)
                                         {
                                             Response.Write("rbclose();doNext('00" + exec_sql + "请求失败！');");
                                             return;
                                         }

                                     }
                                }
                                     string line_no_   = dt_temp.Rows[kkk]["LINE_NO"].ToString();
                                     string ls_in = Fun.save_a31101(
                                     A311_key_,
                                     int.Parse(line_no_),
                                     int.Parse(dt_temp.Rows[kkk]["SORT_BY"].ToString()),
                                     GlobeAtt.A007_KEY,
                                     send_data, 
                                     receive_data,
                                     dt_rb.Rows[k]["TABLE_ID"].ToString(),
                                     objid, 
                                     dt_rb.Rows[k]["A014_ID"].ToString());
                            
                                     //执行完成以后 执行 nextsql  
                                     EXEC_NEXTSQL = EXEC_NEXTSQL + "('" + objid + "','" + GlobeAtt.A007_KEY + "'," + A311_key_ +","+ line_no_ +")";
                                     li_exec=  Fun.execSqlOnly(EXEC_NEXTSQL);
                                     if (li_exec < 0 )
                                     {
                                         Response.Write("rbclose();doNext('" + ls_in.Replace("\n", ";").Replace("'", "\"") + "');");
                                         return;
                                     }
                                     if (ls_in != "0")
                                     {
                                         Response.Write("rbclose();doNext('" + ls_in.Replace("\n", ";").Replace("'", "\"") + "');");
                                         return;

                                     }
                                
                                     dt_temp0 = Fun.getDtBySql("Select t.state,t.DESCRIPTION from A31101 t where  t.a311_key=" + A311_key_ + " AND line_no=" + line_no_);
                                     if (dt_temp0.Rows.Count == 0)
                                     {
                                         Response.Write("rbclose();doNext('00获取A31101出错！');");
                                         return;
                                     }
                                     if (dt_temp0.Rows[0][0].ToString() != "1")
                                     {
                                         
                                         Response.Write("rbclose();");
                                         if (dt_temp0.Rows[0][1].ToString().Length > 3)
                                         {
                                             Response.Write("doNext('" + dt_temp0.Rows[0][1].ToString() + "');");
                                         }
                                         else
                                         {
                                             Response.Write("doNext('" + dt_temp.Rows[kkk]["exec_name"].ToString() + "执行失败！');");
                                         }
                                         return;
                                     }
                                
                                
                                
                               // EXEC_NEXTSQL
                                
                            }

                            dt_temp = Fun.getDtBySql("Select t.state,t.res from A311 t where t.A311_KEY=" + A311_key_);
                           
                            string ls_state = dt_temp.Rows[0]["state"].ToString();
                           
                            //处理返回结果
                            if (ls_state == "0")
                            {
                              Response.Write("doNext('01" + BaseMsg.getMsg("M0018") + "');");
                            }
                            else
                            {
                                
                              Response.Write("doNext('" +  dt_temp.Rows[0]["RES"].ToString() + "');");
                            }
                            return;
                        }
                        
                        break;
                    }
                }

                //读取当前A014的属性





            }
            %><%
            //打印
            if (req_id.IndexOf("MainPrint") == 0)
            {
                //文件名称
                string line_no = req_id.Replace("MainPrint", "");
                for (int k = 0; k < dt_print.Rows.Count; k++)
                {

                    if (dt_print.Rows[k]["LINE_NO"].ToString() == line_no)
                    {

                        string begin_proc = dt_print.Rows[k]["BEGIN_PROC"].ToString();
                        string objid = BaseFun.getStrByIndex(rowdata, data_index + "OBJID|", data_index);
                        if (begin_proc.Length > 4)
                        {
                           
                            string  rowdata__ = "OBJID|" + BaseFun.getStrByIndex(rowdata, data_index + "OBJID|", data_index) + data_index;
                            for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                            {
                                string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                                string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                                string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                                if (BS_LIST != "1")
                                {
                                    continue;
                                }
                                if (rowdata.IndexOf(data_index + a10001_key + "|") >= 0)
                                {
                                    string v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);
                                    rowdata__  +=column_id + "|" + v.Replace("'","''") + data_index;
                                }
                            }
                            begin_proc = begin_proc + "('" + rowdata__ + "','" + GlobeAtt.A007_KEY + "',[A311_KEY])";
                            try
                            {
                                string lsexec=  Fun.execSql(begin_proc, GlobeAtt.A007_KEY, a002_key,"MainPrint");
                                if (lsexec != "0")
                                {
                                    Response.Write("doNext('" + lsexec.Replace("\n",";").Replace("'","\"")+ "');");
                                    return;
                                }
                            }
                            catch (Exception ex)
                            {
                                Response.Write("doNext('00" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
                                return;
                            }
                        }
                        
                        
                        
                 
                        string parmlist = dt_print.Rows[k]["PARM_LIST"].ToString();
                        parmlist = parmlist.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                        parmlist = parmlist.Replace("[MENU_ID]", GlobeAtt.A002_KEY);
                        parmlist = parmlist.Replace("[ROWID]", objid);
                        parmlist = parmlist.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                        parmlist = parmlist.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                        /*把对应的数据写入列中*/
                        for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                        {
                            string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                            string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                            string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                            if (BS_LIST != "1")
                            {
                                continue;
                            }
                            if (parmlist.IndexOf("[" + column_id + "]") >= 0)
                            {
                                string v = BaseFun.getStrByIndex(rowdata, data_index + a10001_key + "|", data_index);

                                parmlist = parmlist.Replace("[" + column_id + "]", v.Replace(",", GlobeAtt.RPT_TEMP_INDEX));
                            }
                            if (parmlist.IndexOf("[") < 0 )
                            {
                                break;
                            }
                        }
                        string dw_id = dt_print.Rows[k]["DW_ID"].ToString();
                        string url = GlobeAtt.HTTP_URL + "/report/CRShow.aspx?showreport=1&code=" + DateTime.Now.ToString("yyyyMMddHHmmssfff");
                        if (dw_id.ToUpper().IndexOf(".RPT") > 0)
                        {
                            // 
                            Session["REPORT_FILE"] = dw_id;
                            //文件SQL
                            Session["REPORT_SQL"] = "";
                            //文件参数
                            Session["REPORT_PARM"] = parmlist;
                            string strdata = "MENU_ID|" + dt_print.Rows[k]["MENU_ID"].ToString() + data_index;
                              strdata = "LINE_NO|" + dt_print.Rows[k]["LINE_NO"].ToString() + data_index;                            
                              strdata = strdata+    "REPORT_FILE|" + dw_id + data_index + "REPORT_SQL|" + data_index + "REPORT_PARM|" + parmlist;
                            int pos_ = strdata.Length % 8;
                            if (pos_ > 0)
                            {
                                for (int kk = 0; kk < 8 - pos_; kk++)
                                {
                                    strdata = strdata + " ";
                                }
                            }
  
                           
                            url = url + "&PARM=" + DES.DESEncrypt(strdata,DES.Key);
                            

                        }
                        else
                        {
                            try
                            {
                                ExcelFunc ef = new ExcelFunc();
                                string ls_file = "";
                                string li_exec = ef.ExportBill(parmlist, dw_id, ref ls_file);
                         
                                if (li_exec != "1")
                                {
                                    Response.Write("alert('导出xls失败！');");
                                    return;
                                }
                                string sql_ = " pkg_log.save_export('" + GlobeAtt.A007_KEY + "','" + a00201_key + "','" + ls_file + "','" + GlobeAtt.A30001_KEY + "','" + dw_id + "')";
                                Fun.execSqlOnly(sql_);
                                url = GlobeAtt.HTTP_URL + "/temp/" + ls_file;
                            }
                            catch(Exception ex)
                            {
                                Response.Write("rbclose();doNext('00" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
                                return;
                            }
                            
                            
                        }   
                        Response.Write("openwin('" + url + "','_blank');");
                        break;
                    }
                }


            }
              %>
              <%
            if (req_id == "CopyRow")
            {
                /*把当前行的数据记录到Session中*/
                Session["COPY_" + a00201_key] = rowdata;
                Response.Write("rbclose();");
            }
            if (req_id == "CopyBill")
            {
                /*把当前行的数据记录到Session中*/
                Session["COPYBill_" + a00201_key] = Session["COPYBill_" + a00201_key].ToString() +row[i].Value ;
                if (i  + 1 == row.Count)
                {
                    Response.Write("rbclose();");
                }
      
 
            }
            if (req_id == "PasteBill")
            {
                /*把当前行的数据记录到Session中*/
                string rowalldata  = Session["COPYBill_" + a00201_key].ToString();


                MatchCollection rowidlist = BaseFun.getAllHyperLinks(rowalldata, "<ROWID>", "</ROWID>");  //BaseFun.getAllHyperLinks(row[i].Value, "<ROWID>", "</ROWID>")[0].Value;
                MatchCollection rowdatalist = BaseFun.getAllHyperLinks(rowalldata, "<KEY>", "</KEY>");  //data_index + BaseFun.getAllHyperLinks(row[i].Value, "<KEY>", "</KEY>")[0].Value;
                
                for (int t = 0; t < rowidlist.Count; t++)
                {

                    string copydata = data_index + rowdatalist[t].Value;
                    string rowid__ = rowidlist[t].Value.Split('_')[0];
                    Response.Write("ifexist__ = checkidexist('btn_addrow_" + rowid__ + "');if(ifexist__== true ){");
                    Response.Write("addrowid = AddRow('" + rowid__ + "');");
                    string rowjson = Session["JSON_" + rowid__].ToString();
                    dt_a013010101 = Fun.getdtByJson(Fun.getJson(rowjson, "P1"));
                    for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                    {
                        string ifcopy = dt_a013010101.Rows[c]["IFCOPY"].ToString();
                        string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                        string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                        string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                        if (BS_LIST != "1")
                        {
                            continue;
                        }
                        if (ifcopy == "1" && column_id != dt_a00201.Rows[0]["MAIN_KEY"].ToString() && column_id != dt_a00201.Rows[0]["TABLE_KEY"].ToString())
                        {
                            string v = BaseFun.getStrByIndex(copydata, data_index + a10001_key + "|", data_index);
                            string exec_xml = "SetItem(addrowid + '_" + a10001_key + "','" + v.Replace("'", "\\'").Replace(Environment.NewLine,"") + "');";
                            Response.Write(exec_xml);
                        }
                        
                    }
                    Response.Write("}");
                }
                Response.Write("rbclose();");
            } 
            
            
             %>
             <%
            if (req_id == "PasteRow")
            {// 把session的值写入到列中
                try
                {

                    string copydata = data_index + Session["COPY_" + a00201_key].ToString();

                    /*把对应的数据写入列中*/
                    for (int c = 0; c < dt_a013010101.Rows.Count; c++)
                    {
                        string ifcopy = dt_a013010101.Rows[c]["IFCOPY"].ToString();
                        string a10001_key = dt_a013010101.Rows[c]["A10001_KEY"].ToString();
                        string column_id = dt_a013010101.Rows[c]["COLUMN_ID"].ToString();
                        string BS_LIST = dt_a013010101.Rows[c]["BS_LIST"].ToString();
                        if (BS_LIST != "1")
                        {
                            continue;
                        }
                        if (ifcopy == "1" && column_id != dt_a00201.Rows[0]["MAIN_KEY"].ToString() && column_id != dt_a00201.Rows[0]["TABLE_KEY"].ToString())
                        {
                            string v = BaseFun.getStrByIndex(copydata, data_index + a10001_key + "|", data_index);
                            string exec_xml = "SetItem('" + rowid + "_" + a10001_key + "','" + v.Replace("'", "\\'").Replace(Environment.NewLine, "") + "');";
                            Response.Write(exec_xml);
                        }

                    }
                    Response.Write("rbclose();");


                }
                catch
                {
                    break;

                }
                //
            }
            %>
            <%

        }
        sqllist.Append(aftersqllist);
        sqllist.Append(a309_sql);
        if (req_id.IndexOf("A014") == 0)
        {
            req_id = req_id.Substring(4);
        }
        if (sqllist.Length > 10)
        {
            try
            {
                string log_key = "";
                string reftree ="0";      
                string lsexec = Fun.execSqlList(sqllist.ToString(), GlobeAtt.A007_KEY, a00201_key, mainobjid, "A014_ID=" + req_id, main_table,main_col_v,SELECTEDROWLIST, ref log_key);
                if (log_key != "")  
                {
                    dt_temp = Fun.getDtBySql("Select t.TABLE_OBJID,t.col06 from A311 t where t.a311_key=" + log_key);
                    if (dt_temp.Rows.Count > 0)
                    {
                        reftree = dt_temp.Rows[0][1].ToString();
                    }
                    if (reftree == null && reftree == "")
                    {
                        reftree = "0";
                    }
                }
                if (OPTION == "I" && (lsexec == "0" || lsexec.IndexOf(BaseMsg.getMsg("M0008")) >= 0) )
                {
                    //新增跳转
                    if (main_col_v == "" && log_key != "" )
                    { //获取当前的id
                        
                        string sql = "Select " + main_col + " from " + main_table + " t where t.objid='" + dt_temp.Rows[0][0].ToString() +"'";
                        if (main_table_type == "T")
                        {
                            sql = "Select " + main_col + " from " + main_table + " t where t.rowid='" + dt_temp.Rows[0][0].ToString() + "'";
                        }
                        dt_temp = Fun.getDtBySql(sql);
                        main_col_v = dt_temp.Rows[0][0].ToString();
                                        
                            
                        sql = "update A311 set MAIN_KEY='" + main_col_v + "' where a311_key=" + log_key;
                        Fun.execSqlOnly(sql);
                    }
                    
                    req_url = req_url.Replace("&key=0&option=I", "&key=" + main_col_v + "&option=M");
                    req_url = req_url.Replace("&key=&option=I", "&key=" + main_col_v + "&option=M");
                    if (reftree == "1")
                    {
                        Response.Write("reload_tree();");
                    }
                    
                    Response.Write("doNext('02" + req_url + "');");
                    
                    return;
                }
                if (reftree == "1")
                {
                    Response.Write("reload_tree();");
                }
                //"&QUERY=1"
                if (lsexec != "0")
                {
                    Response.Write("doNext('" + lsexec.Replace("\n",";").Replace("'","\"")+ "');");
                }
                else
                {
                       
                     Response.Write("doNext('01" + BaseMsg.getMsg("M0018") + "');");
                }

            }
            catch (Exception ex)
            {
                Response.Write("doNext('00" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
            }

        }
    }
    catch ( Exception ex )
    {
        Response.Write("doNext('00" + ex.Message.Replace("\n", ";").Replace("'", "\"") + "');");
    }
%>
 