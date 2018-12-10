using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Common;
using System.Data;
using Base;
public partial class SignDetails : System.Web.UI.Page
{
    public Oracle dt = new Oracle();
    public string name = string.Empty;
    public string mobile_no = string.Empty;
    public string sign = string.Empty;
    public string time1 = string.Empty;
 
    public string Card_no = string.Empty;
    public DataTable date = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        Card_no = Request["CardNo"];
        name = Request["EmpName"];
        time1 = Request["ValidDate"];
        sign = Request["Sign"];
    }
   
}