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


    public partial class loginout :Page
    {

        public string M001_ID = "";
        public DataTable dt_m101 = new DataTable();
        public int insertrow;
        protected void Page_Load(object sender, EventArgs e)
        {
          //  base.PageBase_Load(sender, e);
            Session.Clear();
            if (!IsPostBack)
            {

            }

        }

    }
