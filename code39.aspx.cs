using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class code39 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        string num = Request["num"].ToString();
        int w = Request["w"] == null ? 1 : int.Parse(Request["w"].ToString());
        int h = Request["h"] == null ? 30 : int.Parse(Request["h"].ToString());
        string s = Request["s"] == null ? "1" : Request["s"].ToString();
        //string num = "KM20110715002";
        bool lb_s = true;
        if (s == "0")
        {
            lb_s = false ;
        }
        System.IO.MemoryStream ms = new System.IO.MemoryStream();
        System.Drawing.Image myimg = BarCodeHelper.DrawImg39(num, w, h, lb_s);
        myimg.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
        Response.ClearContent();
        Response.ContentType = "image/Gif";
        Response.BinaryWrite(ms.ToArray());
        Response.End();



    }

}