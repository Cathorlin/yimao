<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CRShow.aspx.cs" Inherits="CRShow"   %>
<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"    Namespace="CrystalDecisions.Web" TagPrefix="CR"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title><%=menu_name %>打印</title>
    <link href="CrystalReport.css"  rel="stylesheet"  type="text/css" />   
    <script language=javascript>


        document.onmouseup = function (oEvent) {
            if (!oEvent) oEvent = window.event;
            source = oEvent.srcElement;
            if (source == null) {
                source = oEvent.target;
            } 
        }
     </script> 
</head>
<body style="margin:0;" scroll="auto">
    <form id="form1" runat="server">
    <table  runat=server id="t_con">
    
    </table>
    <asp:Button ID="Button1" runat="server" Text="确定" OnClick="Button1_Click" />
    <div >       
    <CR:CrystalReportViewer   ID="CrystalReportViewer1" runat="server" BestFitPage=True   
            AutoDataBind="false"  Width="100%" Height="100%"  DisplayToolbar=True  
            CssClass="crview" ToolPanelView="None" ToolPanelWidth="100px"   
            HasDrilldownTabs=False Enabled =true EnableDrillDown =false />
    </div>

    </form>
</body>
</html>
