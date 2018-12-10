using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Windows.Forms;
 
namespace Custom
{
    /// <summary>
    /// _Default 的摘要说明。



    /// </summary>
    public partial class Default : Page
    {
        public string user_id;
        public string user_name;
        public int SH;
        public int SW;
        public BaseFun Fun = new BaseFun();
        public string code = "";
        protected void Page_Load(object sender, System.EventArgs e)
        {
             SH = Screen.PrimaryScreen.Bounds.Height;

             SW = Screen.PrimaryScreen.Bounds.Width;
             Random seedRnd = new Random();
             code = DateTime.Today.ToString("yyyyMMddhh24mmss");
            // 在此处放置用户代码以初始化页面
            // Session["user_id"] = "ADMIN";
            // Session["user_name"] = "管理员";

        }
    }

}
