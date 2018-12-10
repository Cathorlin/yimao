<%@ WebHandler Language="C#" Class="code39" %>

using System;
using System.Web;

public class code39 : IHttpHandler {    
       
    public void ProcessRequest (HttpContext context) {
        string num = context.Request["num"].ToString();
        int w = context.Request["w"] == null ? 1 : int.Parse(context.Request["w"].ToString());
        int h = context.Request["h"] == null ? 30 : int.Parse(context.Request["h"].ToString());
        string s = context.Request["s"] == null ? "1" : context.Request["s"].ToString();
        //string num = "KM20110715002";
        bool lb_s = true;
        if (s == "0")
        {
            lb_s = false ;
        }
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        System.Drawing.Image myimg = BarCodeHelper.DrawImg39(num, w, h, lb_s);
        myimg.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
        context.Response.ClearContent();
        context.Response.ContentType = "image/Gif";
        context.Response.BinaryWrite(ms.ToArray());
        context.Response.End();
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}