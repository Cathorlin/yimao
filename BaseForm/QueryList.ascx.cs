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
using System.Data;
using System.Windows.Forms;
public partial class BaseForm_QueryList : BaseUc
{
    public int PageRow = 0;
    public int MaxRow = 0;
    public string IF_JUMP = "1";
    public int currentpage = 1;
    public int pagecount = 0;
    public int rowscount = 0;
    public DataTable dt_a006 = new DataTable();
    public string getShowDataCountSql = "";
    public string select_id = "";
    public string sql__ = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        base.BaseUc_Page_Load(sender, e);
        string a006_sql = "Select  distinct  query_id from A006 t  where user_id='" + GlobeAtt.A007_KEY + "' AND table_id  ='" + dt_a00201.Rows[0]["table_id"].ToString() + "' and menu_id='"+ dt_a00201.Rows[0]["menu_id"].ToString() +"' union select '' from dual  ";

        dt_a006 = Fun.getDtBySql(a006_sql);

        string RETRIEVE = dt_a00201.Rows[0]["RETRIEVE"].ToString();
       // QueryList_PageRow
        PageRow = int.Parse(GlobeAtt.QueryList_PageRow);
        MaxRow = int.Parse(GlobeAtt.QueryList_MaxRow);  // int.Parse(Fun.getA022Name("QueryList_MaxRow"));
        DataTable dt = new DataTable();
        getShowDataCountSql = Fun.getShowDataCountSql(a00201_key);
        try
        {
             select_id = Session["QUERYID_" + a00201_key].ToString();
        }
        catch
        {
            select_id = "" ;
        }

     

        if (IF_JUMP == "1")
        {
            if (RETRIEVE == "1")
            {
               // dt_data = Fun.getDtBySql(showdatasql + " and rownum <=" + MaxRow.ToString());
                sql__ = showdatasql + " and rownum <=" + MaxRow.ToString();
                getShowDataCountSql = getShowDataCountSql + " and rownum <=" + MaxRow.ToString();
            }
            else
            {
                //dt_data = Fun.getDtBySql(showdatasql + " AND  1 = 2");
                sql__ = showdatasql + " and 1=2 ";
                getShowDataCountSql = getShowDataCountSql  +" and 1=2 ";
            }
        }
        else
        {
            string condition = "";
            try
            {
                condition = Session["CON_" + a00201_key].ToString();
             
            }
            catch
            {
                condition = "";
               
            }
          
            // Session["QUERY_" + a00201_key] = showdatasql + condition + " and rownum <=" + MaxRow.ToString();
            int pos = condition.IndexOf("ORDER BY");
            string str_order = "";
         
            if (pos > 0)
            {
                str_order = condition.Substring(pos);
                condition = condition.Substring(0, pos - 1);
                
            }

            sql__ = showdatasql + condition + " and rownum <=" + MaxRow.ToString() + " "+str_order;   //"Select * from  ( " + showdatasql + condition + " and rownum <=" + MaxRow.ToString() + " ) a where row_num >= " + ((currentpage - 1) * PageRow).ToString() + " and row_num <= " + ((currentpage + 0) * PageRow).ToString();

            getShowDataCountSql = getShowDataCountSql + condition  + " and rownum <=" + MaxRow.ToString();

  
        }
      //  sql__ = showdatasql + condition + " and rownum <=" + MaxRow.ToString();
        try
        {
            currentpage = int.Parse(Session["currentpage_" + a00201_key].ToString());
        }
        catch
        {
            currentpage = 1;
        }
        sql__ = "Select a.* ,rownum as rn from (" + sql__ + ") a  where rownum <=  " +  (currentpage  * PageRow).ToString() ;

        sql__ = "Select b.* from (" + sql__ + ") b where rn > " + ((currentpage - 1) * PageRow).ToString();
        //where row_num >= " + ((currentpage - 1) * PageRow).ToString() + "  row_num <= " + ((currentpage + 0) * PageRow).ToString();
        dt_data = Fun.getDtBySql(sql__);

        Session["QUERY_" + a00201_key] = sql__; // showdatasql + condition + " and rownum <=" + MaxRow.ToString();

        DataTable dt_count = new DataTable();
        dt_count = Fun.getDtBySql(getShowDataCountSql);
        try
        {
            rowscount = int.Parse(dt_count.Rows[0][0].ToString());

        }
        catch
        {
            rowscount = 0;
        }
        pagecount = rowscount / PageRow;
        if (rowscount % PageRow > 0)
        {
            pagecount = pagecount + 1;
        }
        dt_a00204 = Fun.getDtBySql("Select pkg_show.geta00204('"+ a00201_key+"','[LIST]','"+ GlobeAtt.A007_KEY+"','1','Q') as c  from dual ");
        


    }
}

