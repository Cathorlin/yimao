using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using System.Data.OleDb;
using System.Collections;
/// <summary>
/// Import 的摘要说明
/// 导入数据 把txt xls 的数据写入数据库
/// 第一行必须是列名称
/// </summary>
public class Import
{
    private BaseFun Fun = new BaseFun();

    private ArrayList dirs;

    public string d001_id = "";


    public string d001_name = "";
    public string log_key = "";
   
    public int totleline = 0;
    public int totlecol = 0;
    private string[] str_update_sql= new string[50000] ;
    private int update_num = 0;
    private string collist = string.Empty ;
    public string import_key = "";

    public Import()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
        dirs = new ArrayList();
    }
    public void importfile(string filname ,string a308_id ,  string a30803_)
    {
        ImportFileData(filname, a308_id);
    
    }

    public void  getFileList(string dirPath ,string key_)
    {
        //定义一个DirectoryInfo对象 
        DirectoryInfo di = new DirectoryInfo(dirPath);
        import_key = key_;
        //通过GetFiles方法，获取di目录中的所有文件的大小 
        //获取文件类型 
        DataTable dt_a308 = new DataTable();
        dt_a308 = Fun.getDtBySql("Select t.* from A308 t where a308_id='" + key_ + "'");

        string FILE_TYPE = dt_a308.Rows[0]["FILE_TYPE"].ToString().ToUpper();
        FILE_TYPE = FILE_TYPE.Substring(0, 3);
        StreamWriter fs = new StreamWriter(dirPath+"\\import.log",true,System.Text.Encoding.Default);

    //    StreamWriter FileWriter = new StreamWriter(strPath, true); //创建日志文件  
   //     FileWriter.WriteLine("Time: " + dt.ToString("HH:mm:ss") + "  Err: " + strMatter);    
     //   FileWriter.Close(); //关闭StreamWriter对象
        string sWord = GlobeAtt.Sysdatetime;
        try
        {
            fs.WriteLine("------  begin  -----------" + sWord);
            //System.IO.Path.GetDirectoryName(psh)
            foreach (FileInfo fi in di.GetFiles())
            {
                /*获取文件名称和类型*/
                if (fi.Name.ToUpper().IndexOf("." + FILE_TYPE) > 0)
                {
                    /*开始处理文件*/
                 //   fs.WriteLine(fi.Name + " ：" + DateTime.Now.ToString("HH:mm:ss"));
                    
                    sWord = fi.Name + " ：" + DateTime.Now.ToString("HH:mm:ss");
                    string line_no_ = save_begin_log(fi.Name);
                    string imp_msg = ImportFileData(fi.FullName, key_);
                    string psh = "";
                    if (imp_msg == "1")
                    {
                        /*把数据移动到成功的文件夹中*/
                        psh = dirPath + "\\SUCCESS";
                        if (!System.IO.Directory.Exists(psh))
                        {
                            System.IO.Directory.CreateDirectory(psh);
                        }
                        sWord += "成功导入了" + totleline +"条数据！";
                        save_end_log(line_no_,"");
                    }
                    else
                    {
                        psh = dirPath + "\\ERROR";
                        if (!System.IO.Directory.Exists(psh))
                        {
                            System.IO.Directory.CreateDirectory(psh);
                        }

                        /*把文件移动到失败的文件夹中*/
                        sWord += "导入失败---" + imp_msg;
                        save_end_log(line_no_, imp_msg);
                    }


                    sWord += "》》》》" +  DateTime.Now.ToString("HH:mm:ss");
                    fs.WriteLine(sWord );
                    //把文件拷贝到对应的备份文件夹中
                    File.Copy(fi.FullName, psh + "\\" + DateTime.Now.ToShortDateString().Replace("-","")+"_"+ fi.Name,true);
                    File.Delete(fi.FullName);
                }
            }
            sWord = GlobeAtt.Sysdatetime;
            fs.WriteLine("------  end   -----------" + sWord);
        }
        catch( Exception ex)
        {
            
            //throw new Exception(ex.Message);
        }
        finally
        {
            fs.Close();
        }

    }

    public string  save_begin_log( string file_name)
    {
        DataTable dt_key = new DataTable();
        dt_key = Fun.getDtBySql("select s_a30803.nextval as c from dual ");
        string line_no = dt_key.Rows[0][0].ToString();
        log_key = line_no;
        string sql = "Insert into a30803(a308_id,line_no,sort_by,file_name,IF_ERROR,enter_user,enter_date,d001_id,d001_name,state)";
        sql += "Select '" + import_key + "'," + line_no + "," + line_no + ",'" + file_name + "','0','Timer',sysdate,'" + d001_id + "','" + d001_name + "','0' from dual ";
        Fun.execSqlOnly(sql);
        return line_no;    
    }
    public string save_end_log(string line_no,string errmsg_)
    {
        string if_error= "0" ;
        string sql = "update a30803 set modi_date = sysdate,modi_user='Timer',state='1' where line_no=" + line_no;
        if (errmsg_ != "")
        {
            sql = "update a30803 set modi_date = sysdate,modi_user='Timer', DESCRIPTION='" + errmsg_ + "',if_error= '1',state='1' where line_no=" + line_no;
        }
        Fun.execSqlOnly(sql);
        return line_no;
    }
    public string ImportFileData(string fileName, string A308_ID)
    {
        DataTable dt_data = new DataTable();
        return ImportFileData(fileName, A308_ID, log_key,ref  dt_data);
    }
    public static string Chr(int asciiCode)
    {
        if (asciiCode >= 0 && asciiCode <= 255)
        {
            System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
            byte[] byteArray = new byte[] { (byte)asciiCode };
            string strCharacter = asciiEncoding.GetString(byteArray);
            return (strCharacter);
        }
        else
        {
            throw new Exception("ASCII Code is not valid.");
        }
    }
