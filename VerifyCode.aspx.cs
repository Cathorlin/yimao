using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

	/// <summary>
	/// VerifyCode 的摘要说明。
	/// </summary>
	public partial class VerifyCode : System.Web.UI.Page
	{
		protected void Page_Load(object sender, System.EventArgs e)
		{
			// 在此处放置用户代码以初始化页面
			if (!IsPostBack)
			{
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
				Random seedRnd = new Random();
                string verifyCode ="";
                byte[] byteArr = new byte[4];
                for (int i = 0; i < 4; i++)
                {
                    int asciiCode = seedRnd.Next(48, 57);
                    /*58 64  91 96 */
                    while ((asciiCode >= 58 && asciiCode <= 64) || asciiCode >= 91 && asciiCode <= 96)
                  {
                      asciiCode = seedRnd.Next(48, 122);



                  }
                  System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
                  byte[] byteArray = new byte[] { (byte)asciiCode };
                  verifyCode = verifyCode + asciiEncoding.GetString(byteArray);
     
                
                }
                 

				//string verifyCode = Utils.CreateRndStr(5).ToUpper();

				Session["verifycode"]=verifyCode.ToString();
				int width = 100;
				int height = 40;


				/*if(!noisecolor.StartsWith("#"))
					noisecolor = "#"+noisecolor;*/
				Bitmap image = new Bitmap ( width , height );

				Graphics g = Graphics.FromImage(image) ;

				//g.FillRectangle (new SolidBrush(Color.FromArgb(200,200,200)),0 ,0 ,100,40) ;
                int bgcolor = 656565;
                int noisecolor = 123456;
               	int x1;
				int x2;
				int y1;
				int y2;
				int h=0;
       

              //  g.FillRectangle(new SolidBrush(Color.FromArgb(bgcolor)), 0, 0, width/2, height);
              //  g.FillRectangle(new SolidBrush(Color.FromArgb(bgcolor+1200000)), width / 2, 0, width , height);

                Pen rndPen = new Pen(Color.FromArgb(noisecolor), 1);
				Random Rnd1 = new Random();
                while (h <  width )
				{
					x1=Rnd1.Next(0,width);
					x2=Rnd1.Next(0,width);
					y1=Rnd1.Next(0,height-10);
					y2=Rnd1.Next(0,height-10);
					//g . DrawLine ( rndPen , x1 , y1 , x1+2 , y1+2 ) ;
                    g.FillRectangle(new SolidBrush(Color.FromArgb(40 + h, 173, 232)), h, 0, h + 1, height);
					h++;
				}
				//Font axesFont = new Font( "Comic Sans MS" , fontsize ) ;
                Font axesFont = new Font("Arial", 21);
               
				Brush blackBrush = new SolidBrush ( Color.FromArgb(18, 18, 255)) ;

				g.DrawString(verifyCode.ToString(),axesFont,blackBrush,5,-1 ) ;
				//循环写入乱七八糟文字。
				
				/*int x1;
				int x2;
				int y1;
				int y2;
				int h=1;
				Pen rndPen = new Pen ( Color.White , 1 ) ;
				Random Rnd1 = new Random();
				while (h<100)
				{
					x1=Rnd1.Next(0,60);
					x2=Rnd1.Next(0,60);
					y1=Rnd1.Next(0,30);
					y2=Rnd1.Next(0,30);
					g . DrawLine ( rndPen , x1 , y1 , x1+2 , y1+2 ) ;
					h++;
				}
				*/
			/*	Pen grayPen = new Pen ( Color.DimGray , 2 ) ;
				g.DrawLine ( grayPen , 0 , 0 , 0 , height ) ;
				g.DrawLine ( grayPen , width , 0 , width,height) ;
				g.DrawLine ( grayPen , 0 , 0 , width , 0 ) ;
				g.DrawLine ( grayPen , 0 , height*2 , width , height ) ;*/
				image.Save( Response.OutputStream,ImageFormat.Jpeg); 
			}//if

		}

		#region Web 窗体设计器生成的代码
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: 该调用是 ASP.NET Web 窗体设计器所必需的。
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// 设计器支持所需的方法 - 不要使用代码编辑器修改
		/// 此方法的内容。
		/// </summary>
		private void InitializeComponent()
		{    

		}
		#endregion
	}
