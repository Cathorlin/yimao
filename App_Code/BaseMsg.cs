using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Base;
using  System.Xml;
/// <summary>
/// BaseMsg 的摘要说明

/// 消息类 所有的消息 都必须通过消息 类来控制
/// 根据不同的消息类型 返回不同的结果

/// </summary>
public class BaseMsg
{
    db20120229 db = new db20120229();
    public BaseMsg()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }
    /// <summary>
    /// 根据msg_id获取消息
    /// 返回格式 00 + 内容 2位码 表示执行消息的方式

    ///          01 
    /// </summary>
    /// <param name="msg_id">消息编码</param>
    /// <param name="key_id">消息的对应的 表的主键</param>
    /// <returns></returns>
    public string getMsgByMsgId(string msg_id ,string key_id)
    {
        DataTable dt_msg = new DataTable();
        string sql = "Select PKG_MSG.getMsgByMsgId('" + msg_id + "','" + key_id + "','WEB','"+ GlobeAtt.LANGUAGE_ID+"') as c  from dual ";
        int li_db = db.ExcuteDataTable(dt_msg, sql, CommandType.Text);
        if (li_db < 0)
        {
            return "01获取消息失败！";
        }
        if (dt_msg.Rows.Count == 0)
        {
            return "01消息类型" + msg_id + "未定义！";        
        }

        return dt_msg.Rows[0][0].ToString();
    
    }

    public static string getMsg(string msg_id)
    {
        try
        {
            System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
            string filename = HttpRuntime.AppDomainAppPath + "\\"+GlobeAtt.LANGUAGE_ID + "Msg.xml";
            doc.Load(filename);
            XmlNodeList rowsNode = doc.SelectNodes("/MSG/" + msg_id);
            int i = 0;
            string msg_ = "";
            if (rowsNode != null)
            {
                foreach (XmlNode rowNode in rowsNode)
                {

                    msg_ = rowNode.InnerXml;
                    break;
                }
            }
            // string data_ = "";
            //  XmlNodeList rowsNode = doc.SelectNodes("/DATA/ROW");
            return msg_;
        }
        catch
        {
            return "";
        }
    }

}
