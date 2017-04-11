<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CaptchaPage.aspx.cs" Inherits="ChefJeeves.CaptchaPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Captcha</title>
    <link rel="icon" href="~/Images/favicon.ico" />
    <link rel="stylesheet" href="~/Content/bootstrap.min.css" />
    <link rel="stylesheet" href="~/Content/themes/base/jquery-ui.css"/>
    <link rel="stylesheet" href="~/Content/Site.css" />
    <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
</head>
<body>
    <form id="Captcha" method="post" runat="server">
    </form>
    <hr />
    <footer id="footer">
        By using this site you agree that the administrator(s) may save your IP address, cookies, and any other personal data transmitted through your browser. All account data is property of the administrator(s) of this site and can do what he/she wishes with it. This privacy policy may change at any time.
        <br />
        <asp:HyperLink id="lnkContactUs"  NavigateUrl="ContactUs.aspx" Text="Contact Us" runat="server"/>
    </footer>
    <script src="../Scripts/jquery-3.1.1.min.js" ></script>
    <script src="../Scripts/jquery-ui-1.12.1.min.js" ></script>
    <script src="../Scripts/bootstrap.min.js" ></script>
    <script src="../Scripts/Site.js" ></script>
</body>
</html>
