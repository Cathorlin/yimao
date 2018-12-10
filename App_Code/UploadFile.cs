using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.IO;
using Base;
using System.Data;

/// <summary>
///PhotoUpload 的摘要说明
/// </summary>
[WebService(Namespace = "http://microsoft.com/webservices/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
//若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消对下行的注释。 
// [System.Web.Script.Services.ScriptService]
public class UploadFile : System.Web.Services.WebService
{
    public Oracle db = new Oracle();

    public UploadFile()
    {

        //如果使用设计的组件，请取消注释以下行 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld(string str1)
    {
        return str1 + "成功";
    }

    [WebMethod]
    public int Add(int a, int b)
    {
        return a + b;
    }

    [WebMethod]
    public int uploadFile(byte[] bs, String fileName)
    {
        FileStream out1 = null;
        try
        {
            String path = String.Format("{0:yyyyMMdd_hhmmss}_{1}", DateTime.Now, fileName);
            String newFile = HttpContext.Current.Server.MapPath("upload/" + path); // 上传文件存放路径
            out1 = new FileStream(newFile, FileMode.CreateNew, FileAccess.Write);
            try
            {
                out1.Write(bs, 0, bs.Length);
            }
            catch (IOException e)
            {
                // TODO Auto-generated catch block
                return -1;
            }
        }
        catch (FileNotFoundException e)
        {
            // TODO Auto-generated catch block

            return -1;
        }
        finally
        {
            if (out1 != null)
            {
                try
                {
                    out1.Close();
                }
                catch (IOException e)
                {
                    // TODO Auto-generated catch block

                }
            }
        }
        return 0;
    }
    [WebMethod] //android大于1M上传会出问题(内存溢出)
    public int uploadImage(String filename, String image)
    {

        FileStream out1 = null;
        byte[] bs = Convert.FromBase64String(image);
        try
        {
            String path = String.Format("{0:yyyyMMdd_hhmmss}_{1}", DateTime.Now, filename);
            String newFile = HttpContext.Current.Server.MapPath("upload/" + path); // 上传文件存放路径
            out1 = new FileStream(newFile, FileMode.CreateNew, FileAccess.Write);
            try
            {
                out1.Write(bs, 0, bs.Length);
            }
            catch (IOException e)
            {
                // TODO Auto-generated catch block
                ;
            }
        }
        catch (FileNotFoundException e)
        {
            // TODO Auto-generated catch block

            return -1;
        }
        finally
        {
            if (out1 != null)
            {
                try
                {
                    out1.Close();
                }
                catch (IOException e)
                {
                    // TODO Auto-generated catch block

                }
            }
        }
        return 0;
    }
    [WebMethod] //断点续传
    public int uploadResume(String filename, String image, int tag, string type, string id)
    {
        int i = 0;
        FileStream out1 = null;
        byte[] bs = Convert.FromBase64String(image);
        try
        {
            String newFile = HttpContext.Current.Server.MapPath("../images/upload/" + filename); // 上传文件存放路径
            if (tag == 0)
            {
                if (File.Exists(filename))
                    File.Delete(filename);
                out1 = new FileStream(newFile, FileMode.CreateNew, FileAccess.Write);
            }
            else
            {
                out1 = new FileStream(newFile, FileMode.Append, FileAccess.Write);
            }
            try
            {
                out1.Write(bs, 0, bs.Length);
            }
            catch (IOException e1)
            {
                // TODO Auto-generated catch block
            }
        }
        catch (FileNotFoundException e2)
        {
            // TODO Auto-generated catch block
            return -1;
        }
        finally
        {
            if (out1 != null)
            {
                try
                {
                    if (type == "M001")
                    {
                        string sql = "update m001 t set t.picture='" + filename + "' where t.mobile_no='" + id + "'";
                        i = db.ExecuteNonQuery(sql, CommandType.Text);
                    }
                    else if (type == "M041")
                    {
                        string sql = "update m041 t set t.head_icon='" + filename + "' where t.m041_id='" + id + "'";
                        i = db.ExecuteNonQuery(sql, CommandType.Text);
                    }
                    else if (type == "M043")
                    {
                        string sql = "update m043 t set t.head_icon='" + filename + "' where t.m043_id='" + id + "'";
                        i = db.ExecuteNonQuery(sql, CommandType.Text);
                    }
                    else
                    {
                        i = 0;
                    }
                    out1.Close();
                }
                catch (IOException e)
                {
                    // TODO Auto-generated catch block
                }
            }
        }

        if (i > 0)
        {
            return tag;
        }
        else
        {
            return -1;
        }
    }

}
