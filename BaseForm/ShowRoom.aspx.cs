using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using Newtonsoft.Json;
using System.IO;
using System.Text.RegularExpressions;
public partial class BaseForm_ShowRoom : System.Web.UI.Page
{
    public string RequestXml = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Stream RequestStream = Request.InputStream;
        StreamReader RequestStreamReader = new StreamReader(RequestStream);
        RequestXml = RequestStreamReader.ReadToEnd();
        RequestStream.Close();
    }
}