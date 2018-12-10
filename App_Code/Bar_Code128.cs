using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;
using System.Drawing.Imaging;

/// <summary>
///Bar_Code128 的摘要说明
///标准128码模拟一维码图片
/// </summary>
public class Bar_Code128
{
    //ASCII从32到127对应的条码区,由3个条、3个空、共11个单元构成,符号内含校验码
    private string[] CodeEncoding = new string[] {
"11011001100", "11001101100", "11001100110", "10010011000", "10010001100", "10001001100", "10011001000", "10011000100", "10001100100", "11001001000",
"11001000100", "11000100100", "10110011100", "10011011100", "10011001110", "10111001100", "10011101100", "10011100110", "11001110010", "11001011100",
"11001001110", "11011100100", "11001110100", "11101101110", "11101001100", "11100101100", "11100100110", "11101100100", "11100110100", "11100110010",
"11011011000", "11011000110", "11000110110", "10100011000", "10001011000", "10001000110", "10110001000", "10001101000", "10001100010", "11010001000",
"11000101000", "11000100010", "10110111000", "10110001110", "10001101110", "10111011000", "10111000110", "10001110110", "11101110110", "11010001110",
"11000101110", "11011101000", "11011100010", "11011101110", "11101011000", "11101000110", "11100010110", "11101101000", "11101100010", "11100011010",
"11101111010", "11001000010", "11110001010", "10100110000", "10100001100", "10010110000", "10010000110", "10000101100", "10000100110", "10110010000",
"10110000100", "10011010000", "10011000010", "10000110100", "10000110010", "11000010010", "11001010000", "11110111010", "11000010100", "10001111010",
"10100111100", "10010111100", "10010011110", "10111100100", "10011110100", "10011110010", "11110100100", "11110010100", "11110010010", "11011011110",
"11011110110", "11110110110", "10101111000", "10100011110", "10001011110", "10111101000", "10111100010", "11110101000", "11110100010", "10111011110",
"10111101110", "11101011110", "11110101110", "11010000100", "11010010000", "11010011100","1100011101011"
};
   // private const string CodeStop = "11000111010", CodeEnd = "11"; //固定码尾
    private const string CodeStop = "106";
    private enum CodeChange { CodeA = 101, CodeB = 100, CodeC = 99 }; //变更
    private enum CodeStart { CodeUnset = 0, CodeA = 103, CodeB = 104, CodeC = 105 };//各类编码的码头
	public Bar_Code128()
	{
		//
		//TODO: 在此处添加构造函数逻辑
		//
	}

    /// <summary>
    /// 
    /// </summary>
    /// <param name="str_code">条码字符串</param>
    /// <param name="f_showcode">是否显示字符</param>
    /// <param name="hb_wh">宽/高比例</param>
    /// <param name="bs">放大倍数或者是线的宽度</param>
    /// <returns></returns>
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

    private Image ShowBarCode2(string str_code, bool f_showcode, double hb_wh,int bs)
    {
        //拆分条码，根据ABC3中原则自动转换
        List<int> list_code = Get_ListCode(str_code);
        //转化成二进制编码
        string list_codestring = Get_CodeString(list_code);
        //画图，根据二进制码1或0分别画黑线和白线。宽为1*10像素，高为20*10像素
        int width = list_codestring.Length * bs;
        int height = (int)(width / hb_wh);
        Bitmap bitmap = new Bitmap(width, height);
        using (Graphics grap = Graphics.FromImage(bitmap))
        {
            width = DrawBarCode(grap, list_codestring, str_code, f_showcode,width, height);
            //剪切多余的空白
            Bitmap bitmap2 = new Bitmap(width, height);
            using (Graphics grap2 = Graphics.FromImage(bitmap2))
            {
                grap2.DrawImage(bitmap, 0, 0);
                return bitmap2;
            }
        }

    }

