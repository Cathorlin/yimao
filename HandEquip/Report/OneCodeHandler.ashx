<%@ WebHandler Language="C#" Class="OneCodeHandler" %>

using System;
using System.Web;
using System.Drawing;
using System.Drawing.Imaging;

/*
 一般处理程序重要是用于生成动态图片等信息
 本程序重要用于生成动态一维条码信息
 */
public class OneCodeHandler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        
        //获取条码字符串
        string str_code = context.Request["code"].ToString();
        //长宽比例
        double hb_wh = double.Parse(context.Request["hb_wh"]);
        //画布宽
        //int hb_width =(int)(double.Parse(context.Request["hb_width"]));
         //画布高
        //int hb_height = (int)(hb_width / hb_wh);
        //定义线条宽度,以像素为单位
        //double line_width = Double.Parse(context.Request["line_width"]);
        //是否显示字符
        bool f_showcode = true;
        //放大倍数
        int bs = Int32.Parse(context.Request["bs"]);
        string str_showcode = context.Request["f_showcode"].ToString().ToUpper();
        if (str_showcode=="FALSE")
        {
            f_showcode = false;
        }
        //条码类型
        string code_type = context.Request["code_type"].ToString().ToUpper();
        
        //标准128码
         if (code_type=="CODE128")
        {
            Bar_Code128 bar128 = new Bar_Code128();   
            Image img = bar128.ShowBarCode(str_code, f_showcode, hb_wh, bs);
            //hb_height = (int)((img.Height / img.Width) * hb_width);
            //定义图片
            //using (Bitmap bitmap = new Bitmap(hb_width, hb_height))
            using (Bitmap bitmap = new Bitmap(img.Width, img.Height))
            {
                //定义画布
                using (Graphics g = Graphics.FromImage(bitmap))
                {
                    g.Clear(Color.White);//清空画布
                    g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                    g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.GammaCorrected;
                    g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;                    
                                      
                    //g.DrawImage(img, new Rectangle(0, 0, hb_width, hb_height), new Rectangle(0, 0, img.Width, img.Height), GraphicsUnit.Pixel);//绘画条形码
                    //Rectangle to_ectangle = new Rectangle(0, 0, hb_width, hb_height);
                    //g.DrawImage(img, to_ectangle, 0, 0, img.Width, img.Height, GraphicsUnit.Pixel);
                    g.DrawImage(img, 0, 0);
                    bitmap.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                }
            }
        }
         //交叉25码
         if (code_type == "ITF25")
         {
             Bar_ITF25 bar25 = new Bar_ITF25();
             Image img = bar25.ShowBarCode(str_code, f_showcode, hb_wh, bs);
             //hb_height = (int)((img.Height / img.Width) * hb_width);
             //定义图片
             //using (Bitmap bitmap = new Bitmap(hb_width, hb_height))
             using (Bitmap bitmap = new Bitmap(img.Width, img.Height))
             {
                 //定义画布
                 using (Graphics g = Graphics.FromImage(bitmap))
                 {
                     g.Clear(Color.White);//清空画布
                     g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                     g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.GammaCorrected;
                     g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High;

                     //g.DrawImage(img, new Rectangle(0, 0, hb_width, hb_height), new Rectangle(0, 0, img.Width, img.Height), GraphicsUnit.Pixel);//绘画条形码
                     //Rectangle to_ectangle = new Rectangle(0, 0, hb_width, hb_height);
                     //g.DrawImage(img, to_ectangle, 0, 0, img.Width, img.Height, GraphicsUnit.Pixel);
                     g.DrawImage(img, 0, 0);
                     bitmap.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                 }
             }
         }
        
         
        
        //context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}