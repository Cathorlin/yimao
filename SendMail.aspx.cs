using System;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net.Mail;
using System.Net;
using System.Text;
using Base;
using OpenPop.Mime;
using OpenPop.Mime.Header;
using OpenPop.Pop3;
using OpenPop.Pop3.Exceptions;
using OpenPop.Common.Logging;
using Message = OpenPop.Mime.Message;
public partial class SendMail : System.Web.UI.Page
{
    public DataTable dt_main = new DataTable();
    public DataTable dt_list = new DataTable();
    public string[] html_list ;

    public string FROM_EMAIL_TIMES = "100";
    public db20120229 db = new db20120229();
    public string ls_Date = DateTime.Now.ToString();
    Base.HttpRequest http = new Base.HttpRequest();
    BaseFun fun = new BaseFun();  
    protected void Page_Load(object sender, EventArgs e)
    {       
        try
        {
            string  sql_a022 = "Select t.* from a022 t where t.a022_id='FROM_EMAIL_TIMES'";
            DataTable dt_a022_ = new DataTable();
            db.ExcuteDataTable(dt_a022_, sql_a022, CommandType.Text);
            FROM_EMAIL_TIMES = dt_a022_.Rows[0]["a022_name"].ToString();

        string sql_main = "Select t.* from A306_EMAIL t where STATUS='0' and email_state='0' and email is not null  order by t.enter_date ";
        db.ExcuteDataTable(dt_main, sql_main, CommandType.Text);
        http.CharacterSet = "UTF-8";
        string msg_ = "";
        for (int i = 0; i < dt_main.Rows.Count; i++)
        {
                //登录信息                     
                string ls_send = "-1";
                string toemail = dt_main.Rows[i]["EMAIL"].ToString();
                if (toemail.IndexOf("@") > 0)
                {
                    string main_name = dt_main.Rows[i]["DESCRIPTION"].ToString();
                    string title = dt_main.Rows[i]["tittle"].ToString();
                    string A306_ID = dt_main.Rows[i]["A306_ID"].ToString();
                    string a306_name = dt_main.Rows[i]["A306_NAME"].ToString();
                    string showhtmlurl = GlobeAtt.HTTP_URL + "/linkHtml.aspx?a306id=" + A306_ID;
                    string send_email = dt_main.Rows[i]["send_email"].ToString();
                    string SEND_A007_NAME = dt_main.Rows[i]["SEND_A007_NAME"].ToString();
                    string Smtp_Userid = dt_main.Rows[i]["Smtp_Userid"].ToString();
                    string Smtp_Password = dt_main.Rows[i]["Smtp_Password"].ToString();
                    string Smtp_Server = dt_main.Rows[i]["Smtp_Server"].ToString();
                    string Smtp_Server_Portid = dt_main.Rows[i]["Smtp_Server_Portid"].ToString();
                    string html_ ="";
                    if (a306_name.IndexOf("OUT_EMAIL") == 0)
                    {   //获取包的内容
                        html_ = main_name;
                        main_name = title;
                    }
                    else
                    {
                        http.OpenRequest(showhtmlurl, showhtmlurl);                       
                        html_ = http.HtmlDocument;
                    }
                    main_name = main_name.Replace("\r", "</BR>");
                    main_name = main_name.Replace("\n", "</BR>");                   
                    if (a306_name.IndexOf("A30305_ID=") == 0)
                    {
                        if (html_.IndexOf("<NOSENDEMAIL>1</NOSENDEMAIL>") <= 0)
                        {
                            //ls_send = SendSMTPEMail(Smtp_Server, Smtp_Server_Portid,
                            //    Smtp_Userid, Smtp_Password, 
                            //    toemail, 
                            //    title,
                            //    html_, send_email, SEND_A007_NAME); 
                            ls_send = sendMail("stmp.sina.com", 25, "Cathorlin@qq.com", "Cathorlin", "lp901129", "no tittle", "hello this is smtp service", "soraka90@sina.com", false);
                        }
                        else
                        {
                            ls_send = "不需要发邮件";
                        }
                    }
                    else
                    {
                        ls_send = sendMail("stmp.sina.com", 25, "664079027@qq.com", "Cathorlin", "lp901129", "no tittle", "hello this is smtp service", "soraka90@sina.com", false);
                        //ls_send = SendSMTPEMail(Smtp_Server,Smtp_Server_Portid, Smtp_Userid, Smtp_Password, toemail, title, html_, send_email, SEND_A007_NAME);
                    }
                    string sql = "begin pkg_msg.send_mail_end('" + A306_ID + "','" + ls_send.Replace("'","''") + "'); end;";
                    fun.execSqlOnly(sql);
                    if (send_email == "" || send_email == null)
                    {
                        send_email = Smtp_Userid;
                    }
                    msg_ += DateTime.Now.ToString() + " " +send_email + "  " +  A306_ID + ":" + main_name + Environment.NewLine;
                    System.Threading.Thread.Sleep(1000);
                }
                
            }
            this.TextBox1.Text = msg_;
            deleteExportTempFile();
        }
        catch(Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
      
    /// <summary>
    /// 删除导出的临时文件夹
    /// </summary>
    public void deleteExportTempFile()
    {
        DataTable dt_temp = new DataTable();
        dt_temp = fun.getDtBySql("Select t.* from A317 t where t.enter_date < sysdate - 1 ");
       
        for (int i = 0; i < dt_temp.Rows.Count; i++)
        {
            string filename =dt_temp.Rows[i]["FILE_NAME"].ToString();
            string file_ = Server.MapPath("TEMP/" + filename);
            if (System.IO.File.Exists(file_))
            {
                System.IO.File.Delete(file_);
            }
            string a317_id = dt_temp.Rows[i]["A317_ID"].ToString();
            string sql_ = "delete from  A317 where a317_id =  " + a317_id;
            fun.execSqlOnly(sql_);

            string dir_ = filename.Substring(0, filename.IndexOf("/"));
            dt_temp = fun.getDtBySql("Select t.* from A317 t where t.FILE_NAME like '" + dir_ + "%'");
            if (dt_temp.Rows.Count == 0)
            {
                string Directory_ = Server.MapPath("TEMP/" + dir_);
                if (System.IO.Directory.Exists(Directory_))
                {
                    System.IO.Directory.Delete(Directory_);
                }
            }           
           
        }
                     

    
    }
    public string sendMail(string host, int port, string mailAddress, string username, string pwd, string title, string content, string sendTo,
           bool usePassword)
    {
        try
        {
            SmtpClient smtp = new SmtpClient(host, port);
            smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
            smtp.EnableSsl = false;


            if (usePassword)
                smtp.Credentials = new NetworkCredential(username, pwd);
            else
                smtp.UseDefaultCredentials = true;
            MailMessage mm = new MailMessage();
            mm.Priority = MailPriority.High;
            mm.From = new MailAddress(username, mailAddress, System.Text.Encoding.UTF8);
            //foreach (string toEmail in sendTo)
            //{
            //    mm.To.Add(toEmail);
            //}
            mm.To.Add(sendTo);
            mm.Subject = title; //邮件标题
            mm.SubjectEncoding = Encoding.UTF8;
            string con = EncodeString(content);
            Console.WriteLine(con);
            mm.Body = con;
            mm.BodyEncoding = System.Text.Encoding.UTF8;
            mm.IsBodyHtml = true;
            smtp.Send(mm);
            return "1";
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.ToString());
            return ex.ToString();
        }
    }

    public string EncodeString(string content)
    {
        byte[] encrypted = Convert.FromBase64String(content);
        return System.Text.ASCIIEncoding.UTF8.GetString(encrypted);
    } 



 

    //public string SendSMTPEMail(string strSmtpServer,
    //        string strSmtpServerPortid, 
    //        string strFrom, 
    //        string strFromPass, 
    //        string strto, 
    //        string strSubject,
    //        string strBody, 
    //        string send_email,
    //        string SEND_A007_NAME)
    //{
    //    try
    //    {
    //        System.Net.Mail.SmtpClient client = new SmtpClient(strSmtpServer);
    //        client.UseDefaultCredentials = false;
    //        client.Host="smtp.sina.com";
    //        client.Credentials = new System.Net.NetworkCredential(strFrom, strFromPass);
    //        client.DeliveryMethod = SmtpDeliveryMethod.Network;
    //        client.Port = int.Parse(strSmtpServerPortid);
    //        string strfrom_ = send_email;
    //        if (strfrom_ == "" || strfrom_ == null)
    //        {
    //            strfrom_ = strFrom;
    //        }
    //        System.Net.Mail.MailMessage message = new System.Net.Mail.MailMessage(strfrom_, strto, strSubject, strBody);
    //        //System.Net.Mail.Attachment attachment = new System.Net.Mail.Attachment("c:\\log.log"); 添加附件
    //        //message.Attachments.Add(attachment);
    //        message.Headers.Add("X-Priority", "3");
    //        message.Headers.Add("X-MSMail-Priority", "Normal");
    //        message.Headers.Add("X-Mailer", "Microsoft Outlook Express 6.00.2900.2869");
    //        message.Headers.Add("X-MimeOLE", "Produced By Microsoft MimeOLE V6.00.2900.2869");
    //        message.Headers.Add("ReturnReceipt", "1");
    //        message.From = new MailAddress(strfrom_, SEND_A007_NAME);
    //        message.BodyEncoding = System.Text.Encoding.Default;
    //        message.IsBodyHtml = true;
    //        client.Send(message);
    //        return "1";
    //    }
    //    catch( Exception ex)
    //    {
    //        return ex.Message;
    //    }
    //}


}