    /// <summary>
    /// 绘画条码线条&字符串
    /// </summary>
    /// <param name="g"></param>
    /// <param name="str_code"></param>
    /// <param name="f_showcode"></param>
    /// <returns>线条&字符串所占画布宽</returns>
    private int DrawBarCode(Graphics g, string list_codestring, string str_code, bool f_showcode, int width,int height)
    {
        float code_width = 0;
        //画图，根据二进制码1或0分别画黑线和白线。宽为1*10像素，高为20*10像素,字体高100px
        float x,y,line_width,line_height,font_height;
        x = 0;
        y = 0;
        line_width = width / list_codestring.Length;
        line_height = height;
        font_height = 0;
        //显示字符串
        if (f_showcode)
        {
            line_height = height / 2;
            font_height = height - line_height - 2;
            Font font = new System.Drawing.Font("宋体", font_height, System.Drawing.FontStyle.Regular, GraphicsUnit.Pixel, ((byte)(0)));
            SizeF size = g.MeasureString(str_code, font);
            g.DrawString(str_code, font, System.Drawing.Brushes.Black, x, line_height);
            code_width = size.Width;
        }
        //画线条
        for (int i = 0; i < list_codestring.Length; i++)
        {
            if (list_codestring[i].ToString() == "1")
            {
                g.FillRectangle(System.Drawing.Brushes.Black, x, y, line_width, line_height);
            }
            
            x = x + line_width;
        }
        return (int)(x > code_width ? x : code_width);
    }

    /// <summary>
    /// 将字符串转化成条码二进制码
    /// </summary>
    /// <param name="str_code"></param>
    /// <returns></returns>
    private List<int> Get_ListCode(string str_code)
    {
        string code = str_code;
        List<int> listcode = new List<int>();
        string F_ABC = "";
        //循环遍历字符串，根据字符串方式自动判断使用ABC哪种编码方式
        //连续存在4个整数，则使用C类编码，直接采用数字位置来确定二进制条码编码
        //其余的使用B类编码，使用B类，需要采用字符的ASCII码的位置来确定二进制条码编码
        for (int i = 0; code.Length > 0; i++)
        {
            int k = isNumber(code);
            if (k >= 4)
            {
                //采用C类编码
                if (F_ABC == "")
                {
                    //加入码头
                    listcode.Add((int)CodeStart.CodeC);
                    F_ABC = "C";
                }
                if (F_ABC != "C")
                {
                    //加入编码类型转义
                    listcode.Add((int)CodeChange.CodeC);
                    F_ABC = "C";
                }
                for (int j = 0; j < k; j = j + 2) //两位数字合为一个码身
                {
                    listcode.Add(Int32.Parse(code.Substring(0, 2)));
                    code = code.Substring(2);
                }
               // i = i + k-1;

            }
            else
            {
                //采用B类编码
                if ((int)code[0] < 32 || (int)code[0] > 126) throw new Exception("字符串必须是数字或字母");
                if (F_ABC=="")
                {
                    //加入码头
                    listcode.Add((int)CodeStart.CodeB);
                    F_ABC = "B";
                }
                if (F_ABC != "B")
                {
                    //加入编码类型转义
                    listcode.Add((int)(CodeChange.CodeB));
                    F_ABC = "B";
                }
                listcode.Add((int)code[0] - 32);//字符串转为ASCII-32
                code = code.Substring(1);
            }
        }
        //添加校验位，可以不加 
        //校验位规则：（开始位对应ID＋每位数据在整个数据中的位置×每位数据对应的ID值）% 103 
        listcode.Add(Get_CodeCheck(listcode));
        //加入结束码
        listcode.Add(Int32.Parse(CodeStop));
        return listcode;
    }

    //转化成二进制编码
    private string Get_CodeString(List<int> list_code)
    {
        string CodeString = "";
        for (int i = 0; i < list_code.Count; i++)
        {
            CodeString += CodeEncoding[list_code[i]];
        }
        return CodeString;
    }

    //检测是否连续偶个数字,返回连续数字的长度
    private int isNumber(string code)
    {
        int k = 0;
        for (int i = 0; i < code.Length; i++)
        {
            if (char.IsNumber(code[i]))
                k++;
            else
                break;
        }
        if (k % 2 != 0) k--;
        return k;
    }
    //校验码
    private int Get_CodeCheck(List<int> list_code)
    {
        int check = list_code[0];
        for (int i = 1; i < list_code.Count; i++)
            check = check + (list_code[i] * i);
        return (check % 103);
    }

}