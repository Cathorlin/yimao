<%@ Page Language="C#" AutoEventWireup="true" CodeFile="linkjump.aspx.cs" Inherits="linkjump" ResponseEncoding="UTF-8" %>

<%
     //email 连接的跳转界面
    string linkcode = Request.QueryString["linkcode"] == null ? "" : Request.QueryString["linkcode"].ToString();
      /*解析UCODE 包含用户信息*/
     string sql = "Select pkg_user.checklogin('" + linkcode + "') as c from dual";   
     dt_temp = Fun.getDtBySql(sql);
     string a306_id = dt_temp.Rows[0][0].ToString();
     string url = GlobeAtt.HTTP_URL + "/login.aspx?linkcode=" + linkcode;
   
    
     if (a306_id != "" && a306_id != null)
     {   
         
         //判断有没有登录
         if (GlobeAtt.A007_KEY != "")
         {
             url = GlobeAtt.HTTP_URL + "/default.aspx";
         }
        
      
         sql = "select t.* from A306  t where a306_id= '" + a306_id + "'";
         dt_temp = Fun.getDtBySql(sql);
         Session["LINK_P_URL"] = dt_temp.Rows[0]["url"].ToString().Replace("[HTTP_URL]", GlobeAtt.HTTP_URL);
         Session["LINK_A306"] = a306_id;
         Session["LINK_A007_ID"] = dt_temp.Rows[0]["rec_a007"].ToString();
     
         
     }   
%>                    
        <script>
            location.href = "<%=url %>";        
        </script>               
