using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Windows.Forms;
using System.Text;
using System.Collections;
using Newtonsoft.Json;
/// <summary>
/// BaseUc 用户主键的基本属性
/// </summary>
public class BaseUc : System.Web.UI.UserControl
{
    //功能
    public DataTable dt_a00204 = new DataTable();
    //临时的数据集
    public DataTable dt_temp = new DataTable();

    public string status = "-";
    //菜单
    public int SH;
    public int SW;
    public BaseFun Fun = new BaseFun();
     //
    public string a00201_key = "";
    public DataTable dt_a002 =  new  DataTable();
    //
    public string main_key_value = "-1";
    //操作类型
    public string option = "";
    //sql
    public string showdatasql = "";
    //表的功能权限
    public DataTable dt_a103 = new DataTable();
    //还包含  a00201中表的属性  获取方法用当前的菜单
    public DataTable dt_a0130101 = new DataTable(); 
    //表的列属性 包含权限 
    public DataTable dt_a013010101 = new DataTable();

    //用户属性
    public DataTable dt_a007 = new DataTable(); 


    //用户的权限属性
    public DataTable dt_a013 = new DataTable();
    //
    public StringBuilder PageStr  =  new StringBuilder();//检查表

    public DataTable dt_a00201 = new DataTable();
    //格式为

    public DataTable dt_data = new DataTable();
    private  int li_db;
    public  string if_showrow ="0";
    public BaseUc()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        this.Unload += new System.EventHandler(BaseUc_Page_Unload);

    }
    protected void BaseUc_Page_Unload(object sender, EventArgs e)
    {
        Fun.db.db_oracle.GetDBConnection().Dispose();
        dt_a00204.Dispose();
        dt_temp.Dispose();
        dt_a002.Dispose();
        dt_a013010101.Dispose();
        dt_a0130101.Dispose();
        dt_a007.Dispose();
        dt_a013.Dispose();
        dt_a00201.Dispose();

    }
    protected void BaseUc_Page_Load(object sender, EventArgs e)
    {
        SH = Screen.PrimaryScreen.Bounds.Height;

        SW = Screen.PrimaryScreen.Bounds.Width;
        dt_a00201 = Fun.getDtBySql("Select t.* from A00201_V01 t where a00201_key = '" + a00201_key + "'");
       // dt_a0130101 = Fun.getA0130101(a00201_key);
        //dt_a013010101 = Fun.getA013010101(a00201_key);
        // showdatasql = Fun.getShowDataSql(a00201_key);
      //  A002_ID='[REQUEST_A002ID]'
        //解析出request
        for (int i=0 ;i < Request.QueryString.AllKeys.Length;i++)
        {
             string key = Request.QueryString.AllKeys.GetValue(i).ToString();
            // Request.QueryString("").
             showdatasql = showdatasql.Replace("[REQUEST_" + key.ToUpper() + "]", Request.QueryString[key].ToString());
        
        }
        string json = "";
        try
        {
            json = Session["J_" + dt_a00201.Rows[0]["A00201_KEY"].ToString()].ToString() ;
        }
        catch
        {
            json = "";
        }
        if (json == "")
        {
            Hashtable ht = new Hashtable();
            dt_a013010101 = Fun.getA013010101(a00201_key);
            ht.Add("P1", Fun.DataTable2Json(dt_a013010101));
            ht.Add("P2", dt_a00201.Rows[0]["TABLE_KEY"].ToString());
            ht.Add("P3", dt_a00201.Rows[0]["main_key"].ToString());
            ht.Add("P4", dt_a00201.Rows[0]["table_id"].ToString());
            ht.Add("P5", Fun.DataTable2Json(Fun.getDtBySql("select t.* from A00210_V01 t  where a00201_key ='" + dt_a00201.Rows[0]["A00201_KEY"].ToString() + "' and   rb_type='C'")));
            ht.Add("P6", Fun.DataTable2Json(Fun.getDtBySql("select t.* from A00210_V01 t  where a00201_key ='" + dt_a00201.Rows[0]["A00201_KEY"].ToString() + "' and   rb_type='U'")));
            ht.Add("P7", dt_a00201.Rows[0]["tbl_type"].ToString());
            ht.Add("P8", Fun.DataTable2Json(Fun.getDtBySql("select t.*   from a00201_v02 t  where a00201_key ='" + dt_a00201.Rows[0]["A00201_KEY"].ToString() + "' order by sort_by")));

            //        ht.Add("P001", Fun.DataTable2Json(Fun.getDtBySql("Select t.* from A00201_V01 t where a00201_key = '" + a00201_key + "'")));
            //      ht.Add("P002", Fun.getA0130101(a00201_key));
           //  ht.Add("P003", Fun.DataTable2Json(dt_a013010101));
            ht.Add("P004", Fun.getShowDataSql(a00201_key));
            string jsonText = JsonConvert.SerializeObject(ht);
            Session["J_" + dt_a00201.Rows[0]["A00201_KEY"].ToString()] = jsonText;
            json = jsonText;
        }
        else
        {
            dt_a013010101 = Fun.getdtByJson(Fun.getJson(json, "P1"));
        }
        showdatasql = Fun.getJson(json, "P004");       
    }


  
}
