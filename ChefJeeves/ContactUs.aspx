<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="ChefJeeves.ContactUs" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contact Chef Jeeves</title>
    <link rel="icon" href="~/Images/favicon.ico" />
    <link rel="stylesheet" href="~/Content/bootstrap.min.css" />
    <link rel="stylesheet" href="~/Content/themes/base/jquery-ui.css"/>
    <link rel="stylesheet" href="~/Content/Site.css" />
    <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css' />
</head>
<body>
    <header>
        <nav class="navbar navbar-default">
            <div class="container-fluid">
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <div class="navbar-form navbar-left">
                        <a href="/Login.aspx" ><img id="imgLogo" src="../Images/ChefJeevesLogo.png" /></a>
                    </div>
                    <div id="navHeading">Contact Chef Jeeves</div>                     
                </div>
            </div>
        </nav>
    </header>    
    <form id="formContactUs" runat="server">
    <div id="contactPage">        
        <div>
            <table style="margin-bottom:100px;">                

                <tr>
                    <td>
                        <asp:Label runat="server" ID="lblEmail" Text="Email:" />
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtEmail" Width="100%" />
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" Display="Dynamic" ID="RequiredFieldValidator1"
                            ControlToValidate="txtEmail" ErrorMessage="Your Email is required" ForeColor="Red"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                            ControlToValidate="txtEmail" ErrorMessage="Must be valid email address" 
                            ForeColor="Red"></asp:RegularExpressionValidator>
                    </td>
                </tr>
             
                <tr>
                    <td>
                        <asp:Label runat="server" ID="lblBody" Text="Comments:" />
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtBody" Width="100%" TextMode="MultiLine" Rows="8" />
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" Display="Dynamic" ID="valRequireBody"
                            ControlToValidate="txtBody" ErrorMessage="The Message is required" ForeColor="Red"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="3"  >
                        <img src="CaptchaPage.aspx" alt="Catcha" /><br />
                        <p>
                            <strong>Enter the code shown above:</strong><br />
                            <asp:TextBox ID="txtCodeNumber" runat="server"></asp:TextBox>
                        </p>
                        <p>
                            <em class="notice">(Note: If you cannot read the numbers in the above<br/>
                                image, reload the page to generate a new one.)</em>
                        </p>
                        <p>
                            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
                        </p>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" >
                        <asp:Label runat="server" ID="lblFeedbackOK" Text="Your message has been successfully sent."
                            SkinID="FeedbackOK" Visible="false" ForeColor="#006600" Font-Bold="True" />
                        <asp:Label runat="server" ID="lblFeedbackKO" Text="Sorry, there was a problem sending your message."
                            SkinID="FeedbackKO" Visible="false" ForeColor="Red" />
                       
                    </td>
                </tr>
                <tr>
                    <td colspan="3" >
                        <asp:Button runat="server" ID="btnSubmit" Text="Submit" onclick="btnSubmit_Click" CssClass="btn btn-info" />
                        <asp:Button runat="server" ID="btnCancel" Text="Cancel"  onclick="btnCancel_Click" CausesValidation="False" CssClass="btn btn-info" />
                    </td>
                </tr>
            </table>
        </div>
        </div>
    </form>
    <footer id="footer">
        By using this site you agree that the administrator(s) may save your IP address, cookies, and any other personal data transmitted through your browser. All account data is property of the administrator(s) of this site and can do what he/she wishes with it. This privacy policy may change at any time.
    </footer>
    <script src="../Scripts/jquery-3.1.1.min.js" ></script>
    <script src="../Scripts/jquery-ui-1.12.1.min.js" ></script>
    <script src="../Scripts/bootstrap.min.js" ></script>
    <script src="../Scripts/Site.js" ></script>
</body>
</html>
