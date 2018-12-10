<%@ Page Language="C#" AutoEventWireup="true" CodeFile="linkHtml.aspx.cs" Inherits="linkHtml" %>

<%
    string a306_id = Request.QueryString["a306id"] == null ? "" : Request.QueryString["a306id"].ToString();
    string sql = "select t.* from A306_EMAIL t where a306_id= '" + a306_id + "'";
    dt_a306 = Fun.getDtBySql(sql);
    string url = dt_a306.Rows[0]["url"].ToString();
    string des = dt_a306.Rows[0]["DESCRIPTION"].ToString();
    string linkcode = dt_a306.Rows[0]["linkcode"].ToString();
    string HTTP_URL = Fun.getA022Name("HTTP_URL");
    string a306_name = dt_a306.Rows[0]["a306_name"].ToString();
    string A30305_KEY = "";

    if (a306_name.IndexOf("A319_ID=") == 0)
    {
        //"Select Pkg_Socket.Get_Xml('1', 'sendcoline', 'AAAM7gAAFAAAFb0AAF') As c   From Dual";  //
        string select_sql = dt_a306.Rows[0]["DESCRIPTION"].ToString();
        des = select_sql;
        des = des.Replace("[A306_ID]", a306_id);
        url = "javascript:void(0)";
        A30305_KEY = a306_name.Replace("A319_ID=", "");
        dt_temp = Fun.getDtBySql(des);
       StringBuilder s_html = new StringBuilder();
       string strxml = "";
        
        if (dt_temp.Rows.Count > 0)
        {
            strxml = dt_temp.Rows[0][0].ToString();
        }
     Response.Write(strxml);
    }
    else
    { 
%>
 <html>
 <head>
 <title>
<%
   
if (a306_name.IndexOf("A30305_ID=") == 0)
{
    string select_sql = dt_a306.Rows[0]["DESCRIPTION"].ToString();
    //要显示的sql列表
    des = select_sql;
    url = "javascript:void(0)";
    A30305_KEY = a306_name.Replace("A30305_ID=", "");
}
else
{
    A30305_KEY = "-";
    if (url.ToUpper().Trim().IndexOf("[HTTP_URL]") == 0 || url.ToUpper().Trim().IndexOf(GlobeAtt.HTTP_URL.ToUpper()) == 0)
    {
        url = HTTP_URL + "/linkjump.aspx?linkcode=" + linkcode;
    }
    //邮件内容格式
    Response.Write("ERP邮件");

}
    
 %>
 </title> 
<style type="text/css">
<!--
body,table{
    font-size:12px;
}
table{
    table-layout:fixed;
    empty-cells:show; 
    border-collapse: collapse;
    margin:0 auto;
}
td{
    height:20px;
}
h1,h2,h3{
    font-size:12px;
    margin:0;
    padding:0;
}

.title { background: #FFF; border: 1px solid #9DB3C5; padding: 1px; width:90%;margin:20px auto; }
    .title h1 { line-height: 31px; text-align:center;  background: #2F589C url(th_bg2.gif); background-repeat: repeat-x; background-position: 0 0; color: #FFF; }
        .title th, .title td { border: 1px solid #CAD9EA; padding: 5px; }


/*这个是借鉴一个论坛的样式*/
table.t1{
    border:1px solid #cad9ea;
    color:#666;
}
table.t1 th {
    background-image: url(th_bg1.gif);
    background-repeat::repeat-x;
    height:30px;
}
table.t1 td,table.t1 th{
    border:1px solid #cad9ea;
    padding:0 1em 0;
}
table.t1 tr.a1{
    background-color:#f5fafe;
}



table.t2{
    border:1px solid #9db3c5;
    color:#666;
}
table.t2 th {
    height:30px;
}
table.t2 td{
    border:1px dotted #cad9ea;
    padding:0 2px 0;
}
table.t2 th{
    border:1px solid #a7d1fd;
    padding:0 2px 0;
}
table.t2 tr.a1{
    background-color:#e8f3fd;
}



table.t3{
    border:1px solid #fc58a6;
    color:#720337;
}
table.t3 th {
    background-image: url(th_bg3.gif);
    background-repeat::repeat-x;
    height:30px;
    color:#35031b;
}
table.t3 td{
    border:1px dashed #feb8d9;
    padding:0 1.5em 0;
}
table.t3 th{
    border:1px solid #b9f9dc;
    padding:0 2px 0;
}
table.t3 tr.a1{
    background-color:#fbd8e8;
}

-->
</style>
 </head>
 <body>
 <% //普通邮件
if (A30305_KEY == "-")
{
    Response.Write("<a  href=\"" + url + "\">" + des.Replace("\r", "<br/>").Replace("\n", "<br/>") + "</a>");
}
else
{ //发送给用户的邮件
 %>     
 <%  int pos_ = A30305_KEY.IndexOf("-");
     string a30305_id = A30305_KEY.Substring(0, pos_);
     string line_no = A30305_KEY.Substring(pos_ + 1);
     dt_temp = Fun.getDtBySql(des);
     StringBuilder s_html = new StringBuilder();
     if (dt_temp.Rows.Count > 0)
     {
         //        <div class="title">
         //   <h1>大家好，CSS与表格的结合示例</h1>
         //</div>
         s_html.Append("可以拷贝到Excel中使用");
         s_html.Append("<table  width=\"90%\" id=\"mytab\"  border=\"1\" class=\"t2\">");
         s_html.Append("<thead>");
         for (int j = 0; j < dt_temp.Columns.Count; j++)
         {
             string col_id = dt_temp.Columns[j].ColumnName;
             dt_temp0 = Fun.getDtBySql("select t.Col_Name,t.col02 from A3030501 t where  t.A30305_Id='" + a30305_id + "' and t.col_id='" + col_id + "' and if_sql='1'");
             if (dt_temp0.Rows.Count > 0)
             {
                 string col_width = dt_temp0.Rows[0][1].ToString() ;
                 if (col_width == "" || col_width == null)
                 {
                     col_width = "50";
                 }


                 s_html.Append("<th style=\"width:" + col_width + "px;\">" + dt_temp0.Rows[0][0].ToString() + "</th>");
             }
             else
             {
                 s_html.Append("<th>" + col_id + "</th>");

             }

         }
         s_html.Append("</thead>");
         for (int i = 0; i < dt_temp.Rows.Count; i++)
         {
             if (i % 2 == 0)
             {
                 s_html.Append("<tr class=\"a1\">");
             }
             else
             {
                 s_html.Append("<tr>");
             }
             for (int j = 0; j < dt_temp.Columns.Count; j++)
             {
                 s_html.Append("<td>" + dt_temp.Rows[i][j].ToString() + "</td>");

             }
             s_html.Append("</tr>");

         }

         s_html.Append("</table>");
         Response.Write(s_html.ToString());
     }
     else
     {
         Response.Write("<NOSENDEMAIL>1</NOSENDEMAIL>");
     }

}
     
 %>  
 </body>
 </html>
 <%} %>