/// <summary> 
 /// 通用函数,读文本文件 
 /// </summary> 
 /// <param name="fileName">读入的文本文件名称</param> 
     public  string  ImportFileData(string fileName,string A308_ID,string log_key_,ref DataTable dt_data )     
     {
       log_key = log_key_;
       string strRecord = "";
       int errorcount = 0;
       DataTable dt_a308 = new DataTable();
       dt_a308 = Fun.getDtBySql("Select t.* from A308 t where a308_id='" + A308_ID + "'");
       DataTable mydt = new DataTable();
       string FILE_TYPE = dt_a308.Rows[0]["FILE_TYPE"].ToString().ToUpper();
       string CHECK_NAME = dt_a308.Rows[0]["CHECK_NAME"].ToString().ToUpper();
        
         string index__ = "";


         if (FILE_TYPE == "*")
         {
             FILE_TYPE = System.IO.Path.GetExtension(fileName).ToUpper();
             FILE_TYPE = FILE_TYPE.Substring(1, 3);
             if (FILE_TYPE != "XLS")
             {
                 FILE_TYPE = "TXT";
             }
         }
         else
         {
             FILE_TYPE = FILE_TYPE.Substring(0, 3);
         }
       DataTable dt_a30801 = new DataTable();
       dt_a30801 = Fun.getDtBySql("Select t.* , -1 as col_num from A30801 t where a308_id='" + A308_ID + "' order by line_no ");
       if (dt_a30801.Rows.Count == 0)
       {
           return "1";
       }
       DataTable dt_a30802 = new DataTable();

       dt_a30802 = Fun.getDtBySql("Select t.* from A30802 t where a308_id='" + A308_ID + "' order by line_no ");
       if (dt_a30802.Rows.Count == 0)
       {
           return "1";
       }
       totleline = 0;
       //读入文本文件时,一定要指定文件的编码格式.其中:default为文本文件本来的编码格式 
       //如果是简体中文的文本文件,也可以这样设置编码格式: System.Text.Encoding.GetEncode("gb2312") 
        //Encoding.GetEncode("gb2312")为简体中文编码格式,Encoding.GetEncode("big5")为繁体中文编码格式. 
       int r = 0;
       totleline = 0;  
       if (FILE_TYPE == "TXT")
       {
           string BETWEEN_FLAG = dt_a308.Rows[0]["BETWEEN_FLAG"].ToString().ToUpper();
           if (BETWEEN_FLAG == "" || BETWEEN_FLAG == null)
           {
               BETWEEN_FLAG = "0";
           }
           index__ =  Chr(int.Parse(BETWEEN_FLAG));
           StreamReader reader = new StreamReader(fileName, System.Text.Encoding.Default);
           int i, j;

           try
           {
               while (reader.Peek() >= 0)
               {
                   strRecord = reader.ReadLine(); 
                   if (r == 0)
                   {
                       string check_head_ = check_head(strRecord, index__.ToCharArray(),CHECK_NAME,ref dt_a30801);
                   }
                   else
                   {
                       check_data(strRecord, index__.ToCharArray(), dt_a30801, dt_a30802);
                   }
                   r = r + 1;
               }
           }
           catch (Exception ex)
           {

               return ("文件:[" + fileName + "]导入失败,错误行是第" + ( r + 1) .ToString() + "行,原因是: " + ex.Message);

           }
           //相关资源的消除 
           finally
           {
               reader.Close();

           }
       }
       else
       {
           int colcount = 250;
           ExcelFunc xls = new ExcelFunc();
          // xls.OpenReportTempalte(fileName);
           index__ = "|" ;
           try
           {
             string connectionStringFormat = "Provider = Microsoft.Jet.OLEDB.4.0 ; Data Source = '{0}';Extended Properties=Excel 8.0";
             connectionStringFormat = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source='{0}';" + "Extended ProPerties= \"Excel 12.0;HDR=Yes;\"";
   
               DataSet myDs = new DataSet();

            string connectString = string.Format(connectionStringFormat, fileName);
            try
            {
                 myDs.Tables.Clear();
                 myDs.Clear();
                 OleDbConnection cnnxls = new OleDbConnection(connectString);      
                 cnnxls.Open();
                 OleDbDataAdapter myDa = new OleDbDataAdapter("select * from [Sheet1$]", cnnxls);
                 myDa.Fill(myDs, "c");
                 mydt  = myDs.Tables[0];
                 cnnxls.Close();
                
            }
            catch (Exception ex)
            {
                return ("文件:[" + fileName + "]导入失败,错误行是第" + r.ToString() + "行,原因是: " + ex.Message);
  
            }
               DataColumn dc = new DataColumn();
               dc.ColumnName="ERROR_MSG_";
               mydt.Columns.Add(dc);
            for (int i = 0; i < mydt.Columns.Count - 1; i++)
            {
                strRecord += mydt.Columns[i].ColumnName + index__;
            }
            
            string check_head_ = check_head(strRecord, index__.ToCharArray(),CHECK_NAME, ref dt_a30801);
            r = 2;
            for (int i = 0; i < mydt.Rows.Count; i++)
            {
                strRecord = "";

                for (int j = 0; j < mydt.Columns.Count - 1; j++)
                {
                    strRecord += mydt.Rows[i][j].ToString() + index__;
                }
                if (strRecord.Replace(index__, "") == "")
                {
                    continue;
                }
                r = r + 1;
                try
                {
                    check_data(strRecord, index__.ToCharArray(), dt_a30801, dt_a30802);
                }
                catch (Exception ex)
                {
                    mydt.Rows[i]["ERROR_MSG_"] = ex.Message;
                    errorcount = errorcount + 1;
                }
            }
            dt_data = mydt;

           }
           catch(Exception ex)
           {

               return ("文件:" + fileName + "导入失败,错误行是第" + r.ToString() + "行,原因是: " + ex.Message);
           }
           finally
           {

              
              // xls.CloseReportTemplate(fileName);
           }
      
       }
       try
       {
       exec_update_sql();

       }
      catch(Exception ex)
       {
              return ("文件:[" + fileName + "]导入失败,原因是: " + ex.Message);
      }
      if (errorcount == 0)
      {
          return "1";
      }
      else
      {
          return "导入文件出错！";   
      }
     } 
       
     /*
        检测表头 时候是和配置的数据一致
      * 并且把列对应的数据 在文件的数组行中标记
     */ 
     private string  check_head(string strRecord , char[] index_ ,string CHECK_NAME, ref DataTable dt_a30801)
     {
        string[] data = new string[250];
        data = strRecord.Split(index_);
        int colcount =   dt_a30801.Rows.Count;
        if (data.Length < colcount)
        {
            colcount = data.Length;
        
        }
        //不检测列

        for (int i = 0; i < colcount; i++)
        {
            string col_id   = dt_a30801.Rows[i]["COL_ID"].ToString();
            string check_name = CHECK_NAME;
            if (check_name == "1") //0 表示检测名称
            {
                col_id = dt_a30801.Rows[i]["COL_NAME"].ToString();
            }
            if (check_name == "1" || check_name == "0")
            {
                for (int c = 0; c < colcount; c++)
                {
                    if (data[c] == col_id)
                    {
                        dt_a30801.Rows[i]["col_num"] = c;
                        break;
                    }
                }
            }
            //不做任何检测
            if (check_name == "2")
            {

                dt_a30801.Rows[i]["col_num"] = int.Parse(dt_a30801.Rows[i]["col_number"].ToString()) - 1;

                
            }
         
           
            string col_num = dt_a30801.Rows[i]["col_num"].ToString();
            if (col_num == "-1")
            {
                throw new Exception("列" + col_id + "不存在！");
                return "0";
            }
            else
            {
                if (check_name == "2")
                {
                    collist = collist + col_id + "=" + data[int.Parse(col_num)] + ",";
                }
            }
        
        }
        return "1";
     
     }

    private string check_data(string strRecord, char[] index_, DataTable dt_a30801, DataTable dt_a30802)
    {

        totleline = totleline + 1;
        string[] data = new string[250];
        data = strRecord.Split(index_);
        string[] check_sql = new string[200];
        int check = 0;
        int update = 0;
        string[] update_sql = new string[200];
        for (int j = 0; j < dt_a30802.Rows.Count; j++)
        {
            string SQL_TYPE = dt_a30802.Rows[j]["SQL_TYPE"].ToString();
            if (SQL_TYPE == "C") //检测
            {
                check_sql[check] = dt_a30802.Rows[j]["EXEC_SQL"].ToString();
                check_sql[check] = check_sql[check].Replace("[USER_ID]", GlobeAtt.A007_KEY);
                check = check + 1;
            }
            if (SQL_TYPE == "U") //更新
            {
                update_sql[update] = dt_a30802.Rows[j]["EXEC_SQL"].ToString();
                update_sql[check] = update_sql[check].Replace("[USER_ID]", GlobeAtt.A007_KEY);
                update = update + 1;
            }

        }

        string rowlist_ = "_LIST_|" + collist +  GlobeAtt.DATA_INDEX +"_ROWNUM_|" + totleline.ToString() + GlobeAtt.DATA_INDEX;
        for (int i = 0; i < dt_a30801.Rows.Count; i++)
        {
            string col_id = dt_a30801.Rows[i]["COL_ID"].ToString();
            string col_necessary = dt_a30801.Rows[i]["COL_NECESSARY"].ToString();
            int col_num = int.Parse(dt_a30801.Rows[i]["col_num"].ToString()) ;
            string col_data = "";
            if (col_num < data.Length && col_num >=0)
            { 
                col_data = data[col_num].Trim();
            }
            if (col_necessary == "1" && col_data == "")
            {
                throw new Exception("列" + col_id + "必须有数据！");
            }
            rowlist_ += col_id + "|" + col_data.Replace("'", "''") + GlobeAtt.DATA_INDEX;
            for (int j = 0; j < check; j++)
            {
                check_sql[j] = check_sql[j].Replace("[" + col_id + "]", col_data);            
            }
            for (int j = 0; j < update; j++)
            {
                update_sql[j] = update_sql[j].Replace("[" + col_id + "]", col_data);
            }

        }
        for (int j = 0; j < check; j++)
        {
            check_sql[j] = check_sql[j].Replace("[ROWLIST]", rowlist_);
            check_sql[j] = check_sql[j].Replace("[Rowlist]", rowlist_);
            check_sql[j] = check_sql[j].Replace("[rowlist]", rowlist_);
        }
        for (int j = 0; j < update; j++)
        {
            update_sql[j] = update_sql[j].Replace("[ROWLIST]", rowlist_);
            update_sql[j] = update_sql[j].Replace("[Rowlist]", rowlist_);
            update_sql[j] = update_sql[j].Replace("[rowlist]", rowlist_);
        }

        for (int j = 0; j < check; j++)
        {
            DataTable dt_check = new DataTable();
            dt_check = Fun.getDtBySql(check_sql[j]);
            string check_ = dt_check.Rows[0][0].ToString() ;
            if (check_  != "1")
            {
                throw new Exception(check_);
            }
        }
        for (int j = 0; j < update; j++)
        {
         //   int li_exec = Fun.execSqlOnly(update_sql[j]) ;
           // if (li_exec !=  1)
            //{
              //  throw new Exception(update_sql[j] + "执行失败！");
            //}
            str_update_sql[update_num] = update_sql[j];

            update_num = update_num + 1 ;
        }

        return "";

    }
    private  void exec_update_sql()
    {
        Fun.db.BeginTransaction();
        for (int j = 0; j < update_num; j++)
        {
            try
            {
                int li_exec = Fun.db.ExecuteNonQuery(str_update_sql[j].Replace("[LOG_KEY]", log_key), CommandType.Text);

                if (li_exec < 0)
                {
                    Fun.db.Rollback();
                    throw new Exception(str_update_sql[j] + "执行失败！");
                }
            }
            catch (Exception ex)
            {
                Fun.db.Rollback();
                throw new Exception(ex.Message);
            }

        }
        Fun.db.Commit();
    
    }

   





}
