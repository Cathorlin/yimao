<%@ Page Language="C#" AutoEventWireup="true" CodeFile="HtmlReq.aspx.cs" Inherits="BaseForm_HtmlReq" %>
<%         string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;%>
   <%    
 
       if (req_id == "TEST")
           {

               string CODE = BaseFun.getAllHyperLinks(RequestXml, "<NEXTDO>", "</NEXTDO>")[0].Value;
               Response.Write(CODE);
               return;
           }
           %>
<%
         
           //设置Session的值
           if (req_id == "SET_SESSION")
           {

               string NAME = BaseFun.getAllHyperLinks(RequestXml, "<NAME>", "</NAME>")[0].Value;
               string VALUE = BaseFun.getAllHyperLinks(RequestXml, "<VALUE>", "</VALUE>")[0].Value;
               Session[NAME] = VALUE;
               if (VALUE == "1")
               {
                   Response.Write("setchild('1');");
               }
               else
               {
                   Response.Write("setchild('0');");
               }
               return;
           }
           //设置Session的值
           if (req_id == "GET_SESSION")
           {

               string NAME = BaseFun.getAllHyperLinks(RequestXml, "<NAME>", "</NAME>")[0].Value;

               string VALUE = "";
               try
               { 
                   VALUE = Session[NAME].ToString();
               }
               catch
               {
                   VALUE = "";
               }
               Response.Write("session_temp='"+VALUE+"';");
      
               return;
           }
           %>           
<%  //检测登录
           if (req_id == "CHECKLOGIN")
           {
               string CODE = BaseFun.getAllHyperLinks(RequestXml, "<CODE>", "</CODE>")[0].Value;
               string user_id = BaseFun.getAllHyperLinks(RequestXml, "<USERID>", "</USERID>")[0].Value;
               string pass = BaseFun.getAllHyperLinks(RequestXml, "<PASS>", "</PASS>")[0].Value;
               //wp 2014-12-22 begin***
               string ltype = "0";//BaseFun.getAllHyperLinks(RequestXml, "<LTYPE>", "</LTYPE>")[0].Value;
               Session["LTYPE"] = ltype;
               //wp end****************
               string scode = "";
               try
               {
                   scode = Session["verifycode"].ToString();

               }
               catch
               {
                   scode = "";
               }
               //if (scode != CODE)
               //{
               //    Response.Write("setLoginError('错误的验证码！')");
               //    return;
               //}

               BaseLogin BLogin = new BaseLogin("1", user_id, pass, "1");
               string ls_login = BLogin.checkUserLogin();
               //wp begin
               if (ltype == "1")
               {
                   if (ls_login.Substring(0, 2) == "02")
                       ls_login = "02[HTTP_URL]/HandEquip/index.aspx";
               }
               //wp end
               Response.Write("doNext('" + ls_login + "')");
               return;

           }
      %>           
<%//退出登录
           if (req_id == "LOGINOUT")
           {
               Session.Clear();
               Response.Write("parent.location.href = 'login.aspx';");
               
               return;
           }
      %>          
<% //设置语言
           if (req_id == "SET_LANGUAGE")
           {
                             
               Session["LANGUAGE_ID"] =  BaseFun.getAllHyperLinks(RequestXml, "<LANGUAGE_ID>", "</LANGUAGE_ID>")[0].Value;
               Response.Write("location.reload()");
               return;
           }
      %>          
<% //检测用户是否登录
           if  (req_id == "IFLOGIN")
           {
              
               if (GlobeAtt.A007_KEY == "")
               {
                   Response.Write("parent.location.href = 'login.aspx';");
               }
               else
               {
                   string  a002_key = "";
                   try
                   {
                       a002_key = Session["JUMP_A002_KEY"].ToString();
                   }
                   catch
                   {
                        a002_key = "";
                   }
                 

                    string sql_ = "update A30001 set EXE_NM='" + a002_key + "', modi_date =sysdate,modi_user='" + GlobeAtt.A007_KEY + "' where a300_id='" + GlobeAtt.A30001_KEY + "' AND  LINE_NO =1   and SORT_BY = " + GlobeAtt.A30001_KEY;
                    Fun.execSqlOnly(sql_);
                    Response.Write("setTimeout('checklogin()', 600000);");//10分钟刷新一次登录信息
                    string des = "";
                       
                    string a306sql = "Select t.* from A306 t where t.rec_a007 ='System' and   t.status ='0'";
                    dt_data = Fun.getDtBySql(a306sql);

                    if (dt_data.Rows.Count > 0)
                    {
                        des = "";
                        for (int i = 0; i < dt_data.Rows.Count; i++)
                        {
                            des += dt_data.Rows[i]["description"].ToString() + "  ";
                        }
                          
                        string des1 = "<marquee width=400  direction=left align=middle border=1 style=\"color:white;\" scrollamount=\"3\">" + des.Replace("'", "\\'") + "</marquee>";
                        Response.Write("$('#show_sysmsg').html('" + des1 + "');");
                        return;
                    }
                    else
                    {
                        Response.Write("$('#show_sysmsg').html('');");
                    }
                        
                    
                            //string sql_ = "update A306 set status='1', modi_date =sysdate  where a306_id='" + dt_data  .Rows[0]["a306_id"].ToString()+ "'";
                            //Fun.execSqlOnly(sql_);

              
                       
                   
                   
               }
            
               return ;
           }
      %>          
