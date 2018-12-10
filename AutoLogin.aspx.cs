using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Base;
using System.Data;
public partial class AutoLogin : System.Web.UI.Page
{
    BaseFun fun = new BaseFun();
    public string user_id = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        string linkcode = "";
        try
        {
            linkcode = Request.Form[0].ToString();
            //检测用户名称 是否
            DataTable dt_check = fun.getDtBySql("select pkg_user.check_auto_login('" + linkcode + "') as c from dual");
            user_id = dt_check.Rows[0][0].ToString();
        }
        catch
        {
            linkcode = "";
            user_id = "-1";

        }

      
    }
}