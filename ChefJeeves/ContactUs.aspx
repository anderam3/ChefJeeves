<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="ChefJeeves.ContactUs" %>
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
</asp:Content>
