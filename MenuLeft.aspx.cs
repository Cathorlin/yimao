using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

    public partial class MenuLeft :BasePage
    {
        public DataTable dt_child = new DataTable();
        public DataTable dt_child_child = new DataTable();
        public DataTable dt_menu = new DataTable();
        public DataTable dt_all = new DataTable();
        public DataTable menu_type = new DataTable();
        public string sql = "";
        public string menu_name = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            //获取用户名和用户名称
            base.PageBase_Load(sender, e);
            string menu_id = Request.QueryString["menu_id"] == null ? "" : Request.QueryString["menu_id"].ToString();
            menu_id = "00";
            menu_name = Request.QueryString["menu_name"] == null ? "主菜单" : Request.QueryString["menu_name"].ToString();
           // sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where  parent_id = '[PARENT_ID]'  and active ='1' and pkg_a.getUserMenu(t.menu_id,'" + A007_KEY + "'," + A30001_KEY + ") = '1' order by sort_by,menu_id";
            //dt_menu = Fun.getDtBySql(sql.Replace("[PARENT_ID]", menu_id));
            sql = "Select t.*,pkg_a.getmenuname(t.a002_key,'" + GlobeAtt.A007_KEY + "') as show_name from A002_V01 t where  active ='1' and pkg_a.getUserMenu(t.menu_id,'" + A007_KEY + "'," + A30001_KEY + ") = '1' order by  PARENT_ID ,sort_by,menu_id";

            dt_all = Fun.getDtBySql(sql);
            /*
            if (!IsPostBack)
            {


                for (int i = 0; i < dt_menu.Rows.Count; i++)
                {
                    string menu_id = dt_menu.Rows[i]["menu_id"].ToString();
                    string menu_name = dt_menu.Rows[i]["show_name"].ToString();
                    TreeNode tn = new TreeNode();
                    tn.Text = menu_name;

                    dt_child = Fun.getDtBySql(sql.Replace("[PARENT_ID]", menu_id));
                    for (int j = 0; j < dt_child.Rows.Count; j++)
                    {
                        TreeNode tchild = new TreeNode();
                        string menu_id_child = dt_child.Rows[j]["menu_id"].ToString();
                        string menu_name_child = dt_child.Rows[j]["show_name"].ToString();
                        tchild.Text = menu_name_child;
                        tn.ChildNodes.Add(tchild);

                    }
                    tn.Expanded = false;
                    TreeView1.Nodes.Add(tn);

                }
            
            }
             * */

        }

    }
