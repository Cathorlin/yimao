using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

/// <summary>
///Log 的摘要说明
/// </summary>
public class SaveLog
{
    public  static void Verification(string msg_)
    {
        
               try
                {
                    string uploadfilepath = HttpContext.Current.Server.MapPath("/") + "Logs\\"+ DateTime.Now.ToString("yyyyMMdd") + ".log";
                   
  
                    FileStream file = new FileStream(uploadfilepath, FileMode.Append);
                    StreamWriter sw = new StreamWriter(file);

                    sw.WriteLine(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss:fff") +":"+ msg_);
                    sw.Close();
                }
                catch (IOException e)
                {
                    Console.WriteLine(e.Message);
                }
        
    }
}
