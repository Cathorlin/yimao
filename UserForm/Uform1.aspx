<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Uform1.aspx.cs" Inherits="UserForm_Uform1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <%string jsver = GlobeAtt.GetValue("JSVER");        
%>
    <script src="<%=http_url %>js/http.js?ver=<%=jsver%>"    language="javascript" type="text/javascript"></script>
    <script src="<%=http_url %>js/jquery-1.9.1.js?ver=<%=jsver %>"   type="text/javascript"></script>
    <script src="<%=http_url %>js/BasePage.js?ver=<%=jsver%>"    language="javascript" type="text/javascript"></script>
    <link  href="<%=http_url %>Css/BasePage.css?ver=<%=jsver %>"  rel="stylesheet"  type="text/css" />
  
</head>
<body>
    <form id="form1" runat="server">

    <div id="maindiv" style="margin:20px 0 0 0px;  border: 0px solid blue; overflow:auto;">
    <%
        StringBuilder str_html = new StringBuilder();
        
        if (dt_div.Rows.Count > 0)
        {
            str_html.Append("<table style=\"width:100%;table-layout:fixed;\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr style=\"height:2px;display:none;\">");
            str_html.Append(Environment.NewLine);
            int  td_count = int.Parse( dt_form.Rows[0]["TD_COUNT"].ToString());
            for (int i = 0; i < td_count; i++)
            {
                str_html.Append("<td style=\"width:" + (100 / td_count).ToString() + "%;\">");
                str_html.Append("&nbsp;</td>");
                str_html.Append(Environment.NewLine);     
            }
            str_html.Append("</tr>");
            str_html.Append(Environment.NewLine);

            int divcount = dt_div.Rows.Count;
            if (divcount > 0)
            {
                int l_td = 0;
                for (int i = 0; i < divcount; i++)
                {
                    string DIV_HTML = dt_div.Rows[i]["DIV_HTML"].ToString();
                    string DIV_TYPE = dt_div.Rows[i]["DIV_TYPE"].ToString();
                    int td_count_div = int.Parse(dt_div.Rows[i]["TD_COUNT"].ToString());
                    if (td_count_div <= l_td)
                    {
                        l_td = l_td - td_count_div;
                    }
                    else
                    {
               
                        if (l_td > 0)
                        {
                            str_html.Append("<td colspan=" + l_td.ToString() + ">&nbsp;</td>");
                            str_html.Append(Environment.NewLine);
                        }
                      
                        if (i > 0)
                        {
                            
                            str_html.Append("</tr>");
                        }
                        str_html.Append("<tr>");
                        l_td = td_count - td_count_div;
                    }
                    if (td_count_div > 1)
                    {
                        str_html.Append("<td colspan=" + td_count_div.ToString() + " style=\"vertical-align:top;\" >");
                    }
                    else
                    {
                        str_html.Append("<td style=\"vertical-align:bottom;\" >");
                    }
                    str_html.Append(Environment.NewLine);

                    if (DIV_TYPE == "HTML")
                    {
                        str_html.Append(DIV_HTML);
                    }
                    if (DIV_TYPE == "SQL")
                    {
                        str_html.Append(DIV_HTML);
                        
                    }
                   
                    str_html.Append("</td>");
                    str_html.Append(Environment.NewLine);
                }
                if (l_td > 0)
                {
                    str_html.Append("<td colspans=" + l_td.ToString() + ">&nbsp;</td>");
                    str_html.Append(Environment.NewLine);
                }

                str_html.Append("</tr>");
                str_html.Append(Environment.NewLine);
            }
            str_html.Append("</table>");
            str_html.Append(Environment.NewLine);
            Response.Write(str_html.ToString());  
        }
         %>
     </div>
        <script>
            function set_div() {
                tmainh = getPheight() - 28;
                tmainw = getPwidth() - 5;

                $("#maindiv").height(tmainh);
                $("#maindiv").width(tmainw);

            }
            set_div();
    </script>
    </form>
</body>
</html>
