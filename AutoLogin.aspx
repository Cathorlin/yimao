<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AutoLogin.aspx.cs" Inherits="AutoLogin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <script type="text/javascript" src ="js/BasePage.js?ver=20130902"></script>
    <script type="text/javascript" src ="js/http.js?ver=20130902"></script>	
    <title></title>
 </head>
<body>
    <form id="form1" runat="server">
    <div>    

    </div>
    </form>
</body>
   <script language=javascript>
        document.body.onload = function () {
            window.moveTo(0, 0);
            window.resizeTo(screen.width, screen.height);
            var tmp = window.open("about:blank", "", "status=no,toolbar=no,menubar=no")
            tmp.moveTo(0, 0)
            tmp.resizeTo(screen.width, screen.height - 30)
            tmp.focus()
            url="";
            <%        
                if (user_id == "-1")
                {
                    Response.Write("url=\"login.aspx\";");
                }
                else
                {
                    BaseLogin BLogin = new BaseLogin("1", user_id, "", "0");
                    string ls_login = BLogin.checkUserLogin();
                    Response.Write("url=\"default.aspx\";");
                }
            %>
            tmp.location = url;
            closeWin();
        }

        function closeWin() {
            window.opener = null;
            window.open('', '_self');
            window.close();
        }
</script>

</html>
