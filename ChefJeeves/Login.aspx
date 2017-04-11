<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ChefJeeves.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Chef Jeeves</title>
        <link rel="icon" href="~/Images/favicon.ico" />
        <link rel="stylesheet" href="~/Content/bootstrap.min.css" />
        <link rel="stylesheet" href="~/Content/themes/base/jquery-ui.css"/>
        <link rel="stylesheet" href="~/Content/Site.css" />
        <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
    </head>
    <body>
        <header>
            <nav class="navbar navbar-default">
                <div class="container-fluid">
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                        <div class="navbar-form navbar-left">
                            <a href="#" ><img id="imgLogo" src="../Images/ChefJeevesLogo.png" /></a>
                        </div>
                        <div class="navbar-form navbar-right">
                            <form runat="server">
                                <asp:Button ID="btnCreateAccount" runat="server" Text="Create Account" OnClick="btnCreateAccount_Click" CssClass="btn btn-info"/>
                                <asp:Button ID="btnForgotPassword" runat="server" Text="Forgot Password" OnClick="btnForgotPassword_Click" CssClass="btn btn-info"/>
                                <asp:Login ID="lgn" runat="server" DisplayRememberMe="False" OnAuthenticate="lgn_Authenticate" OnLoggedIn="lgn_LoggedIn" FailureText="Your credentials incorrect or your account does not exist" UserNameLabelText="Username:" LoginButtonText="Sign-in" TitleText="Please enter your username and password">
                                    <TitleTextStyle Font-Bold="True" />
                                </asp:Login>
                                <asp:Label ID="lblError" runat="server" EnableViewState="False" ForeColor="DarkRed"></asp:Label>
                            </form>
                        </div>                        
                    </div>
                </div>
            </nav>
        </header>
        <div class="jumbotron">
            <div id="nameText">Chef Jeeves</div> 
        </div>
        <div class="row">
            <div class="col-md-4">
                <h2>Manage Ingredient Inventory</h2>
                <p>Keep track off all the ingredients you buy for your fridge and pantry!</p>
            </div>
            <div class="col-md-4">
                <h2>Recipes Are Suggested For You</h2>
                <p>Chef Jeeves's enhanced AI determines recipes you can make based off your current inventory!</p>
            </div>
            <div class="col-md-4">
                <h2>Help Grow Our Community</h2>
                <p>Our database is expanding with new recipes being continously added!</p>
            </div>
        </div>
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