<%@ WebHandler Language="C#" Class="ShowHtml" %>

using System;
using System.Web;
using System.Web.UI;

public class ShowHtml : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Write("Hello World");
    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}