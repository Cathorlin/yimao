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

public partial class BaseForm_MainHead : BaseUc
{
    public string PARENTROWID = "";
    public string IFA309 = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        string data_sql = "";
        base.BaseUc_Page_Load(sender, e);     

        if (if_showrow == "1")
        {

            if (PARENTROWID != "-1")
            {
                data_sql = showdatasql + " AND " + dt_a00201.Rows[0]["TABLE_KEY"].ToString() + "= -1 ";
            }
            else
            {
                data_sql = showdatasql + " AND " + dt_a00201.Rows[0]["TABLE_KEY"].ToString() + "='" + main_key_value + "'";
               
            }
        }
        else
        {
            if (dt_a00201.Rows[0]["MAIN_KEY"].ToString() != "")
            {
                data_sql = showdatasql + " AND " + dt_a00201.Rows[0]["MAIN_KEY"].ToString() + "='" + main_key_value + "'";
                     
            }
            else
            {
                if (option == "I")
                {
                    data_sql = showdatasql + " AND 1=2";
                }
                else
                { 
                    data_sql = showdatasql + " AND " + dt_a00201.Rows[0]["TABLE_KEY"].ToString() + "='" + main_key_value + "'";
                }
            }
             string a309_con = dt_a002.Rows[0]["A309_CON"].ToString().Trim();
             if (a309_con != null &&  a309_con != "" )
             {
                 a309_con = a309_con.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                if (a309_con.ToUpper().IndexOf("AND ") ==0)
                {
                    dt_temp = Fun.getDtBySql(data_sql + a309_con  ) ;
                }
                else
                {
                    dt_temp = Fun.getDtBySql(data_sql + " AND " + a309_con);
                }
            
             }
             if (dt_temp.Rows.Count > 0)
             {
                 IFA309 = "1";
             }

        }
        dt_data = Fun.getDtBySql(data_sql);
        if (dt_data.Rows.Count == 0)
        {
            DataRow dr = dt_data.NewRow();
            dt_data.Rows.Add(dr);

        }
        if (PARENTROWID == "-1")
        {
            try
            {
                status = dt_data.Rows[0]["status"].ToString();
            }
            catch
            {
                status = "-";
            }
            try
            {
                DataTable dt_opition = new DataTable();

                dt_opition = Fun.getDtBySql("Select PKG_SHOW.getoption('" + dt_a002.Rows[0]["menu_id"].ToString() + "','" + status + "','" + option + "','" + GlobeAtt.A007_KEY + "') as c from dual ");


                option = dt_opition.Rows[0][0].ToString();

                Session["MAIN_OPTION"] = option;
            }
            catch
            {
                Session["MAIN_OPTION"] = option;

            }
        }
        else
        {
            Session["MAIN_OPTION"] = option;
        }


        dt_a00204 = Fun.getDtBySql("Select pkg_show.geta00204('" + a00201_key + "','" + main_key_value + "','" + GlobeAtt.A007_KEY + "','0','" + option + "','" + status + "') as c  from dual ");

 
     
        
    }
}

