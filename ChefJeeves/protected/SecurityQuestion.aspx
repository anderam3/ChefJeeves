<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SecurityQuestion.aspx.cs" Inherits="ChefJeeves.SecurityQuestion" %>
<asp:Content ID="Content4" ContentPlaceHolderID="title" runat="server">Security Question</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="heading" runat="server">Answer Security Question</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="content" runat="server">
    <form runat="server">
        <asp:Label ID="lblSecurityQuestion" runat="server" Text="Security Question:"></asp:Label>
        <br />
        <asp:Label ID="lblSecurityAnswer" runat="server" Text="Security Answer:"></asp:Label>
        <asp:TextBox ID="txtSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
            ControlToValidate="txtSecurityAnswer" ErrorMessage="Can't be empty" 
            Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
        <br />
        <asp:Label ID="lblConfirmSecurityAnswer" runat="server" Text="Confirm Security Answer:" ></asp:Label>
        <asp:TextBox ID="txtConfirmSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox>
        <asp:CompareValidator ID="CompareValidator1" runat="server" 
            ControlToCompare="txtSecurityAnswer" ControlToValidate="txtConfirmSecurityAnswer" 
            ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
        <br />
        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn btn-default"/>
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnReset_Click" CssClass="btn btn-default"/>
        <br />
        <asp:Label ID="lblError" runat="server" ForeColor="DarkRed"></asp:Label>
    </form>
</asp:Content>