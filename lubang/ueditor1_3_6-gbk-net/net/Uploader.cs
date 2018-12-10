using System;
using System.Collections.Generic;
using System.Web;
using System.IO;
using System.Collections;
using System.Text.RegularExpressions;


/// <summary>
/// UEditor�༭��ͨ���ϴ���
/// </summary>
public  class Uploader
{
     string state = "SUCCESS";

     string URL = null;
     string currentType = null;
     string uploadpath = null;
     string filename = null;
     string originalName = null;
     HttpPostedFile uploadFile = null;

    /**
  * �ϴ��ļ�����������
  * @param HttpContext
  * @param string
  * @param  string[]
  *@param int
  * @return Hashtable
  */
    public  Hashtable upFile(HttpContext cxt, string pathbase, string[] filetype, int size)
    {
        pathbase = pathbase + "/";
        uploadpath = cxt.Server.MapPath(pathbase);//��ȡ�ļ��ϴ�·��

        try
        {
            uploadFile = cxt.Request.Files[0];
            originalName = uploadFile.FileName;

            //Ŀ¼����
            createFolder();

            //��ʽ��֤
            if (checkType(filetype))
            {
                //��������ļ�����
                state = "\u4e0d\u5141\u8bb8\u7684\u6587\u4ef6\u7c7b\u578b";
            }
            //��С��֤
            if (checkSize(size))
            {
                //�ļ���С������վ����
                state = "\u6587\u4ef6\u5927\u5c0f\u8d85\u51fa\u7f51\u7ad9\u9650\u5236";
            }
            //����ͼƬ
            if (state == "SUCCESS")
            {
                filename = NameFormater.Format(cxt.Request["fileNameFormat"], originalName);
                var testname = filename;
                var ai = 1;
                while (File.Exists(uploadpath + testname))
                {
                    testname =  Path.GetFileNameWithoutExtension(filename) + "_" + ai++ + Path.GetExtension(filename); 
                }
                uploadFile.SaveAs(uploadpath + testname);
                URL = pathbase + testname;
            }
        }
        catch (Exception)
        {
            // δ֪����
            state = "\u672a\u77e5\u9519\u8bef";
            URL = "";
        }
        return getUploadInfo();
    }

    /**
 * �ϴ�Ϳѻ����������
  * @param HttpContext
  * @param string
  * @param  string[]
  *@param string
  * @return Hashtable
 */
    public  Hashtable upScrawl(HttpContext cxt, string pathbase, string tmppath, string base64Data)
    {
        pathbase = pathbase + DateTime.Now.ToString("yyyy-MM-dd") + "/";
        uploadpath = cxt.Server.MapPath(pathbase);//��ȡ�ļ��ϴ�·��
        FileStream fs = null;
        try
        {
            //����Ŀ¼
            createFolder();
            //����ͼƬ
            filename = System.Guid.NewGuid() + ".png";
            fs = File.Create(uploadpath + filename);
            byte[] bytes = Convert.FromBase64String(base64Data);
            fs.Write(bytes, 0, bytes.Length);

            URL = pathbase + filename;
        }
        catch (Exception e)
        {
            state = "δ֪����";
            URL = "";
        }
        finally
        {
            fs.Close();
            deleteFolder(cxt.Server.MapPath(tmppath));
        }
        return getUploadInfo();
    }

    /**
* ��ȡ�ļ���Ϣ
* @param context
* @param string
* @return string
*/
    public  string getOtherInfo(HttpContext cxt, string field)
    {
        string info = null;
        if (cxt.Request.Form[field] != null && !String.IsNullOrEmpty(cxt.Request.Form[field]))
        {
            info = field == "fileName" ? cxt.Request.Form[field].Split(',')[1] : cxt.Request.Form[field];
        }
        return info;
    }

    /**
     * ��ȡ�ϴ���Ϣ
     * @return Hashtable
     */
    private  Hashtable getUploadInfo()
    {
        Hashtable infoList = new Hashtable();

        infoList.Add("state", state);
        infoList.Add("url", URL);

        if (currentType != null)
            infoList.Add("currentType", currentType);
        if (originalName != null)
            infoList.Add("originalName", originalName);
        return infoList;
    }

    /**
     * �������ļ�
     * @return string
     */
    private  string reName()
    {
        return System.Guid.NewGuid() + getFileExt();
    }

    /**
     * �ļ����ͼ��
     * @return bool
     */
    private  bool checkType(string[] filetype)
    {
        currentType = getFileExt();
        return Array.IndexOf(filetype, currentType) == -1;
    }

    /**
     * �ļ���С���
     * @param int
     * @return bool
     */
    private  bool checkSize(int size)
    {
        return uploadFile.ContentLength >= (size * 1024*1024);
    }

    /**
     * ��ȡ�ļ���չ��
     * @return string
     */
    private  string getFileExt()
    {
        string[] temp = uploadFile.FileName.Split('.');
        return "." + temp[temp.Length - 1].ToLower();
    }

    /**
     * ���������Զ������洢�ļ���
     */
    private  void createFolder()
    {
        if (!Directory.Exists(uploadpath))
        {
            Directory.CreateDirectory(uploadpath);
        }
    }

    /**
     * ɾ���洢�ļ���
     * @param string
     */
    public  void deleteFolder(string path)
    {
        //if (Directory.Exists(path))
        //{
        //    Directory.Delete(path, true);
        //}
    }
}


public static class NameFormater
{
    public static string Format(string format, string filename)
    {
        if (String.IsNullOrWhiteSpace(format))
        {
            format = "{filename}{rand:6}";
        }
        string ext = Path.GetExtension(filename);
        filename = Path.GetFileNameWithoutExtension(filename);
        format = format.Replace("{filename}", filename);
        format = new Regex(@"\{rand(\:?)(\d+)\}", RegexOptions.Compiled).Replace(format, new MatchEvaluator(delegate(Match match)
        {
            var digit = 6;
            if (match.Groups.Count > 2)
            {
                digit = Convert.ToInt32(match.Groups[2].Value);
            }
            var rand = new Random();
            return rand.Next((int)Math.Pow(10, digit), (int)Math.Pow(10, digit + 1)).ToString();
        }));
        format = format.Replace("{time}", DateTime.Now.Ticks.ToString());
        format = format.Replace("{yyyy}", DateTime.Now.Year.ToString());
        format = format.Replace("{yy}", (DateTime.Now.Year % 100).ToString("D2"));
        format = format.Replace("{mm}", DateTime.Now.Month.ToString("D2"));
        format = format.Replace("{dd}", DateTime.Now.Day.ToString("D2"));
        format = format.Replace("{hh}", DateTime.Now.Hour.ToString("D2"));
        format = format.Replace("{ii}", DateTime.Now.Minute.ToString("D2"));
        format = format.Replace("{ss}", DateTime.Now.Second.ToString("D2"));
        var invalidPattern = new Regex(@"[\\\/\:\*\?\042\<\>\|]");
        format = invalidPattern.Replace(format, "");
        return format + ext;
    }
}