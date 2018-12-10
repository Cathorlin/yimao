using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Data;
using System.Reflection;
using System.IO;
using Excel;
using System.Data.OleDb;
    public class ExcelFunc
    {
        /// <summary>
        /// 根据数据集填充Excel的值
        /// </summary>
        private Excel.ApplicationClass m_oExcelApp;
        private Excel.Workbooks m_oBooks;
        private Excel._Workbook m_oBook;
        private Excel._Worksheet m_oSheet;
        private object m_oMissing;

        public ExcelFunc()
        {
            m_oExcelApp = null;
            m_oBooks = null;
            m_oBook = null;
            m_oSheet = null;
            m_oMissing = System.Reflection.Missing.Value;
        }


        #region 插入数据到统计分析图Excel中

        public string WriteExecl(System.Data.DataTable myDt, string inExcel, string outExcel)
        {
            object FileSave = (object)outExcel;
            string modelAdress = inExcel;
            try
            { //把模板拷贝到数据目录
                File.Copy(inExcel, outExcel, true);
                modelAdress = outExcel;
                OpenReportTempalte(modelAdress);
                m_oSheet = (Excel._Worksheet)m_oBook.Worksheets[1];
                for (int r = 0; r < myDt.Rows.Count; r++)
                {
                    for (int c = 0; c < myDt.Columns.Count; c++)
                    {
                        m_oSheet.Cells[r + 1, c + 1] = myDt.Rows[r][c].ToString();
                    }

                }
                m_oBook.Save();
            }
            catch (Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write(ex.Message);
                return "0";
            }
            finally
            {
                CloseReportTemplate(modelAdress);
            }
            return "1";

        }
        //读取excel文件的数据
        public string  getExeclData(string outExcel,int r,string index_,ref int colcount )
        {
            string rowdata = "";
            try
            {   m_oSheet = (Excel._Worksheet)m_oBook.Worksheets[1];
                for (int c = 0; c < colcount; c++)
                {
                    string v = "";
                    try
                    {
                        v = m_oSheet.get_Range(m_oSheet.Cells[r, c + 1], m_oSheet.Cells[r, c + 1]).Value2.ToString();
                    }
                    catch
                    {
                        v = "";
                    }
                    if (r == 1 && v == "")
                    {
                        colcount = c ;
                        break;
                    }
                    rowdata = rowdata + v + index_;                        
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            return rowdata;
        
        }
        public string WriteExeclByColumns(System.Data.DataTable myDt, string[] column_id_, string[] col_text_, string inExcel, string outExcel)
        {
            object FileSave = (object)outExcel;
            string modelAdress = inExcel;
            try
            { //把模板拷贝到数据目录
                File.Copy(inExcel, outExcel, true);
                modelAdress = outExcel;
                OpenReportTempalte(modelAdress);
                m_oSheet = (Excel._Worksheet)m_oBook.Worksheets[1];
                for (int cc = 0; cc < myDt.Columns.Count; cc++)
                {
                    string column_ = myDt.Columns[cc].ColumnName;
                    for (int c = 0; c < column_id_.Length; c++)
                    {

                        if (column_id_[c] == column_)
                        {
                            m_oSheet.Cells[1, cc + 1] = col_text_[c];
                            break;
                        }
                    }
                }
                for (int r = 0; r < myDt.Rows.Count; r++)
                {
                    for (int cc = 0; cc < myDt.Columns.Count; cc++)
                    {
                        string column_ = myDt.Columns[cc].ColumnName;
                        for (int c = 0; c < column_id_.Length; c++)
                        {
                            if (column_id_[c] == column_)
                            {
                                m_oSheet.Cells[r + 2, cc + 1] = myDt.Rows[r][column_].ToString();
                                break;
                            }

                        }

                    }
                }
                m_oBook.Save();
            }
            catch (Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") + "');");
                return "0";
            }
            finally
            {
                CloseReportTemplate(modelAdress);
            }
            return "1";
        }

        public string ExportBill(string wheresql,string  a328_id ,ref string outurl )
        {
            BaseFun fun = new BaseFun();
      
            System.Data.DataTable dt_a328 = new System.Data.DataTable();
            dt_a328 = fun.getDtBySql("Select t.* from A328 t where t.a328_id='" + a328_id + "'");
            string wheresql_ = wheresql;
            if (wheresql.ToUpper().Trim().IndexOf("AND") == 0)
            {
                wheresql_ = " WHERE 1=1 " + wheresql;
            }
            else
            {
                if (wheresql.ToUpper().Trim().IndexOf("WHERE") == 0)
                {
                    wheresql_ = wheresql;
                }
                else
                {
                    wheresql_ = " WHERE " + wheresql;
                }
            
            }
            string g_sql = "Select  pkg_show.get_table_sql('" + dt_a328.Rows[0]["TABLE_ID"].ToString() + "','" + wheresql_.Replace("'","''") + "','"+ GlobeAtt.A007_KEY +"') as outsql from dual";
        
            System.Data.DataTable dt_sql = new System.Data.DataTable();
            dt_sql = fun.getDtBySql(g_sql);
            g_sql = dt_sql.Rows[0][0].ToString();
            string ORDER_SQL = dt_a328.Rows[0]["ORDER_SQL"].ToString();
            if (ORDER_SQL != null && ORDER_SQL !="" && ORDER_SQL.Length > 5 )
            {
              g_sql = g_sql +  " " + ORDER_SQL;
            }
           
            System.Data.DataTable dt_data = new System.Data.DataTable();
            dt_data = fun.getDtBySql(g_sql);
            if (dt_data.Rows.Count == 0)
            {
                System.Web.HttpContext.Current.Response.Write("alert('没有数据不能导出！');");
                return "0";
            }
          
          


            string uploadfilepath = System.Web.HttpContext.Current.Request.MapPath("../data/" + a328_id + ".xls");
            string model_file = uploadfilepath;
            if (System.IO.File.Exists(uploadfilepath) == false)
            {
                System.Web.HttpContext.Current.Response.Write("alert('模板文件" + a328_id + ".xls不存在！');");
                return "0";
            }
            string filename = Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath); // Guid.NewGuid().ToString() + System.IO.Path.GetExtension(uploadfilepath);
            uploadfilepath = "../temp" ;
                        
            string vpsh = uploadfilepath + "/" + a328_id + "/" + filename;
            string outfilename = System.Web.HttpContext.Current.Request.MapPath("../temp/" + a328_id + "/" + filename);
            
            string psh = System.Web.HttpContext.Current.Request.MapPath(vpsh);
            if (!System.IO.Directory.Exists(System.IO.Path.GetDirectoryName(psh)))
            {
                System.IO.Directory.CreateDirectory(System.IO.Path.GetDirectoryName(psh));
            }
            outurl =  a328_id + "/" + filename;
            try
            { //把模板拷贝到数据目录
                File.Copy(model_file, outfilename, true);
            }
            catch(Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") .Replace("\r", "").Replace("\n", "")+ "');");
                return "0";
            }

              //要循环的列
            System.Data.DataTable dt_a32801_loop = new System.Data.DataTable();
            dt_a32801_loop = fun.getDtBySql("Select t.* from A32801 t where t.a328_id='" + a328_id + "' and LOOP_FLAG = '1' ");

         
            //页眉
            System.Data.DataTable dt_a32801_0 = new System.Data.DataTable();
            dt_a32801_0 = fun.getDtBySql("Select t.* from A32801 t where t.a328_id='" + a328_id + "' and LOOP_FLAG = '0' and  PAGEFOOT ='0' ");

             //非循环的列 
            System.Data.DataTable dt_a32801_1 = new System.Data.DataTable();
            dt_a32801_1 = fun.getDtBySql("Select t.* from A32801 t where t.a328_id='" + a328_id + "' and LOOP_FLAG = '0' and PAGEFOOT ='1' ");
            try
            {
                OpenReportTempalte(outfilename);
                int count_ = m_oBook.Worksheets.Count;
                for (int i = 1; i  <=  count_ ; i++)
                {
                    Excel._Worksheet sheet_ = (Excel._Worksheet)m_oBook.Worksheets[i];
                    for (int r = 0; r < dt_data.Rows.Count; r++ )
                    {
                        for (int c = 0; c < dt_data.Columns.Count; c++)
                        {
                            string column_ = dt_data.Columns[c].ColumnName;
                            for (int cc = 0; cc < dt_a32801_loop.Rows.Count; cc++)
                            {
                                string column_id_ = dt_a32801_loop.Rows[cc]["column_id"].ToString();
                                if (column_id_ == column_)
                                {
                                    int row_id = int.Parse(dt_a32801_loop.Rows[cc]["row_id"].ToString()) + r;
                                    int col_id = int.Parse(dt_a32801_loop.Rows[cc]["col_id"].ToString());
                                    sheet_.Cells[row_id, col_id] = dt_data.Rows[r][column_id_].ToString();
                                    //sheet_.Cells[2, c + 1] = col_text_[cc];
                                }
                            }
                            //打页眉
                            if (r == 0)
                            {
                                for (int cc = 0; cc < dt_a32801_0.Rows.Count; cc++)
                                {
                                    string column_id_ = dt_a32801_0.Rows[cc]["column_id"].ToString();

                                    if (column_id_ == column_)
                                    {

                                        int row_id = int.Parse(dt_a32801_0.Rows[cc]["row_id"].ToString());
                                        int col_id = int.Parse(dt_a32801_0.Rows[cc]["col_id"].ToString());
                                        sheet_.Cells[row_id, col_id] = dt_data.Rows[r][column_id_].ToString();
                                        //sheet_.Cells[2, c + 1] = col_text_[cc];
                                    }
                                }
                                ////打页脚
                                for (int cc = 0; cc < dt_a32801_1.Rows.Count; cc++)
                                {
                                    string column_id_ = dt_a32801_1.Rows[cc]["column_id"].ToString();

                                    if (column_id_ == column_)
                                    {
                                        int row_id = int.Parse(dt_a32801_1.Rows[cc]["row_id"].ToString()); //+r + 1;
                                        int col_id = int.Parse(dt_a32801_1.Rows[cc]["col_id"].ToString());
                                        sheet_.Cells[row_id, col_id] = dt_data.Rows[r][column_id_].ToString();
                                        //sheet_.Cells[2, c + 1] = col_text_[cc];
                                    }
                                }
                            }
                            ////打页脚
                            //if (r == dt_data.Rows.Count - 1)
                            //{
                            //    for (int cc = 0; cc < dt_a32801_1.Rows.Count; cc++)
                            //    {
                            //        string column_id_ = dt_a32801_1.Rows[cc]["column_id"].ToString();

                            //        if (column_id_ == column_)
                            //        {
                            //            int row_id = int.Parse(dt_a32801_1.Rows[cc]["row_id"].ToString()); //+r + 1;
                            //            int col_id = int.Parse(dt_a32801_1.Rows[cc]["col_id"].ToString());
                            //            sheet_.Cells[row_id, col_id] = dt_data.Rows[r][column_id_].ToString();
                            //            //sheet_.Cells[2, c + 1] = col_text_[cc];
                            //        }
                            //    }
                            //}
                          }
                        }
                    //删除多余的空行
                    // ROW_ID_END
                    int ROW_ID_END = int.Parse(dt_a328.Rows[0]["ROW_ID_END"].ToString());
                    int ROW_ID = int.Parse(dt_a328.Rows[0]["ROW_ID"].ToString());
                    if (ROW_ID_END > ROW_ID + dt_data.Rows.Count)
                    {
                        //删除空白行
                        int delrow = ROW_ID + dt_data.Rows.Count + 1;
                        string delrows = (ROW_ID + dt_data.Rows.Count + 1).ToString()+":" + ROW_ID_END.ToString();

                        Excel.Range range = sheet_.get_Range(sheet_.Cells[delrow, 1], sheet_.Cells[ROW_ID_END, 1]);
                        range.Select();
                        range.EntireRow.Delete(Excel.XlDirection.xlUp);

                   // sheet_.Rows(delrows).
                         // Rows("2:10").Select
    //Selection.Delete Shift:=xlUp

                        //for (int cc = delrow; cc <= ROW_ID_END; cc++)
                        //{
                        //    sheet_.Rows.Delete(cc);
                        //    //sheet_.
                        // }
                        //sheet_.Cells[row_id, col_id] = dt_data.Rows[r][column_id_].ToString();

                    }
                    break;
                }
              
                m_oBook.Save();
                 
            }
           catch(Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") .Replace("\r", "").Replace("\n", "")+ "');");
                return "0";
            }
            finally
            {
                
                CloseReportTemplate(outfilename);
            }
            return "1";
        }


        public string AddExeclByColumns(ArrayList parm, string inExcel, string outExcel)
        {
                string modelAdress = inExcel;
                try
                { //把模板拷贝到数据目录
                    if (System.IO.File.Exists(outExcel) == false)
                    {
                        File.Copy(inExcel, outExcel, true);
                        modelAdress = outExcel;
                    }
                }
                catch (Exception ex)
                {
                    System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "").Replace("\r", "").Replace("\n", "") + "');");
                    return "0";
                }
                int sheetcount = parm.Count;
                string[] sheetnamelist = new  string[sheetcount];
                try
                {
                    OpenReportTempalte(modelAdress);      
                   
                    for (int i = 0; i < sheetcount; i++)
                    {
                        Worksheet sheets = (Worksheet)m_oBook.Worksheets.Add();
                        sheetnamelist[sheetcount - i - 1 ] = sheets.Name;                
                    }
                     m_oBook.Save();
                }
                catch (Exception ex)
                {
                    System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") + "');");
                    return "0";
                }
                finally
                {
                    CloseReportTemplate(modelAdress);
                }

               object FileSave = (object)outExcel;
               ExportToExcel ete = new ExportToExcel();
               try
               {
                   ete.DtlistToExcel(parm, outExcel, sheetnamelist);
               }
               catch (Exception ex)
               {
                   System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") + "');");
                   return "0";
               }
            //开始更新列名称 和 sheet名称
               try
               {
                   OpenReportTempalte(modelAdress);
                   int count_ = m_oBook.Worksheets.Count;
                   for (int i = count_; i >= 1; i--)
                   {
                        Excel._Worksheet sheet_ = (Excel._Worksheet)m_oBook.Worksheets[i];
                        Boolean lb_exist = false;
                        int  parmi = 0;
                        for (int j = 0; j < sheetnamelist.Length; j++)
                        {
                            if (sheet_.Name == sheetnamelist[j])
                            {
                                parmi = j;
                                lb_exist = true;
                                break;
                            }
                        }
                        if (lb_exist == false)
                        {
                            m_oExcelApp.DisplayAlerts = false; //如果想删除某个sheet页，首先要将此项设为fasle。                         
                            sheet_.Delete();
                        }
                        else
                        {
                            //给 sheet_ 赋值
                            ArrayList thisparm = new ArrayList();
                            thisparm = (ArrayList)parm[parmi];
                           // sheet_.Rows.Delete(2);
                            sheet_.Name = (string)thisparm[3];
                            System.Data.DataTable myDt = new System.Data.DataTable();
                            myDt = (System.Data.DataTable)thisparm[0];
                            string[] column_id_ = (string[])thisparm[1];
                            string[] col_text_ = (string[])thisparm[2];
                            for (int c = 0; c < myDt.Columns.Count; c++)
                            {
                                string column_ = myDt.Columns[c].ColumnName;
                                for (int cc = 0; cc < column_id_.Length; cc++)
                                {
                                    if (column_id_[cc] == column_)
                                    {
                                        sheet_.Cells[2, c + 1] = col_text_[cc];
                                    }
                                }

                            }
           

                        }

                   }
                   m_oBook.Save();
               }
               catch (Exception ex)
               {
                   System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") + "');");
                   return "0";
               }
              finally
              {
                 CloseReportTemplate(modelAdress);
              }

                //thisparm.Add(dt_data);
                //thisparm.Add(column_id_);
                //thisparm.Add(col_text_);
                //thisparm.Add(dt_a00201.Rows[l]);

            //创建sheet
   
             //try
             //{
             //    OpenReportTempalte(modelAdress);
             //    int count_ = m_oBook.Worksheets.Count;
             //    for (int i = count_; i >= 1; i--)
             //    {
             //        Excel._Worksheet sheet_ = (Excel._Worksheet)m_oBook.Worksheets[i];
             //        if (sheet_.Name != sheet_name)
             //        {
             //            Boolean lb_exist = false;
             //            for (int j = 0; j < sheet_list.Length; j++)
             //            {
             //                if (sheet_.Name != sheet_list[j])
             //                {
             //                    lb_exist = true;
             //                    break;
             //                }
             //            }
             //            if (lb_exist == false)
             //            {
             //                m_oExcelApp.DisplayAlerts = false; //如果想删除某个sheet页，首先要将此项设为fasle。                         
             //                sheet_.Delete();
                             
             //            }
             //        }
             //        else
             //        {
             //            for (int c = 0; c < myDt.Columns.Count; c++)
             //            {
             //                string column_ = myDt.Columns[c].ColumnName;
             //                for (int cc = 0; cc < column_id_.Length; cc++)
             //                {
             //                    if (column_id_[cc] == column_)
             //                    {
             //                        sheet_.Cells[1, c + 1] = col_text_[cc];
             //                    }
             //                }

             //            }
             //        }
             //    }
             //    m_oBook.Save();
             //}
             //catch (Exception ex)
             //{
             //    System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") + "');");
             //    return "0";
             //}
             //finally
             //{
             //    CloseReportTemplate(modelAdress);
             //}
             return "1";
        }
        public string WriteExeclByColumns_Ole(System.Data.DataTable myDt, string[] column_id_, string[] col_text_, string inExcel, string outExcel)
        {
            object FileSave = (object)outExcel;
            string modelAdress = inExcel;
             
            try
            { //把模板拷贝到数据目录
                File.Copy(inExcel, outExcel, true);
                modelAdress = outExcel;
                //OpenReportTempalte(modelAdress);
                //m_oSheet = (Excel._Worksheet)m_oBook.Worksheets[1];
                //for (int c = 0; c < column_id_.Length; c++)
                //{
                //    if (column_id_[c] == "" || column_id_[c] == null)
                //    {
                //        break;
                //    }
                //    m_oSheet.Cells[1, c + 1] = column_id_[c];// col_text_[c];
                //}
                /*for (int r = 0; r < myDt.Rows.Count; r++)
                {

                    for (int c = 0; c < column_id_.Length; c++)
                    {
                        if (column_id_[c] == "" || column_id_[c] == null)
                        {
                            break;
                        }
                        m_oSheet.Cells[r + 2, c + 1] = myDt.Rows[r][column_id_[c]].ToString();
                    }

                }
                */
                //m_oBook.Save();
            }
            catch (Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'", "") .Replace("\r", "").Replace("\n", "")+ "');");
                return "0";
            }
            //finally
            //{
            //    CloseReportTemplate(modelAdress);
            //}
            ExportToExcel ete = new ExportToExcel();
            string sheet_name = "Export";
           
                
                //SaveExcel(myDt, outExcel, sheet_name);
            try
            {
                ete.DtToExcel(myDt, outExcel, sheet_name);
                modelAdress = outExcel;
                OpenReportTempalte(modelAdress);
                int count_ = m_oBook.Worksheets.Count;
                for (int i = count_; i >= 1; i--)
                {
                    Excel._Worksheet sheet_ = (Excel._Worksheet)m_oBook.Worksheets[i];
                    if (sheet_.Name != sheet_name)
                    {
                        m_oExcelApp.DisplayAlerts = false; //如果想删除某个sheet页，首先要将此项设为fasle。                         
                        sheet_.Delete();
                    }
                    else
                    {
                        for (int c = 0; c < myDt.Columns.Count; c++)
                        {
                            string column_ = myDt.Columns[c].ColumnName;
                            for (int cc = 0; cc < column_id_.Length; cc++)
                            {
                                if (column_id_[cc] == column_)
                                {
                                    sheet_.Cells[2, c + 1] = col_text_[cc];
                                }
                            }
                                
                        }
                    }
                }
                m_oBook.Save();
            }
            catch (Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write("alert('" + ex.Message.Replace("'","") + "');");
                return "0";
            }
            finally
            {
                CloseReportTemplate(modelAdress);
            }

            return "1";

        }
        public string WriteExeclByModel(System.Data.DataTable myDt, string inExcel, string outExcel)
        {
            object FileSave = (object)outExcel;
            string modelAdress = inExcel;
            try
            { //把模板拷贝到数据目录
                File.Copy(inExcel, outExcel, true);
                modelAdress = outExcel;
                OpenReportTempalte(modelAdress);
                m_oSheet = (Excel._Worksheet)m_oBook.Worksheets[1];

                for (int c = 0; c < myDt.Columns.Count; c++)
                {
                    // m_oSheet.Cells[r + 1, c + 1] = myDt.Rows[r][c].ToString();
                    string column_id = myDt.Columns[c].ColumnName.ToUpper();
                    try
                    {


                        Range oRange = m_oSheet.Cells.Find("[" + column_id + "]", Missing.Value, Missing.Value, Missing.Value, Missing.Value, Excel.XlSearchDirection.xlNext, Missing.Value, Missing.Value, Missing.Value);
                        if (oRange != null && oRange.Cells.Rows.Count >= 1 && oRange.Cells.Columns.Count >= 1)
                        {
                            bool lb_res = m_oSheet.Cells.Replace("[" + column_id + "]", myDt.Rows[0][c].ToString(), Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value);

                        }
                    }
                    catch
                    {

                    }

                }


                m_oBook.Save();
            }
            catch (Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write(ex.Message);
                return "0";
            }
            finally
            {
                CloseReportTemplate(modelAdress);
            }
            return "1";

        }
        /// <summary>
        /// 插入数据到统计分析图Excel中
        /// </summary>
        /// <param name="myDs"></param>
        public void GeneralExcel(DataSet myDs, string inExcel, string outExcel, string Date, string DeptName)
        {
            object FileSave = (object)outExcel;
            string modelAdress = inExcel;
            try
            {
                File.Copy(inExcel, outExcel, true);
                modelAdress = outExcel;

                OpenReportTempalte(modelAdress);
                m_oSheet = (Excel._Worksheet)m_oBook.Worksheets[1];

                #region 显示Table1,Table2,Table3 数据
                //显示Table1,Table2,Table3 数据
                if (myDs.Tables[0].Rows.Count > 0)
                {
                    for (int i = 0; i < myDs.Tables[0].Rows.Count; i++)
                    {
                        string mark = myDs.Tables[0].Rows[i][0].ToString();
                        int temp = 1;
                        switch (mark)
                        {
                            case "112":
                                {
                                    temp = 2;
                                    break;
                                }
                            case "114":
                                {
                                    temp = 3;
                                    break;
                                }
                            case "115":
                                {
                                    temp = 4;
                                    break;
                                }
                            case "117":
                                {
                                    temp = 5;
                                    break;
                                }
                            case "118":
                                {
                                    temp = 6;
                                    break;
                                }
                            case "1182":
                                {
                                    temp = 7;
                                    break;
                                }
                            case "1":
                                {
                                    temp = 8;
                                    break;
                                }
                        }

                        m_oSheet.Cells[12, temp] = myDs.Tables[0].Rows[i][1].ToString();
                        m_oSheet.Cells[13, temp] = myDs.Tables[0].Rows[i][2].ToString();
                        m_oSheet.Cells[22, temp] = myDs.Tables[0].Rows[i][3].ToString();
                        m_oSheet.Cells[32, temp] = myDs.Tables[0].Rows[i][4].ToString();
                        m_oSheet.Cells[33, temp] = myDs.Tables[0].Rows[i][4].ToString();

                    }
                    m_oSheet.Cells[13, 7] = "×";
                    m_oSheet.Cells[33, 7] = "×";
                }
                #endregion

                #region 显示 Table4,Table5 数据
                if (myDs.Tables[1].Rows.Count > 0)
                {
                    int temp = 0;
                    for (int i = 2; i < 6; i++)
                    {
                        m_oSheet.Cells[44, i] = myDs.Tables[1].Rows[0][temp].ToString();
                        temp++;
                    }
                    for (int i = 2; i < 8; i++)
                    {
                        m_oSheet.Cells[54, i] = myDs.Tables[1].Rows[0][temp].ToString();
                        temp++;
                    }
                }
                #endregion
                m_oSheet.Cells[8, 1] = Date.Substring(0, 4).ToString();
                m_oSheet.Cells[8, 3] = Date.Substring(4, 2).ToString();
                m_oSheet.Cells[9, 1] = DeptName + "线损统计分析表";

                m_oBook.Save();
            }
            catch (Exception ex)
            {
                System.Web.HttpContext.Current.Response.Write(ex.Message);
            }
            finally
            {
                CloseReportTemplate(modelAdress);
            }
        }
        #endregion
        #region OpenReportTempalte
        public void OpenReportTempalte(string modelAdress)
        {
            if (m_oExcelApp != null)
                CloseReportTemplate(modelAdress);

            // Create an instance of Microsoft Excel, make it visible,
            // and open Book1.xls.
            m_oExcelApp = new Excel.ApplicationClass();
            m_oExcelApp.Visible = false;
            m_oBooks = m_oExcelApp.Workbooks;

            // IMPORTANT: IF YOU ARE USING EXCEL Version >= 10.0 Use function
            // prototype in "EXCEL VERSION 10.0" section.
            // For Excel Version 9.0 use default "EXCEL VERSION = 9.0".
            // This application is not tested with versions lower than Excel 9.0
            // Or greater than 10.0

            // EXCEL VERSION 10.0
            //m_oBook = m_oBooks.Open(modelAdress, m_oMissing, m_oMissing,
            // m_oMissing, m_oMissing, m_oMissing, m_oMissing, m_oMissing, m_oMissing,
            // m_oMissing, m_oMissing, m_oMissing, m_oMissing,m_oMissing,m_oMissing);
            // END EXCEL VERSION 10.0

            // EXCEL VERSION 9.0
            m_oBook = m_oBooks.Open(modelAdress, 0, m_oMissing,
          m_oMissing, m_oMissing, m_oMissing, m_oMissing, m_oMissing, m_oMissing,
          m_oMissing, m_oMissing, m_oMissing, m_oMissing, m_oMissing, m_oMissing);
            // END EXCEL VERSION 9.0


        }
        #endregion

        #region CloseReportTemplate
        public void CloseReportTemplate(string modelAdress)
        {
            if (m_oBook != null)
                m_oBook.Save();
            //  m_oBook.Close(true, modelAdress, m_oMissing);

            // Quit Excel and clean up.
            if (m_oSheet != null)
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oSheet);
            m_oSheet = null;
            if (m_oBook != null)
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oBook);
            m_oBook = null;
            if (m_oBooks != null)
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oBooks);
            m_oBooks = null;
            if (m_oExcelApp != null)
            {
                m_oExcelApp.Quit();
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oExcelApp);
                KillExcel();
                m_oExcelApp = null;
            }
        }
        #endregion

        #region CloseReportTemplate
        public void CloseReport(string modelAdress)
        {
            if (m_oBook != null)
                m_oBook.Close(true, modelAdress, m_oMissing);

            // Quit Excel and clean up.
            if (m_oSheet != null)
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oSheet);
            m_oSheet = null;
            if (m_oBook != null)
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oBook);
            m_oBook = null;
            if (m_oBooks != null)
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oBooks);
            m_oBooks = null;
            if (m_oExcelApp != null)
            {
                m_oExcelApp.Quit();
                System.Runtime.InteropServices.Marshal.ReleaseComObject(m_oExcelApp);
                // KillExcel();
                m_oExcelApp = null;
            }
        }
        #endregion



        #region 强制杀死EXCEL应用程序进程
        /// <summary>
        /// 强制杀死EXCEL应用程序进程
        /// </summary>
        private static void KillExcel()
        {
            int iProcessID = 0;
            String sProcessName = "";
            string exmsg = "";
            System.Diagnostics.Process[] pTemp;
            pTemp = System.Diagnostics.Process.GetProcesses();
            foreach (System.Diagnostics.Process pTempProcess in pTemp)
            {
                sProcessName = pTempProcess.ProcessName;
                iProcessID = pTempProcess.Id;
                //将EXCEL改成你需要检测的程序名，不要加exe
                if (sProcessName.CompareTo("EXCEL") == 0)
                {
                    try
                    {
                        pTempProcess.Kill();
                        pTempProcess.Close();
                    }
                    catch(Exception ex)
                    {
                        exmsg = ex.Message;
                    }
                    //   break;
                }
            }
        }
        #endregion

    }

