<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DetailQuery.aspx.cs" Inherits="BaseForm_DetailQuery" %>

<%
     string COLID = BaseFun.getAllHyperLinks(RequestXml, "<COLID>", "</COLID>")[0].Value;
     string MAINROWLIST = BaseFun.getAllHyperLinks(RequestXml, "<MAINROWLIST>", "</MAINROWLIST>")[0].Value;
     string ROWLIST = BaseFun.getAllHyperLinks(RequestXml, "<ROWLIST>", "</ROWLIST>")[0].Value;
     string ROWID = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
     string data_index = GlobeAtt.DATA_INDEX;
     StringBuilder str_html = new StringBuilder();
     StringBuilder str_conhtml = new StringBuilder();
     StringBuilder send_conhtml = new StringBuilder();
     for (int i = 0; i < dt_a013010101.Rows.Count; i++)
     {
         string a10001_key = dt_a013010101.Rows[i]["A10001_KEY"].ToString();
         if (COLID != a10001_key)
         {
             continue;
         }
         //格式化SQL
         string BS_CHOOSE_SQL = dt_a013010101.Rows[i]["BS_CHOOSE_SQL"].ToString();
         BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[USER_ID]", GlobeAtt.A007_KEY);
         BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
         BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
         BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("[", "<PARM>");
         BS_CHOOSE_SQL = BS_CHOOSE_SQL.Replace("]", "</PARM>");
         MatchCollection col = BaseFun.getAllHyperLinks(BS_CHOOSE_SQL, "<PARM>", "</PARM>");
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
             string sql = BS_CHOOSE_SQL.Replace("<PARM>" + COLID_ + "</PARM>", v);
             BS_CHOOSE_SQL = sql;
         }
         BS_CHOOSE_SQL = BS_CHOOSE_SQL + " and rownum  <  " + GlobeAtt.GetValue("RESULTROWS");

         string CHOOSE_SORT = dt_a013010101.Rows[i]["CHOOSE_SORT"].ToString();
         if (CHOOSE_SORT.Length > 5)
         {
             BS_CHOOSE_SQL = BS_CHOOSE_SQL + CHOOSE_SORT;
         }
         //组包发送打印输出的数据
         //dt_data = Fun.getDtBySql(BS_CHOOSE_SQL + "");
         //数据已经格式化
         send_conhtml.Append("<?xml version=\"1.0\" encoding=\"utf-8\" ?><DATA>") ;
         send_conhtml.Append("<A00201KEY>"+ a00201_key + "</A00201KEY>");
         send_conhtml.Append("<A00101KEY>"+ a10001_key + "</A00101KEY>");
         send_conhtml.Append("<TABLESELECT>" + dt_a013010101.Rows[i]["TABLE_SELECT"].ToString() + "<TABLESELECT>");
         send_conhtml.Append("<SQLSELECT>" + BS_CHOOSE_SQL + "<SQLSELECT>");
         send_conhtml.Append("</DATA>");


%>  
        
         
         <%
         break;
     }    
    
%>
