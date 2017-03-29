<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="ChefJeeves.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Change Password</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Change Password</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form runat="server">
        <asp:Label ID="lblNewPassword" runat="server" Text="New Password:"></asp:Label>
        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
            ControlToValidate="txtNewPassword" ErrorMessage="Can't be empty" 
            Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
        <br />
        <asp:Label ID="lblConfirmNewPassword" runat="server" Text="Confirm New Password:" ></asp:Label>
        <asp:TextBox ID="txtConfirmNewPassword" runat="server" TextMode="Password"></asp:TextBox>
        <asp:CompareValidator ID="CompareValidator1" runat="server" 
            ControlToCompare="txtNewPassword" ControlToValidate="txtConfirmNewPassword" 
            ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
        <br />
        <asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn btn-default"/>
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnReset_Click" CssClass="btn btn-default"/>
        <br />
        <asp:Label ID="lblError" runat="server" ForeColor="DarkRed"></asp:Label>
    </form>
</asp:Content>
