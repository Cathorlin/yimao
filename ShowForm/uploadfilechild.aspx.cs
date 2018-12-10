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

public partial class ShowForm_uploadfilechild : System.Web.UI.Page
{
    public string model_file_name = "";
    public string table_id = "";
    public string line_no = "";
    public string key_id = "";
    public DataTable dt_a10001 = new DataTable();
    public DataTable dt_a308 = new DataTable();
    public DataTable dt_a30801 = new DataTable();
    public DataTable dt_a30802 = new DataTable();
    public DataTable dt_data = new DataTable();
    
    public string a30803_key = "";
    string FILE_TYPE;
    string a308_id;
    BaseFun fun = new BaseFun();
    string basekey = "";
    public static string uploadfilepath = "../DATA/FILE";
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            table_id = Request.QueryString["table_id"] == null ? "" : Request.QueryString["table_id"].ToString();
            key_id = Request.QueryString["key_id"] == null ? "" : Request.QueryString["key_id"].ToString();
            line_no = Request.QueryString["line_no"] == null ? "" : Request.QueryString["line_no"].ToString();
            basekey = Request.QueryString["basekey"] == null ? "" : Request.QueryString["basekey"].ToString();
            basekey = basekey.Replace("-", "+");
            key_id = key_id.Replace("-", "+");
            key_id = key_id.Replace("'", "''");
            string sql = "Select t.* from A10001 t where t.table_id='" + table_id + "' and  line_no='" + line_no + "'";
            dt_a10001 = fun.getDtBySql(sql);
            a308_id = dt_a10001.Rows[0]["col_mask"].ToString();
            dt_a308 = fun.getDtBySql("Select t.* from A308 t where t.a308_id='" + a308_id + "'");            
            FILE_TYPE = dt_a308.Rows[0]["FILE_TYPE"].ToString().ToUpper();
           // FILE_TYPE = FILE_TYPE.Substring(0, 3);
            if (FILE_TYPE != "*")
            {
                string model_file_name_ = HttpContext.Current.Request.MapPath("../data/" + a308_id + "." + FILE_TYPE);
                if (System.IO.File.Exists(model_file_name_))
                {
                    model_file_name = fun.GetIndexUrl() + "\\data\\" + a308_id + "." + FILE_TYPE;
                }
                else
                {
                    model_file_name = "";
                }
            }
            else
            {
                model_file_name = "";
            }
            dt_a30801 = fun.getDtBySql("Select t.* from A30801 t where t.a308_id='" + a308_id + "'");
            dt_a30802 = fun.getDtBySql("Select t.* from A30802 t where t.a308_id='" + a308_id + "'");
            uploadfilepath = "..\\data\\import\\" + a308_id + "\\upload";
            sql = "Select count(*) from a30803 t where a308_id='" + a308_id + "' and t.BASE_TABLE_ID='" + table_id + "' and BASE_COLUMN_ID='" + dt_a10001.Rows[0]["COLUMN_ID"].ToString() + "' and  BASE_KEY='" + basekey + "'";
            DataTable dt_count = new DataTable();
            dt_count = fun.getDtBySql(sql);
            if (dt_count.Rows[0][0].ToString() == "0")
            {
                DataTable dt_key = new DataTable();
                dt_key = fun.getDtBySql("select s_a30803.nextval as c from dual ");
                a30803_key = dt_key.Rows[0][0].ToString();
                sql = "insert into a30803(a308_id,line_no,d001_id,d001_name,BASE_TABLE_ID,BASE_COLUMN_ID,BASE_KEY,BASE_USER,BASE_DATE,state)";
                sql += "Select '" + a308_id + "'," + a30803_key + ",'" + key_id + "','','" + table_id + "','" + dt_a10001.Rows[0]["COLUMN_ID"].ToString() + "','" + basekey + "','" + GlobeAtt.A007_KEY + "',sysdate,'-1' from dual ";
            //    Response.Write(sql);
                fun.execSqlOnly(sql);
            }
            else
            {
                DataTable dt_key = new DataTable();
                sql = "select line_no as c from a30803 t  where a308_id='" + a308_id + "' and t.BASE_TABLE_ID='" + table_id + "' and BASE_COLUMN_ID='" + dt_a10001.Rows[0]["COLUMN_ID"].ToString() + "' and  BASE_KEY='" + basekey + "'";
               // Response.Write(sql);
                dt_key = fun.getDtBySql(sql);
                a30803_key = dt_key.Rows[0][0].ToString();
                
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message.Replace("\n", ";").Replace("'", "\""));
        }

        

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        try
        {

            if (fileupdate.PostedFile != null && fileupdate.PostedFile.ContentLength > 0)
            {
                string ls_type = fileupdate.PostedFile.ContentType.ToString();
                uploadfilepath = uploadfilepath.Equals(string.Empty) ? "uploadfilepath" : uploadfilepath;
                if (System.IO.Path.GetExtension(fileupdate.PostedFile.FileName).ToUpper() != "." + FILE_TYPE && FILE_TYPE  != "*")
                {
                    Response.Write("<script>alert('文件格式必须是" + FILE_TYPE +"文件!');</script>");
                    return;
                }
                string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fileupdate.PostedFile.FileName);
                string vpsh = uploadfilepath + "/" + filename;
                string psh = MapPath(vpsh);
                if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(psh)))
                {
                    System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(psh));
                }

                
               
                /*把当前的原文件名称和新的文件名称保存*/
                string sql = "update a30803 set FROM_FILE='" + fileupdate.PostedFile.FileName + "',import_Date=sysdate,IMPORT_USER = '" + GlobeAtt.A007_KEY + "' ,file_name='" + filename + "' where line_no=" + a30803_key;
                fun.execSqlOnly(sql);

                fileupdate.PostedFile.SaveAs(psh);

                sql = "update a30803 set  modi_date=sysdate,modi_user = '" + GlobeAtt.A007_KEY + "'  where line_no=" + a30803_key;
                fun.execSqlOnly(sql);
                try
                {
                    sql = "update " + table_id + " set  " + dt_a10001.Rows[0]["COLUMN_ID"].ToString() + "='" + filename + "' where  rowid='" + key_id.Replace("''", "'") + "'";
                    fun.execSqlOnly(sql);
                }
                catch
                { 
                
                }

                

                Session["uploadFile"] = filename;                
                string ls_msg = "1";
                if (model_file_name != "" || FILE_TYPE == "*" )
                {
                    Import imp = new Import();
                    ls_msg = imp.ImportFileData(psh, a308_id, a30803_key, ref dt_data);
                }
                else
                {
                    ls_msg = "1";
                }
          
                if (ls_msg != "1")
                {
                    GridView1.DataSource = dt_data;
                    GridView1.DataBind();
                    GridView1.Visible = true;
                    ls_msg = ls_msg.Replace(psh, fileupdate.PostedFile.FileName);
                    ls_msg = ls_msg.Replace("\n", ";").Replace("'", "\"").Replace("\"", "").Replace("\\", "\\\\");
                    Response.Write("<script>");
                    Response.Write("alert(\"" + ls_msg + "\");");
                    Response.Write("</script>");
                    System.IO.File.Delete(psh);
                }
                else
                {
                     Response.Write("<script>");
                     Response.Write("var v_v = new Object();");
                     Response.Write(" v_v.DataId = \""+ filename+"\";");
                     Response.Write("  v_v.Para = window.dialogArguments;");
                     Response.Write("  window.returnValue=v_v;");
                     Response.Write("  v_v.Para = window.dialogArguments;");
                     Response.Write("  window.close();");   
                     Response.Write("</script>");
                }

            }
            else
            {
                Session["uploadFile"] = "";
                Response.Write("<script>alert(\"请选择文件！\");</script>");

            }
        }
        catch (Exception ee)
        {
            Session["uploadFile"] = "";
            Response.Write("<script>alert('上传文件失败！" + ee.Message.Replace("\n", ";").Replace("'", "\"") + "');</script>");
        }




    }
}
