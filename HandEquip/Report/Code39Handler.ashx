<%@ WebHandler Language="C#" Class="Code39Handler" %>

using System;
using System.Web;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Text;
using System.Text.RegularExpressions;

/// <summary>
/// 用 .NET 繪圖 API，搭配條碼最普遍的 Code 39 編碼規則 (一般超商的讀條碼機都可讀)，產生條碼圖檔
/// </summary>
public class Code39Handler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        
        //int huabugao = 20;//画布高
        //int huabukuan = 0;//画布宽
        
        string mycode =string.Empty;
        ////huabukuan = Int32.Parse(context.Request["w"]);
        ////huabugao = Int32.Parse(context.Request["h"]);
        string codeType=string.Empty;
        string strshowText=string.Empty;
        bool showtext = true;
        try
        {
            mycode = context.Request["code"].ToString();
            ////huabukuan = Int32.Parse(context.Request["w"]);
            ////huabugao = Int32.Parse(context.Request["h"]);
            codeType = context.Request["type"].ToString();
            strshowText = context.Request["showtext"].ToString();

        }
        catch (Exception e)
        {
            strshowText = "true";
        }
        
        if (strshowText.ToLower()=="flase")
        {
            showtext = false;
        }
       
        //string zichuan;
        //string ziyuan;
        ////zichuan = "*-%$*"
        
        //zichuan = this.GetString(mycode, codeType);    
        ////zichuan =  "*" + mycode + "*";  //Code 39 的特性是前、後置碼會標識「星號(*)」，表示開始和結束

        ////int huabugao = 20;//画布高
        ////int huabukuan = 0;//画布宽
        //int bi_x = 0;//笔画x        
        //int bi_y = 20;//笔画y,
        ////int bi_kuan = 0;//笔画宽
        //int add_x = 1;//x轴横向移动间距
        //float bi_width = 2;//笔画宽
        
        if (!string.IsNullOrEmpty(mycode))
        {
            //huabukuan = zichuan.Length * 13;

            //Bitmap BMP = new Bitmap(huabukuan, huabugao,System.Drawing.Imaging.PixelFormat.Format32bppPArgb);
            //Graphics G = Graphics.FromImage(BMP);
            //G.TextRenderingHint = TextRenderingHint.AntiAlias;
           
            //G.Clear(Color.White);

            //Brush bishua_1 = new SolidBrush(Color.White);
            //G.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            //G.FillRectangle(bishua_1, 0, 0, huabukuan, huabugao);
            if (codeType == "39")
            {
                int huabugao = 20;//画布高
                int huabukuan = 0;//画布宽

                
                //huabukuan = Int32.Parse(context.Request["w"]);
                //huabugao = Int32.Parse(context.Request["h"]);

                string zichuan;
                string ziyuan;
                //zichuan = "*-%$*"

                zichuan = this.GetString(mycode, codeType);
                //zichuan =  "*" + mycode + "*";  //Code 39 的特性是前、後置碼會標識「星號(*)」，表示開始和結束

                //int huabugao = 20;//画布高
                //int huabukuan = 0;//画布宽
                int bi_x = 0;//笔画x        
                int bi_y = 20;//笔画y,
                //int bi_kuan = 0;//笔画宽
                int add_x = 1;//x轴横向移动间距
                float bi_width = 2;//笔画宽

                huabukuan = zichuan.Length * 13;

                Bitmap BMP = new Bitmap(huabukuan, huabugao, System.Drawing.Imaging.PixelFormat.Format32bppPArgb);
                Graphics G = Graphics.FromImage(BMP);
                G.TextRenderingHint = TextRenderingHint.AntiAlias;

                G.Clear(Color.White);

                Brush bishua_1 = new SolidBrush(Color.White);
                G.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                G.FillRectangle(bishua_1, 0, 0, huabukuan, huabugao);
                
                for (int i = 0; i < zichuan.Length; i++)
                {
                    //取得 Code 39 碼的規則
                    //ziyuan = this.genBarcode(zichuan.Substring(i, 1).ToUpper());
                    ziyuan = this.Get_Ziyuan(zichuan.Substring(i, 1).ToUpper(), codeType);

                    for (int j = 0; j < 4; j++)
                    {
                        if (ziyuan.Substring(j, 1).Equals("0"))
                        {
                            //G.DrawLine(Pens.Black, bi_x, 0, bi_x, bi_y);
                            G.DrawLine(new Pen(Color.Black, bi_width), bi_x, 0, bi_x, bi_y);
                           
                        }
                        else
                        {
                            //G.DrawLine(Pens.Black, bi_x, 0, bi_x, bi_y);
                            G.DrawLine(new Pen(Color.Black, bi_width), bi_x, 0, bi_x, bi_y);
                            //G.DrawLine(Pens.Black, bi_x + 1, 0, bi_x + 1, bi_y);
                            G.DrawLine(new Pen(Color.Black, bi_width), bi_x + add_x, 0, bi_x + add_x, bi_y);
                            //bi_x += 1;
                            bi_x = bi_x + add_x;
                        }

                        //bi_x += 1;
                        bi_x = bi_x + add_x;

                        if (ziyuan.Substring(j + 5, 1).Equals("0"))
                        {
                            //G.DrawLine(Pens.White, bi_x, 0, bi_x, bi_y);
                            G.DrawLine(new Pen(Color.White,bi_width), bi_x, 0, bi_x, bi_y);
                        }
                        else
                        {
                            //G.DrawLine(Pens.White, bi_x, 0, bi_x, bi_y);
                            G.DrawLine(new Pen(Color.White, bi_width), bi_x, 0, bi_x, bi_y);
                            //G.DrawLine(Pens.White, bi_x + 1, 0, bi_x + 1, bi_y);
                            G.DrawLine(new Pen(Color.White,bi_width), bi_x + add_x, 0, bi_x + add_x, bi_y);
                            //bi_x += 1;
                            bi_x = bi_x + add_x;
                        }

                        //bi_x += 1;
                        bi_x = bi_x + add_x;
                    } //end of loop

                    if (ziyuan.Substring(4, 1).Equals("0"))
                    {
                        //G.DrawLine(Pens.Black, bi_x, 0, bi_x, bi_y);
                        G.DrawLine(new Pen(Color.Black, bi_width), bi_x, 0, bi_x, bi_y);
                    }
                    else
                    {
                        //G.DrawLine(Pens.Black, bi_x, 0, bi_x, bi_y);
                        G.DrawLine(new Pen(Color.Black, bi_width), bi_x, 0, bi_x, bi_y);
                        //G.DrawLine(Pens.Black, bi_x + 1, 0, bi_x + 1, bi_y);
                        G.DrawLine(new Pen(Color.Black, bi_width), bi_x + add_x, 0, bi_x + add_x, bi_y);
                        //bi_x += 1;
                        bi_x = bi_x + add_x;
                    }

                    //bi_x += 2;
                    bi_x = bi_x + add_x * 2;


                } //end of loop

                int x = 0;
                int addx = 10;

                G.DrawString("-", new Font("Arial", 8, FontStyle.Italic), SystemBrushes.WindowText, new PointF(x, 20));
                x += addx;

                for (int k = 0; k < mycode.Length; k++)
                {
                    G.DrawString(mycode.Substring(k, 1), new Font("Arial", 8, FontStyle.Italic), SystemBrushes.WindowText, new PointF(x, 20));
                    x = x + addx;
                }

                G.DrawString("-", new Font("Arial", 8, FontStyle.Italic), SystemBrushes.WindowText, new PointF(x, 20));
                
                //int w_ =110;
                //int h_ = 20;
                //Bitmap map = new Bitmap(w_, h_);
                //Graphics g_ = Graphics.FromImage(map);
                //g_.DrawImage(BMP, new Rectangle(0, 0, w_, h_), new Rectangle(0, 0, BMP.Width, BMP.Height), GraphicsUnit.Pixel);
                //map.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                //g_.Dispose();
                //map.Dispose();
                BMP.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                
                G.Dispose();
                BMP.Dispose();
            }
            else if (codeType=="25")
            {
                int huabugao = 20;//画布高
                int huabukuan = 0;//画布宽

               // string mycode = context.Request["code"].ToString();
                //huabukuan = Int32.Parse(context.Request["w"]);
                //huabugao = Int32.Parse(context.Request["h"]);
                //string codeType = context.Request["type"].ToString();

                string zichuan;
                string ziyuan;
                //zichuan = "*-%$*"

                zichuan = this.GetString(mycode, codeType);
                //zichuan =  "*" + mycode + "*";  //Code 39 的特性是前、後置碼會標識「星號(*)」，表示開始和結束

                //int huabugao = 20;//画布高
                //int huabukuan = 0;//画布宽
                int bi_x = 0;//笔画x        
                int bi_y = 20;//笔画y,
                //int bi_kuan = 0;//笔画宽
                int add_x = 1;//x轴横向移动间距
                float bi_width = 2;//笔画宽

                huabukuan = zichuan.Length * 13;

                Bitmap BMP = new Bitmap(huabukuan, huabugao, System.Drawing.Imaging.PixelFormat.Format32bppPArgb);
                Graphics G = Graphics.FromImage(BMP);
                G.TextRenderingHint = TextRenderingHint.AntiAlias;

                G.Clear(Color.White);

                Brush bishua_1 = new SolidBrush(Color.White);
                G.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                G.FillRectangle(bishua_1, 0, 0, huabukuan, huabugao);
                
                string ziyuan2;
                for (int i = 0; i < zichuan.Length; i++)
                {
                    //开始字符
                    if (i == 0)
                    {
                        ziyuan = Get_Ziyuan(zichuan.Substring(i, 1).ToUpper(), codeType);
                        for (int j = 0; j < 2; j++)
                        {
                            if (ziyuan.Substring(j,1).Equals("0"))
                            {
                                G.DrawLine(Pens.Black,bi_x,0,bi_x,bi_y);
                            }
                            else
                            {
                                G.DrawLine(Pens.Black,bi_x,0,bi_x,bi_y);
                                G.DrawLine(Pens.Black,bi_x+1,0,bi_x+1,bi_y);
                                bi_x = bi_x + 1;
                            }
                            bi_x = bi_x + 2;
                        }
                    }
                    //结束字符
                    else if (i == zichuan.Length - 1)
                    {
                        ziyuan = Get_Ziyuan(zichuan.Substring(i, 1).ToUpper(), codeType);
                        for (int j = 0; j < 2; j++)
                        {
                            if (ziyuan.Substring(j,1).Equals("0"))
                            {
                                G.DrawLine(Pens.Black,bi_x,0,bi_x,bi_y);
                            }
                            else
                            {
                                G.DrawLine(Pens.Black,bi_x,0,bi_x,bi_y);
                                G.DrawLine(Pens.Black,bi_x+1,0,bi_x+1,bi_y);
                                bi_x = bi_x + 1;
                            }
                            bi_x = bi_x + 2;
                        }
                    }
                    else
                    {
                        ziyuan = Get_Ziyuan(zichuan.Substring(i, 1).ToUpper(), codeType);
                        ziyuan2 = Get_Ziyuan(zichuan.Substring(i + 1, 1).ToUpper(), codeType);

                        for (int j = 0; j < 5; j++)
                        {
                            //1是粗线，0是细线
                            if (ziyuan.Substring(j, 1).Equals("0"))
                            {
                                G.DrawLine(Pens.Black, bi_x, 0, bi_x, bi_y);
                            }
                            else
                            {
                                G.DrawLine(Pens.Black, bi_x, 0, bi_x, bi_y);
                                G.DrawLine(Pens.Black, bi_x + 1, 0, bi_x + 1, bi_y);
                                bi_x += 1;
                            }
                            
                            bi_x += 1;
                            
                            if (ziyuan2.Substring(j,1).Equals("0"))
                            {
                                G.DrawLine(Pens.White,bi_x,0,bi_x,bi_y);
                            }
                            else
                            {
                                G.DrawLine(Pens.White,bi_x,0,bi_x,bi_y);
                                G.DrawLine(Pens.White,bi_x+1,0,bi_x+1,bi_y);
                                bi_x += 1;
                            }

                            bi_x =bi_x+2;
                        }
                        i += 1;
                    }
                    
                }

                int x = 0;
                int addx = 9;

                G.DrawString("-", new Font("Arial", 8, FontStyle.Italic), SystemBrushes.WindowText, new PointF(x, 20));
                x += addx;

                for (int k = 0; k < mycode.Length; k++)
                {
                    G.DrawString(mycode.Substring(k, 1), new Font("Arial", 8, FontStyle.Italic), SystemBrushes.WindowText, new PointF(x, 20));
                    x = x + addx;
                }

                G.DrawString("-", new Font("Arial", 8, FontStyle.Italic), SystemBrushes.WindowText, new PointF(x, 20));
                BMP.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                G.Dispose();
                BMP.Dispose();
            }
            else if (codeType=="128")
            {
                //string type = context.Request["c128"].ToString();//A=code128A规则，B=code128B规则，C=code128C规则，AUTO=code128混合结构，系统自动识别。
                //CreateCode128Image(context,mycode, type);

                BarCode128 bar128 = new BarCode128();
                using (Bitmap map = new Bitmap(bar128.EncodeBarcode(mycode, 160, 30, showtext)))
                {
                    map.Save(context.Response.OutputStream, ImageFormat.Jpeg);
                }
                
            }
        }
        else
        {
            int huabugao = 20;//画布高
            int huabukuan = 0;//画布宽
            
            huabukuan = 100;

            Bitmap BMP = new Bitmap(huabukuan, huabugao, System.Drawing.Imaging.PixelFormat.Format32bppPArgb);
            Graphics G = Graphics.FromImage(BMP);
            G.TextRenderingHint = TextRenderingHint.AntiAlias;
            G.Clear(Color.White);
            
            //未給參數時顯示的提示內容
            G.DrawString("无条码生产", new Font("宋体", 12, FontStyle.Regular), SystemBrushes.WindowText, new PointF(0, 20));

            BMP.Save(context.Response.OutputStream, ImageFormat.Jpeg);
            G.Dispose();
            BMP.Dispose();
        }
    }


    /// <summary>
    /// 生成128码图片
    /// </summary>
    private void CreateCode128Image( HttpContext context ,string myCode,string type) {
        if (type=="A" || type=="B")
        {
            CreateCode128ABImage_(context,myCode, type);
        }
        else if (type=="C")
        {
            CreateCode128CImage_(context, myCode,type);
        }
        else if (type=="AUTO")
        {
            CreateCode128AUTOImage_(context,myCode,type);
        }
    }

    private void CreateCode128ABImage_(HttpContext context,string myCode, string type) {
        
        string bsCode = string.Empty;//转义之后的二进制字串
        int yzCode = 0;
        int zyBar = 0;

        for (int i = 0; i < myCode.Length; i++)
        {
            bsCode = bsCode + genBarcode128(myCode.Substring(i, 1).ToString(), type, "0", yzCode);
            zyBar = zyBar + yzCode * (i + 1);
        }

        //设置起始码
        if (type=="A")
        {
            bsCode = "11010000100" + bsCode;
        }
        else if (type=="B")
        {
            bsCode = "11010010000" + bsCode;
        }
        
        //设置校验码
        //设置校验码
        zyBar = (105 + zyBar) / 103;
        bsCode = bsCode + genBarcode128(zyBar.ToString(), type, "1", yzCode);
        
        //设置结束码
        bsCode = bsCode + "11000111010";
        //画图
        CreateImage__(context, bsCode);
    }

    private void CreateCode128CImage_(HttpContext context, string myCode,string type) {
        string bsCode = string.Empty;//转义之后的二进制字串
        int yzCode = 0;//验证码
        int zyBar = 0;
        
        for (int i = 0; i < myCode.Length; i=i+2)
        {            
            bsCode = bsCode + genBarcode128(myCode.Substring(i, 2).ToString(), type,"0", yzCode);
            zyBar = zyBar + yzCode * (i / 2 + 1);
        }
        //设置起始码
        bsCode = "11010011100" + bsCode; 
        //设置校验码
        zyBar = (105 + zyBar) % 103;
        bsCode = bsCode + genBarcode128(zyBar.ToString(), type, "1", yzCode);
        //设置结束码
        bsCode = bsCode + "1100011101011"; 
        //画图
        CreateImage__(context, bsCode);
    }

    /// <summary>
    /// 混合型打印，系统自动编码打印规则
    /// </summary>
    /// <param name="context"></param>
    /// <param name="myCode"></param>
    /// <param name="type"></param>
    private void CreateCode128AUTOImage_(HttpContext context,string myCode,string type) {
        int b_c = 0;//B类型的连续个数
        int c_c = 0;//C类型的连续个数
        bool b_f = false;
        bool c_f = false;
        string strv = string.Empty;//当前连续字符串
        string strBar = string.Empty;//最终的Bar
        int zyCode = 0;
        int zyBar = 0;
        int zy_weishu = 0;//字元总位数
        bool lianxu_b = true;//B是否连续,true-不连续，false-连续
        string startType = string.Empty;//起始位置类型。B / C
        
        string v=string.Empty;

        for (int i = 0; i < myCode.Length; i++)
        {
            Regex reg=new Regex ("^[0-9]*$");
            
            v=myCode.Substring(i,1).ToString();
            if (reg.Match(v).Success) //数字格式验证
            {
                if (c_f)
                {
                    c_c = 0;
                    if (strv.Length > 0)
                    {
                        //之前的strv判断为B类型的，则字符串开始为Code B开始
                        if (i + 1 - strv.Length >= 0)
                        {
                            
                            if (i + 1 - strv.Length == 0) //已StartB为起始码类型
                            {
                                strBar = strBar + "11010010000";//StartB 起始码
                                zy_weishu = 1;//起始码
                                zyBar = zyBar + 104 * zy_weishu;
                                startType = "B";
                            }
                            else
                            {
                                if (lianxu_b)
                                {
                                    if (startType=="C")
                                    {
                                        strBar = strBar + "10111101110";//不是第一位开始的加上Code B的转义符
                                        zy_weishu = zy_weishu + 1;//字串类型标识码
                                        zyBar = zyBar + 100 * zy_weishu;
                                    }
                                    else
                                    {
                                        strBar = strBar + "11010010000";//不是第一位开始的加上Code B的转义符
                                        zy_weishu = zy_weishu + 1;//字串类型标识码
                                        zyBar = zyBar + 104 * zy_weishu;
                                    }                                 
                                }
                                
                            }                            
                        }
                        for (int j = 0; j < strv.Length; j++)
                        {
                            strBar = strBar + genBarcode128(strv.Substring(j, 1), "B", "0", zyCode);
                            zy_weishu += 1 ;
                            zyBar = zyBar + zyCode * zy_weishu;
                        }
                    }
                }
                c_c += 1;
                strv = strv + v;
                b_f = true;
                c_f = false;
                
            }
            else
            {
                if (b_f)
                {
                    b_c = 0;
                    //处理数字字串
                    if (strv.Length > 0)
                    {
                        if (i + 1 - strv.Length == 0 && strv.Length >= 4)
                        {
                            //说明是起始位置，此时为start C类型开头
                            strBar = strBar + "11010011100";
                            zy_weishu = 1;//位置设为1
                            zyBar = zyBar + 105 * zy_weishu;
                            startType = "C";

                            for (int j = 0; j < strv.Length; j=j+2)
                            {
                                strBar = strBar + genBarcode128(strv.Substring(j, 2),"C","0",zyCode);
                                zy_weishu += 1;
                                zyBar = zyBar + zyCode * zy_weishu;
                                
                                //判断是否有多余的一位
                                if (strv.Length-j+1==1)
                                {
                                    strBar = strBar + "10111101110";
                                    zy_weishu += 1;
                                    zyBar = zyBar + 100 * zy_weishu;
                                    lianxu_b = false; //字串连续
                                    break;
                                }
                            }
                        }

                        if (i+1-strv.Length==0 && strv.Length<4)
                        {
                            //说明是起始位置，但是数字长度没超过4为，用C类型不划算,还是采用B类型
                            strBar = strBar + "11010010000";
                            zy_weishu = 1;
                            zyBar = zyBar + 104 * zy_weishu;
                            startType = "B";

                            for (int j = 0; j < strv.Length; j++)
                            {
                                strBar = strBar + genBarcode128(strBar.Substring(j,1),"B","0",zyCode);
                                zy_weishu += 1;
                                zyBar = zyBar + zyCode * zy_weishu;
                            }

                            lianxu_b = false;//字串连续
                        }

                        if (i+1-strv.Length>0 && strv.Length>=4)
                        {
                            //说明是中间位置，数字长度超过4为，采用C类型，
                            strBar = strBar + "";
                        }
                    }
                }
                
                b_c += 1;
                strv = strv + v;
                b_f = false;
                c_f = true;
            }
        }
    }
    
    private void CreateImage__(HttpContext context, string bsCode) {
        int width = 110;
        int height = 20;
        int x = 0;
        int y = 15;
        int b_w = 1;
        string zi_yuan = string.Empty;
        using (Bitmap map = new Bitmap(width, height))
        {


            using (Graphics g = Graphics.FromImage(map))
            {
                g.Clear(Color.White);

                for (int i = 0; i < bsCode.Length; i++)
                {
                    zi_yuan = bsCode.Substring(i, 1);
                    //g.FillRectangle(zi_yuan == "0" ? System.Drawing.Brushes.White : System.Drawing.Brushes.Black, x, 0, b_w, y);
                    g.DrawLine(new Pen(zi_yuan == "0" ? System.Drawing.Brushes.White : System.Drawing.Brushes.Black,b_w),x,0,x,y);
                    x = x + b_w;
                }


            }
            map.Save(context.Response.OutputStream, ImageFormat.Jpeg);
        }
    }


    // 規則可參考網址 1：http://blog.csdn.net/xuzhongxuan/archive/2008/05/28/2489358.aspx
    // 規則可參考網址 2：http://blog.163.com/zryou/blog/static/6903184200971704226450/
    /// <summary>
    /// Code 39 碼的規則。
    /// Code 39 碼可使用的ziyuan如下：0~9、A~Z、+、-、*、/、%、$、. 及空白ziyuan。    
    /// </summary>
    /// <param name="code"></param>
    /// <returns></returns>
    public string genBarcode(string code)
    {
        switch (code)
        {
            case "0":
                code = "001100100";
                break;
            case "1":
                code = "100010100";
                break;
            case "2":
                code = "010010100";
                break;
            case "3":
                code = "110000100";
                break;
            case "4":
                code = "001010100";
                break;
            case "5":
                code = "101000100";
                break;
            case "6":
                code = "011000100";
                break;
            case "7":
                code = "000110100";
                break;
            case "8":
                code = "100100100";
                break;
            case "9":
                code = "010100100";
                break;
            case "A":
                code = "100010010";
                break;
            case "B":
                code = "010010010";
                break;
            case "C":
                code = "110000010";
                break;
            case "D":
                code = "001010010";
                break;
            case "E":
                code = "101000010";
                break;
            case "F":
                code = "011000010";
                break;
            case "G":
                code = "000110010";
                break;
            case "H":
                code = "100100010";
                break;
            case "I":
                code = "010100010";
                break;
            case "J":
                code = "001100010";
                break;
            case "K":
                code = "100010001";
                break;
            case "L":
                code = "010010001";
                break;
            case "M":
                code = "110000001";
                break;
            case "N":
                code = "001010001";
                break;
            case "O":
                code = "101000001";
                break;
            case "P":
                code = "011000001";
                break;
            case "Q":
                code = "000110001";
                break;
            case "R":
                code = "100100001";
                break;
            case "S":
                code = "010100001";
                break;
            case "T":
                code = "001100001";
                break;
            case "U":
                code = "100011000";
                break;
            case "V":
                code = "010011000";
                break;
            case "W":
                code = "110001000";
                break;
            case "X":
                code = "001011000";
                break;
            case "Y":
                code = "101001000";
                break;
            case "Z":
                code = "011001000";                        
                break;
            case "*":
                code = "001101000";
                break;
            case "-":
                code = "000111000"; //好像辨識不出來
                break;
            case "%":
                code = "100101000"; //好像辨識不出來
                break;
            case "$":
                code = "010101000"; //好像辨識不出來
                break;
            default:
                code = "010101000"; //都不是就印 $
                break;
        }
        
        return code;
    }

    /// <summary>
    /// Code 25 碼的規則。
    /// Code 25 碼可使用的ziyuan如下：0~9、A~Z、+、-、*、/、%、$、. 及空白ziyuan。    
    /// </summary>
    /// <param name="code"></param>
    /// <returns></returns>
    public string genBarcode25(string code)
    {
        switch (code)
        {
            case "0":
                code = "00110";
                break;
            case "1":
                code = "10001";
                break;
            case "2":
                code = "01001";
                break;
            case "3":
                code = "11000";
                break;
            case "4":
                code = "00101";
                break;
            case "5":
                code = "10100";
                break;
            case "6":
                code = "01100";
                break;
            case "7":
                code = "00011";
                break;
            case "8":
                code = "10010";
                break;
            case "9":
                code = "01010";
                break;
            case "S"://起始码
                code = "00";
                break;
            case "E"://结束码
                code = "10"; //好像辨識不出來
                break;
            default:
                code = "01010"; //都不是就印 $
                break;
        }

        return code;
    }

    /// <summary>
    /// 128码转义字符
    /// </summary>
    /// <param name="code"></param>
    /// <returns></returns>
    public string genBarcode128(string code,string codetype,string yztype,int yzCode) {
        code = getBarcode128__(code, codetype, yztype,yzCode);
       
        
        return code;
    }

    private string getBarcode128__(string code,string type,string yz,int yzCode) {
        string tc=string.Empty;
        if (yz =="1") //0标识
        {
            tc = type + "-" + code + "-" + yz;
        }
        else
        {
            tc = type + "-" + code;
        }
        switch (tc)
        {
            case "A-0-1":
            case "B-0-1":
            case "C-0-1":
            case "C-00":
                code = "11011001100";
                yzCode = 0;
                break;
            case "A-1-1":
            case "B-1-1":
            case "C-1-1":            
            case "A-!":
            case "B-!":
            case "C-01":
                code = "11001101100";
                yzCode = 1;
                break;
            case "A-2-1":
            case "B-2-1":
            case "C-2-1":
            case "A-\"":
            case "B-\"":
            case "C-02":
                code = "11001100110";
                yzCode = 2;
                break;
            case "A-3-1":
            case "B-3-1":
            case "C-3-1":
            case "A-#":
            case "B-#":
            case "C-03":
                code = "10010011000";
                yzCode = 3;
                break;
            case "A-4-1":
            case "B-4-1":
            case "C-4-1":
            case "A-$":
            case "B-$":
            case "C-04":
                code = "10010001100";
                yzCode = 4;
                break;
            case "A-5-1":
            case "B-5-1":
            case "C-5-1":
            case "A-%":
            case "B-%":
            case "C-05":
                code = "10001001100";
                yzCode = 5;
                break;
            case "A-6-1":
            case "B-6-1":
            case "C-6-1":
            case "A-&":
            case "B-&":
            case "C-06":
                code = "10011001000";
                yzCode = 6;
                break;
            case "A-7-1":
            case "B-7-1":
            case "C-7-1":
            case "A-'":
            case "B-'":
            case "C-07":
                code = "10011000100";
                yzCode = 7;
                break;
            case "A-8-1":
            case "B-8-1":
            case "C-8-1":
            case "A-(":
            case "B-(":
            case "C-08":
                code = "10001100100";
                yzCode = 8;
                break;
            case "A-9-1":
            case "B-9-1":
            case "C-9-1":
            case "A-)":
            case "B-)":
            case "C-09":
                code = "11001001000";
                yzCode = 9;
                break;
            case "A-10-1":
            case "B-10-1":
            case "C-10-1":
            case "A-*":
            case "B-*":
            case "C-10":
                code = "11001000100";
                yzCode = 10;
                break;
            case "A-11-1":
            case "B-11-1":
            case "C-11-1":
            case "A-+":
            case "B-+":
            case "C-11":
                code = "11000100100";
                yzCode = 11;
                break;
            case "A-12-1":
            case "B-12-1":
            case "C-12-1":
            case "A-,":
            case "B-,":
            case "C-12":
                code = "10110011100";
                yzCode = 12;
                break;
            case "A-13-1":
            case "B-13-1":
            case "C-13-1":
            case "A--":
            case "B--":
            case "C-13":
                code = "10011011100";
                yzCode = 13;
                break;
            case "A-14-1":
            case "B-14-1":
            case "C-14-1":
            case "A-.":
            case "B-.":
            case "C-14":
                code = "10011001110";
                yzCode = 14;
                break;
            case "A-15-1":
            case "B-15-1":
            case "C-15-1":
            case "A-/":
            case "B-/":
            case "C-15":
                code = "10111001100";
                yzCode = 15; 
                break;
            case "A-16-1":
            case "B-16-1":
            case "C-16-1":
            case "A-0":
            case "B-0":
            case "C-16":
                code = "10011101100";
                yzCode = 16;
                break;
            case "A-17-1":
            case "B-17-1":
            case "C-17-1":
            case "A-1":
            case "B-1":
            case "C-17":
                code = "10011100110";
                yzCode = 17;
                break;
            case "A-18-1":
            case "B-18-1":
            case "C-18-1":
            case "A-2":
            case "B-2":
            case "C-18":
                code = "11001110010";
                yzCode = 18;
                break;
            case "A-19-1":
            case "B-19-1":
            case "C-19-1":
            case "A-3":
            case "B-3":
            case "C-19":
                code = "11001011100";
                yzCode = 19;
                break;
            case "A-20-1":
            case "B-20-1":
            case "C-20-1":
            case "A-4":
            case "B-4":
            case "C-20":
                code = "11001001110";
                yzCode = 20;
                break;
            case "A-21-1":
            case "B-21-1":
            case "C-21-1":
            case "A-5":
            case "B-5":
            case "C-21":
                code = "11011100100";
                yzCode = 21;
                break;
            case "A-22-1":
            case "B-22-1":
            case "C-22-1":
            case "A-6":
            case "B-6":
            case "C-22":
                code = "11001110100";
                yzCode = 22;
                break;
            case "A-23-1":
            case "B-23-1":
            case "C-23-1":
            case "A-7":
            case "B-7":
            case "C-23":
                code = "11101101110";
                yzCode = 23;
                break;
            case "A-24-1":
            case "B-24-1":
            case "C-24-1":
            case "A-8":
            case "B-8":
            case "C-24":
                code = "11101001100";
                yzCode = 24;
                break;
            case "A-25-1":
            case "B-25-1":
            case "C-25-1":
            case "A-9":
            case "B-9":
            case "C-25":
                code = "11100101100";
                yzCode = 25;
                break;
            case "A-26-1":
            case "B-26-1":
            case "C-26-1":
            case "A-:":
            case "B-:":
            case "C-26":
                code = "11100100110";
                yzCode = 26;
                break;
            case "A-27-1":
            case "B-27-1":
            case "C-27-1":
            case "A-;":
            case "B-;":
            case "C-27":
                code = "11101100100";
                yzCode = 27;
                break;
            case "A-28-1":
            case "B-28-1":
            case "C-28-1":
            case "A-<":
            case "B-<":
            case "C-28":
                code = "11100110100";
                yzCode = 28;
                break;
            case "A-29-1":
            case "B-29-1":
            case "C-29-1":
            case "A-=":
            case "B-=":
            case "C-29":
                code = "11100110010";
                yzCode = 29;
                break;
            case "A-30-1":
            case "B-30-1":
            case "C-30-1":
            case "A->":
            case "B->":
            case "C-30":
                code = "11011011000";
                yzCode = 30;
                break;
            case "A-31-1":
            case "B-31-1":
            case "C-31-1":
            case "A-?":
            case "B-?":
            case "C-31":
                code = "11011000110";
                yzCode = 31;
                break;
            case "A-32-1":
            case "B-32-1":
            case "C-32-1":
            case "A-@":
            case "B-@":
            case "C-32":
                code = "11000110110";
                yzCode = 32;
                break;
            case "A-33-1":
            case "B-33-1":
            case "C-33-1":
            case "A-A":
            case "B-A":
            case "C-33":
                code = "10100011000";
                yzCode = 33; 
                break;
            case "A-34-1":
            case "B-34-1":
            case "C-34-1":
            case "A-B":
            case "B-B":
            case "C-34":
                code = "10001011000";
                yzCode = 34;
                break;
            case "A-35-1":
            case "B-35-1":
            case "C-35-1":
            case "A-C":
            case "B-C":
            case "C-35":
                code = "10001000110";
                yzCode = 35;
                break;
            case "A-36-1":
            case "B-36-1":
            case "C-36-1":
            case "A-D":
            case "B-D":
            case "C-36":
                code = "10110001000";
                yzCode = 36;
                break;
            case "A-37-1":
            case "B-37-1":
            case "C-37-1":
            case "A-E":
            case "B-E":
            case "C-37":
                code = "10001101000";
                yzCode = 37;
                break;
            case "A-38-1":
            case "B-38-1":
            case "C-38-1":
            case "A-F":
            case "B-F":
            case "C-38":
                code = "10001100010";
                yzCode = 38;
                break;
            case "A-39-1":
            case "B-39-1":
            case "C-39-1":
            case "A-G":
            case "B-G":
            case "C-39":
                code = "11010001000";
                yzCode = 39;
                break;
            case "A-40-1":
            case "B-40-1":
            case "C-40-1":
            case "A-H":
            case "B-H":
            case "C-40":
                code = "11000101000";
                yzCode = 40;
                break;
            case "A-41-1":
            case "B-41-1":
            case "C-41-1":
            case "A-I":
            case "B-I":
            case "C-41":
                code = "11000100010";
                yzCode = 41;
                break;
            case "A-42-1":
            case "B-42-1":
            case "C-42-1":
            case "A-J":
            case "B-J":
            case "C-42":
                code = "10110111000";
                yzCode = 42;
                break;
            case "A-43-1":
            case "B-43-1":
            case "C-43-1":
            case "A-K":
            case "B-K":
            case "C-43":
                code = "10110001110";
                yzCode = 43;
                break;
            case "A-44-1":
            case "B-44-1":
            case "C-44-1":
            case "A-L":
            case "B-L":
            case "C-44":
                code = "10001101110";
                yzCode = 44;
                break;
            case "A-45-1":
            case "B-45-1":
            case "C-45-1":
            case "A-M":
            case "B-M":
            case "C-45":
                code = "10111011000";
                yzCode = 45;
                break;
            case "A-46-1":
            case "B-46-1":
            case "C-46-1":
            case "A-N":
            case "B-N":
            case "C-46":
                code = "10111000110";
                yzCode = 46;
                break;
            case "A-47-1":
            case "B-47-1":
            case "C-47-1":
            case "A-O":
            case "B-O":
            case "C-47":
                code = "10001110110";
                yzCode = 47;
                break;
            case "A-48-1":
            case "B-48-1":
            case "C-48-1":
            case "A-P":
            case "B-P":
            case "C-48":
                code = "11101110110";
                yzCode = 48;
                break;
            case "A-49-1":
            case "B-49-1":
            case "C-49-1":
            case "A-Q":
            case "B-Q":
            case "C-49":
                code = "11010001110";
                yzCode = 49;
                break;
            case "A-50-1":
            case "B-50-1":
            case "C-50-1":
            case "A-R":
            case "B-R":
            case "C-50":
                code = "11000101110";
                yzCode = 50;
                break;
            case "A-51-1":
            case "B-51-1":
            case "C-51-1":
            case "A-S":
            case "B-S":
            case "C-51":
                code = "11011101000";
                yzCode = 51;
                break;
            case "A-52-1":
            case "B-52-1":
            case "C-52-1":
            case "A-T":
            case "B-T":
            case "C-52":
                code = "11011100010";
                yzCode = 52;
                break;
            case "A-53-1":
            case "B-53-1":
            case "C-53-1":
            case "A-U":
            case "B-U":
            case "C-53":
                code = "11011101110";
                yzCode = 53;
                break;
            case "A-54-1":
            case "B-54-1":
            case "C-54-1":
            case "A-V":
            case "B-V":
            case "C-54":
                code = "11101011000";
                yzCode = 54;
                break;
            case "A-55-1":
            case "B-55-1":
            case "C-55-1":
            case "A-W":
            case "B-W":
            case "C-55":
                code = "11101000110";
                yzCode = 55;
                break;
            case "A-56-1":
            case "B-56-1":
            case "C-56-1":
            case "A-X":
            case "B-X":
            case "C-56":
                code = "11100010110";
                yzCode = 56;
                break;
            case "A-57-1":
            case "B-57-1":
            case "C-57-1":
            case "A-Y":
            case "B-Y":
            case "C-57":
                code = "11101101000";
                yzCode = 57;
                break;
            case "A-58-1":
            case "B-58-1":
            case "C-58-1":
            case "A-Z":
            case "B-Z":
            case "C-58":
                code = "11101100010";
                yzCode = 58;
                break;
            case "A-59-1":
            case "B-59-1":
            case "C-59-1":
            case "A-[":
            case "B-[":
            case "C-59":
                code = "11100011010";
                yzCode = 59;
                break;
            case "A-60-1":
            case "B-60-1":
            case "C-60-1":
            case "A-\\":
            case "B-\\":
            case "C-60":
                code = "11101111010";
                yzCode = 60;
                break;
            case "A-61-1":
            case "B-61-1":
            case "C-61-1":
            case "A-]":
            case "B-]":
            case "C-61":
                code = "11001000010";
                yzCode = 61;
                break;
            case "A-62-1":
            case "B-62-1":
            case "C-62-1":
            case "A-^":
            case "B-^":
            case "C-62":
                code = "11110001010";
                yzCode = 62;
                break;
            case "A-63-1":
            case "B-63-1":
            case "C-63-1":
            case "A-_":
            case "B-_":
            case "C-63":
                code = "10100110000";
                yzCode = 63;
                break;
            case "A-64-1":
            case "B-64-1":
            case "C-64-1":
            case "B-`":
            case "C-64":
                code = "10100001100";
                yzCode = 64;
                break;
            case "A-65-1":
            case "B-65-1":
            case "C-65-1":
            case "B-a":
            case "C-65":
                code = "10010110000";
                yzCode = 65;
                break;
            case "A-66-1":
            case "B-66-1":
            case "C-66-1":
            case "B-b":
            case "C-66":
                code = "10010000110";
                yzCode = 66;
                break;
            case "A-67-1":
            case "B-67-1":
            case "C-67-1":
            case "B-c":
            case "C-67":
                code = "10000101100";
                yzCode = 67;
                break;
            case "A-68-1":
            case "B-68-1":
            case "C-68-1":
            case "B-d":
            case "C-68":
                code = "10000100110";
                yzCode = 68;
                break;
            case "A-69-1":
            case "B-69-1":
            case "C-69-1":
            case "B-e":
            case "C-69":
                code = "10110010000";
                yzCode = 69;
                break;
            case "A-70-1":
            case "B-70-1":
            case "C-70-1":
            case "B-f":
            case "C-70":
                code = "10110000100";
                yzCode = 70;
                break;
            case "A-71-1":
            case "B-71-1":
            case "C-71-1":
            case "B-g":
            case "C-71":
                code = "10011010000";
                yzCode = 71;
                break;
            case "A-72-1":
            case "B-72-1":
            case "C-72-1":
            case "B-h":
            case "C-72":
                code = "10011000010";
                yzCode = 72;
                break;
            case "A-73-1":
            case "B-73-1":
            case "C-73-1":
            case "B-i":
            case "C-73":
                code = "10000110100";
                yzCode = 73;
                break;
            case "A-74-1":
            case "B-74-1":
            case "C-74-1":
            case "B-j":
            case "C-74":
                code = "10000110010";
                yzCode = 74;
                break;
            case "A-75-1":
            case "B-75-1":
            case "C-75-1":
            case "B-k":
            case "C-75":
                code = "11000010010";
                yzCode = 75;
                break;
            case "A-76-1":
            case "B-76-1":
            case "C-76-1":
            case "B-l":
            case "C-76":
                code = "11001010000";
                yzCode = 76;
                break;
            case "A-77-1":
            case "B-77-1":
            case "C-77-1":
            case "B-m":
            case "C-77":
                code = "11110111010";
                yzCode = 77;
                break;
            case "A-78-1":
            case "B-78-1":
            case "C-78-1":
            case "B-n":
            case "C-78":
                code = "11000010100";
                yzCode = 78;
                break;
            case "A-79-1":
            case "B-79-1":
            case "C-79-1":
            case "B-o":
            case "C-79":
                code = "10001111010";
                yzCode = 79;
                break;
            case "A-80-1":
            case "B-80-1":
            case "C-80-1":
            case "B-p":
            case "C-80":
                code = "10100111100";
                yzCode = 80;
                break;
            case "A-81-1":
            case "B-81-1":
            case "C-81-1":
            case "B-q":
            case "C-81":
                code = "10010111100";
                yzCode = 81;
                break;
            case "A-82-1":
            case "B-82-1":
            case "C-82-1":
            case "B-r":
            case "C-82":
                code = "10010011110";
                yzCode = 82;
                break;
            case "A-83-1":
            case "B-83-1":
            case "C-83-1":
            case "B-s":
            case "C-83":
                code = "10111100100";
                yzCode = 83;
                break;
            case "A-84-1":
            case "B-84-1":
            case "C-84-1":
            case "B-t":
            case "C-84":
                code = "10011110100";
                yzCode = 84;
                break;
            case "A-85-1":
            case "B-85-1":
            case "C-85-1":
            case "B-u":
            case "C-85":
                code = "10011110010";
                yzCode = 85;
                break;
            case "A-86-1":
            case "B-86-1":
            case "C-86-1":
            case "B-v":
            case "C-86":
                code = "11110100100";
                yzCode = 86;
                break;
            case "A-87-1":
            case "B-87-1":
            case "C-87-1":
            case "B-w":
            case "C-87":
                code = "11110010100";
                yzCode = 87;
                break;
            case "A-88-1":
            case "B-88-1":
            case "C-88-1":
            case "B-x":
            case "C-88":
                code = "11110010010";
                yzCode = 88;
                break;
            case "A-89-1":
            case "B-89-1":
            case "C-89-1":
            case "B-y":
            case "C-89":
                code = "11011011110";
                yzCode = 89;
                break;
            case "A-90-1":
            case "B-90-1":
            case "C-90-1":
            case "B-z":
            case "C-90":
                code = "11011110110";
                yzCode = 90;
                break;
            case "A-91-1":
            case "B-91-1":
            case "C-91-1":
            case "B-{":
            case "C-91":
                code = "11110110110";
                yzCode = 91;
                break;
            case "A-92-1":
            case "B-92-1":
            case "C-92-1":
            case "B-|":
            case "C-92":
                code = "10101111000";
                yzCode = 92;
                break;
            case "A-93-1":
            case "B-93-1":
            case "C-93-1":
            case "B-}":
            case "C-93":
                code = "10100011110";
                yzCode = 93;
                break;
            case "A-94-1":
            case "B-94-1":
            case "C-94-1":
            case "B-~":
            case "C-94":
                code = "10001011110";
                yzCode = 94;
                break;
            case "A-95-1":
            case "B-95-1":
            case "C-95-1":
            case "C-95":
                code = "10111101000";
                yzCode = 95;
                break;
            case "A-96-1":
            case "B-96-1":
            case "C-96-1":
            case "C-96":
                code = "10111100010";
                yzCode = 96;
                break;
            case "A-97-1":
            case "B-97-1":
            case "C-97-1":
            case "C-97":
                code = "11110101000";
                yzCode = 97;
                break;
            case "A-98-1":
            case "B-98-1":
            case "C-98-1":
            case "C-98":
                code = "11110100010";
                yzCode = 98;
                break;
            case "A-99-1":
            case "B-99-1":
            case "C-99-1":
            case "C-99":
                code = "10111011110";
                yzCode = 99;
                break;
            case "A-100-1":
            case "B-100-1":
            case "C-100-1":
            case "C-100":
                code = "10111101110";
                yzCode = 100;
                break;
            case "A-101-1":
            case "B-101-1":
            case "C-101-1":
            case "C-101":
                code = "11101011110";
                yzCode = 101;
                break;
            case "A-102-1":
            case "B-102-1":
            case "C-102-1":
            case "C-102":
                code = "11110101110";
                yzCode = 102;
                break;
            case "A-103-1":
            case "B-103-1":
            case "C-103-1":
            case "C-103":
                code = "11010000100";
                yzCode = 103;
                break;
            case "A-104-1":
            case "B-104-1":
            case "C-104-1":
            case "C-104":
                code = "11010010000";
                yzCode = 104;
                break;
            case "A-105-1":
            case "B-105-1":
            case "C-105-1":
            case "C-105":
                code = "11010011100";
                yzCode = 105;
                break;           
            default:
                break;
        }
        return code;
    }
    
    /// <summary>
    /// 按照编码类型生成起始字符。
    /// </summary>
    /// <param name="code"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    public string GetString(string code,string type) {
        string result = string.Empty;
        
        switch (type)
        {
            case "39":
                result = "*" + code + "*";
                break;
            case "25":
                result = "s" + code + "e";
                break;                  

            default:
                break;
        }
        return result;
    }

    /// <summary>
    /// 根据编码类型自动解析字元。
    /// </summary>
    /// <param name="code"></param>
    /// <param name="codeType"></param>
    /// <returns></returns>
    public string Get_Ziyuan(string code, string codeType) {
        string result = string.Empty;
        switch (codeType)
        {
            case "39":
                result = genBarcode(code);
                break;
            case "25":
                result = genBarcode25(code);
                break;
            default:
                break;
        }
        return result;
        
    }
    
    public bool IsReusable {
        get {
            return false;
        }
    }

}