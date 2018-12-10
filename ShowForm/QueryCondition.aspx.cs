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

namespace Custom.BaseForm
{

    public partial class QueryCondition :BasePage
    {
        public DataTable dt_A10001 = new DataTable();
        public DataTable dt_menu = new DataTable();
        public DataTable dt_a006 = new DataTable();
        public DataTable dt_data = new DataTable();
        public DataTable dt_a00201 = new DataTable();
        public string a00201_key = "";
        public string a006_key_zj = "0";
        public string ifchoose = "0";
        public string choosecolumn = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            //获取用户名和用户名称
          //  base.PageBase_Load(sender, e);
            base.PageBase_Load(sender, e);
            a00201_key = Request.QueryString["A00201KEY"] == null ? "-1" : Request.QueryString["A00201KEY"].ToString();
            ifchoose = Request.QueryString["ifchoose"] == null ? "0" : Request.QueryString["ifchoose"].ToString();
            dt_A10001 = Fun.getQueryCondtion(a00201_key);
            dt_a00201 = Fun.getDtBySql("Select t.* from A00201_v01 t where a00201_key='" + a00201_key + "'");
            string a006_sql = "Select  distinct  query_id from A006 t  where user_id='" + A007_KEY + "' AND menu_id   ='" + dt_a00201.Rows[0]["menu_id"].ToString() + "' and table_id='"+ dt_a00201.Rows[0]["table_id"].ToString()+"' ";
            dt_a006 = Fun.getDtBySql(a006_sql);
            for (int i = 0; i < dt_a006.Rows.Count; i++)
            {
                if (dt_a006.Rows[i]["query_id"].ToString() == "最近的查询")
                {
                    a006_key_zj = dt_a006.Rows[i]["query_id"].ToString();
                    break; 
                }
            }
          //   Response.Write(a006_sql);
            if (ifchoose =="1")
            {
                try
                {
                    choosecolumn = Session["choosecolumn"].ToString();
                  
                }
                catch
                {
                    choosecolumn = "";
                }

              
            }

        }


        public string getColumnHtml(DataRow dr, int col_i)
        {
            string  ls_input_string = "";



            return ls_input_string;


        
        
        }


        public string getddd_rbhtml(string select_sql, string type, string opition_id)
        {

      

        
            return "";
        }

    }
}