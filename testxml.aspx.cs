using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class testxml : System.Web.UI.Page
{
    public string Responsexml = "";
    public DataTable dt_data = new DataTable();
    public string Reqxml = "";
    public BaseFun Fun = new BaseFun();
    public string a319_id = "";
    public string REQURL = "http://117.184.99.162:8080";
    public DataTable dt_detail = new DataTable();
    public DataTable dt_temp = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        dt_data = Fun.getDtBySql("Select t.* from a319 t where  t.state='1'");

        a319_id = Request.QueryString["key"] == null ? "-1" : Request.QueryString["key"].ToString();
        if ((a319_id == "" || a319_id == "-1") && dt_data.Rows.Count > 0)
        {
            a319_id = dt_data.Rows[0]["a319_id"].ToString();
        }
        dt_detail = Fun.getDtBySql("Select t.* from A31901_V01 t where  t.a319_id='" + a319_id + "' order by t.col_id ");
            Base.HttpRequest http = new Base.HttpRequest();
            StringBuilder REQDATA =   new StringBuilder();
            //REQDATA.Append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            //REQDATA.Append("<miap>");
            //REQDATA.Append("<miap-header>");
            //REQDATA.Append("<transactionid>" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + "</transactionid>");
            //REQDATA.Append("<version>1.0</version>");
            //REQDATA.Append("<messagename>getaddressidreq</messagename>");
            //REQDATA.Append("</miap-header>");
            //REQDATA.Append("<miap-Body>");
            //REQDATA.Append("<getaddressidreq>");
            //REQDATA.Append("<customerno>102419</customerno>");
            //REQDATA.Append("</getaddressidreq>");
            //REQDATA.Append("</miap-Body>");
            //REQDATA.Append("</miap>");


            //REQDATA.Append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            //REQDATA.Append("<miap>");
            //REQDATA.Append("<miap-header>");
            //REQDATA.Append("<transactionid>" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + "</transactionid>");
            //REQDATA.Append("<version>1.0</version>");
            //REQDATA.Append("<messagename>getcostatereq</messagename>");
            //REQDATA.Append("</miap-header>");
            //REQDATA.Append("<miap-Body>");
            //REQDATA.Append("<getcostatereq>");
            //REQDATA.Append("<transid>100161</transid>");
            //REQDATA.Append("</getcostatereq>");
            //REQDATA.Append("<getcostatereq>");
            //REQDATA.Append("<transid>100162</transid>");
            //REQDATA.Append("</getcostatereq>");
            //REQDATA.Append("<getcostatereq>");
            //REQDATA.Append("<transid>100163</transid>");
            //REQDATA.Append("</getcostatereq>");
            //REQDATA.Append("<getcostatereq>");
            //REQDATA.Append("<transid>100164</transid>");
            //REQDATA.Append("</getcostatereq>");
            //REQDATA.Append("<getcostatereq>");
            //REQDATA.Append("<transid>100165</transid>");
            //REQDATA.Append("</getcostatereq>");
            //REQDATA.Append("</miap-Body>");
            //REQDATA.Append("</miap>");




            //#region 创建订单
            //REQDATA.Append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            //REQDATA.Append("<miap>");
            //REQDATA.Append("<miap-header>");
            //REQDATA.Append("<transactionid>" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + "</transactionid>");
            //REQDATA.Append("<version>1.0</version>");
            //REQDATA.Append("<messagename>newcoreq</messagename>");
            //REQDATA.Append("</miap-header>");
            //REQDATA.Append("<miap-Body>");
            //REQDATA.Append("<newcoreq>");
            //REQDATA.Append("<orderno>1000001</orderno>");
            //REQDATA.Append("<customerno>990997</customerno>");
            //REQDATA.Append("<contract>18</contract>");
            //REQDATA.Append("<userid>USERTEST</userid>");
            //REQDATA.Append("<ordertype>0</ordertype>");
            //REQDATA.Append("<paytype>3</paytype>");
            //REQDATA.Append("<payno>20000000001</payno>");
            //REQDATA.Append("<paytime>20140810110810</paytime>");
            //REQDATA.Append("<remark>ddddccc.c.c.cldddddd</remark>");
            //REQDATA.Append("<amount>5370</amount>");
            //REQDATA.Append("<shipcode>B23</shipcode>");
            //REQDATA.Append("<shipamount>123</shipamount>");
            //REQDATA.Append("<othersamount>-89</othersamount>");
            //REQDATA.Append("<invoiceflag>0</invoiceflag>");
            //REQDATA.Append("<invoicehead></invoicehead>");
            //REQDATA.Append("<invoiceprocject></invoiceprocject>");
            //REQDATA.Append("<invoiceamount></invoiceamount>");
            //REQDATA.Append("<addressid>01</addressid>");
            //REQDATA.Append("<address>中山西路1000号XX大厦1号楼****室</address>");
            //REQDATA.Append("<state>上海市</state>");
            //REQDATA.Append("<city>徐汇区</city>");
            //REQDATA.Append("<zipcode>100001</zipcode>");
            //REQDATA.Append("<name>XXXXXX</name>");
            //REQDATA.Append("<phone>021-12345678</phone>");
            //REQDATA.Append("<fax>021-12345679</fax>");
            //REQDATA.Append("<email>XXXXXXXXX@wwww.*****.com</email>");
            //REQDATA.Append("<mobile>13112345678</mobile>");
            //REQDATA.Append("<partlist>");
            //REQDATA.Append("<detail>");
            //REQDATA.Append("<partno>110410602078</partno>");
            //REQDATA.Append("<qty>10</qty>");
            //REQDATA.Append("<saleprice>426</saleprice>");
            //REQDATA.Append("<amount>4260</amount>");
            //REQDATA.Append("<lineremark>dddaaa,ddd|ddd.,ddd;|</lineremark>");
            //REQDATA.Append("</detail>");
            //REQDATA.Append("<detail>");
            //REQDATA.Append("<partno>110410600321</partno>");
            //REQDATA.Append("<qty>10</qty>");
            //REQDATA.Append("<saleprice>111</saleprice>");
            //REQDATA.Append("<amount>1110</amount>");
            //REQDATA.Append("<lineremark>222dddaaa,ddd|ddd.,ddd;|</lineremark>");
            //REQDATA.Append("</detail>");
            //REQDATA.Append("</partlist>");
            //REQDATA.Append("</newcoreq>");
            //REQDATA.Append("</miap-Body>");
            //REQDATA.Append("</miap>");
            //#endregion

            http.CharacterSet = "utf-8";
            Reqxml = get_modifuaddress();// REQDATA.ToString();
            SaveLog.Verification(Reqxml);
            http.OpenRequest(REQURL, REQURL, Reqxml);
            Responsexml = http.HtmlDocument;

    }
    public string get_modifuaddress()
    {

        StringBuilder REQDATA = new StringBuilder();
        // 地址
        REQDATA.Append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
        REQDATA.Append("<miap>");
        REQDATA.Append("<miap-header>");
        REQDATA.Append("<transactionid>" + DateTime.Now.ToString("yyyyMMddHHmmssfff") + "</transactionid>");
        REQDATA.Append("<version>1.0</version>");
        REQDATA.Append("<messagename>modifyaddressidreq</messagename>");
        REQDATA.Append("</miap-header>");
        REQDATA.Append("<miap-Body>");
        REQDATA.Append("<modifyaddressidreq>");
        REQDATA.Append("<customerno>102000</customerno>");
        REQDATA.Append("<addressid>-</addressid>");
        REQDATA.Append("<address>中山西路104号XX大厦1号楼****室33sssss号楼</address>");
        REQDATA.Append("<state>上海市</state>");
        REQDATA.Append("<city>徐汇区</city>");
        REQDATA.Append("<zipcode>10000w</zipcode>");
        REQDATA.Append("<name>006</name>");
        REQDATA.Append("<phone>021-12333331</phone>");
        REQDATA.Append("<fax>021-1444dd</fax>");
        REQDATA.Append("<email>888@wwww.*****.com</email>");
        REQDATA.Append("<mobile>14333333</mobile>");
        REQDATA.Append("</modifyaddressidreq>");
        REQDATA.Append("</miap-Body>");
        REQDATA.Append("</miap>");

        return REQDATA.ToString();
    }

}