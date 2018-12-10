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

public partial class EXAM_Mydo : System.Web.UI.Page
{
    public BaseFun Fun = new BaseFun();
    public string RequestXml = string.Empty;
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