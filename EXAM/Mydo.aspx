<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mydo.aspx.cs" Inherits="EXAM_Mydo" %>

<%
    string req_id = BaseFun.getAllHyperLinks(RequestXml, "<REQID>", "</REQID>")[0].Value;
    if (req_id == "DOLINE")
    {
        string line_no = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
        string Q103ID = BaseFun.getAllHyperLinks(RequestXml, "<Q103ID>", "</Q103ID>")[0].Value;
        string MAINKEY = BaseFun.getAllHyperLinks(RequestXml, "<MAINKEY>", "</MAINKEY>")[0].Value;
        //
        string sql = "update Q10301 t set state ='1',t.qresult='" + MAINKEY + "',modi_date = sysdate ,modi_user = '" + GlobeAtt.A007_KEY + "' where t.q103_id='" + Q103ID + "' and line_no=" + line_no;
        Fun.execSqlOnly(sql);
         
    }
    if (req_id == "CHECKLOGIN")
    {
        string CODE = BaseFun.getAllHyperLinks(RequestXml, "<CODE>", "</CODE>")[0].Value;
        string user_id = BaseFun.getAllHyperLinks(RequestXml, "<USERID>", "</USERID>")[0].Value;
        string pass = BaseFun.getAllHyperLinks(RequestXml, "<PASS>", "</PASS>")[0].Value;
        string scode = "";
        try
        {
            scode = Session["verifycode"].ToString();

        }
        catch
        {
            scode = "";
        }
        //登录
        BaseLogin BLogin = new BaseLogin("2", user_id, pass, "1");
        string ls_login = BLogin.checkUserLogin();
        if (ls_login.IndexOf("02") == 0)
        {
            ls_login = "02[HTTP_URL]/EXAM/default.aspx";
           // Response.Write("doNext('" + ls_login + "')");
        }
        return;

    }
  %>