/*
    程序说明,在这里我主要以GeneralExcel方法来说明.NET操作Excel。这里对程序作些简单地解释：

GeneralExcel(DataSet myDs,string inExcel, string outExcel,string Date,string DeptName)方法中，大家只须

注意myDs,inExcel,outExcel三个参数即可。myDs为你要插入到Excel中的数据集。其后的程序很简单，我就不细说了

，相信大家都能看懂！

    在上面的这个类文件中，我指提到了怎样往Excel中插入数据，那怎样重Excel中读取数据呢！其实这个方法在网

上有很多中，也可以用上面的类文件，把插入数据换成读取数据就可以了，例如：

     m_oSheet = (Excel._Worksheet)m_oBook.Worksheets[i];
     mRange=(Excel.Range)m_oSheet.Cells[8,1];     
     strYear=mRange.Value2.ToString();   

这样就可以读取到Excel中数据了。这个方法虽然很简单，但是当Excel中数据很庞大时，我发现这个方法读取速度尤

其的慢，其已经超出了我的忍耐能力，为此我介绍另一中Excel读取方法。既把Excel当做数据库来操作，如下程序事

例：


  public DataSet ExcleToDS_WS(string FilePath,string SheetName)
  {
   string  strConn = "Provider=Microsoft.Jet.OLEDB.4.0;"   +   
    "Data Source=" + FilePath   +   ";"   +   
    ";Extended Properties=Excel 8.0;";   
    
   OleDbConnection   conn   =   new   OleDbConnection(strConn);  
   OleDbDataAdapter   myCommand   =   null;     
   DataSet   ds   =   null;     
   
   conn.Open();     
   string   sSQL   =   "";  
   string strDate=this.hidYM.Value.ToString();
   ExcelFunc m_ExcelFunc=new ExcelFunc(); 
   ds   =   new   DataSet();     
   
   try
   {
    sSQL=string.Format("select   *   from   [{0}$A7:E29]",SheetName);
    myCommand   =   new   OleDbDataAdapter(sSQL,   strConn);      
    myCommand.Fill(ds,"WS_Supply");   
  
    sSQL=string.Format("select   *   from   [{0}$F7:J20]",SheetName);
    myCommand   =   new   OleDbDataAdapter(sSQL,   strConn);      
    myCommand.Fill(ds,"WS_Sell");

    sSQL=string.Format("select   *   from   [{0}$F26:J29]",SheetName);
    myCommand   =   new   OleDbDataAdapter(sSQL,   strConn);      
    myCommand.Fill(ds,"WS_Other");
   }
   catch
   {
    Response.Write("<script language = javascript> alert('模版有误,请按模版填写！');</script>");
   }

   conn.Close();   
   return   ds;      
  }
 //ExcleToDS_WS(string FilePath,string SheetName)函数中FilePath参数为Excel的物理路径，SheetName为Excel中

*/


