using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Configuration;
using System.Collections;
public partial class ShowForm_TreeShowList :BasePage
{
    public DataTable dt_main = new DataTable();
    public DataTable dt_child = new DataTable();
    public DataTable dt_temp = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        try
        {
            A007_KEY = GlobeAtt.A007_KEY;
            A30001_KEY = GlobeAtt.A30001_KEY;
        }
        catch
        {
            A007_KEY = "";
            A30001_KEY = "";
        }
        //需求
        //dt_main = Fun.getDtBySql("Select t.*  From bl_shop_order_pro_line t   Where  t.pro_id = 1002252");
        ////需求的供应
        //dt_child = Fun.getDtBySql("select t.supp_pro_id  from bl_shop_order_pro_detail t Where t.pro_id =1002252 group by supp_pro_id ");

    }
    public string get_child_html(string mainsql_, string childsql_,DataRow dr_parent , string main_exec_sql , string exec_Sql, int num,string parent_id_  )
    {
        DataTable dt__main = new DataTable();
        DataTable dt__child = new DataTable();
        StringBuilder html_ = new StringBuilder();
     
       
     
        if (num > 50)
        {
            return "错误" + dr_parent[0].ToString();
        }
        dt__main = Fun.getDtBySql(main_exec_sql);
       if (childsql_.Length > 10)
       {
           dt__child = Fun.getDtBySql(exec_Sql);

       }
        
      StringBuilder showhtml = new StringBuilder();
     
    //如果是最后一层的
      if (dt__child.Rows.Count == 0)
      {
          showhtml.Append("<div style=\"width:" + (20 * num).ToString() + "px;float:left;background:url(../images/line_y.gif) repeat-y 16px 0;\">");
          showhtml.Append("<img src=\"../images/t.gif\" style=\"height:20px;margin-left:" + (20 * (num - 1) -20).ToString() + "px;\" ></div>");
      
          showhtml.Append("<div id=\"S" + parent_id_ + "\" class=\"showdiv\" style=\"margin-left:0px;float:left;\">");
          html_.Append(Environment.NewLine);
          //showhtml.Append("<img src=\"../images/14.png\" class=\"arrow_img_s\">");
          html_.Append(Environment.NewLine);
          showhtml.Append("<div class=\"shows\">");
          html_.Append(Environment.NewLine);
          if (dt__main.Rows.Count == 0)
          {
              showhtml.Append(dr_parent[0].ToString() );
          }
          else
          {           
              showhtml.Append(dt__main.Rows[0][0].ToString());
          }
          html_.Append(Environment.NewLine);
          showhtml.Append("</div>");
          html_.Append(Environment.NewLine);
          showhtml.Append("</div>");
          html_.Append(Environment.NewLine);
          return showhtml.ToString();
      }
      else
      {
          //bigsize.jpg
          //showhtml.Append("<div style=\"width:" + (20 * (num -1)-35).ToString() + "px;float:left;\">&nbsp;<div>");

          showhtml.Append("<div style=\"width:35px;float:left;background:url(../images/line_y.gif) repeat-y 16px 0;\">");
          showhtml.Append("<img id=\"i" + parent_id_ + "\" class=\"arrow_img\" src=\"../images/ico_folder_open_fst.gif\" style=\"height:20px;margin-left:10px;\" ></div>");           
          showhtml.Append("<div id=\"S" + parent_id_ + "\" class=\"maindiv\" style=\"margin-left:" + (20 * num).ToString() + "px;\">");
          html_.Append(Environment.NewLine);
          //showhtml.Append("<img  src=\"../images/26.png\" id=\"i" + parent_id_ + "\">");
          //html_.Append(Environment.NewLine);
          showhtml.Append("<div class=\"shows\">");
          html_.Append(Environment.NewLine);
          if (dt__main.Rows.Count == 0)
          {
              showhtml.Append(dr_parent[0].ToString());
          }
          else
          {            
              showhtml.Append(dt__main.Rows[0][0].ToString());
          }
          html_.Append(Environment.NewLine);
          showhtml.Append("</div>");
          html_.Append(Environment.NewLine);
          showhtml.Append("</div>");
          html_.Append(Environment.NewLine);
          html_.Append("<table  class=\"maint\" cellSpacing=0 cellPadding=0>");
          //显示行
          html_.Append(Environment.NewLine);
          html_.Append("<tr class=\"t0\">");
          html_.Append(Environment.NewLine);
          html_.Append("<td>");
          html_.Append(Environment.NewLine);
          html_.Append(showhtml.ToString());

          html_.Append(Environment.NewLine);
          html_.Append("</td>");
          html_.Append(Environment.NewLine);
          html_.Append("</tr>");
          html_.Append(Environment.NewLine);
          //分割线
          //html_.Append("<tr class=\"t1\">");
          //html_.Append(Environment.NewLine);
          //html_.Append("<td align=center>");
          //html_.Append(Environment.NewLine);
          ////html_.Append(showhtml.ToString());
          //    StringBuilder str_line = new StringBuilder();
          //    str_line.Append("<table width=\"100%\"><tr>");
          //    for (int i = 0; i < dt__child.Rows.Count; i++)
          //    {
          //        str_line.Append("<td  align=center>");
          //        str_line.Append("<img  src=\"../images/18.png\" style=\"width:10px; height:20px;\">");
          //        str_line.Append(" </td>");
          //    }
          //    str_line.Append("</tr></table>");

          //html_.Append(str_line.ToString());
          //html_.Append(Environment.NewLine);
          //html_.Append("</td>");
          //html_.Append(Environment.NewLine);
          //html_.Append("</tr>");
          html_.Append(Environment.NewLine);



          //明细
          html_.Append("<tr class=\"t2\" id=\"tr" + parent_id_ +"\" show=\"1\">");
          html_.Append(Environment.NewLine);
          html_.Append("<td align=left>");
          html_.Append(Environment.NewLine);

          StringBuilder str_child = new StringBuilder();
          str_child.Append("<table width=\"100%\" cellSpacing=0 cellPadding=0>");
          str_child.Append(Environment.NewLine);
          for (int i = 0; i < dt__child.Rows.Count; i++)
          {
               string child_key = dt__child.Rows[i][0].ToString();
               StringBuilder childhtml = new StringBuilder();
               childhtml.Append("<tr><td>");
               childhtml.Append(Environment.NewLine);
               string exec_Sql_ = childsql_;
               string main_exec_sql_ = mainsql_;
               
               //格式化下级的SQL
               for (int c = 0; c < dt__child.Columns.Count; c++)
               {
                   exec_Sql_ = exec_Sql_.Replace("[" + dt__child.Columns[c].ColumnName.ToUpper()+"]", dt__child.Rows[i][c].ToString());
                   main_exec_sql_ = main_exec_sql_.Replace("[" + dt__child.Columns[c].ColumnName.ToUpper() + "]", dt__child.Rows[i][c].ToString());
                
               }
                   //string childhtml = get_child_html(mainsql_, childsql_, child_key);
                   if (num > 100)
                   {
                       childhtml.Append(child_key);
                   }
                   else
                   {
                       string id_ = i.ToString();
                       if (i >=9)
                       {
                           System.Text.ASCIIEncoding asciiEncoding = new System.Text.ASCIIEncoding();
                           byte[] byteArray = new byte[] { (byte)(48 + i ) };
                           id_ = asciiEncoding.GetString(byteArray);
         
                       }

                       childhtml.Append(get_child_html(mainsql_, childsql_, dt__child.Rows[i], main_exec_sql_, exec_Sql_, num + 1, parent_id_ + id_));
                   }

                   childhtml.Append("</td></tr>");
                   childhtml.Append(Environment.NewLine);
                   str_child.Append(childhtml.ToString());
          }
          str_child.Append("</table>");
          str_child.Append(Environment.NewLine);

          html_.Append(str_child.ToString());

          html_.Append(Environment.NewLine);
          html_.Append("</td>");
          html_.Append(Environment.NewLine);
          html_.Append("</tr>");
          str_child.Append(Environment.NewLine);
          html_.Append("</table>");
          str_child.Append(Environment.NewLine);

        
      }  
      

      return html_.ToString();;
   
    
    }


}