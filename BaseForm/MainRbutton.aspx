<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MainRbutton.aspx.cs" Inherits="BaseForm_MainRbutton" %>
<%
    string option = BaseFun.getAllHyperLinks(RequestXml, "<OPTION>", "</OPTION>")[0].Value;
    string COPYA00201KEY = BaseFun.getAllHyperLinks(RequestXml, "<COPYA00201KEY>", "</COPYA00201KEY>")[0].Value;
    StringBuilder str_html = new StringBuilder();
    string selectrowlist__ = BaseFun.getAllHyperLinks(RequestXml, "<ROWIDLIST>", "</ROWIDLIST>")[0].Value; ;
    str_html.Append("<table class=\"rb_table\">");
    for (int i = 0; i < dt_rb.Rows.Count; i++)
    {
        if (option == "P")
        {
            continue;
        }
        string name = dt_rb.Rows[i]["A014_NAME"].ToString();
        if (GlobeAtt.LANGUAGE_ID == "EN")
        {
            try
            {
                name = dt_rb.Rows[i]["e_a014_name"].ToString();
            }
            catch
            {
                name = dt_rb.Rows[i]["A014_NAME"].ToString();
            }
        }
        string id = dt_rb.Rows[i]["A014_ID"].ToString();
        string if_first = dt_rb.Rows[i]["IF_FIRST"].ToString();
        //获取当前用户的按钮权限
        if (if_first == "A")
        {
            //是表头 
            if (dt_a00201.Rows[0]["if_main"].ToString() == "1")
            {
                //并且不是查询
                if (option != "Q")
                {
                    continue;
                }

            }
        }
        else
        {

            if (option != "Q")
            {
                if (if_first == "71")
                {
                    continue;
                }
            }
            else
            {
                if (if_first != "7")
                {
                    continue;
                }
            }
        }  
        
        string if_use = "1";
        if (objid == "")
        {
            if_use = "0";
            
        }
        if (if_use == "1")
        {
          if_use = getRbUseable(id);
        }
  
        if (selectrowlist.Length < 3)
        {
            if_use = "0";
        }
        if ((if_first == "6") && if_use == "1")
        {

                string objid_ = objid;
                string child_url = dt_rb.Rows[i]["A014_SQL"].ToString();
                if (if_first == "6")
                {
                    child_url = dt_rb.Rows[i]["NEXT_DO"].ToString();
                }
                string a014_name = dt_rb.Rows[i]["A014_NAME"].ToString();
                if (child_url.Length < 10)
                {
                    if_use = "0";
                    str_html.Append("<tr id=\"tr" + id + "\" class=\"disable\"  style=\"display:none;\" ><td ><a>" + name + "</a></tr>"); 
                    continue;
                }
                else
                {
                    dt_temp = Fun.getDtBySql(child_url.Replace("[ROWID]", objid));
                    if (dt_temp.Rows.Count == 0)
                    {
                        if_use = "0";
                        str_html.Append("<tr id=\"tr" + id + "\" class=\"disable\"  style=\"display:none;\"  ><td ><a>" + name + "</a></tr>"); 
                        continue;
                    }
                    else
                    {
                        if (dt_temp.Rows.Count == 1)
                        {
                            child_url = dt_temp.Rows[0][0].ToString();
                            string name_ = dt_temp.Rows[0][1].ToString();
                            if (child_url.ToLower().IndexOf("mainform.aspx?") == 0)
                            {
                                child_url = GlobeAtt.HTTP_URL + "/ShowForm/" + child_url;
                            }
                            if (child_url.ToLower().IndexOf("mainform.aspx?") > 0)
                            {
                                child_url = child_url + "&rbchild=1";
                            }
                            str_html.Append("<tr id=\"tr" + id + "\" class=\"rb_do\"   onclick =\"showtaburl('" + child_url + "','" + name_ + "');rbclose();\"><td ><a>" + a014_name + "</a></tr>");              
                        }
                        else
                        {
                            str_html.Append("<tr id=\"tr" + id + "\" class=\"rb_do\" value=\"0\"   onclick =\"showrbdetail(this,'" + dt_temp.Rows.Count.ToString() + "');\"><td ><a>" + a014_name + "</a></tr>");              
                 
                            for (int kk = 0; kk < dt_temp.Rows.Count; kk++)
                            {

                                child_url = dt_temp.Rows[kk][0].ToString();
                                string name_ = dt_temp.Rows[kk][1].ToString();
                                if (child_url.ToLower().IndexOf("mainform.aspx?") == 0)
                                {
                                    child_url = GlobeAtt.HTTP_URL + "/ShowForm/" + child_url;
                                }
                                str_html.Append("<tr id=\"tr" + id + kk.ToString() + "\"  class=\"rb_do_0\" style=\"display:none;\"   onclick =\"showtaburl('" + child_url + "','" + name_ + "');rbclose();\"><td ><a>" + name_ + "</a></tr>");              
     
                            }
                        }
                    
                    }

                }
             continue;
        }
      
        if (if_use != "0")
        {
            //读取系统是否要进行confirm
                  if (if_first == "7" )
                  {
                      // 
                      if (option == "M")
                      {
                          if (a00201_key.IndexOf("-0") < 0)
                          {
                              if (selectrowlist__.IndexOf(selectrowlist) >= 0)
                              {
                                  str_html.Append("<tr id=\"tr" + id + "\" class=\"rb_do\"   onclick =\"showReq('" + a00201_key + "','A014" + id + "','" + selectrowlist__ + "','" + if_use + "')\"><td ><a>" + name + "</a></tr>");
                              }
                              else
                              {
                                  str_html.Append("<tr id=\"tr" + id + "\" class=\"disable\"   ><td ><a>" + name + "</a></tr>");
                              }
                          }
                      }
                      else
                      {
                          str_html.Append("<tr id=\"tr" + id + "\" class=\"rb_do\"   onclick =\"showReq('" + a00201_key + "','A014" + id + "','" + selectrowlist + "','" + if_use + "')\"><td ><a>" + name + "</a></tr>");
                 
                      }
                      
                  }
                  else
                  {
                     str_html.Append("<tr id=\"tr" + id + "\" class=\"rb_do\"   onclick =\"showReq('" + a00201_key + "','A014" + id + "','" + selectrowlist + "','" + if_use + "')\"><td ><a>" + name + "</a></tr>");              
                  }
        }
        else
        {
            if (if_first == "2" || if_first == "5" || if_first == "3")
            {
                str_html.Append("<tr id=\"tr" + id + "\" class=\"disable\"   ><td ><a>" + name + "</a></tr>");
            }
            else
            {
                str_html.Append("<tr id=\"tr" + id + "\" class=\"disable\"  style=\"display:none;\" ><td ><a>" + name + "</a></tr>");
   
            }
        }
    }
        if (option == "P")
        { str_html.Append("<tr  class=\"lines\"><td><div></div></td></tr>");     
           string url = BaseFun.getAllHyperLinks(RequestXml, "<URL>", "</URL>")[0].Value.ToLower();
           string if_use= "1";
            if (url.IndexOf("option=i") > 0)
            {
                string url__ = dt_a00201.Rows[0]["bs_url"].ToString();
                if (url__.ToLower().IndexOf("querydata.aspx") > 0)
                {
                    if_use = "0";
                }
            }

              for (int i = 0; i < dt_print.Rows.Count; i++)
              {
                  string DW_NAME = dt_print.Rows[i]["DW_NAME"].ToString();
                  string DW_ID = dt_print.Rows[i]["DW_ID"].ToString();
                  if (DW_ID == "-")
                  {
                      str_html.Append("<tr  class=\"lines\"><td><div></div></td></tr>");
                      continue;
                  }
                  string line_no = dt_print.Rows[i]["LINE_NO"].ToString();
                  //获取用户对报表的权限
                  string SHOW_USER = dt_print.Rows[i]["SHOW_USER"].ToString();
                  string REPORT_TYPE = dt_print.Rows[i]["REPORT_TYPE"].ToString();
                  if (SHOW_USER == null || SHOW_USER == "")
                  {
                      SHOW_USER = "Select '" + GlobeAtt.A007_KEY + "' as a007_id from dual";
                  }
                  SHOW_USER = SHOW_USER.Replace("[USER_ID]",GlobeAtt.A007_KEY);
                  SHOW_USER = SHOW_USER.Replace("[ROWID]", objid);
                  SHOW_USER = SHOW_USER.Replace("[REPORT_TYPE]", REPORT_TYPE);
                  SHOW_USER = SHOW_USER.Replace("[DW_ID]", DW_ID);  
                  dt_temp = Fun.getDtBySql(SHOW_USER);
                  if (dt_temp.Rows.Count > 0)
                  {
                      string v = dt_temp.Rows[0][0].ToString();
                      if (v == GlobeAtt.A007_KEY || v == "1")
                      {
                          if (if_use == "1")
                          {

                              str_html.Append("<tr id=\"tr" + (100 + i).ToString() + "\"  class=\"rb_do\"  onclick =\"showReq('" + a00201_key + "','MainPrint" + line_no.ToString() + "','" + selectrowlist + "')\"><td><a>" + DW_NAME + "</a></tr>");
                          }
                          else
                          {                    
                             str_html.Append(Environment.NewLine);
                          }
                      }     
                  }}
             
        }

          if (option != "P" &&  option != "Q")
          {
              str_html.Append("<tr  class=\"lines\"><td><div></div></td></tr>");
              if (dt_a00201.Rows[0]["IF_MAIN"].ToString() == "1" && COPYA00201KEY.Length > 0)
              {
                  string selectrowlist_ = COPYA00201KEY;
                  string copy_data1 = "";
                  try
                  {
                      copy_data1 = Session["COPYBill_" + a00201_key].ToString();
                  }
                  catch
                  {
                      copy_data1 = "";
                  }

                  str_html.Append("<tr id=\"tr_sys7\"  class=\"rb_do\" onclick =\"showReq('" + a00201_key + "','CopyBill','" + selectrowlist_ + "')\"><td width=\"200\" ><a>" + BaseMsg.getMsg("M0056") + "</a></tr>");

                  if (copy_data1 != "")
                  {
                      str_html.Append("<tr id=\"tr_sys8\"  class=\"rb_do\" onclick =\"showReq('" + a00201_key + "','PasteBill','" + selectrowlist_ + "')\"><td width=\"200\" ><a>" + BaseMsg.getMsg("M0057") + "</a></tr>");

                  }
                  else
                  {

                      str_html.Append("<tr id=\"tr_sys8\" class=\"disable\"><td ><a>" + BaseMsg.getMsg("M0057") + "</a></tr>");
                  }
              }



              str_html.Append("<tr id=\"tr_sys3\"  class=\"rb_do\" onclick =\"showReq('" + a00201_key + "','CopyRow','" + selectrowlist + "')\"><td width=\"200\" ><a>" + BaseMsg.getMsg("M0058") + "</a></tr>");
       
                
        string copy_data = "";
        try
        {
            copy_data = Session["COPY_" + a00201_key].ToString();
        }
        catch
        {
            copy_data = "";
        }
        if (copy_data != "")
        {
            str_html.Append("<tr id=\"tr_sys4\"  class=\"rb_do\" onclick =\"showReq('" + a00201_key + "','PasteRow','" + selectrowlist + "')\"><td width=\"200\" ><a>" + BaseMsg.getMsg("M0059") + "</a></tr>");
     
        }
        else
        {
            str_html.Append("<tr id=\"tr_sys4\" class=\"disable\"><td ><a>" + BaseMsg.getMsg("M0059") + "</a></tr>");
        }
              
           //   NEWBTN
        try
        {
            string NEWBTN = BaseFun.getAllHyperLinks(RequestXml, "<NEWBTN>", "</NEWBTN>")[0].Value;
            if (NEWBTN == "1")
            {
                str_html.Append("<tr id=\"tr_sys9\"  class=\"rb_do\" onclick =\"do_new()\"><td width=\"200\" ><a>" + BaseMsg.getMsg("M0063") + "</a></tr>");
            }
        }
        catch
        { 
        
        }
              
            str_html.Append("<tr  class=\"lines\"><td><div></div></td></tr>");
      }
        str_html.Append("</table>");
         
        Response.Write(str_html.ToString());
%>
