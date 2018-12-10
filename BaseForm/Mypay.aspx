<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mypay.aspx.cs" Inherits="BaseForm_Mypay" %>
<%//发送支付请求
     string req_url = BaseFun.getAllHyperLinks(RequestXml, "<URL>", "</URL>")[0].Value;
        string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;
        string SELECTEDROWLIST = "";

        if (req_id == "EXEC")
        {

        }   
 %>