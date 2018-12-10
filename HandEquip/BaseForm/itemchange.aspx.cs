using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class HandEquip_BaseForm_itemchange : BaseForm
{
    public DataTable dt_a10001 = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
    }
}