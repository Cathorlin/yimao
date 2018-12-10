using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net.Mail;
using System.Text;
using Base;
using System.Data;

public partial class SendEmail : System.Web.UI.Page
{
    Oracle db = new Oracle();
    DataTable dt_table = new DataTable();
    private static bool issend = true;
    protected void Page_Load(object sender, EventArgs e)
    {
        /// 调用方法  
        Init();
    }

    static object mylock = new object();//定义锁
    //初始化
    public void Init()
    {
        //在应用程序启动时运行的代码
        System.Timers.Timer t = new System.Timers.Timer(35 * 1000);  //实例化Timer类，设置间隔时间为一天24*60*1000；   
        t.Elapsed += new System.Timers.ElapsedEventHandler(sendEmailBySingle);  //到达时间的时候执行事件；   
        t.AutoReset = true;  //设置是执行一次（false）还是一直执行(true)；   
        t.Enabled = true;
        t.Start();
    }

    public void sendEmailBySingle(System.Object sender, System.Timers.ElapsedEventArgs e)
    {
        Oracle db = new Oracle();
        DataTable dt_table = new DataTable();
        if (issend)
        {
            issend = false;
            string sql = "Select t.* from A306_EMAIL t where STATUS='0' and email_state='0' and email is not null  order by t.enter_date";//
            db.ExcuteDataTable(dt_table, sql, CommandType.Text);

            for (int i = 0; i < dt_table.Rows.Count; i++)
            {
                string fromname = dt_table.Rows[i]["SEND_A007_NAME"].ToString();  //发送者称谓
                string from = dt_table.Rows[i]["SMTP_USERID"].ToString();  //发送者邮箱地址
                string password = dt_table.Rows[i]["SMTP_PASSWORD"].ToString();//发送者邮箱密码
                string server = dt_table.Rows[i]["SMTP_SERVER"].ToString();  //stmp服务器EMAIL
                string to = dt_table.Rows[i]["EMAIL"].ToString();  //接收者邮箱地址
                string subject = dt_table.Rows[i]["TITTLE"].ToString();  //邮件标题
                string body = dt_table.Rows[i]["SEND_EMAIL"].ToString();  //邮件内容
                string key = dt_table.Rows[i]["A306_ID"].ToString();//此邮件的主键
                string returnLng;
                returnLng = SendMail(from, fromname, to, subject, body, from, password, server, "");
                if (returnLng == "1")//1:发送成功，其他发送失败！
                {
                    //send successfully
                    string strcmd = "update A306 set status ='1',send_date=sysdate,email_state='1',email_date=sysdate,email_result='发送成功！' where A306_ID = '" + key + "'";
                    db.ExecuteNonQuery(strcmd, CommandType.Text);
                    continue;
                }
                else
                {
                    //send failed
                    string strcmd = "update A306 set status ='2',send_date=sysdate,email_state='1',email_date=sysdate,email_result='" + returnLng + "' where A306_ID = '" + key + "'";
                    db.ExecuteNonQuery(strcmd, CommandType.Text);
                    continue;

                }
            }
            issend = true;
        }
    }

    /// <summary> 
    /// 发送邮件程序 
    /// </summary> 
    /// <param name="from">发送人邮件地址</param> 
    /// <param name="fromname">发送人显示名称</param> 
    /// <param name="to">发送给谁（邮件地址）</param> 
    /// <param name="subject">标题</param> 
    /// <param name="body">内容</param> 
    /// <param name="username">邮件登录名</param> 
    /// <param name="password">邮件密码</param> 
    /// <param name="server">邮件服务器</param> 
    /// <param name="fujian">附件</param> 
    /// <returns>send ok</returns> 
    private string SendMail(string from, string fromname, string to, string subject, string body, string username, string password, string server, string fujian)
    {
        try
        {
            //邮件发送类 
            MailMessage mail = new MailMessage();
            //是谁发送的邮件 
            mail.From = new MailAddress(from, fromname);
            //发送给谁 
            mail.To.Add(to);
            //标题 
            mail.Subject = subject;
            //内容编码 
            mail.BodyEncoding = Encoding.Default;
            //发送优先级 
            mail.Priority = MailPriority.High;
            //邮件内容 
            mail.Body = body;
            //是否HTML形式发送 
            mail.IsBodyHtml = true;
            //附件 
            if (fujian.Length > 0)
            {
                mail.Attachments.Add(new Attachment(fujian));
            }
            //邮件服务器和端口 
            SmtpClient smtp = new SmtpClient(server, 25);
            smtp.UseDefaultCredentials = true;
            //指定发送方式 
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            //指定登录名和密码 
            smtp.Credentials = new System.Net.NetworkCredential(username, password);
            //超时时间 
            smtp.Timeout = 10000;
            smtp.Send(mail);
            return "1";
        }
        catch (Exception exp)
        {
            return exp.ToString();
        }
    }


}




