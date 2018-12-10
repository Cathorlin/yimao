using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
public partial class Default3 : System.Web.UI.Page
{
    

    protected void Page_Load(object sender, EventArgs e)
    {
        Base.HttpRequest http = new Base.HttpRequest();
       // com.w_9eat.websoftinterface2010.WsWzMobile ws = new com.w_9eat.websoftinterface2010.WsWzMobile();
      //  string get_= ws.get_shop("ws0577", "shbomai", "123456");

      //  string url = "http://websoftinterface2010.9eat.com/wswzmobile/20131012/WsWzMobile.asmx?wsdl";//wsdl地址  

        //string url = "http://www.ldsms.com/SmsService.asmx?wsdl";//wsdl地址
        //string name = "GetBalance";//javaWebService开放的接口  
        //TPSVService.WebServiceProxy wsd = new TPSVService.WebServiceProxy(url, name);
        //string[] str = { "iek-8207", "bl,it6089" };
        //try
        //{
        //    string suc = (string)wsd.ExecuteQuery(name, str).ToString();
        //    Response.Write(suc);
        //}
        //catch(Exception ex )
        //{
        //    Response.Write(ex.Message);
        //}


        string url = "http://websoftinterface2010.9eat.com/wswzmobile/20131012/WsWzMobile.asmx?wsdl";//wsdl地址
        string name = "get_shop";//javaWebService开放的接口  
        TPSVService.WebServiceProxy wsd = new TPSVService.WebServiceProxy(url, name);
        string[] str = { "ws0577", "shbomai", "123456" };
        try
        {
            string suc = (string)wsd.ExecuteQuery(name, str).ToString();
            Response.Write(suc);
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
     
      
        //iek-8207
        //bl,it6089
        
      //  http://localhost/App_WebReferences/com/w_9eat/websoftinterface2010/WsWzMobile.wsdl
       // string smsurl = "http://websoftinterface2010.9eat.com/wswzmobile/20131012/WsWzMobile.asmx/get_shop?sn=ws0577&userid=shbomai&pwd=123456";
      //  string smsurl = "http://www.ldsms.com/SmsService.asmx/GetBalance?username=iek-8207&password=bl,it6089";
        
      //  http.OpenRequest(smsurl, smsurl);
           

    }
}