<% //右键显示
           if (req_id == "SHOWRBDATA")
           {
               string data_index = GlobeAtt.DATA_INDEX;
               string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
               string MAINKEY = data_index + BaseFun.getAllHyperLinks(RequestXml, "<MAINKEY>", "</MAINKEY>")[0].Value;
               string KEY =  BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
               string SQL_ =  BaseFun.getStrByIndex(MAINKEY, "SQL|", data_index);
               
               StringBuilder html_ = new StringBuilder();
               dt_data = Fun.getDtBySql(SQL_);
               html_.Append("<table class=\"a0\">");
               for (int c = 0; c < dt_data.Rows.Count; c++)
               {
                   StringBuilder trhtml_ = new StringBuilder();
                   StringBuilder trhtmlall_ = new StringBuilder();
                   trhtmlall_.Append("<tr>");                  
                   string rowlist = "";
                   Boolean lb_exist =false ;
                   if (KEY == "" || KEY == null)
                   {
                       lb_exist = true;
                   }
                   for (int cc = 0; cc < dt_data.Columns.Count; cc++)
                   {
                       string col_v = dt_data.Rows[c][cc].ToString();
                       rowlist += dt_data.Columns[cc].ColumnName + "|" + col_v + data_index;
                       trhtml_.Append("<td>" + col_v + "</td>");
                       if (col_v.IndexOf(KEY) >= 0 && lb_exist == false)
                       {
                           lb_exist = true;
                       }
                   }

                   trhtmlall_.Append("<td><input  type=\"radio\" name=\"" + BaseFun.getStrByIndex(MAINKEY, "A014_ID|", data_index) + "\" value=\"" + rowlist.Replace("\"", "\\\"") + "\" /></td>");
                   trhtmlall_.Append(trhtml_);
                   trhtmlall_.Append("</tr>");
                   if (lb_exist == true)
                   {
                       html_.Append(trhtmlall_);
                   }
               }

               html_.Append("</table>");
               Response.Write(html_);
           }
      %>           
<%//接收消息以后
           if (req_id == "RECMSG")
           {  //获取用户的消息列表
               string A306_ID = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
               string sql = "update A306 set status='1', modi_date = sysdate,modi_user = '" + GlobeAtt.A007_KEY + "' where a306_id='" + A306_ID + "'";
               Fun.execSqlOnly(sql);  
               Response.Write("hidediv('"+ A306_ID+"');");                        
           }
           if (req_id == "SHOWMSG")
           {  //获取用户的消息列表
               int w_ = 400;
               int h_ = 70;
               string sql = "Select t.* from A306 t  where  t.a306_name not like 'A30305_ID=%' and   t.rec_a007='" + GlobeAtt.A007_KEY + "' and  t.status='0'  and enter_date > sysdate - 2  and rownum < 20 order by  enter_date desc ";
               dt_data = Fun.getDtBySql(sql);
               StringBuilder html_ = new StringBuilder();
               html_.Append("<table style=\"FONT-WEIGHT: normal; FONT-SIZE: 12px; COLOR: #1f336b;width:100%;\">");
               html_.Append("<tr><td height=15px>您有" + dt_data.Rows.Count.ToString() + "条消息<td></tr>");
               for (int i = 0; i < dt_data.Rows.Count; i++)
               {   string description= dt_data.Rows[i]["description"].ToString();
                   string a306_id = dt_data.Rows[i]["a306_id"].ToString();
                   string url = dt_data.Rows[i]["url"].ToString();
                   if (url.Length > 5)
                   {
                       url = url.Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
                       description = "<a name=\"btlink\" id=\"tblink" + a306_id + "\"  href=\"" + url + "\">" + description + "</a>";

                      // description = "<a name=\"btlink\" id=\"tblink" + a306_id + "\"  href=showtaburl(\"" + url + "\",\"消息-" + a306_id + "\")>" + description + "</a>";
                   }
                   html_.Append("<tr id=\"rec" + a306_id + "\">");
                   html_.Append("<td width=\"100%\">");
                   h_ += 20;
                   html_.Append("<div style=\"COLOR: #red;float:left;width:" + (w_ - 80 ).ToString()+ "px;\"><span>" + description.Replace("'","\\'") + "</span></div>");
                   html_.Append("<div style=\"float:right;width:30px;cursor:hand;\" ><a id=\"btRec" + a306_id + "\" name=\"btRec\"><span>收到<span></a></div>");
                   html_.Append("</td>");
                   html_.Append("</tr>");
               }
               html_.Append("</table>");
               if (h_ < 300)
               {
                   h_ = 300; 
               }
             //  string h = HttpUtility.UrlEncode(html_.ToString()).Replace("+", "%20");
               Response.Write("showusermsg(" + w_.ToString() + "," + h_.ToString() + ",'" + html_.ToString() + "'," + dt_data.Rows.Count.ToString() + ")");
           }
      %>           
