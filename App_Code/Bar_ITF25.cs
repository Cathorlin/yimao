using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;

/// <summary>
///Bar_ITF25 的摘要说明
///交叉25码
/// </summary>
public class Bar_ITF25
{   
    //定义0-9 ；1标识宽条，0标识窄条
    private string[] CodeEncoding = new string[] { "00110", "10001", "01001", "11000", "00101", "10100", "01100", "00011", "10010", "01010" };
    private const string CodeStart = "0000";//起始码
    private const string CodeEnd = "1000";//结束码
	public Bar_ITF25()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}
    public Image ShowBarCode(string str_code, bool f_showcode, double hb_wh, int bs)
    {
        if (string.IsNullOrEmpty(str_code))
        {
            new Exception("条码不能为空！");
        }
        //获取条码图片
        Image img = ShowBarCode2(str_code, f_showcode, hb_wh, bs);
        return img;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="str_code">条码字符串</param>
    /// <param name="f_showcode">是否显示字符</param>
    /// <param name="hb_wh">宽/高比例</param>
    /// <param name="bs">放大倍数或者是线的宽度</param>
    /// <returns></returns>
    private Image ShowBarCode2(string str_code, bool f_showcode, double hb_wh, int bs)
    {
        //判断字符串是否是偶数位，如果是奇数位，在首位补充一位0
        if (str_code.Length%2==1)
        {
            str_code = "0" + str_code;
        }
        string code_string = Get_CodeString(str_code);
        //图片宽度
        int width = (str_code.Length * 2 * 2 + str_code.Length * 3 + 4 + 4 +1) * bs;
        int height = (int)(width / hb_wh);
        Bitmap bitmap = new Bitmap(width, height);
        using (Graphics grap = Graphics.FromImage(bitmap))
        {
            width = DrawBarCode(grap, code_string, str_code, f_showcode, width, height,bs);
            //剪切多余的空白
            Bitmap bitmap2 = new Bitmap(width, height);
            using (Graphics grap2 = Graphics.FromImage(bitmap2))
            {
                grap2.DrawImage(bitmap, 0, 0);
                return bitmap2;
            }
        }
      
        ////拆分条码，根据ABC3中原则自动转换
        //List<int> list_code = Get_ListCode(str_code);
        ////转化成二进制编码
        //string list_codestring = Get_CodeString(list_code);
        ////画图，根据二进制码1或0分别画黑线和白线。宽为1*10像素，高为20*10像素
        //int width = list_codestring.Length * bs;
        //int height = (int)(width / hb_wh);
        //Bitmap bitmap = new Bitmap(width, height);
        //using (Graphics grap = Graphics.FromImage(bitmap))
        //{
        //    width = DrawBarCode(grap, list_codestring, str_code, f_showcode, width, height);
        //    //剪切多余的空白
        //    Bitmap bitmap2 = new Bitmap(width, height);
        //    using (Graphics grap2 = Graphics.FromImage(bitmap2))
        //    {
        //        grap2.DrawImage(bitmap, 0, 0);
        //        return bitmap2;
        //    }
        //}

    }

    private int DrawBarCode(Graphics g, string code_string, string str_code, bool f_showcode, int width, int height, int bs)
    {
        float code_width = 0;
        //画图，根据二进制码1或0分别画黑线和白线。宽为1*10像素，高为20*10像素,字体高100px
        float x, y, line_width, line_height, font_height;
        x = 0;
        y = 0;
        line_width = bs;
        line_height = height;
        font_height = 0;
        //显示字符串
        if (f_showcode)
        {
            line_height = height / 2;
            font_height = height - line_height;
            Font font = new System.Drawing.Font("宋体", font_height, System.Drawing.FontStyle.Regular, GraphicsUnit.Pixel, ((byte)(0)));
            SizeF size = g.MeasureString(str_code, font);
            g.DrawString(str_code, font, System.Drawing.Brushes.Black, x, line_height);
            code_width = size.Width;
        }
        //画线条
        for (int i = 0; i < code_string.Length; i++)
        {   
            //奇数位用黑线条，偶数位用白线条
            if ((i + 1) % 2 == 1)
            {
                if (code_string[i].ToString() == "1")
                {
                    g.FillRectangle(System.Drawing.Brushes.Black, x, y, line_width * 2, line_height);
                    x = x + line_width * 2;
                }
                else
                {
                    g.FillRectangle(System.Drawing.Brushes.Black, x, y, line_width, line_height);
                    x = x + line_width;
                }
            }
            else
            {
                if (code_string[i].ToString() == "1")
                {
                    g.FillRectangle(System.Drawing.Brushes.White, x, y, line_width * 2, line_height);
                    x = x + line_width * 2;
                }
                else
                {
                    g.FillRectangle(System.Drawing.Brushes.White, x, y, line_width, line_height);
                    x = x + line_width;
                }
            }            
        }
        return (int)(x > code_width ? x : code_width);
    }

    private string Get_CodeString(string str_code) {
        //List<string> list_code = new List<string>();
        string code_string = "";
        //添加起始符
        //list_code.Add(CodeStart.ToString());
        code_string = code_string + CodeStart.ToString();
        //循环添加字符串二进制字符
        for (int i = 0; str_code.Length>0; i++)
        {
            int code0 = Int32.Parse(str_code[0].ToString());
            int code1=Int32.Parse(str_code[1].ToString());
            string code_string0 = CodeEncoding[code0].ToString();
            string code_string1 = CodeEncoding[code1].ToString();
            
            for (int j = 0; j < code_string0.Length; j++)
            {
                code_string = code_string + code_string0[j].ToString() + code_string1[j].ToString();
            }
            str_code = str_code.Substring(2);            
        }
        //添加结束符
        //list_code.Add(CodeEnd.ToString());
        code_string = code_string + CodeEnd.ToString();
        return code_string;
    }
}