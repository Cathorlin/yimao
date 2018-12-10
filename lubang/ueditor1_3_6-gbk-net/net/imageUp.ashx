<%@ WebHandler Language="C#" Class="imageUp" %>
<%@ Assembly Src="Uploader.cs" %>
<%@ Assembly Src="Config.cs" %>

using System;
using System.Web;
using System.IO;
using System.Collections;
using System.Linq;

public class imageUp : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        if (!String.IsNullOrEmpty(context.Request.QueryString["fetch"]))
        {
            context.Response.AddHeader("Content-Type", "text/javascript;charset=utf-8");
            context.Response.Write(String.Format("updateSavePath([{0}]);", String.Join(", ", Config.ImageSavePath.Select(x => "\"" + x + "\""))));
            return;
        }

        context.Response.ContentType = "text/plain";

        //�ϴ�����
        int size = 2;           //�ļ���С����,��λMB                             //�ļ���С���ƣ���λMB
        string[] filetype = { ".gif", ".png", ".jpg", ".jpeg", ".bmp" };         //�ļ������ʽ


        //�ϴ�ͼƬ
        Hashtable info = new Hashtable();
        Uploader up = new Uploader();

        string path = up.getOtherInfo(context, "dir");
        if (String.IsNullOrEmpty(path)) 
        {
            path = Config.ImageSavePath[0];
        } 
        else if (Config.ImageSavePath.Count(x => x == path) == 0)
        {
            context.Response.Write("{ 'state' : '�Ƿ��ϴ�Ŀ¼' }");
            return;
        }

        info = up.upFile(context, path + '/', filetype, size);                   //��ȡ�ϴ�״̬

        string title = up.getOtherInfo(context, "pictitle");                   //��ȡͼƬ����
        string oriName = up.getOtherInfo(context, "fileName");                //��ȡԭʼ�ļ���


        HttpContext.Current.Response.Write("{'url':'" + info["url"] + "','title':'" + title + "','original':'" + oriName + "','state':'" + info["state"] + "'}");  //���������������json����
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}