class ExportToExcel
{
    public void DtlistToExcel(ArrayList parm, string FileName, string[] SheetNamelist)
    {
        String sConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + FileName + ";Extended Properties=Excel 8.0;";
        sConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + FileName + ";" + "Extended ProPerties= \"Excel 12.0;HDR=Yes;\"";
        OleDbConnection cn = new OleDbConnection(sConnectionString);
        try
        {
            cn.Open();
            for (int i = 0; i < SheetNamelist.Length; i++)
            {
                System.Data.DataTable dt = new System.Data.DataTable();
                ArrayList thisparm = new ArrayList();
                thisparm = (ArrayList)parm[i];
                dt = (System.Data.DataTable)thisparm[0];
                string SheetName = SheetNamelist[i];
                String queryString = "INSERT INTO [" + SheetName + "$](";

                string sqlCreate = "CREATE TABLE [" + SheetName + "$] (";
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    string ColumnName_ = "[" + dt.Columns[j].ColumnName + "]";
                    queryString = queryString + ColumnName_ + ",";
                    if (dt.Columns[j].DataType.Name == "Decimal")
                    {
                        sqlCreate = sqlCreate + " " + ColumnName_ + " Double,";
                    }
                    else
                    {
                        sqlCreate = sqlCreate + " " + ColumnName_ + " Text,";
                    }               
                }
                sqlCreate = sqlCreate.Substring(0, sqlCreate.Length - 1) + ")";
                queryString = queryString.Substring(0, queryString.Length - 1) + ")";
                OleDbCommand cmd = new OleDbCommand(sqlCreate, cn);
                //创建Excel文件
                
                //创建表
 
                cmd.ExecuteNonQuery();
                for (int r = 0; r < dt.Rows.Count; r++)
                {
                    String values_ = " VALUES (";
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        string col_v = dt.Rows[r][j].ToString();
                        if (dt.Columns[j].DataType.Name.ToLower().IndexOf("date") >= 0)
                        {
                            try
                            {
                                //把日期转换为 yyyy-mm-dd hh24:mi:ss
                                DateTime dt1 = DateTime.Parse(col_v);
                                col_v = string.Format("{0:u}", dt1);//2005-11-05 14:23:23Z
                                col_v = col_v.Substring(0, 19);
                                col_v = col_v.Replace(" 00:00:00", "");
                                 
                            }
                            catch
                            {
                                col_v = dt.Rows[r][j].ToString();
                            }
                        }
                        if (dt.Columns[j].DataType.Name == "Decimal")
                        {
                            if (col_v == null || col_v == "")
                            {
                                values_ += col_v + "null,"; ;
                            }
                            else
                            {
                                values_ += col_v + ","; ;
                            }
                            
                            
                        }
                        else
                        {
                            if (col_v == null || col_v == "")
                            {
                                values_ += "null,";
                            }
                            else
                            {
                                values_ += "'" + col_v.Replace("'", "''").Replace("\n", ";").Replace("\r", ";") + "',";
                            }

                        }
                    }
                    string insertsql = queryString + values_.Substring(0, values_.Length - 1) + ")";
                    try
                    {
                        cmd.CommandText = insertsql;
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        throw new Exception(insertsql.Replace("'", "\"") + ex.Message);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message);
        }
        finally
        {

            cn.Close();
        }
    }


