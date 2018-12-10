using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
public partial class BaseForm_loginform : System.Web.UI.Page
{
    public DataTable dt_temp = new DataTable();
    public BaseFun  fun = new BaseFun();
    public User user = new User();

    protected void Page_Load(object sender, EventArgs e)
    {
       

       
    }

  
}