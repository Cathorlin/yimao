using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class ShowForm_QueryList : System.Web.UI.Page
{
    public BaseFun Fun = new BaseFun();
    public string a00201_key = "";
    public DataTable dt_a00201 = new DataTable();
    public DataTable dt_a013010101 = new DataTable();
    public DataTable dt_data = new DataTable();
    public DataTable dt_temp = new DataTable();
    public string showdatasql = string.Empty;
    public string getShowDataCountSql = string.Empty;
    public string json = "";
    public string RequestXml = "";
    public string DIVID = "";
    public string QUERYID = "";
    public string RequestURL = "";

    public string if_showrow = string.Empty;
    public string PARENTROWID = string.Empty;
    public string main_key_value = string.Empty;
    public string option = string.Empty;
    public int BS_SHOW_HEAD = 0;
    public int PageRow = 0;
    public int MaxRow = 0;
    public int PageNum = 0;
    public int pagecount = 0;
    public int rowscount = 0;
    public string ifinsertrow = string.Empty;
    string status = string.Empty;
    public DataTable dt_a00204 = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        
        try
        {
            string u_select_sql = "";
            PageRow = int.Parse(GlobeAtt.DetailRowS);
            MaxRow = int.Parse(GlobeAtt.QueryList_MaxRow);
            string if_main = dt_a00201.Rows[0]["if_main"].ToString();
            string sort_col = dt_a00201.Rows[0]["sort_col"].ToString();
            Boolean if_select = false;
            if (sort_col == null)
            {
                sort_col = "";
            }
            ifinsertrow = Request.QueryString["IFINSERT"] == null ? "V" : Request.QueryString["IFINSERT"].ToString();
            /*新增*/
            main_key_value = BaseFun.getAllHyperLinks(RequestXml, "<KEY>", "</KEY>")[0].Value;
            option = BaseFun.getAllHyperLinks(RequestXml, "<OPTION>", "</OPTION>")[0].Value;
            //调整dt_a013010101 的数据
            if (dt_a013010101.Rows.Count > 0)
            {
                string a016_a016_enable = dt_a013010101.Rows[0]["a016_enable"].ToString();


                DataTable dt = dt_a013010101.Clone();
                dt.Clear();
                //格式化列
                for (int i = 0; i < dt_a013010101.Rows.Count; i++)
                {
                    a016_a016_enable = dt_a013010101.Rows[i]["a016_enable"].ToString();
                    if (a016_a016_enable == "0" || a016_a016_enable == "1")
                    {
                        string A016_ENABLE = dt_a013010101.Rows[i]["A016_ENABLE"].ToString();
                        if (A016_ENABLE == "0")
                        {
                            dt_a013010101.Rows[i]["COL_ENABLE"] = "0";
                        }
                        string A016_VISIBLE = dt_a013010101.Rows[i]["A016_VISIBLE"].ToString();
                        if (A016_VISIBLE == "0")
                        {
                            dt_a013010101.Rows[i]["COL_VISIBLE"] = "0";
                        }
                        string A016_NECESSARY = dt_a013010101.Rows[i]["A016_NECESSARY"].ToString();
                        if (A016_NECESSARY == "1")
                        {
                            dt_a013010101.Rows[i]["COL_NECESSARY"] = "1";
                        }


                        string a016_col_x = dt_a013010101.Rows[i]["a016_col_x"].ToString();
                        if (a016_col_x != null && a016_col_x != "")
                        {
                            dt_a013010101.Rows[i]["COL_X"] = decimal.Parse(a016_col_x);
                        }

                        string a016_bs_width = dt_a013010101.Rows[i]["a016_bs_width"].ToString();
                        string bs_width = dt_a013010101.Rows[i]["bs_width"].ToString();
                        if (a016_bs_width != null && a016_bs_width != "" && a016_bs_width != bs_width)
                        {

                            dt_a013010101.Rows[i]["bs_width"] = decimal.Parse(a016_bs_width);
                            string bs_edit_width = dt_a013010101.Rows[i]["BS_EDIT_WIDTH"].ToString();
                            dt_a013010101.Rows[i]["BS_EDIT_WIDTH"] = decimal.Parse(bs_edit_width) + (decimal.Parse(a016_bs_width) - decimal.Parse(bs_width));

                            string col_width = dt_a013010101.Rows[i]["col_width"].ToString();
                            dt_a013010101.Rows[i]["col_width"] = decimal.Parse(col_width) + (decimal.Parse(a016_bs_width) - decimal.Parse(bs_width));

                        }
                    }
                    string col01 = dt_a013010101.Rows[i]["col01"].ToString().ToLower();

                    if (col01 == "1")
                    {
                        if_select = true;
                        string COLUMN_ID = dt_a013010101.Rows[i]["COLUMN_ID"].ToString();
                        string line_no = dt_a013010101.Rows[i]["LINE_NO"].ToString();
                        string select_sql_ = dt_a013010101.Rows[i]["SELECT_SQL"].ToString();
                        select_sql_ = select_sql_.Replace("[A007_KEY]", GlobeAtt.A007_KEY);
                        select_sql_ = select_sql_.Replace("[A30001_KEY]", GlobeAtt.A30001_KEY);
                        select_sql_ = select_sql_.Replace("[USER_ID]", GlobeAtt.A007_KEY);
                        select_sql_ = select_sql_.Replace("[MAIN_KEY]", main_key_value);
                        dt_temp = Fun.getDtBySql(select_sql_);
                        //sql
                        string BS_HTML_ = dt_a013010101.Rows[i]["BS_HTML"].ToString();
                        string col10 = dt_a013010101.Rows[i]["col10"].ToString();
                        string col_X = dt_a013010101.Rows[i]["COL_X"].ToString();
                        for (int j = 0; j < dt_temp.Rows.Count; j++)
                        {
                            string id = dt_temp.Rows[j][0].ToString();
                            string name = dt_temp.Rows[j][1].ToString();
                            DataRow dr = dt_a013010101.NewRow();
                            dr = dt_a013010101.Rows[i];
                            dr["COLUMN_ID"] = COLUMN_ID + id;
                            dr["COL_TEXT"] = name;
                            dr["COL_X"] = double.Parse(col_X) + 0.0001 * j;
                            dr["A10001_KEY"] = int.Parse(line_no) * 1000 + j;
                            string BS_HTML = BS_HTML_.Replace("[" + COLUMN_ID + "]", "[" + COLUMN_ID + id + "]");
                            BS_HTML = BS_HTML.Replace("[" + dt_temp.Columns[0].ToString().ToUpper() + "]", id);
                            dr["BS_HTML"] = BS_HTML;
                            dt.ImportRow(dr);
                            //替换列名称
                            u_select_sql = u_select_sql + col10.Replace("[" + dt_temp.Columns[0].ToString().ToUpper() + "]", id) + " as " + COLUMN_ID + id + ",";
                        }

                    }
                    else
                    {
                        dt.ImportRow(dt_a013010101.Rows[i]);
                    }
                }
                dt_a013010101 = dt;


                DataRow[] rows = dt_a013010101.Select("", "COL_X asc");
                DataTable t = dt_a013010101.Clone();
                t.Clear();
                foreach (DataRow row in rows)
                    t.ImportRow(row);
                dt_a013010101 = t;


            }




            if (option == "Q")
            {
                PageRow = int.Parse(GlobeAtt.QueryList_PageRow);
                string PageRow_ = dt_a00201.Rows[0]["pagerows"].ToString();
                if (PageRow_ != null && PageRow_ != "")
                {
                    PageRow = int.Parse(PageRow_);
                }
            }
            else
            {
                string PageRow_ = dt_a00201.Rows[0]["pagerows"].ToString();
                if (PageRow_ != null && PageRow_ != "")
                {
                    PageRow = int.Parse(PageRow_);
                }

            }
            try
            {
                PageNum = int.Parse(BaseFun.getAllHyperLinks(RequestXml, "<PageNum>", "</PageNum>")[0].Value);
            }
            catch
            {
                PageNum = 1;
            }

            string data_sql = "";
            string con_sql = "";
            if (option != "Q")
            {

                if (option == "I")
                {
                    con_sql = con_sql + " AND 1=2";
                }
                else
                {
                    if (dt_a00201.Rows[0]["if_main"].ToString() != "1")
                    {
                        if (dt_a00201.Rows[0]["MAIN_KEY"].ToString() != "")
                        {

                            con_sql = con_sql + " AND " + dt_a00201.Rows[0]["MAIN_KEY"].ToString() + "='" + main_key_value + "'";

                        }
                        else
                        {
                            con_sql = con_sql + " AND " + dt_a00201.Rows[0]["TABLE_KEY"].ToString() + "='" + main_key_value + "'";
                        }
                    }

                }

            }
            else
            {
               // showdatasql = replace_getShowDataSql(dt_a013010101, showdatasql, u_select_sql);
                if (PageNum <= 0)
                {
                    string RETRIEVE = dt_a00201.Rows[0]["RETRIEVE"].ToString();
                    if (RETRIEVE != "1")
                    {
                        con_sql = con_sql + " AND 1=2";
                    }
                }
                string A002ID = BaseFun.getAllHyperLinks(RequestXml, "<A002ID>", "</A002ID>")[0].Value;
                if (a00201_key != A002ID)
                {
                    option = "V";
                    con_sql = con_sql + " AND " + dt_a00201.Rows[0]["MAIN_KEY"].ToString() + "='" + main_key_value + "'";
                }
                //if (RequestURL.ToUpper().IndexOf("QUERYDATA.ASPX") > 0 && main_key_value != "")
                //{
                //    con_sql = con_sql + " AND " + dt_a00201.Rows[0]["TABLE_KEY"].ToString() + "='" + main_key_value + "'";
                //}

            }

            if (option == "Q")
            {
                con_sql = con_sql + " AND ROWNUM <=" + dt_a00201.Rows[0]["MAXROWS"].ToString();
            }
            int pos = showdatasql.IndexOf("ORDER BY");
            string str_order = "";
            if (pos > 0)
            {
                str_order = " " + showdatasql.Substring(pos);
                showdatasql = showdatasql.Substring(0, pos - 1);
            }
            else
            {
                str_order = " " + sort_col;
            }

            data_sql = showdatasql + con_sql + str_order;
            getShowDataCountSql = getShowDataCountSql + con_sql;
            data_sql = data_sql.Replace("[MAIN_KEY]", main_key_value);
            getShowDataCountSql = getShowDataCountSql.Replace("[MAIN_KEY]", main_key_value);
            /*把查询的写日志记录到A00601中*/
            if (GlobeAtt.BS_LOG_SELECTSQL == "1")
            {
                string log_sql = "pkg_a.saveQuerySql('" + GlobeAtt.A007_KEY + "', '" + a00201_key + "' , '" + data_sql.Replace("'", "''") + "','" + main_key_value + "' ) ";
                try
                {
                    Fun.saveQuerySql(a00201_key, data_sql, main_key_value, option);
                }
                catch (Exception ex)
                {
                    log_sql = ex.Message;
                }

            }

            if (option != "Q")
            {
                if (if_select)
                {
                    data_sql = "Select a.* , " + u_select_sql + " rownum as rn from (" + data_sql + ") a  where rownum <=  " + (PageNum * PageRow).ToString();
                }
                else
                {
                    data_sql = "Select a.* , rownum as rn from (" + data_sql + ") a  where rownum <=  " + (PageNum * PageRow).ToString();

                }
            }
            else
            {
                data_sql = "Select a.* , rownum as rn from (" + data_sql + ") a  where rownum <=  " + (PageNum * PageRow).ToString();

            }

            data_sql = "Select b.*  from (" + data_sql + ") b where rn > " + ((PageNum - 1) * PageRow).ToString();
            Session["QUERY" + a00201_key] = data_sql;
            DateTime ld = DateTime.Now;
            dt_data = Fun.getDtBySql(data_sql);
            double le = (DateTime.Now - ld).TotalSeconds;

            string sql_ = "Select pkg_show.geta00204('" + a00201_key + "','" + main_key_value + "','" + GlobeAtt.A007_KEY + "','0','" + option + "','" + status + "') as c  from dual ";
            if (option == "Q")
            {
                sql_ = "Select pkg_show.geta00204('" + a00201_key + "','[LIST]','" + GlobeAtt.A007_KEY + "','1','Q') as c  from dual ";
            }
            dt_a00204 = Fun.getDtBySql(sql_);
            double GRID_SECONDS = 5;
            try
            {
                GRID_SECONDS = double.Parse(GlobeAtt.GetValue("GRID_SECONDS"));
            }
            catch
            {
                GRID_SECONDS = 5;
            }
            if (le < GRID_SECONDS)
            {
                dt_temp = Fun.getDtBySql(getShowDataCountSql);
                try
                {
                    rowscount = int.Parse(dt_temp.Rows[0][0].ToString());
                }
                catch
                {
                    rowscount = 0;
                }
            }
            else
            {
                if (dt_data.Rows.Count < PageRow)
                {
                    rowscount = dt_data.Rows.Count;
                }
                else
                {
                    rowscount = int.Parse(dt_a00201.Rows[0]["MAXROWS"].ToString());
                }
            }
            pagecount = rowscount / PageRow;
            if (rowscount % PageRow > 0)
            {
                pagecount = pagecount + 1;
            }
        }
        catch (Exception ex)
        {
            Response.Write("ERROR URL:" + ex.Message);
        }
    }

}