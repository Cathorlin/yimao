using System; 
using System.Collections; 
using System.ComponentModel; 
using System.Data; 
using System.Data.SqlClient; 
using System.Web; 
using System.Web.SessionState; 
using System.Web.UI; 
using System.Web.UI.WebControls; 
using System.Web.UI.HtmlControls; 
using Base;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Text;
using System.Globalization;
using System.Security.Cryptography; 
namespace  Custom.BaseObject
{
	/// <summary>
	/// Summary description for IDataAccess.
	/// </summary>
    /// 
    public class md5
    { 
    
    
                public string GenerateKey()   
        {   
            DESCryptoServiceProvider desCrypto = (DESCryptoServiceProvider)DESCryptoServiceProvider.Create();   
            return ASCIIEncoding.ASCII.GetString(desCrypto.Key);   
        }   
                // �����ַ���   
                public string EncryptString(string sInputString, string sKey)   
                {   
                    byte [] data = Encoding.UTF8.GetBytes(sInputString);   
                    DESCryptoServiceProvider DES = new DESCryptoServiceProvider();   
                    DES.Key = ASCIIEncoding.ASCII.GetBytes(sKey);   
                    DES.IV = ASCIIEncoding.ASCII.GetBytes(sKey);   
                    ICryptoTransform desencrypt = DES.CreateEncryptor();   
                    byte [] result = desencrypt.TransformFinalBlock(data, 0, data.Length);   
                    return BitConverter.ToString(result);   
                }   
                // �����ַ���   
                public string DecryptString(string sInputString, string sKey)   
                {   
                    string [] sInput = sInputString.Split("-".ToCharArray());   
                    byte [] data = new byte[sInput.Length];   
                    for(int i = 0; i < sInput.Length; i++)   
                    {   
                       data[i] = byte.Parse(sInput[i], NumberStyles.HexNumber);   
                    }   
                    DESCryptoServiceProvider DES = new DESCryptoServiceProvider();   
                    DES.Key = ASCIIEncoding.ASCII.GetBytes(sKey);   
                    DES.IV = ASCIIEncoding.ASCII.GetBytes(sKey);   
                    ICryptoTransform desencrypt = DES.CreateDecryptor();   
                    byte [] result = desencrypt.TransformFinalBlock(data, 0, data.Length);   
                    return Encoding.UTF8.GetString(result);   
                }   

      
   
    }


	public class  Function
	{
        public string getText(string des)
        {
            string ls_text = des.Replace(" ", "&nbsp;");
            ls_text = ls_text.Replace("\n", "<br>");
            return ls_text;

        }
        public   string getClientIp()
        {

            string str = "";
            //�������������ȡԶ���û���ʵIP��ַ��
            try
            {
                if (System.Web.HttpContext.Current.Request.ServerVariables["HTTP_VIA"] != null)
                    str = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
                else
                    str = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
            }
            catch
            {
                str = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
            }
            return str;
        }
        public  string  saveLogin(string inorout )
        {
            try
            {
                string logintype = System.Web.HttpContext.Current.Session["logintype"].ToString();
                string clientip = getClientIp();
                string user_id = System.Web.HttpContext.Current.Session["user_id"].ToString();
                string m002_key = "-";
                try
                {
                    m002_key = System.Web.HttpContext.Current.Session["m002_key"].ToString();
                }
                catch
                {
                    m002_key = "-";
                    
                }
                string log_sql = "Proc_login_log('" + logintype + "','" + m002_key + "','" + user_id + "','" + clientip + "','" + inorout + "')";
                Oracle db = new Oracle();
                db.BeginTransaction();
                int li_db = db.ExecuteNonQuery(log_sql, CommandType.Text);
                if (li_db < 0)
                {
                    db.Rollback();
                }
                else
                {
                    db.Commit();
                }
                return li_db.ToString();

            }
            catch
            {

                return "-1";
            }
     
        }

