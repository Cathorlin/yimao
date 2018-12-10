<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BaseTree.aspx.cs" Inherits="BaseForm_BaseTree" %>
<%
    string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;
    string MAINKEY = BaseFun.getAllHyperLinks(RequestXml, "<MAINKEY>", "</MAINKEY>")[0].Value;
    string TREEID_ = BaseFun.getAllHyperLinks(RequestXml, "<TREEID>", "</TREEID>")[0].Value;
    TREEID = TREEID_.Replace("-", "");
    string id_ = "0";
    try
    {
        id_ = Session["TREEID"].ToString();
    }
    catch
    {
        id_ = "0";
    }

    dt_data = Fun.getDtBySql("Select t.* from A00212 t where menu_id='" + dt_a00201.Rows[0]["menu_id"].ToString() + "'order by t.sort_by ");
    string data_index = GlobeAtt.DATA_INDEX;
    if (TREEID != "0")
    {
        Response.Write(" var N" + TREEID+"=[];");
        for (int i = 0; i < dt_data.Rows.Count; i++)
        {
            string show_sql = dt_data.Rows[i]["SHOW_SQL"].ToString();

            show_sql = show_sql.Replace("[USER_ID]", GlobeAtt.A007_KEY);
            show_sql = show_sql.Replace("[MAIN_KEY]", MAINKEY);

            dt_temp = Fun.getDtBySql(show_sql);
            string parm_ = "";
            string tree_width = (int.Parse(dt_data.Rows[i]["TREE_WIDTH"].ToString()) - 10).ToString();
            string child_sql = dt_data.Rows[i]["CHILD_SQL"].ToString();
            string child_type = dt_data.Rows[i]["CHILD_TYPE"].ToString();

            string title = "";
            for (int j = 0; j < dt_temp.Rows.Count; j++)
            {
                string show_child = "0";
                parm_ = "";
                for (int c = 1; c < dt_temp.Columns.Count; c++)
                {
                    string column_id = dt_temp.Columns[c].ColumnName.ToUpper();
                    string col_data = dt_temp.Rows[j][c].ToString();
                    if (col_data == null)
                    {
                        col_data = "";
                    }
                    if (column_id == "SHOWCHILD")
                    {
                        show_child = col_data;
                    }
                    parm_ = parm_ + column_id + "|" + col_data + data_index;
                }
                //显示标题
                title = dt_temp.Rows[j][0].ToString();
                if (child_sql.Length > 5)
                {
                    id_ = (int.Parse(id_) + 1).ToString();

                    Session["TREEID"] = id_;
                  
                    string html_ = Get_Tree_Json(title, child_sql, parm_, 0, "0", show_child, child_type);                    
                    Response.Write(html_);
      
                }
            }
            // str_json_ = "{id:menu_id, pId:parent_id, name:menu_name};";
          
            //Response.Write("N" + TREEID + "push("+ str_json_+");");
        }


        Response.Write("createTree(\"" + TREEID_ + "\", N" + TREEID + ");ifdiv_req = \"0\";");
        return;
    }

   
 %>




<div style="margin:20px 0 0 5px; ">
<%

 
  for (int i = 0; i < dt_data.Rows.Count; i++)
  {
      string show_sql = dt_data.Rows[i]["SHOW_SQL"].ToString();

      show_sql = show_sql.Replace("[USER_ID]",GlobeAtt.A007_KEY);
      show_sql = show_sql.Replace("[MAIN_KEY]",MAINKEY);
     
      dt_temp = Fun.getDtBySql(show_sql);
      string parm_ = "";
      string tree_width = (int.Parse(dt_data.Rows[i]["TREE_WIDTH"].ToString()) - 10).ToString();
      string child_sql = dt_data.Rows[i]["CHILD_SQL"].ToString();
      string child_type = dt_data.Rows[i]["CHILD_TYPE"].ToString();
 
      string title = "";
      for (int j = 0; j < dt_temp.Rows.Count; j++)
      {
          string show_child = "0";
          parm_ = "";
          for (int c = 1; c < dt_temp.Columns.Count; c++)
          {
              string column_id = dt_temp.Columns[c].ColumnName.ToUpper();
              string col_data = dt_temp.Rows[j][c].ToString();
              if (col_data == null)
              {
                  col_data = ""; 
              }
              if (column_id == "SHOWCHILD")
              {
                  show_child = col_data;
              }
              parm_ = parm_ + column_id + "|" + col_data + data_index;          
          }
          //显示标题
          title = dt_temp.Rows[j][0].ToString();
          if (child_sql.Length > 5)
          {
              id_ = (int.Parse(id_) + 1).ToString();
              
              Session["TREEID"] = id_;
              string html_ = Get_Tree_Html(title, child_sql, parm_, 0, "tr" + id_, show_child, child_type);
              Response.Write("<div style=\"margin:0px 0 0 5px;width:" + tree_width + "\">");
              Response.Write(html_);
              Response.Write("</div>");
          }
      }

  }   
   
 %>   
 </div>

