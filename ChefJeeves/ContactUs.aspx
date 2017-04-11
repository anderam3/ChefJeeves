<<<<<<< HEAD
﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="ChefJeeves.ContactUs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Contact Chef Jeeves</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Contact Chef Jeeves</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form id="formContactUs" runat="server" class="form-horizontal" >
        <div class="form-group">
            <asp:Label runat="server" ID="lblEmail"  Text="Email:" for="txtEmail" class="col-sm-2  control-label"/>
            <div class="col-sm-10">
                <asp:TextBox runat="server"  ID="txtEmail" class="form-control" />
                <asp:RequiredFieldValidator runat="server" Display="dynamic" ID="RequiredFieldValidator1" SetFocusOnError="true" ControlToValidate="txtEmail" ErrorMessage="Your Email is required">*</asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtEmail" ErrorMessage="Must be valid email address" ForeColor="DarkRed"></asp:RegularExpressionValidator>
            </div>
=======
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="ChefJeeves.ContactUs" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contact Chef Jeeves</title>
    <link rel="icon" href="~/Images/favicon.ico" />
    <link rel="stylesheet" href="~/Content/bootstrap.min.css" />
    <link rel="stylesheet" href="~/Content/themes/base/jquery-ui.css"/>
    <link rel="stylesheet" href="~/Content/Site.css" />
    <link href='https://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
</head>
<body>
    <form id="formContactUs" runat="server">
    <div style="padding: 5px 0px 10px 150px">
        
        <div>
            <table>
              
                <tr>
                    <td >
                       <asp:Label runat="server" ID="lblEmail" AssociatedControlID="txtEmail" Text="Email:" />
                    </td>
                    <td>
                          <asp:TextBox runat="server" ID="txtEmail" Width="100%" />
                    </td>
                    <td>
                      <asp:RequiredFieldValidator runat="server" Display="dynamic" ID="RequiredFieldValidator1"
                            SetFocusOnError="true" ControlToValidate="txtEmail" ErrorMessage="Your Email is required">*</asp:RequiredFieldValidator>
                       
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                    ControlToValidate="txtEmail" ErrorMessage="Must be valid email address" 
                    ForeColor="DarkRed"></asp:RegularExpressionValidator>
                    </td>
                </tr>
             
                <tr>
                    <td >
                        <asp:Label runat="server" ID="lblBody" AssociatedControlID="txtBody" Text="Comments:" />
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="txtBody" Width="100%" TextMode="MultiLine" Rows="8" />
                    </td>
                    <td>
                        <asp:RequiredFieldValidator runat="server" Display="dynamic" ID="valRequireBody"
                            SetFocusOnError="true" ControlToValidate="txtBody" ErrorMessage="The Message is required">*</asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="3"  >
                        <img src="CaptchaPage.aspx" alt="Catcha" /><br />
                        <p>
                            <strong>Enter the code shown above:</strong><br />
                            <asp:TextBox ID="CodeNumberTextBox" runat="server"></asp:TextBox>
                        </p>
                        <p>
                            <em class="notice">(Note: If you cannot read the numbers in the above<br/>
                                image, reload the page to generate a new one.)</em>
                        </p>
                        <p>
                            <asp:Label ID="MessageLabel" runat="server" ForeColor="#CC0000"></asp:Label></p>
                    </td>
                </tr>
                <tr>
                    <td colspan="3" >
                        <asp:Label runat="server" ID="lblFeedbackOK" Text="Your message has been successfully sent."
                            SkinID="FeedbackOK" Visible="false" ForeColor="#006600" Font-Bold="True" />
                        <asp:Label runat="server" ID="lblFeedbackKO" Text="Sorry, there was a problem sending your message."
                            SkinID="FeedbackKO" Visible="false" ForeColor="#CC0000" />
                       
                    </td>
                </tr>
                <tr>
                    <td colspan="3" >
                        
                        <asp:Button runat="server" ID="btnSubmit" Text="Submit" onclick="btnSubmit_Click" />
                        <asp:Button runat="server" ID="btnCancel" Text="Cancel"  onclick="btnCancel_Click" CausesValidation="False" />
                        <asp:ValidationSummary runat="server" ID="ValidationSummary1" ShowSummary="false" ShowMessageBox="true" />
                    </td>
                </tr>
            </table>
>>>>>>> f0c75d0bf41e7aebda560471c02b661c14783a41
        </div>
        <div class="form-group">
            <asp:Label runat="server" ID="lblBody" for="txtBody" Text="Comments:" class="col-sm-2  control-label" />
            <div class="col-sm-10">
                <asp:TextBox runat="server" ID="txtBody" Width="100%" TextMode="MultiLine" Rows="8" class="form-control" />
                <asp:RequiredFieldValidator runat="server" Display="dynamic" ID="valRequireBody" SetFocusOnError="true" ControlToValidate="txtBody" ErrorMessage="The Message is required">*</asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <img src="CaptchaPage.aspx" alt="Catcha" /><br />
                <p>
                    <strong>Enter the code shown above:</strong><br />
                    <asp:TextBox ID="CodeNumberTextBox" runat="server" class="form-control"></asp:TextBox>
                </p>
                <p>
                    <em class="notice">(Note: If you cannot read the numbers in the above<br/>
                    image, reload the page to generate a new one.)</em>
                </p>
                <p>
                    <asp:Label ID="MessageLabel" runat="server" ForeColor="#CC0000"></asp:Label></p>    
                    <asp:Label runat="server" ID="lblFeedbackOK" Text="Your message has been successfully sent." SkinID="FeedbackOK" Visible="false" ForeColor="#006600" Font-Bold="True" />
                    <asp:Label runat="server" ID="lblFeedbackKO" Text="Sorry, there was a problem sending your message." SkinID="FeedbackKO" Visible="false" ForeColor="#CC0000" />
            </div>   
        </div>
 
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
            <asp:Button runat="server" type="submit" ID="btnSubmit" Text="Submit" onclick="btnSubmit_Click" class="btn btn-default "/>
            <asp:Button runat="server" type="cancel" ID="btnCancel" Text="Cancel"  onclick="btnCancel_Click" CausesValidation="False" class="btn btn-default "/>
            <asp:ValidationSummary runat="server" ID="ValidationSummary1" ShowSummary="false" ShowMessageBox="true" />
            </div>
        </div> 
    </form>
<<<<<<< HEAD
</asp:Content>
=======
    <script src="../Scripts/jquery-3.1.1.min.js" ></script>
    <script src="../Scripts/jquery-ui-1.12.1.min.js" ></script>
    <script src="../Scripts/bootstrap.min.js" ></script>
    <script src="../Scripts/Site.js" ></script>
</body>
</html>
>>>>>>> f0c75d0bf41e7aebda560471c02b661c14783a41
