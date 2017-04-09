<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ChefJeeves.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <title>Chef Jeeves</title>
        <link rel="stylesheet" href="~/Content/bootstrap.min.css" />
        <link rel="stylesheet" href="~/Content/Site.css" />
        <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css' />
    </head>
    <body>
        <form runat="server">
        <div class="jumbotron">
            <div id="nameText">Chef Jeeves</div> 
            <asp:Login ID="lgn" runat="server" DisplayRememberMe="False" OnAuthenticate="lgn_Authenticate" OnLoggedIn="lgn_LoggedIn" FailureText="Your credentials incorrect or your account does not exist" UserNameLabelText="Username:" LoginButtonText="Sign-in" TitleText="Please enter your username and password">
                <TitleTextStyle Font-Bold="True" />
            </asp:Login>
            <asp:Label
                ID="lblError"
                runat="server"
                EnableViewState="False"
                ForeColor="DarkRed"></asp:Label>
        </div>
            <asp:Button ID="btnCreateAccount" runat="server" Text="Create Account" OnClick="btnCreateAccount_Click" CssClass="btn btn-default"/>
            <asp:Button ID="btnForgotPassword" runat="server" Text="Forgot Password" OnClick="btnForgotPassword_Click" CssClass="btn btn-default"/>
        </form>
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
        <footer>
             By using this site you agree that the administrator(s) may save your IP address, cookies, and any other personal data transmitted through your browser. All account data is property of the administrator(s) of this site and can do what he/she wishes with it. This privacy policy may change at any time.
            <asp:HyperLink id="hyperlink1"  NavigateUrl="ContactUs.aspx" Text="Contact Us" runat="server"/>
        </footer>
        <script src="../Scripts/jquery-3.1.1.min.js" ></script>
        <script src="../Scripts/bootstrap.min.js" ></script>
        <script src="../Scripts/Site.js" ></script>   
    </body>
</html>