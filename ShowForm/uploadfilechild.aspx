<%@ Page Language="C#" AutoEventWireup="true" CodeFile="uploadfilechild.aspx.cs" Inherits="ShowForm_uploadfilechild" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>上传文件</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">


<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.tabfont01 {	
	font-family: "宋体";
	font-size: 9px;
	color: #555555;
	text-decoration: none;
	text-align: center;
}
.font051 {font-family: "宋体";
	font-size: 12px;
	color: #333333;
	text-decoration: none;
	line-height: 20px;
}
.font201 {font-family: "宋体";
	font-size: 12px;
	color: #FF0000;
	text-decoration: none;
}
.button {
	font-family: "宋体";
	font-size: 14px;
	height: 37px;
}
html { overflow-x: auto; overflow-y: auto; border:0;} 
    .style1
    {
       
        font-family: "宋体";
	font-size: 12px;
    }
-->
</style>
<script language=javascript>
function chgValue(v)
{
    var pos1 = v.lastIndexOf("\\");
    var pos2 = v.lastIndexOf(".");
    var vv= "";
    if (pos1>0 && pos2 >0)
    {
        vv =  v.substring(pos1 + 1,pos2)
        document.getElementById("TextBox1").value = vv ;
    }
    
}

</script>
  </HEAD>
<body topmargin="0" class="bd" style="font-size: 9pt" >
    <center>
        <form id="Form1" runat="server" method="post">

   <table id="subtree1"  width="100%" border="0" cellspacing="0" cellpadding="0">

       <tr id ="tr_file" runat="server">
       <td>
       
            <table >
                <tr>
             <td style="width: 60px;font-size:9pt;">
                        <nobr>文件：</nobr></td>
                    <td style="width: 323px">
          <asp:FileUpload ID="fileupdate" runat="server" Font-Size="12px" Height="22px" Width="420px"  /></td>
          <td style="width: 60px">
             <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="上传" /> 
             </td>
             <%if (model_file_name.Length > 1)
               { %>
             <td style="width: 80px">
             <a href="<%=model_file_name %>" target=_blank  
                     class="style1">下载模板 </a>
             </td>
             <%} %>
             </tr>
            </table>
       </td>
       </tr>
        <tr >
         <td >
          
	 <div id="List1_list" class="div_list" style="overflow:auto;">
   
                <asp:GridView ID="GridView1" runat="server"  BackColor="White"  CellPadding="4" CssClass="newfont03" AllowPaging="True" PageSize="100000" width="100%" BorderColor="#3366CC" BorderStyle="None" BorderWidth="1px" style="border-right: blue thin solid; border-top: blue thin solid; border-left: blue thin solid; border-bottom: blue thin solid" Font-Names="新宋体" Font-Size="9pt" >
        <FooterStyle BackColor="#99CCCC" ForeColor="#003399" />
        <SelectedRowStyle BackColor="#009999" ForeColor="#CCFF99" Font-Bold="True" />
        <PagerStyle  HorizontalAlign="Left" BackColor="#99CCCC" ForeColor="#003399" />
        <HeaderStyle  Font-Bold="True"  BackColor="#003399" ForeColor="#CCCCFF" />
        <AlternatingRowStyle   BorderWidth="0px" />
                    <RowStyle  BackColor="White" ForeColor="#003399" />


    </asp:GridView>
            </div>
        </td>
        </tr>
        <tr>
        <td style="height: 15px">
            &nbsp;</td>
        
        </tr>
</table>
        </form>
    </center>

    </body>
	
	
</HTML>

