using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class BaseForm_Login : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(BaseForm_Login));
    }

    //检测用户登录
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string CheckUserLogin(string comp_no_, string user_id_, string pass_word_)
    {
        BaseLogin BLogin = new BaseLogin(comp_no_, user_id_, pass_word_,"1");
        string ls_login = BLogin.checkUserLogin();
        return ls_login;    
    }
}
