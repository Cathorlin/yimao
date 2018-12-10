using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using Newtonsoft.Json;
using System.IO;
using System.Text.RegularExpressions;

public partial class BaseForm_ShowList : BaseShowPage
{
    public  string RequestXml = "";
    public DataTable  dt_a10001 = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Stream RequestStream = Request.InputStream;
            StreamReader RequestStreamReader = new StreamReader(RequestStream);
            RequestXml = RequestStreamReader.ReadToEnd();
            RequestStream.Close();         

        }
        catch (Exception ex)
        {
            return;
        }
    }
}