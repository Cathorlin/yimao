<%@ Page Language="C#" AutoEventWireup="true" CodeFile="myreq.aspx.cs" Inherits="HandEquip_BaseForm_myreq" %>

<%
    string data_index = GlobeAtt.DATA_INDEX;
    string sql = "";
    
    StringBuilder strhtml = new StringBuilder();
    
    //执行添加行
    if (reqtype == "HEQ_SAVE")
    {
        string EXESQL = BaseFun.getAllHyperLinks(RequestXml, "<EXESQL>", "</EXESQL>")[0].Value;
        string main_key = BaseFun.getAllHyperLinks(RequestXml, "<MAIN_KEY>", "</MAIN_KEY>")[0].Value;
        string main_key_value = BaseFun.getAllHyperLinks(RequestXml, "<MAIN_KEY_VALUE>", "</MAIN_KEY_VALUE>")[0].Value;        
        string SELECTDROWLIST = BaseFun.getAllHyperLinks(RequestXml, "<SELECTDROWLIST>", "</SELECTDROWLIST>")[0].Value;

        
        string exesql_ = "";
        string rowid = "";
        string table_id = "";

        
        //string[] EXESQL_list=new Array();
        ArrayList EXESQL_list = new ArrayList();
        string EXESQL_ = EXESQL;
        int index = EXESQL_.IndexOf("<EXECSQL></EXECSQL>");
        int EXESQL_index = 0;
        while (index>=0)
        {
            EXESQL_list.Add(EXESQL_.Substring(0, index - 1));
            EXESQL_index = EXESQL_index + 1;
            EXESQL_ = EXESQL_.Substring(index +19 );
            index = EXESQL_.IndexOf("<EXECSQL></EXECSQL>");
        }
            //EXESQL.Replace("","$").Split('$');
        string rb_do = "";
        string rb_sql = "";
        for (int i = 0; i < EXESQL_list.Count; i++)
        {
            exesql_ = EXESQL_list[i].ToString();                      
            rowid = Get_Item_Value("ROWID", exesql_);
            string[] rowid_split = rowid.Split('_');
            //替换行column_id
            for (int j = 0; j < dt_a00201.Rows.Count; j++)
            {
                if (rowid_split[1].ToString()==dt_a00201.Rows[j]["LINE_NO"].ToString())
                {
                    table_id = dt_a00201.Rows[j]["TABLE_ID"].ToString();
                    exesql_ = Replace_Rowlist(dt_a00201.Rows[j]["TABLE_ID"].ToString(), exesql_);
                    break;
                }
                
            }
            //组存储过程            
            if (rowid_split[1].ToString() == "0")
            {
                rb_do = "dw_main";
            }
            else
            {
                rb_do = "dw_" + rowid_split[1].ToString();
            }

            for (int j = 0; j < dt_a00210.Rows.Count; j++)
            {
                if (dt_a00210.Rows[j]["RB_DO"].ToString() == rb_do)
                {
                    rb_sql = dt_a00210.Rows[j]["RB_SQL"].ToString();
                    rb_sql = rb_sql.ToUpper();
                    rb_sql = rb_sql.Replace("[ROWLIST]",exesql_);
                    rb_sql = rb_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                    rb_sql = rb_sql + "<EXECSQL></EXECSQL>";
                    sql = sql + rb_sql;
                    break;
                }
            }
        }
        if (sql.Length>0)
        {
            string log_key="";                     
            sql = Fun.execSqlList(sql, GlobeAtt.A007_KEY, menu_id, main_key_value, "HEQ_SAVE=" + main_key_value, table_id, main_key, SELECTDROWLIST, ref log_key);
            if (sql!="0")
            {
                Response.Write("heq_doNext('" + sql.Replace("\n", ";").Replace("'", "\"") + "');");
            }
            if (sql.Substring(0, 2) != "00")
            {
                Response.Write("clearObjlist();");
            }
        }
    }
    else if (reqtype == "HEQ_NEW")
    {
       // string main_key = BaseFun.getAllHyperLinks(RequestXml, "<MAIN_KEY>", "</MAIN_KEY>")[0].Value;
        string main_key_value = BaseFun.getAllHyperLinks(RequestXml, "<MAIN_KEY_VALUE>", "</MAIN_KEY_VALUE>")[0].Value;

        string Form_Init = dt_a00201.Rows[0]["Form_Init"].ToString();
        if (Form_Init!="")
        {
            sql = Fun.getProcData(Form_Init, dt_a00201.Rows[0]["TABLE_ID"].ToString());
            if (sql != "0")
            {
                Response.Write("heq_doNext('" + sql.Replace("\n", ";").Replace("'", "\"") + "');");
            }
        }
        
    }
   
 %>