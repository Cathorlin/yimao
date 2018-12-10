<%@ Page Language="C#" AutoEventWireup="true" CodeFile="mainbutton.aspx.cs" Inherits="HandEquip_BaseForm_mainbutton" %>

<%
    StringBuilder strbtn = new StringBuilder();
    StringBuilder strselbtn = new StringBuilder();
    StringBuilder strHtml = new StringBuilder();
    StringBuilder str = new StringBuilder();
    // string selectindex = "0";
    
    strbtn.Append("<div><input class=\"bt1\" type=\"button\" id=\"btn_save\" value=\"保存\" onclick=\"javascript:heq_save();\" ");
    if (f_save=="0")
    {
        strbtn.Append(" style=\"display:none;\" ");
    }
    strbtn.Append("/>");
    if (dt_a00201.Rows.Count > 1)
    {
        strbtn.Append("<input class=\"bt1\" type=\"button\" id=\"btn_del\" value=\"删除行\" onclick=\"javascript:heq_delrow();\" ");
        if (f_del == "0")
        {
            strbtn.Append(" style=\"display:none;\" ");
        }
        strbtn.Append(" />");
        strselbtn.Append("<div style=\" width:100%; ");
        if (dt_a00201.Rows.Count == 2)
        {
            strselbtn.Append("display:none; >");
        }
        strselbtn.Append(" \">");
        strselbtn.Append("<ul class=\"ul_btn_detail\">");
        strHtml.Append("<div style=\" width:100%;\">");
        //加载页签按钮
        for (int i = 0; i < dt_a00201.Rows.Count; i++)
        {
            if (i > 0)
            {
                strselbtn.Append("<li id=\"btn_detail_" + dt_a00201.Rows[i]["LINE_NO"].ToString() + "\" onclick=\"select_detaillist(this.id);\">");
                strselbtn.Append(dt_a00201.Rows[i]["TAB_ORIGINAL"].ToString());
                strselbtn.Append("</li>");
                strHtml.Append("<div id=\"div_detail_" + dt_a00201.Rows[i]["LINE_NO"].ToString() + "\" style=\" width:100%; overflow:auto; height:150px;  border:1px solid #AACAEE; ");
                if (i != 1)
                {
                    strHtml.Append("display:none;");
                }
                strHtml.Append(" \" ></div>");
            }
           
        }
        strselbtn.Append("</ul>");
        strselbtn.Append("</div>");
        strHtml.Append("</div>");
    }
    if (dt_a00201.Rows.Count == 1)
    {
        strselbtn.Clear();
    }

    strbtn.Append("</div>");

    str.Append(strbtn.ToString());
    str.Append(strselbtn.ToString());
    str.Append(strHtml.ToString());

    Response.Write("$(\"#div_btn\").html(\"" + str.Replace("\"", "\\\"") + "\");");

    if (dt_a00201.Rows.Count > 1)
    {
        string selectindex = dt_a00201.Rows[1]["LINE_NO"].ToString();
        Response.Write(" nowdetail_index = \"" + selectindex + "\";");
        Response.Write("loaddetaillist(nowdetail_index, menu_id, main_keyvalue);");
    }
    else {
        Response.Write(" nowdetail_index = \"0\";");
    }
%>
