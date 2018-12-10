<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Dchild.aspx.cs" Inherits="ShowForm_Dchild" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title><%=dt_A014.Rows[0]["A014_NAME"].ToString() %></title>
     <script language=javascript src ="<%=http_url %>/js/BasePage.js"></script>	
      <link href="dchild.css"  rel="stylesheet"  type="text/css" />
    <script language=javascript>
        window.dialogWidth ="<%=int.Parse(width_ ) + 20 %>px";
    window.dialogHeight="<%=int.Parse(height_ ) + 50 %>px";
    <%if (IF_FIRST=="4")
    { %>

    function selectchange()
    {
        ifame = document.getElementById("child");
        ifame.src = "<%=child_url %>&dialog=1&code=" +  Math.random() * 100000 ;
    }
    <%}%>
 
     //  public string DoA014(string a014_id_, string objid_, string table____)
    var data_index = "<%=data_index %>";
    function doA014()
    {
        var str = "OBJID|" + "<%=ROWID %>" + data_index;
        var objs = document.getElementsByTagName("textarea");
        for (var i=0;i< objs.length; i++)
        {
            str += objs[i].id.substr(2) + "|" + objs[i].value + data_index;
        }
        a014_id_ = '<%=dt_A014.Rows[0]["A014_ID"].ToString() %>';
        objid_  = str;
        table____ =  '<%=dt_A014.Rows[0]["TABLE_ID"].ToString() %>';
        var v = BasePage.DoA014( a014_id_,  objid_,  table____).value;
        if (v.indexOf(getMsg("M0008"))  >= 0)
        {
           winclose(v);
        }  
        else
        {
          return ;
        }  
    }   
       
    function winclose(str_v)  
    {
       var   v_v   =   new   Object();  
         v_v.DataId  =  str_v;
         v_v.Para    =   window.dialogArguments; 
         window.returnValue   =   v_v;  
         window.close();        
    }
    </script>
</head>
<body style="font-size:9pt;font-family: 宋体; color: black; overflow:hidden;">
    <form id="form1" runat="server">    
    <div>    
    <%if (IF_FIRST=="4"){%>
        <iframe id="child"  scrolling="auto" style="width:98%;height:600px;"  ></iframe>
       <script language=javascript>
       selectchange()
        </script>
    <%} %>
     <% 
         if (IF_FIRST == "5")
        {
            int max_width = 0;
            int max_height = 0;   
            Response.Write("<table class=\"showdes\">");
           for (int i = 0; i < dt_data.Rows.Count; i++)
            {
                string id = dt_data.Rows[i]["id"].ToString();
                string name = dt_data.Rows[i]["name"].ToString();
                string width = dt_data.Rows[i]["width"].ToString();
                string height = dt_data.Rows[i]["height"].ToString();
                max_width = int.Parse(width) + 25;
                max_height += int.Parse(height);
                string data = dt_data.Rows[i]["des"].ToString();
             %>
              <tr class="h">
              <td>
              <%=name %>
              </td>
              </tr>
              <tr  class="d">
              <td>
              <textarea id="T_<%=id %>"   style="text-align:left; width:<%=width %>px; height:<%=height %>px;" ><%=data%></textarea>
              </td>
              </tr>
            <%
            }
            %>
            <tr>
            <td>
             <div  class="d_bottom">
             <input  type=button value="确定" onclick="doA014()"/>
             <input  type=button value="取消" onclick="winclose('0')"/>
             
             </div>
            </td>
            </tr>
            <% 
            Response.Write("</table>");  
        }
      %>
  
     </div>
    </form>
</body>
</html>