    public void DtToExcel(System.Data.DataTable dt, string FileName, string SheetName)
    {

        String sConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;" + "Data Source=" + FileName + ";Extended Properties=Excel 8.0;";
        sConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + FileName + ";" + "Extended ProPerties= \"Excel 12.0;HDR=Yes;\"";

       // con.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;" + "Data Source=" + fileName + ";" + "Extended ProPerties= \"Excel 12.0;HDR=Yes;\"";


        OleDbConnection cn = new OleDbConnection(sConnectionString);
        String queryString = "INSERT INTO [" + SheetName + "$](";
        
        string sqlCreate ="CREATE TABLE [" + SheetName + "$] (";
        for (int j = 0; j < dt.Columns.Count; j++)
        {
            string  ColumnName_ = "[" +   dt.Columns[j].ColumnName +"]" ;
            
            queryString = queryString + ColumnName_ +",";
            if (dt.Columns[j].DataType.Name == "Decimal")
            {
                sqlCreate = sqlCreate + " " + ColumnName_ + " Double,";
            }
            else
            {
                sqlCreate = sqlCreate + " " + ColumnName_ + " Text,";
            }
        }
        sqlCreate = sqlCreate.Substring(0, sqlCreate.Length - 1) + ")"; 
        queryString = queryString.Substring(0, queryString.Length - 1) + ")";
        OleDbCommand cmd = new OleDbCommand(sqlCreate, cn);
        //创建Excel文件
        cn.Open();
        //创建表
        try
        {
            cmd.CommandText = sqlCreate;
            cmd.ExecuteNonQuery();
            for (int r = 0; r < dt.Rows.Count; r++)
            {
                String values_ = " VALUES (";
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    string col_v = dt.Rows[r][j].ToString();
                    if (dt.Columns[j].DataType.Name.ToLower().IndexOf("date") >= 0)
                    {
                        try
                        {
                            //把日期转换为 yyyy-mm-dd hh24:mi:ss
                            DateTime dt1 = DateTime.Parse(col_v);
                            col_v = string.Format("{0:u}", dt1);//2005-11-05 14:23:23Z
                            col_v = col_v.Substring(0, 19);
                            col_v = col_v.Replace(" 00:00:00", "");
                        }
                        catch
                        {
                            col_v = dt.Rows[r][j].ToString();
                        }
                    }
                    if (dt.Columns[j].DataType.Name == "Decimal")
                    {
                        if (col_v == null || col_v == "")
                        {
                            values_ += col_v + "null,"; ;
                        }
                        else
                        {
                            values_ += col_v + ","; ;
                        }

                    }
                    else
                    {
                        
                        if (col_v == null || col_v == "")
                        {
                            values_ += "null,";
                        }
                        else
                        {
                            values_ += "'" + col_v.Replace("'", "''").Replace("\n", ";").Replace("\r", ";") + "',";
                        }

                    }
                }
                string insertsql = queryString + values_.Substring(0, values_.Length - 1) + ")";
                try
                {
                    cmd.CommandText = insertsql;
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    throw new Exception(insertsql.Replace("'", "\"") + ex.Message);
                }
            }
        }
        catch(Exception ex )
        {
            throw new Exception(ex.Message);
        }
        finally
        {

            cn.Close();
        }
    }
    public void SaveExcel(System.Data.DataTable dt, string FileName, string SheetName)
    {
        try
        {
            string ConnStr;
            ConnStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=\"" + FileName + "\";Extended Properties=\"Excel 8.0;HDR=YES\"";

            OleDbConnection conn_excel = new OleDbConnection();
            conn_excel.ConnectionString = ConnStr;

            OleDbCommand cmd_excel = new OleDbCommand();

            string sql;
            sql = SqlCreate(dt, SheetName);

            conn_excel.Open();
            cmd_excel.Connection = conn_excel;
            cmd_excel.CommandText = sql;
            cmd_excel.ExecuteNonQuery();

            conn_excel.Close();

            OleDbDataAdapter da_excel = new OleDbDataAdapter("Select * From [" + SheetName + "$]", conn_excel);
            System.Data.DataTable dt_excel = new System.Data.DataTable();
            int count_ = dt_excel.Columns.Count;
            //for (int j = count_ - 1 ; j <= 0; j--)
            //{
            //    string column_name = dt_excel.Columns[j].ColumnName;
            //    dt_excel.Columns.Remove(column_name);
            //}

             
             for (int j = 0; j < dt.Columns.Count; j++)
             {
                 DataColumn dc = dt_excel.Columns.Add();
                 dc.ColumnName = "[" + dt.Columns[j].ColumnName +"]";                 
             }
             da_excel.Fill(dt_excel);
             da_excel.InsertCommand = SqlInsert(SheetName, dt, conn_excel);

            DataRow dr_excel;
            string ColumnName;
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dr_excel = dt_excel.NewRow();
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    ColumnName = dt.Columns[j].ColumnName;
                    string col_v= dt.Rows[i][ColumnName].ToString();
                    if (col_v== null)
                    {
                        col_v = "";
                    }
                    for (int c = 0; c < dt_excel.Columns.Count; c++)
                    {
                        if (dt_excel.Columns[c].ColumnName.ToUpper() == ColumnName.ToUpper())
                        {
                            dr_excel[ColumnName] = col_v;
                            break;
                        
                        }
                    }

                        
                }
                dt_excel.Rows.Add(dr_excel);
            }

            da_excel.Update(dt_excel);
            conn_excel.Close();

        }
        catch (Exception ex)
        { 
            
        }
    }

    private void CheckColumn(System.Data.DataTable dt, System.Data.DataTable dt_v)
    {
        foreach (DataRow dr in dt_v.Select())
        {
            if (!dt.Columns.Contains(dr["列名"].ToString()))
            {
                dr.Delete();
            }
        }
        dt_v.AcceptChanges();
    }

    private string GetDataType(Type i)
    {
        string s;
        s = "Char";
        return s;
        switch (i.Name)
        {
            case "String":
                s = "Char";
                break;
            case "Int32":
                s = "Int";
                break;
            case "Int64":
                s = "Int";
                break;
            case "Int16":
                s = "Int";
                break;
            case "Double":
                s = "Double";
                break;
            case "Decimal":
                s = "Double";
                break;
            default:
                s = "Char";
                break;

        }
        return s;
    }

    private OleDbType StringToOleDbType(Type i)
    {
        OleDbType s;
        s = OleDbType.Char;
        return s;
        switch (i.Name)
        {
            case "String":
                s = OleDbType.Char;
                break;
            case "Int32":
                s = OleDbType.Integer;
                break;
            case "Int64":
                s = OleDbType.Integer;
                break;
            case "Int16":
                s = OleDbType.Integer;
                break;
            case "Double":
                s = OleDbType.Double;
                break;
            case "Decimal":
                s = OleDbType.Decimal;
                break;
            default:
                s = OleDbType.Char;
                break;

        }
        return s;

    }


    private string SqlCreate(System.Data.DataTable dt, string SheetName)
    {
        string sql;

        sql = "CREATE TABLE " + SheetName + " (";

        foreach (DataColumn dc in dt.Columns)
        {
            sql += "[" + dc.ColumnName + "] " + GetDataType(dc.DataType) + " ,";
        }

        //sql = "CREATE TABLE [" + SheetName + "] (";

        //foreach (C1.Win.C1TrueDBGrid.C1DataColumn dc in grid.Columns)
        //{
        //    sql += "[" + dc.Caption + "] " + GetDataType(dc.DataType) + ",";
        //}
        //sql = sql.Substring(0, sql.Length - 1);
        //sql += ")";

        sql = sql.Substring(0, sql.Length - 1);
        sql += ")";

        return sql;
    }


    // 生成 InsertCommand 并设置参数
    private OleDbCommand SqlInsert(string SheetName, System.Data.DataTable dt, OleDbConnection conn_excel)
    {
        OleDbCommand i;
        string sql;

        sql = "INSERT INTO [" + SheetName + "$] (";
        foreach (DataColumn dc in dt.Columns)
        {
            sql += "[" + dc.ColumnName + "] ";
            sql += ",";
        }
        sql = sql.Substring(0, sql.Length - 1);
        sql += ") VALUES (";
        foreach (DataColumn dc in dt.Columns)
        {
            sql += "?,";
        }
        sql = sql.Substring(0, sql.Length - 1);
        sql += ")";

        i = new OleDbCommand(sql, conn_excel);

        foreach (DataColumn dc in dt.Columns)
        {
            i.Parameters.Add("@" + dc.ColumnName, StringToOleDbType(dc.DataType), 0, dc.ColumnName);
        }

        return i;
    }

}
