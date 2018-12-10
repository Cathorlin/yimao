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
using Newtonsoft.Json;

public partial class BaseForm_MainDetail : BaseUc
{
    public int BS_SHOW_HEAD = 0;
    public int PageRow = 0;
    public int PageNum = 0;
    public int pagecount = 0;
    public int rowscount = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        
        base.BaseUc_Page_Load(sender, e);
        //计算总宽度
        
        //Hashtable ht = new Hashtable();
        //ht.Add("P1", Fun.DataTable2Json(dt_a013010101));
        //ht.Add("P2", dt_a00201.Rows[0]["TABLE_KEY"].ToString());
        //ht.Add("P3", dt_a00201.Rows[0]["main_key"].ToString());
        //ht.Add("P4", dt_a00201.Rows[0]["table_id"].ToString());
        //ht.Add("P5", Fun.DataTable2Json(Fun.getDtBySql("select t.* from A00210_V01 t  where a00201_key ='" + dt_a00201.Rows[0]["A00201_KEY"].ToString() + "' and   rb_type='C'")));
        //ht.Add("P6", Fun.DataTable2Json(Fun.getDtBySql("select t.* from A00210_V01 t  where a00201_key ='" + dt_a00201.Rows[0]["A00201_KEY"].ToString() + "' and   rb_type='U'")));
        //ht.Add("P7", dt_a00201.Rows[0]["tbl_type"].ToString());
        //ht.Add("P8", Fun.DataTable2Json(Fun.getDtBySql("select t.*   from a00201_v02 t  where a00201_key ='" + dt_a00201.Rows[0]["A00201_KEY"].ToString() + "' order by sort_by")));


        //string jsonText = JsonConvert.SerializeObject(ht);
        //Session["J_" + dt_a00201.Rows[0]["A00201_KEY"].ToString()] = jsonText;

        BS_SHOW_HEAD = int.Parse(dt_a002.Rows[0]["BS_SHOW_HEAD"].ToString());
        if (BS_SHOW_HEAD == null)
        {
            BS_SHOW_HEAD = 0;
        }
        PageRow = int.Parse(Fun.getA022Name("DetailRowS"));
        string if_main = dt_a00201.Rows[0]["if_main"].ToString();
        string sort_col = dt_a00201.Rows[0]["sort_col"].ToString();
        if (sort_col == null)
        {
            sort_col = "";
        }
        try
        {
            PageNum = int.Parse(Session["detail_" + a00201_key].ToString());
        }
        catch
        {
            PageNum = 0;
        }
        dt_data = Fun.getDtBySql(showdatasql + " AND " + dt_a00201.Rows[0]["MAIN_KEY"].ToString() + "='" + main_key_value + "'  " + sort_col);
        option = Session["MAIN_OPTION"].ToString();
        rowscount = dt_data.Rows.Count;
        dt_a00204 = Fun.getDtBySql("Select pkg_show.geta00204('" + a00201_key + "','" + main_key_value + "','" + GlobeAtt.A007_KEY + "','0','"+ option+"') as c  from dual ");
        pagecount = rowscount / PageRow;
        if (rowscount % PageRow > 0)
        {
            pagecount = pagecount + 1;
        }
        if (PageNum > pagecount)
        {
            PageNum = 0;
        }
    }
}