        public MatchCollection getAllHyperLinks(String text, String s, string e)
        {
            try
            {
                Regex rg = new Regex("(?<=(" + s + "))[.\\s\\S]*?(?=(" + e + "))", RegexOptions.Multiline | RegexOptions.Singleline);
                MatchCollection matches = rg.Matches(text);
                return matches;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string getSysDateTime()
        {
            Oracle db = new Oracle();
            DataTable dt = new DataTable();
            string sql = "Select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') as c from dual ";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt.Rows[0][0].ToString();

        }


        /*��ȡģ������ӵ�ַ*/
        public string getUrlById(string m013_key)
        {
            Oracle db = new Oracle();
            DataTable dt = new DataTable();
            string sql = "Select t.* from m013 t where t.m013_key=" + m013_key;
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            string url = GetIndexUrl()+"/M002/";
            return url + dt.Rows[0]["MODEL_FILE"].ToString();
        }
        public DataTable getDt(string sql)
        {
            Oracle db = new Oracle();
            DataTable dt = new DataTable();
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;
        }
        public string getA022Name(string a022_id)
        {
            Oracle db = new Oracle();
            DataTable dt = new DataTable();
            string sql = "Select t.* from a022 t where t.a022_id='" + a022_id+"'";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            string sql_ =  dt.Rows[0]["a022_name"].ToString();
            try
            {
                  sql_ = sql_.Replace("[M002_KEY]", HttpContext.Current.Session["M002_KEY"].ToString());
                  sql_ = sql_.Replace("[USER_ID]", HttpContext.Current.Session["user_id"].ToString());
            }
            catch
            {
                sql_ =  dt.Rows[0]["a022_name"].ToString();
                
            }

            return sql_;
        }


      
        public string GetIndexUrl()
        {
            //  2009��12��15�� 11:45:24
            //  B�� kuibono@163.com
            string strTemp = "";
            if (System.Web.HttpContext.Current.Request.ServerVariables["HTTPS"] == "off")
            {
                strTemp = "http://";
            }
            else
            {
                strTemp = "https://";
            }

            strTemp = strTemp + System.Web.HttpContext.Current.Request.ServerVariables["SERVER_NAME"];

            if (System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"] != "80")
            {
                strTemp = strTemp + ":" + System.Web.HttpContext.Current.Request.ServerVariables["SERVER_PORT"];
            }

            strTemp = strTemp + System.Web.HttpContext.Current.Request.ApplicationPath;  //  System.Web.HttpContext.Current.Request.ServerVariables["URL"];

            strTemp = strTemp;
            return strTemp;
        }



		public string  GetColumnAttribute(string table_id,string column_id, string  attribute)

		{
			/*table_id ���� column_id ����  attribute Ҫ��ȡ������ֵ*/
			DataTable dt = new DataTable();
			SQLServer db = new SQLServer();
			string sql="Select Top 1 * From  A10001 Where TABLE_ID= '"+ table_id +"'";
			sql+=" AND COLUMN_ID= '"+column_id+"'";			
			db.ExcuteDataTable(dt,sql,CommandType.Text);
			return  dt.Rows[0][attribute].ToString();

		} 

        public  bool IsNumeric(string value)
        {
        return Regex.IsMatch(value, @"^[+-]?\d*[.]?\d*$");
        }
        public  bool IsInt(string value)
        {
        return Regex.IsMatch(value, @"^[+-]?\d*$");
        }
        public  bool IsUnsign(string value)
        {
        return Regex.IsMatch(value, @"^\d*[.]?\d*$");
        }

        public string getDublicToStr(double dbstr)
        {
            if (dbstr < 0)
            {
                return dbstr.ToString("0.####");
            }
            string a = dbstr.ToString();
            string[] b = a.Split('.');
             string f;
            if (b.Length > 1)
            {
                f = (dbstr - 0.5 ).ToString("#,##0") + "." + b[1];    //���CС���c������ͬ
            }
            else
            {
                f = dbstr.ToString("#,##0");
            }
            return f;
        }


        public string GetOpitionHtml(string sql,string opition_id,string display_col,string data_col,string default_id)
        {

            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
            str_html.Append("<select  id=\"" + opition_id + "\" onchange=\"selectchange(this)\">");
            str_html.Append(Environment.NewLine);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i][data_col].ToString() == default_id)
                {
                    str_html.Append("<option  selected value=\"" + dt.Rows[i][data_col].ToString() + "\">");
                }
                else
                {
                    str_html.Append("<option   value=\"" + dt.Rows[i][data_col].ToString() + "\">");
                }
                    str_html.Append( dt.Rows[i][display_col].ToString());
                str_html.Append(" </option> ");

                str_html.Append(Environment.NewLine);
            
            }
            str_html.Append("</select>");
            str_html.Append(Environment.NewLine);
            return str_html.ToString();
        
        }
        public string GetOpitionHtml(string sql, string opition_id, string display_col, string data_col, string default_id,string classid)
        {

            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();

            db.ExcuteDataTable(dt, sql, CommandType.Text);
            System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
            str_html.Append("<select  class =\""+classid+"\" id=\"" + opition_id + "\" onchange=\"selectchange(this)\">");
            str_html.Append(Environment.NewLine);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i][data_col].ToString() == default_id)
                {
                    str_html.Append("<option  selected value=\"" + dt.Rows[i][data_col].ToString() + "\">");
                }
                else
                {
                    str_html.Append("<option   value=\"" + dt.Rows[i][data_col].ToString() + "\">");
                }
                str_html.Append(dt.Rows[i][display_col].ToString());
                str_html.Append(" </option> ");