<%//显示查询结果
           if (req_id == "SHOWQUERYDATA")
           {

               string SQL_ = BaseFun.getAllHyperLinks(RequestXml, "<MAINKEY>", "</MAINKEY>")[0].Value;
               string sort_ = "";
               int pos_ = SQL_.ToUpper().IndexOf(" ORDER ");
               if ( pos_ > 0)
               {
                   sort_ = SQL_.Substring(pos_);
                   SQL_ = SQL_.Substring(0, pos_);
                  
               }
               string data_index= GlobeAtt.DATA_INDEX;
               string vlist = data_index +  BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
               string DIVID = BaseFun.getAllHyperLinks(RequestXml, "<DIVID>", "</DIVID>")[0].Value;
               string RESULT_ROWS = BaseFun.getAllHyperLinks(RequestXml, "<RESULTROWS>", "</RESULTROWS>")[0].Value;
               string SHOWROWS = BaseFun.getAllHyperLinks(RequestXml, "<SHOWROWS>", "</SHOWROWS>")[0].Value;
               string bs_width_ = data_index +  BaseFun.getAllHyperLinks(RequestXml, "<WIDTH>", "</WIDTH>")[0].Value;
              
               string COLID = BaseFun.getAllHyperLinks(RequestXml, "<COLID>", "</COLID>")[0].Value;
               string ROWID = BaseFun.getAllHyperLinks(RequestXml, "<ROWID>", "</ROWID>")[0].Value;
               //树传入的条件 
               string TREECON = BaseFun.getAllHyperLinks(RequestXml, "<TREECON>", "</TREECON>")[0].Value;
               //列名
               string COLNAME = BaseFun.getAllHyperLinks(RequestXml, "<COLNAME>", "</COLNAME>")[0].Value;
               if (TREECON != "" && TREECON != null)
               {
                   SQL_ = SQL_ + TREECON;
               }
               StringBuilder str_html = new StringBuilder();
               dt_data = Fun.getDtBySql(SQL_ + " AND 1 = 2");
               string[] bs_width = new string[dt_data.Columns.Count];
               string con = "";
               for (int r = 0; r < dt_data.Columns.Count; r++)
               {
                   string column_id = dt_data.Columns[r].ColumnName;
                   string col_type = dt_data.Columns[r].DataType.ToString();
                   string v =  BaseFun.getStrByIndex(vlist, data_index + r.ToString() + "|", data_index);
                   string CALC = BaseFun.getStrByIndex(vlist, data_index + "C" + r.ToString() + "|", data_index);

                   if (CALC == "NULL" || CALC == "NOT NULL")
                   {
                       con += " AND (" + column_id + " IS " + CALC + " ) ";
                   }
                   else
                   {
                       if (v != "")
                       {
                           if (CALC == "LIKE" || CALC == "IN" || CALC == "NOT LIKE" || CALC == "NOT IN")
                           {
                               if (CALC == "LIKE" || CALC == "NOT LIKE")
                               {
                                   if (GlobeAtt.GetValue("QUERY_LIKE") == "1")
                                   {
                                       if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                                       {
                                           con += " AND  (to_char(" + column_id + ") " + CALC + " '%" + v.Replace("|", "") + "%')";
                                       }
                                       else
                                       {
                                           con += " AND  (" + column_id + " " + CALC + "  '%" + v.Replace("|", "") + "%')";
                                       }
                                   }
                                   else
                                   {
                                       if (v.IndexOf("%") <= -1)
                                       {
                                           v = "%" + v + "%";
                                       }

                                       if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                                       {
                                           con += " AND  (to_char(" + column_id + ") " + CALC + " '" + v.Replace("|", "") + "')";
                                       }
                                       else
                                       {
                                           con += " AND  (" + column_id + " " + CALC + "  '" + v.Replace("|", "") + "')";
                                       }

                                   }

                               }
                               if (CALC == "IN" || CALC == "NOT IN")
                               {
                                   string[] vlist_ = v.Split(new char[1] { '|' });
                                   con += " AND  (" + column_id + " " + CALC + " (";
                                   for (int j = 0; j < vlist_.Length; j++)
                                   {

                                       string[] vlistc = vlist_[j].Split(new char[1] { ',' });
                                       if (vlist_[j].IndexOf(";") > 0)
                                       {
                                           vlistc = vlist_[j].Split(new char[1] { ';' });
                                       }
                                       for (int k = 0; k < vlistc.Length; k++)
                                       {
                                           if (vlistc[k].Length > 0)
                                           {
                                               con += "'" + vlistc[k] + "',";
                                           }
                                       }
                                   }
                                   con = con.Substring(0, con.Length - 1) + ") )";
                               }
                           
                       }
                       else
                       {
                           if (CALC == "BETWEEN")
                           {
                               string[] vlist_ = v.Replace("..","|").Split(new char[1] { '|' });
                               
                               if (vlist_.Length >= 2)
                               {

                                   string v_begin = vlist_[0];
                                   string v_end = vlist_[1];
                                   if (v_begin.Length > 0 || v_end.Length > 0)
                                   {
                                       if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                                       {
                                           if (v_begin == "")
                                           {
                                               v_begin = "-999999999999999";
                                           }
                                       }
                                       else
                                       {
                                           v_begin = "'" + v_begin + "'";
                                       }

                                       if (col_type == "numeric" || col_type == "number" || col_type == "int" || col_type == "decimal")
                                       {
                                           if (v_end == "")
                                           {
                                               v_end = "999999999999999";
                                           }

                                       }
                                       else
                                       {
                                           v_end = "'" + v_end + "'";
                                       }
                                       con += " AND ( " + column_id + ">=" + v_begin + " and " + column_id + " <= " + v_end + ")";
                                   }
                               }
                           }
                           else
                           {
                               con += " AND  (" + column_id + " " + CALC + " '" + v.Replace("|", "") + "')";
                           }
                        }
                       }
                   }
                   bs_width[r] = BaseFun.getStrByIndex(bs_width_, data_index + r.ToString() + "|", data_index);
               }
               SQL_ = SQL_ + con + " AND ROWNUM <= " + SHOWROWS;
               dt_data = Fun.getDtBySql(SQL_ + " "+ sort_);
               string a00201_key__ = COLNAME + "-" + COLID;
               string sql____ = SQL_ + " " + sort_;
              // Fun.saveQuerySql(ROWID, sql____, a00201_key__, "Q");    
               str_html.Append("<table class=\"showdata\">");
               for (int r = 0; r < dt_data.Rows.Count; r++)
               {
                   string v = dt_data.Rows[r][COLNAME].ToString();
                   if (r % 2 == 0)
                   {
                       str_html.Append("<tr class=\"r0\">");
                   }
                   else
                   {
                       str_html.Append("<tr class=\"r1\">");
                   }
                   str_html.Append("<td style=\"width:25px;\">" + (r + 1).ToString() + "</td>");
                   if (RESULT_ROWS == "1")
                   {
                       str_html.Append("<td style=\"width:20px;\"><input id=\"con" + COLID + "_" + (r + 1).ToString() + "\" type=\"checkbox\" name =\"con" + COLID + "\"  value=\"" + v + "\"  /></td>");
                   }
                   else
                   {
                       str_html.Append("<td style=\"width:20px;\"><input id=\"con" + COLID + "_" + (r + 1).ToString() + "\" type=\"radio\"  name=\"" + COLID + "radio\" onclick=\"chooseselect('" + ROWID + "_" + COLID + "','" + v + "')\" /></td>");
                   }
                   for (int c = 0; c < dt_data.Columns.Count; c++)
                   {
                       string col_text = dt_data.Rows[r][c].ToString();
                       if (col_text == null)
                       {
                           col_text = "";
                       }
                       if (dt_data.Columns[c].DataType.Name == "DateTime")
                       {
                           if (col_text.Length > 12)
                           {
                               col_text = col_text.Substring(0, 10);
                           }
                       }
                       if (r == 0)
                       {
                           str_html.Append("<td style=\"width:" + bs_width[c] + "px;\">" + col_text + "</td>");
                       }
                       else
                       {
                           str_html.Append("<td>" + col_text + "</td>");
                       }
                   }
                   str_html.Append("</tr>");
               }

               str_html.Append("</table>");
               Response.Write(str_html);
           }
             %>
             <%if (req_id == "GET_A403")
               {
                 
                       string A403_ID = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
                       string objid = BaseFun.getAllHyperLinks(RequestXml, "<OBJID>", "</OBJID>")[0].Value;
                       string id_ = BaseFun.getAllHyperLinks(RequestXml, "<ID>", "</ID>")[0].Value;
                       StringBuilder html_ = new StringBuilder();
                       try
                       {
                       dt_data = Fun.getDtBySql("Select t.*  from A40301_v01 t where  t.objid='" + objid + "'");
                       if (dt_data.Rows.Count == 0 || dt_data.Rows.Count > 1)
                       {
                           html_.Append("获取内容失败！");
                       }
                       else
                       {
                           string show_type = dt_data.Rows[0]["SHOW_TYPE"].ToString();
                           string show_html = dt_data.Rows[0]["SHOW_HTML"].ToString();
                           string div_html = show_html;
                           if (show_type == "SQL")
                           {
                               dt_data = Fun.getDtBySql(div_html);
                               div_html = dt_data.Rows[0][0].ToString();
                           }
                           if (show_type == "HTTP_GET")
                           {

                               show_html = show_html.Replace("[HTTP_URL]", Fun.GetIndexUrl());
                               Base.HttpRequest http = new Base.HttpRequest();
                               http.CharacterSet = "utf-8";
                               http.OpenRequest(show_html, show_html);
                               div_html = http.HtmlDocument;
                           }

                           div_html = div_html.Replace("\"", "\\\"").Replace(Environment.NewLine, "</BR>");
                           html_.Append(div_html);

                       }

                       string h = HttpUtility.UrlEncode(html_.ToString()).Replace("+", "%20");
                       Response.Write("$(\"#" + id_ + "\").html(decodeURIComponent(\"" + h + "\"));");
                   }
                   catch(Exception ex)
                   {
                       
                       Response.Write("$(\"#" + id_ + "\").html(\"获取内容失败!\");");
                   }
               }
               %>
 <%if (req_id == "SAVE_A403")
    {  //处理显示产线
        string A403_ID = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
        MatchCollection row = BaseFun.getAllHyperLinks(RequestXml, "<ROW>", "</ROW>");
        string data_index = GlobeAtt.DATA_INDEX;
        StringBuilder sqllist = new StringBuilder();

        for (int i = 0; i < row.Count; i++)
        {
            string rowid = BaseFun.getAllHyperLinks(row[i].Value, "<ROWID>", "</ROWID>")[0].Value;
            string rowdata = BaseFun.getAllHyperLinks(row[i].Value, "<ROWLIST>", "</ROWLIST>")[0].Value;
            string sql_ = "begin pkg_a40301.modify__('" + rowdata + "','"+ GlobeAtt.A007_KEY +"','[A311_KEY]');end;";
            sqllist.Append(sql_ + "<EXECSQL></EXECSQL>");

        } 
       if (sqllist.Length > 10)
        {
            try
            {
                string log_key="";
                string lsexec = Fun.execSqlList(sqllist.ToString(), GlobeAtt.A007_KEY, "SHOWA403", "", "A014_ID=" + req_id, "A403_V01", A403_ID, "", ref log_key);
                if (lsexec != "0")
                {
                    Response.Write("doNext('" + lsexec.Replace("\n", ";").Replace("'", "\"") + "');");
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
        //string sql = "update A306 set status='1', modi_date = sysdate,modi_user = '" + GlobeAtt.A007_KEY + "' where a306_id='" + A306_ID + "'";
        //Fun.execSqlOnly(sql);  
        //Response.Write("hidediv('"+ A306_ID+"');");                        
    }


  %>
   <%if (req_id == "GET_XML_REQ")
     {
         string url = BaseFun.getAllHyperLinks(RequestXml, "<REQURL>", "</REQURL>")[0].Value;
         string xml = BaseFun.getAllHyperLinks(RequestXml, "<SENDXML>", "</SENDXML>")[0].Value;
         string dofun = BaseFun.getAllHyperLinks(RequestXml, "<DOFUN>", "</DOFUN>")[0].Value;
             
         string h = HttpUtility.UrlDecode(xml);
         Base.HttpRequest http = new Base.HttpRequest();
         http.CharacterSet = "utf-8";
         http.OpenRequest(url,url, h);
         string receivexml = http.HtmlDocument;
         dofun = dofun.Replace("[XML]", HttpUtility.UrlEncode( receivexml));
         Response.Write(dofun);
         
     }
  %>