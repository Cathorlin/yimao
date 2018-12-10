using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class HandEquip_index : BasePage
{
    public DataTable dt_temp = new DataTable();
    public DataTable dt_url = new DataTable();
    public BaseFun fun = new BaseFun();
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        base.PageBase_Load(sender, e);

        dt_temp = fun.getDtBySql("Select * From A002 t Where t.ACTIVE='1' and T.Parent_Id = '1201' And Exists (Select 1 From A01301 a Inner Join A00701 a1 On a1.a013_id=a.a013_id And a1.a007_id='" + GlobeAtt.A007_KEY +"' Where a.useable=1 And a.a002_id=t.menu_id) order by t.sort_by");
    }

    /// <summary>
    /// 获取字符串字节长度
    /// </summary>
    /// <param name="str"></param>
    /// <returns></returns>
    static public int TrueLength(string str)
    {
        int lenTotal = 0;
        int n = str.Length;
        string strWord = "";
        int asc;
        for (int i = 0; i < n; i++)
        {
            strWord = str.Substring(i, 1);
            asc = Convert.ToChar(strWord);
            if (asc < 0 || asc > 127)
                lenTotal = lenTotal + 2;
            else
                lenTotal = lenTotal + 1;
        }

        return lenTotal;
    }


}