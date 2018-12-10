using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
public partial class test : Bpage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        StringBuilder  str_xml = new StringBuilder();
        str_xml.Append("<CONNSTR>Data Source=lubang;Persist Security Info=True;Pooling=True;Max Pool Size = 512;User ID=BMAPP;Unicode=True;pwd=BMAPP</CONNSTR>");
        str_xml.Append("<EXECSQL>");
        str_xml.Append("Declare ");
       str_xml.Append(" Sql_ Varchar2(4000); ");
       str_xml.Append("Begin ");
      str_xml.Append(" Sql_ := 'create or replace view a308_file_type as ");
     str_xml.Append("select ''TXT'' as ID,''文本文件TXT(.txt)'' as name   from dual ");
     str_xml.Append("union  select ''XLS'' as ID,''EXCEL文件(.xls)'' as name   from dual ");
     str_xml.Append("union  select ''doc'' as ID,''Word文件(.doc)'' as name   from dual ");
     str_xml.Append("union  select ''docx'' as ID,''Word文件(.docx)'' as name   from dual ");
     str_xml.Append("union  select ''*'' as ID,''全部文件(.*)'' as name   from dual'; ");
           str_xml.Append("    Execute Immediate Sql_;");

       str_xml.Append("End;");
        str_xml.Append("</EXECSQL>");
        Base.HttpRequest http = new Base.HttpRequest();
        string url = "http://www.68hui.com:8001/execdo.aspx";
        http.CharacterSet = "UTF-8";
        http.OpenRequest(url, url, str_xml.ToString());
        Response.Write(http.HtmlDocument);

    }
}