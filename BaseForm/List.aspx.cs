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

public partial class BaseForm_List : BaseForm
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //读取显示条件 
        base.PageBase_Load(sender, e);
    
        string condition = "";
        try
        {
            condition = Session["FORM_CON_" +  a00201_key].ToString();
        }
        catch
        {
            condition = "";
        }
 
        int  PageRow = int.Parse(GlobeAtt.QueryList_PageRow);
        int  MaxRow = int.Parse(GlobeAtt.QueryList_MaxRow);  // int.Parse(Fun.getA022Name("QueryList_MaxRow"));
        MaxRow = 100;
        string data_sql = showdatasql + condition + " and rownum <=" + MaxRow.ToString(); 
        dt_data = Fun.getDtBySql(data_sql);
    }
}
