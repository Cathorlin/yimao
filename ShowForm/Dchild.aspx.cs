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

public partial class ShowForm_Dchild : BasePage
{
    public string A014ID = ""; //要编辑的功能键
    public string ROWID = ""; //要编辑的功能键
    public DataTable dt_A014 = new DataTable();
    public DataTable dt_data = new DataTable();
    public string child_url = "";
    public string exec_sql = "";
    public string width_ = "0";
    public string height_ = "0";
    public string IF_FIRST = "";
    public string data_index = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        base.PageBase_Load(sender, e);
        /*获取当前的角色列表*/
        A014ID = Request.QueryString["A014ID"] == null ? "" : Request.QueryString["A014ID"].ToString();
        ROWID = Request.QueryString["ROWID"] == null ? "" : Request.QueryString["ROWID"].ToString();
        dt_A014 = Fun.getDtBySql("Select t.* from A014 t where t.a014_id='" + A014ID + "'");
        if (dt_A014.Rows.Count == 0)
        {
            Response.Write("<script>winclose();</script>");
        
        }
         IF_FIRST = dt_A014.Rows[0]["IF_FIRST"].ToString();

         DataTable dt_index = new DataTable();
        dt_index = Fun.getDtBySql("select f_get_data_index() as c  from dual");
        data_index = dt_index.Rows[0][0].ToString();
        try
        {
            if (IF_FIRST == "4")
            {
                child_url = dt_A014.Rows[0]["A014_SQL"].ToString();
                DataTable dt_url = new DataTable();
                dt_url = Fun.getDtBySql(child_url.Replace("[ROWID]", ROWID));
                child_url = dt_url.Rows[0][0].ToString();
                width_ = dt_url.Rows[0][1].ToString();
                height_ = dt_url.Rows[0][2].ToString();
            }
            if (IF_FIRST == "5")
            {
                child_url = dt_A014.Rows[0]["NEXT_DO"].ToString();
                exec_sql = dt_A014.Rows[0]["A014_SQL"].ToString();
                
                dt_data = Fun.getDtBySql(child_url.Replace("[ROWID]", ROWID));
                        int max_width = 0;
                        int max_height = 0;   
                        for (int i = 0; i < dt_data.Rows.Count; i++)
                        {
                        
                            string width = dt_data.Rows[i]["width"].ToString();
                            string height = dt_data.Rows[i]["height"].ToString();
                            if (int.Parse(width) > max_width)
                            {
                                max_width = int.Parse(width);
                            }
                            max_height += int.Parse(height)+25;
                        }
                        width_ = max_width.ToString();
                        height_ = max_height.ToString();

            }
        }
        catch
        {

            Response.Write("<script> alert(\"" + BaseMsg.getMsg("M0014") + "\");winclose();</script>");
        }

        
    }





}
