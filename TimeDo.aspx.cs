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
using System.IO;
public partial class TimeDo :BasePage
{
    public int  time_out = 60000;
    public DataTable dt_d001 = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {

        /*
        string fileName = "D:\\public\\web\\ifsappzh.dic";
        StreamReader reader = new StreamReader(fileName, System.Text.Encoding.Default);
    
        try
        {
            while (reader.Peek() >= 0)
            {
                string strRecord = reader.ReadLine();
                string sql0 = "insert into a0(col) select '" + strRecord.Replace("'", "''") + "' from dual ";
                Fun.db.BeginTransaction();
                try
                {
                  
                    Fun.db.ExecuteNonQuery(sql0, CommandType.Text);
                    Fun.db.Commit();
                }
                catch (Exception ex)
                {
                    Fun.db.Rollback();
                    Response.Write(strRecord);

                }
            }
        }
        catch (Exception ex)
        {

            Response.Write ("文件:" + fileName + "导入失败,错误行是第原因是: " + ex.Message);

        }
        //相关资源的消除 
        finally
        {
            reader.Close();

        }


        return;
        */
        try
        {
            time_out = int.Parse(Fun.getA022Name("BS_IMPORT_TIMEOUT")) * 60 ;
        }
        catch
        {
            time_out = 10;
        }
        Response.Write(GlobeAtt.Sysdatetime);
        time_out = time_out  ;
        string sql = Fun.getA022Name("BS_IMPORT_SQL");
        DataTable dt_a308_id = new DataTable();
        dt_a308_id = Fun.getDtBySql(sql);

        Import im = new Import();
        /*获取客户对应的文件夹*/
        string key_ = "1";
        string psh = HttpContext.Current.Request.MapPath("data\\import\\" + key_);
        for (int i = 0; i < dt_a308_id.Rows.Count; i++)
        {
            key_ = dt_a308_id.Rows[i]["a308_id"].ToString();
            im.d001_id = dt_a308_id.Rows[i]["d001_id"].ToString();
            im.d001_name = dt_a308_id.Rows[i]["d001_name"].ToString();
            psh = HttpContext.Current.Request.MapPath("data\\import\\" + key_);
            im.getFileList(psh, key_);
        }
    }
}
