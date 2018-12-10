<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Drawing;
using System.IO;
using System.Text;
using System.Data;
using Base;
using System.Data.OracleClient;
public class Handler : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/html";
       
        
        //不知道为什么获取不到  
        string type = context.Request.Form["type"];
        string key = context.Request.Form["key"];
        string mainkey = context.Request.Form["mainkey"];
        string v_ = "";
        StringBuilder sb = new StringBuilder();
        if (type == "file")
        {
            HttpPostedFile fileupdate = context.Request.Files["file"];
            string filePath = fileupdate.FileName;           
            string ls_type = fileupdate.ContentType.ToString();
            string uploadfilepath = "images\\M00203\\"; ;
            string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(fileupdate.FileName);
            string vpsh = uploadfilepath + "/" + filename;
            string psh = context.Server.MapPath(vpsh);
            if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(psh)))
            {
                System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(psh));
            }
          
            //sb.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            // sb.Append("<data>");
            try
            {
                fileupdate.SaveAs(psh);
                //上传成功后显示IMG文件 
                sb.Append("showmsg('" + key + "','" + filename + "');");
                v_ = filename;
                //把数据写入数据库
                
            }
            catch (Exception ex)
            {
                sb.Append("alert('" + ex.Message + "');");
                v_ = "";
            }
            // sb.Append("</data>");
          
            //

            // sb.Append("showmsg('" + key + "','" + filename + "')");
           
        }
        else
        {
            string show_html = HttpUtility.UrlDecode(context.Request.Form["show_html"]);
            v_ = show_html;
           
        }
        if (v_ != "")
        {
            OracleParameter[] parmeters =
           {
                new OracleParameter("m00203_key_", OracleType.LongVarChar,500),
                new OracleParameter("column_id_", OracleType.LongVarChar,30000),
                new OracleParameter("col_vaule_", OracleType.LongVarChar,30000),
                new OracleParameter("user_id_", OracleType.NVarChar,200)
           };
            parmeters[0].Direction = ParameterDirection.Input;
            parmeters[1].Direction = ParameterDirection.Input;
            parmeters[2].Direction = ParameterDirection.Input;
            parmeters[3].Direction = ParameterDirection.Input;
            parmeters[0].Value = mainkey;
            parmeters[1].Value = key;
            parmeters[2].Value = v_;
            parmeters[3].Value = "wtl";
            Oracle db = new Oracle();
           // db.BeginTransaction();

            int li_db = 1;// db.ExecuteNonQuery("pkg_m00203.update_column", parmeters);
            if (li_db < 0)
            {
                //db.Rollback();
                sb.Append("alert('更新数据库失败！');");
            }
            else
            {
                //db.Commit();
                if (type != "file")
                {
                    sb.Append("alert('更新数据库成功！');");
                }
            }

        }
        context.Response.Write(sb.ToString());
        context.Response.End();  
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}