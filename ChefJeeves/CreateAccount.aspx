<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateAccount.aspx.cs" Inherits="ChefJeeves.CreateAccount" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Account</title>
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
                        <a href="/Login.aspx" ><img id="imgLogo" src="../Images/ChefJeevesLogo.png" /></a>
                    </div>
                    <div id="navHeading">Create Account</div>                     
                </div>
            </div>
        </nav>
    </header>  
    <form id="form1" runat="server">
    <table id="createAccount">
        <tr>
            <td>
                <asp:FileUpload ID="fileUpload" runat="server" />
            </td>
            <td>
                <asp:CustomValidator runat="server" ID="CustomValidator1" 
                    OnServerValidate="hasImage"
                    ErrorMessage="The profile must have an image" ForeColor="DarkRed"></asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblUserName" runat="server" Text="Username:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtUserName" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="txtUserName" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="txtUserName" ErrorMessage="Must be less than 65 alphanumeric characters" 
                    ValidationExpression="^\w{1,64}$" ForeColor="DarkRed"></asp:RegularExpressionValidator>
                <asp:CustomValidator runat="server" ID="CustomValidator2" 
                    OnServerValidate="usernameExists"
                    ErrorMessage="Username already exists. Choose another one." ForeColor="DarkRed"></asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblEmail" runat="server" Text="Email:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Must be valid email address" 
                    ForeColor="DarkRed"></asp:RegularExpressionValidator>
                <asp:CustomValidator runat="server" ID="CustomValidator3" 
                    OnServerValidate="emailExists"
                    ErrorMessage="Email address already exists. Choose another one." ForeColor="DarkRed"></asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblName" runat="server" Text="Name:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ControlToValidate="txtName" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblSecurityQuestion" runat="server" Text="Security Question:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtSecurityQuestion" runat="server" ></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                    ControlToValidate="txtSecurityQuestion" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblSecurityAnswer" runat="server" Text="Security Answer:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                    ControlToValidate="txtSecurityAnswer" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblConfirmSecurityAnswer" runat="server" Text="Confirm Security Answer:" ></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtConfirmSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox>
            </td>
            <td>
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ControlToCompare="txtSecurityAnswer" ControlToValidate="txtConfirmSecurityAnswer" 
                    ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblPassword" runat="server" Text="Password:" TextMode="Password"></asp:Label>                   
            </td>
            <td>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
            </td>
            <td>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                    ControlToValidate="txtPassword" ErrorMessage="Must be between 7 and 12 characters, and contains at least 1 special, 1 number, and 1 letter character"
                    ForeColor="DarkRed"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblConfirmPassword" runat="server" Text="Confirm Password:" ></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
            </td>
            <td>
                <asp:CompareValidator ID="CompareValidator2" runat="server" 
                    ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" 
                    ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button ID="btnCreate" runat="server" Text="Create" OnClick="btnCreate_Click" CssClass="btn btn-info"/>
            </td>
            <td>
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="btn btn-info"/>
            </td>
        </tr>        
    </table>
    </form>
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