                str_html.Append(Environment.NewLine);

            }
            str_html.Append("</select>");
            str_html.Append(Environment.NewLine);
            return str_html.ToString();

        }

        public string GetRadioHtml(string sql, string opition_id, string display_col, string data_col, string default_id, string classid, Boolean lb_eidt)
         {
    
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
                //<INPUT TYPE="radio" NAME="a" value="0" >��
                //<INPUT TYPE="radio" NAME="a" value="1">Ů
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
            str_html.Append("<nobr>");
       
            for (int i = 0; i < dt.Rows.Count; i++)
            {




                if (dt.Rows[i][data_col].ToString() == default_id)
                {
                   // str_html.Append("<option  selected value=\"" + dt.Rows[i][data_col].ToString() + "\">");


                    if (lb_eidt == false)
                    {
                        str_html.Append("<INPUT   TYPE=\"radio\"  name=\"" + opition_id + "\" disabled id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" checked onclick=\"rbselectchange(this)\">");
                    }
                    else
                    {
                        str_html.Append("<INPUT TYPE=\"radio\"  name=\"" + opition_id + "\" id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" checked onclick=\"rbselectchange(this)\">");
                    }
                }
                else
                {
                   // str_html.Append("<option   value=\"" + dt.Rows[i][data_col].ToString() + "\">");

                    if (lb_eidt == false)
                    {
                        str_html.Append("<INPUT TYPE=\"radio\"  name=\"" + opition_id + "\" disabled id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" onclick=\"rbselectchange(this)\">");
                    }
                    else
                    {
                        str_html.Append("<INPUT  TYPE=\"radio\" name=\"" + opition_id + "\" id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" onclick=\"rbselectchange(this)\">");
                    }
                }
                str_html.Append(dt.Rows[i][display_col].ToString());

                str_html.Append(Environment.NewLine);

            }
            str_html.Append("</nobr>");
            str_html.Append(Environment.NewLine);
            return str_html.ToString();

    
    
    }

        public string GetRadioHtml(DataTable dt , string opition_id, string display_col, string data_col, string default_id, string classid, Boolean lb_eidt)
        {

            System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
            str_html.Append("<nobr>");

            for (int i = 0; i < dt.Rows.Count; i++)
            {




                if (dt.Rows[i][data_col].ToString() == default_id)
                {
                    // str_html.Append("<option  selected value=\"" + dt.Rows[i][data_col].ToString() + "\">");


                    if (lb_eidt == false)
                    {
                        str_html.Append("<INPUT   TYPE=\"radio\"  name=\"" + opition_id + "\" disabled id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" checked onclick=\"rbselectchange(this)\">");
                    }
                    else
                    {
                        str_html.Append("<INPUT TYPE=\"radio\"  name=\"" + opition_id + "\" id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" checked onclick=\"rbselectchange(this)\">");
                    }
                }
                else
                {
                    // str_html.Append("<option   value=\"" + dt.Rows[i][data_col].ToString() + "\">");

                    if (lb_eidt == false)
                    {
                        str_html.Append("<INPUT TYPE=\"radio\"  name=\"" + opition_id + "\" disabled id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" onclick=\"rbselectchange(this)\">");
                    }
                    else
                    {
                        str_html.Append("<INPUT  TYPE=\"radio\" name=\"" + opition_id + "\" id=\"" + opition_id + "_" + i.ToString() + "\"   value=\"" + dt.Rows[i][data_col].ToString() + "\" onclick=\"rbselectchange(this)\">");
                    }
                }
                str_html.Append(dt.Rows[i][display_col].ToString());

                str_html.Append(Environment.NewLine);

            }
            str_html.Append("</nobr>");
            str_html.Append(Environment.NewLine);
            return str_html.ToString();



        }



        public string GetOpitionHtml(string sql, string opition_id, string display_col, string data_col, string default_id, string classid,Boolean lb_eidt)
        {

            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();

            db.ExcuteDataTable(dt, sql, CommandType.Text);
            System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
            if (lb_eidt == false)
            {
                str_html.Append("<select  class =\"" + classid + "\" disabled id=\"" + opition_id + "\" onchange=\"selectchange(this)\">");
            }
            else
            {
                str_html.Append("<select  class =\"" + classid + "\" id=\"" + opition_id + "\" onchange=\"selectchange(this)\">");
            }
            str_html.Append(Environment.NewLine);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                if (dt.Rows[i][data_col].ToString() == default_id)
                {
                    str_html.Append("<option  selected value=\"" + dt.Rows[i][data_col].ToString() + "\">");
                }
                else
                {
                    str_html.Append("<option   value=\"" + dt.Rows[i][data_col].ToString() + "\">");
                }
                str_html.Append(dt.Rows[i][display_col].ToString());
                str_html.Append(" </option> ");

                str_html.Append(Environment.NewLine);

            }
            str_html.Append("</select>");
            str_html.Append(Environment.NewLine);
            return str_html.ToString();

        }

        //��ȡ��ǰ��2������֮�������
        //{2}{3}
        //Ҫ�õ�2
        public string getStrByIndex(string str_data, string index1, string index2)
        { //
            int pos1 = str_data.IndexOf(index1);
            int pos2 = str_data.IndexOf(index2);
            string str_data1;
            if (pos1 >= 0)
            {
                str_data1 = str_data.Substring(pos1 + index1.Length);
                pos2 = str_data1.IndexOf(index2);
                if (pos2 >= 0)
                {
                    return str_data1.Substring(0, pos2);

                }

                else
                {
                    return "";
                
                }
            }
            else
            {
                return "";            
            }
            //return "";      
        
        
        
        }




        //���ݱ���������ݻ�ȡ�������
        public DataTable GetTableDataByCondition(DataTable dt_column,string str_where)
        {
            /*table_id ���� column_id ����  attribute Ҫ��ȡ������ֵ*/
            string sql;
            //string this_key;
         //   int str;
            string str_table;
            str_table = dt_column.Rows[0]["table_id"].ToString();

            string column_id, primary_key;
            sql ="SELECT ";
            //str = 0;
 
            for (int i = 0; i < dt_column.Rows.Count; i++)
            {
                primary_key = dt_column.Rows[i]["primary_key"].ToString();
                column_id = dt_column.Rows[i]["column_id"].ToString();
                sql = sql + " " + column_id + ",";
            }


            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            sql = sql.Substring(0, sql.Length - 1) + " From  " + str_table +" WHERE 1 = 1 " +str_where;
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;

        }







        public DataTable GetA10001ColumnByTable(string table_id)
        {
            /*table_id ���� ���ݱ����ƻ�ȡ�е��嵥*/
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "Select * From  A10001 Where TABLE_ID= '" + table_id + "' and bs_table='1' order by sort_by asc,line_no asc";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;
        }

        public DataTable GetA10001ShowColumnByTable(string table_id)
        {
            /*table_id ���� ���ݱ����ƻ�ȡ�е��嵥*/
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "Select * From  A10001 Where TABLE_ID= '" + table_id + "' and bs_column='1' order by sort_by asc,line_no asc";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;
        }


        public DataTable GetConditionColumnByTable(string table_id)
        {
            /*table_id ���� ���ݱ����ƻ�ȡ�е��嵥*/
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "Select * From  A10001 Where TABLE_ID= '" + table_id + "'  and BS_QUERY = '1' order by line_no asc";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;
        }
        public DataTable GetSysConditionColumnByTable(string table_id)
        {
            /*table_id ���� ���ݱ����ƻ�ȡ�е��嵥*/
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "Select * From  SYS_PROC_COLUMN Where TABLE_ID= '" + table_id + "'  order by line_no asc";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;
        }


        public DataTable GetConditionColumnByTable(string table_id, string table_type)
        {
            /*table_id ���� ���ݱ����ƻ�ȡ�е��嵥*/
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "Select * From  A10001 Where tbl_type = '" + table_type + "' and TABLE_ID= '" + table_id + "'  and BS_QUERY = '1' order by  sort_by asc , line_no asc";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;
        }
        public DataTable GetShowColumnByTable(string table_id, string table_type)
        {
            /*table_id ���� ���ݱ����ƻ�ȡ�е��嵥*/
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "Select * From  A10001 Where tbl_type = '" + table_type + "' and  TABLE_ID= '" + table_id + "'  and BS_COLUMN = '1' order by sort_by asc   ,line_no asc";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;
        }
        public DataSet GetA10001ColumnByTable_ds(string table_id)
        {
            /*table_id ���� ���ݱ����ƻ�ȡ�е��嵥*/
            DataSet ds = new DataSet();
            SQLServer db = new SQLServer();
            string sql = "Select * From  A10001 Where TABLE_ID= '" + table_id + "' order by line_no asc";
            ds = db.ExecuteDataSet(sql, CommandType.Text);
            return ds;
        }

        public DataTable ConvertArrayToDataTable(Array Array_Parm,int X ,int Y)
        {
            DataTable dt = new DataTable();
            
          for (int i = 0; i < Y; i++)
          {
            DataColumn  dc = new DataColumn();
            dc.ColumnName ="COL" + i.ToString();
            dt.Columns.Add(dc) ;
          
          }
            for (int i = 0; i < X; i++)
            {
                DataRow dr = dt.NewRow();
             
                for (int j = 0; j < Y; j++)
                {
                    dr[j] = Array_Parm.GetValue(i, j);
                }
               dt.Rows.Add(dr);
            }   

 

            return dt;
          
        }

        public Array SetArrayValue(int x, int y)
       {       
            //��ά����ĳ���
            int[,] ar = (int[,]) Array.CreateInstance(typeof(int), x, y);
            //���鸳ֵ 
            for (int i = 0; i < x; i++)
            {
                for (int j = 0; j < y; j++) 
                {

                    ar[i, j] = i + j * 10;
                }
            
            }

            //
            DataTable dt = new DataTable();
            dt =  ConvertArrayToDataTable(ar, x, y);

            return ar;
       }

        public string GetStringTrueOrFalse(string ls_string,Boolean lb_true   )
        { 
        /***�ж��ַ�������� ���� 1 = 0 */
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql;
            /**true ��ʾ�ж���� ���ص� 1 �� 0 
               false ��ʾ���̵��﷨ Ҫ������ sql �������̱�� ���� call ������
             
             */
            if (lb_true )
            {
                sql = "Select Case When " + ls_string + " then 1 else  0 end   ";
            }
            else
            {

                /*��ٵ������Ѿ��滻����  ��ʽ ��if  1 then goto  [10002] else goto [10003]
                                          ���� ��if  1 then goto [10003] else call [gz0001]
                 * 
                 */
                sql = "Select Case ";



                
            }
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt.Rows[0][0].ToString();	
        }



        #region ���ݱ��ȡ�����
        public DataTable GetColumnByTable(string str_table)
        {

            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql;
            sql = "Select t.* from " + str_table + " t  where  1 = 2  ";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            return dt;

        }

        #endregion




        public string  GetTableName(string sql)

		{
			/*sql  ������sql���  ����sql����еı���*/
			string ls_sql=sql.ToUpper();
			int  pos=sql.IndexOf("FROM");

			if ( pos != -1)
			{
				int pos1= ls_sql.IndexOf("WHERE");
				if ( pos == -1)
				{
					return sql.Substring(pos + 4,sql.Length - pos - 4).Trim();
				}
				else
				{
				
					return sql.Substring(pos + 4 ,pos1 - pos - 4).Trim();
				}
				
			
			}
			return  "";
		}
        public string GetHtml(DataTable dt_column, DataTable dt_data, string xs_type, string do_type)
        //xs_type 0 ��ʾ��ʾΪfreeform   1 ��ʾ grid
        //do_type 0 ��ʾ ��ʾ 1 ��ʾ�޸� 2 ���
        //dt_column �е��嵥
        //dt_data ÿ�е�����
        {
            System.Text.StringBuilder str_html = new System.Text.StringBuilder("");
            System.Text.StringBuilder str_addhtml = new System.Text.StringBuilder("");
            System.Text.StringBuilder str_freehtml = new System.Text.StringBuilder("");
            //string str_tr;
            string str_td;
            string str_visble;
            string str_column_id;
            string str_enable, str_col_type;
            string str_condition;
            string  primary_key;
            string str_data,col_edit;
            string str_table;
            string ls_color; //��ɫ
            str_table = dt_column.Rows[0]["table_id"].ToString();
            str_html.Append("<table id='T_" + dt_column.Rows[0]["table_id"].ToString() + "'    cellSpacing=0 cellPadding=0  border = '1' bordercolor='#121212'   bordercolorlight='#121212'   bordercolordark='#7bb6ba'    >");
                str_freehtml.Append("<table id='T_" + dt_column.Rows[0]["table_id"].ToString() + "' >");
                //��ʾ����
                str_html.Append("<tr  class = 'gridHead'><td style='width:32px;'><div class='gridHead'>ɾ��</div></td>");
           
                str_addhtml.Append("<tr height='26px'>");
                
                for (int col = 0; col < dt_column.Rows.Count; col++)
                { 
                    str_visble = dt_column.Rows[col]["sys_visible"].ToString();
                    str_column_id = dt_column.Rows[col]["column_id"].ToString();
                    str_enable = dt_column.Rows[col]["sys_enable"].ToString();
                    col_edit = dt_column.Rows[col]["col_edit"].ToString();
                    if (do_type == "V") //��ʾ
                    {
                        str_enable = "0";
                    }

                    if (dt_data.Rows.Count > 0)
                    {
                        str_data = dt_data.Rows[0][str_column_id].ToString();
                    }
                    else
                    {
                        str_data = "";

                    }
                    if (str_visble == "0")
                    {
                        str_freehtml.Append("<tr style='display:none;'><td></td><td><INPUT   type=hidden value='" + str_data + "' id='0_" + str_table + "_" + str_column_id + "' ></td></tr>");
                     
  

                        str_addhtml.Append("<td style='display:none;'>");
                        str_addhtml.Append("</td>");

                        str_html.Append("<td style='display:none;'>");
                        str_html.Append("</td>");
                    }
                    else
                    {
                            str_freehtml.Append("<tr>");

                            str_freehtml.Append("<td><div class='freeHead'>" + dt_column.Rows[col]["col_text"].ToString() + "</div></td>");
                            if (str_enable == "1")
                            {
                                if (col_edit == "checkbox")
                                {
                                    if (str_data =="1")
                                    {
                                        str_freehtml.Append("<td><INPUT  type=checkbox  onclick='changecbx(this)'  onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' value='" + str_data + "' id='0_" + str_table + "_" + str_column_id + "' checked ></td>");
                                    }
                                    else
                                    {
                                        str_freehtml.Append("<td><INPUT  type=checkbox  onclick='changecbx(this)' onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' value='" + str_data + "' id='0_" + str_table + "_" + str_column_id + "' ></td>");
                                    }
                                
                                }
                                else
                                {
                                    str_freehtml.Append("<td><INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' type=text onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' value='" + str_data + "' id='0_" + str_table + "_" + str_column_id + "' ></td>");
   
                                }


                              }
                            else
                            {
                                if (col_edit == "checkbox")
                                {
                                    if (str_data=="1")
                                    {
                                        str_freehtml.Append("<td><INPUT  type=checkbox  disabled  onclick='changecbx(this)' onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' value='" + str_data + "' id='0_" + str_table + "_" + str_column_id + "' checked ></td>");
                                    }
                                    else
                                    {
                                        str_freehtml.Append("<td><INPUT  type=checkbox  disabled  onclick='changecbx(this)' onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' value='" + str_data + "' id='0_" + str_table + "_" + str_column_id + "' ></td>");
                                    }
                                   
      
                                }
                                else
                                {
                                    str_freehtml.Append("<td><INPUT style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' type=text onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' disabled  value='" + str_data + "' id='0_" + str_table + "_" + str_column_id + "' ></td>");
                                }
                            }
                          
                        
                  

                        str_freehtml.Append("</tr>");



                        //�嵥��ʽ




                        str_addhtml.Append("<td style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'>");
                        if (str_enable == "1")
                        {

                            str_addhtml.Append("<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' type=text onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' value='' id='N_" + str_column_id + "' >");
                        }
                        else
                        {
                            str_addhtml.Append("<INPUT style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px; ' type=text onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)'  disabled  value='' id='N_" + str_column_id + "' >");

                        }

                        str_addhtml.Append("</td>");

                        str_html.Append("<td style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'>");
                        str_html.Append("<div class='gridHead'>" + dt_column.Rows[col]["col_text"].ToString() + "</div>");
                        str_html.Append("</td>");
                    }
                }
                //���һ�������б�ʾ���޸Ļ�����������ɾ�� M A D  �����к�
                str_html.Append("<td style='display:none;'>");
                str_html.Append("</td>");
                str_freehtml.Append("</table>");

                str_html.Append("</tr>");
                str_addhtml.Append("</tr>");
                //if (do_type == "A")
                //{
                //    return str_addhtml.ToString();
                
                //}

            //��ʾ̧ͷ
                if (xs_type == "0") {

                    return str_freehtml.ToString();
                }
                
//��ʾ����   ��ͬ�е���ɫ��ͬ 1EC044  083F15
                for (int row = 0; row < dt_data.Rows.Count; row++)
                {  
                    str_td = "";
                    
                    //str_html.Append("<tr id='row"+row.ToString()+"'>");
                    str_condition = "" ;
                    //��ż�еĲ�ͬ��ɫ��չʾ
                    if (row % 2 == 0)
                    {
                        ls_color = "bm_table_row_even";
                    }
                    else 
                    {
                        ls_color = "bm_table_row_odd";
                    }
                    for (int col = 0; col < dt_column.Rows.Count; col++)
                    {
                        str_visble = dt_column.Rows[col]["sys_visible"].ToString();
                        str_column_id = dt_column.Rows[col]["column_id"].ToString();
                        str_enable = dt_column.Rows[col]["sys_enable"].ToString();
                        str_col_type = dt_column.Rows[col]["col_type"].ToString();
                        primary_key = dt_column.Rows[col]["primary_key"].ToString();
                        col_edit = dt_column.Rows[col]["col_edit"].ToString();
                        if (primary_key == "1")
                        {
                            if (str_col_type == "varchar")
                            {
                                str_condition = str_condition +  " AND " + str_column_id + "= @@@@" + dt_data.Rows[row][str_column_id].ToString() + "@@@@";
                            }
                            if (str_col_type == "number")
                            {
                                str_condition = str_condition + " AND " + str_column_id + "=" + dt_data.Rows[row][str_column_id].ToString() + "";
                            }
                        
                        }


                        if (do_type == "V") //��ʾ
                        {
                            str_enable = "0";
                        }
                        if (str_visble == "0")
                        {
                            str_td = str_td + "<td style='display:none;'>";
                            str_td = str_td + "<INPUT type=hidden value='" + dt_data.Rows[row][str_column_id].ToString() + "'  id='" + (row + 1).ToString() + "_" + str_table + "_" + str_column_id + "' >";
                            str_td = str_td + "</td>";
                        }
                        else
                        {
                            str_td = str_td +"<td style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'>";
                            if (str_enable == "1")
                            {

                                if (col_edit == "checkbox")
                                {
                                    if (dt_data.Rows[row][str_column_id].ToString() == "1")
                                    {
                                        str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'  onclick='changecbx(this)'  onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' type='checkbox' value='" + dt_data.Rows[row][str_column_id].ToString() + "' id='" + (row + 1).ToString() + "_" + str_table + "_" + str_column_id + "' checked >";
                                    }
                                    else
                                    {
                                        str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'  onclick='changecbx(this)' onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' type='checkbox' value='" + dt_data.Rows[row][str_column_id].ToString() + "' id='" + (row + 1).ToString() + "_" + str_table + "_" + str_column_id + "' >";
                                    }
                                    
 
                              //      str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' onclick='changecbx(this)' type=checkbox value='0' id='" + String(rowid) + "_" + table_id + "_" + COLUMN_ID + "' >";
                                }
                                else
                                {


                                    str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' type=text onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' value='" + dt_data.Rows[row][str_column_id].ToString() + "' id='" + (row + 1).ToString() + "_" + str_table + "_" + str_column_id + "' >";
                                }
                            }
                            else
                            {
                                if (col_edit == "checkbox")
                                {
                                    if (dt_data.Rows[row][str_column_id].ToString() == "1")
                                    {
                                        str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'  disabled onclick='changecbx(this)' onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)'  type='checkbox' value='" + dt_data.Rows[row][str_column_id].ToString() + "' id='" + (row + 1).ToString() + "_" + str_table + "_" + str_column_id + "' checked >";
                                    }
                                    else
                                    {
                                        str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;'  disabled onclick='changecbx(this)' onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' type='checkbox' value='" + dt_data.Rows[row][str_column_id].ToString() + "' id='" + (row + 1).ToString() + "_" + str_table + "_" + str_column_id + "' >";
                                    }
                                    //      str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' onclick='changecbx(this)' type=checkbox value='0' id='" + String(rowid) + "_" + table_id + "_" + COLUMN_ID + "' >";
                                }
                                else
                                {


                                    str_td = str_td + "<INPUT  style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;border:medium none; ' type=text  onfocus='bill_item_focus_bg(this)' onblur='bill_item_nofocus_bg(this)' disabled  value='" + dt_data.Rows[row][str_column_id].ToString() + "' id='" + (row + 1).ToString() + "_" + str_table + "_" + str_column_id + "' class ='" + ls_color + "' >";
                                }
                              //  str_td = str_td + "<INPUT style='width:" + dt_column.Rows[col]["col_width"].ToString() + "px;' type=text  disabled  value='" + dt_data.Rows[row][str_column_id].ToString() + "' id='" + row.ToString() + "_" + str_table + "_" + str_column_id + "' >";
                            }
                            str_td = str_td +"</td>";
                        }
                       
                    }
                    if (do_type == "V")
                    {
                        str_html.Append("<tr id='row" + (row + 1).ToString() + "' ondblclick=\"showdata('" + str_condition + "')\" class ='" + ls_color + "'>");
                    }
                    else
                    {
                        str_html.Append("<tr id='row" + (row + 1).ToString() + "' ondblclick=\"showdata('" + str_condition + "')\" class ='" + ls_color + "' onclick = 'selectRow(this.rowIndex,this.parentNode)'>");
                    }
                     if (do_type == "V")
                    {
                        str_html.Append("<td style='width:32px;'><INPUT  style='width:30px;'  disabled onclick='changedel(this)'  type='checkbox' value='0' id='" + (row + 1).ToString() + "_" + str_table + "_DELTYPE'  ></td>");
                    }
                    else
                    {
                        str_html.Append("<td style='width:32px;'><INPUT  style='width:30px;'  onclick='changedel(this)'  type='checkbox' value='0' id='" + (row + 1).ToString() + "_" + str_table + "_DELTYPE'  ></td>");
                    }
                    str_html.Append(str_td);
                    str_html.Append("<td style='display:none;'>");
                    str_html.Append("<INPUT type=hidden value='" + do_type + "' id='" + (row + 1).ToString() + "_" + str_table + "_ROWTYPE' >");
                    str_html.Append("<INPUT type=hidden value='" + (row + 1).ToString() + "' id='ROW" + (row+1).ToString() + "_ID' >");

                    str_html.Append("</td>");


                    str_html.Append("</tr>");



                }





                str_html.Append("</table>");

     



            return str_html.ToString();

        }

		#region ��DataReader תΪ DataTable
		/// <summary>
		/// ��DataReader תΪ DataTable
		/// </summary>
		/// <param name="DataReader">DataReader</param>
		public DataTable ConvertDataReaderToDataTable(SqlDataReader dataReader)
		{
			DataTable datatable = new DataTable();
			DataTable schemaTable = dataReader.GetSchemaTable();
			//��̬�����
			foreach(DataRow myRow in schemaTable.Rows)
			{
				DataColumn myDataColumn = new DataColumn();
				myDataColumn.DataType	= System.Type.GetType("System.String");
				myDataColumn.ColumnName = myRow[0].ToString();
				datatable.Columns.Add(myDataColumn);
			}
			//�������
			while(dataReader.Read())
			{
				DataRow myDataRow = datatable.NewRow();
				for(int i=0;i<schemaTable.Rows.Count;i++)
				{
					myDataRow[i] = dataReader[i].ToString();
				}
				datatable.Rows.Add(myDataRow);
				myDataRow = null;
			}
			schemaTable = null;
			return datatable;
		}
		#endregion



 
    }


	public class  user
	{
		public string CheckUserExist(string userid){
			DataTable dt = new DataTable();
			SQLServer db = new SQLServer();
            string sql = "Select Top 1 count(*) From  A007  Where A007_ID= '" + userid + "'";
			db.ExcuteDataTable(dt,sql,CommandType.Text);
			return  dt.Rows[0][0].ToString();	

		}

        public DataTable GetPassWord(string userid)		
		{
			DataTable dt = new DataTable();
			SQLServer db = new SQLServer();
            string sql = "Select  *   From  A007  Where A007_ID= '" + userid + "'";
			db.ExcuteDataTable(dt,sql,CommandType.Text);
            return dt;
			
		}
        /*��ȡȨ���嵥*/
        public string GetA013Id(string userid)
        {
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string a013_id ;
            a013_id = "";
            string sql = "Select  distinct a013_id  From  a00701  Where A007_ID= '" + userid + "'";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            for (int i = 0; i < dt.Rows.Count; i++) 
            {
                a013_id   = a013_id +  dt.Rows[i][0].ToString()+",";
            }
            return a013_id;        
        }



        //д��¼��־
        public string write_login_log(string user_id)
        {
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "write_login_log '" + user_id + "','0'";
            string a300_id;
            a300_id = "";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            if (dt.Rows.Count > 0)
            {
                a300_id = dt.Rows[0][0].ToString(); 
            }
            return a300_id;
        
        
        }
        
        //д��¼��־
        public string update_login_log(string user_id, string a003_id)
        {
            DataTable dt = new DataTable();
            SQLServer db = new SQLServer();
            string sql = "write_login_log '" + user_id + "','" + a003_id + "'";
            string a300_id;
            a300_id = "";
            db.ExcuteDataTable(dt, sql, CommandType.Text);
            if (dt.Rows.Count > 0)
            {
                a300_id = dt.Rows[0][0].ToString();
            }
            return a300_id;


        }

    }

    public class app
    {
        [STAThread]
        static void Main(string[] args)
        {
            //������һ��int�͵Ķ�ά����
            int[,] my2DArray = (int[,])Array.CreateInstance(typeof(int), 2, 3);
            for (int i = my2DArray.GetLowerBound(0); i <= my2DArray.GetUpperBound(0); i++)
                for (int j = my2DArray.GetLowerBound(1); j <= my2DArray.GetUpperBound(1); j++)
                    my2DArray.SetValue(i + j, i, j);
            PrintValues(my2DArray);
            Console.WriteLine();
            my2DArray = (int[,])Redim(my2DArray, 2, 4);
            PrintValues(my2DArray);
            my2DArray = (int[,])Redim(my2DArray, 2, 2);
            PrintValues(my2DArray);
        }
        //��������
        public static Array Redim(Array origArray, params int[] lengths)
               {
                   //ȷ��ÿ��Ԫ�ص�����
                   Type t=origArray.GetType().GetElementType();
                   //�����µ�����
                   Array newArray=Array.CreateInstance(t,lengths);
                   //ԭ�����е����ݿ�������������
          for ( int i = origArray.GetLowerBound(0); i <= Math.Min(origArray.GetUpperBound(0),newArray.GetUpperBound(0)); i++ )
                 for ( int j = origArray.GetLowerBound(1); j <= Math.Min(origArray.GetUpperBound(1),newArray.GetUpperBound(1)); j++ )     
                      newArray.SetValue( origArray.GetValue( i, j ) , i, j );
                   //������û����Copy����������ô˷��������ԭ�������������������������������                   
                     return newArray;
               }
        //�������
        public static void PrintValues(Array myArr)
        {
            System.Collections.IEnumerator myEnumerator = myArr.GetEnumerator();
            int i = 0;
            int cols = myArr.GetLength(myArr.Rank - 1);
            while (myEnumerator.MoveNext())
            {
                if (i < cols)
                {
                    i++;
                }
                else
                {
                    Console.WriteLine();
                    i = 1;
                }
                Console.Write("\t{0}", myEnumerator.Current);
            }
            Console.WriteLine();
        }






    }




}