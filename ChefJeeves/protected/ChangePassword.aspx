<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="ChefJeeves.ChangePassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Change Password</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Change Password</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form runat="server">
        <table>
            <tr>
                <td><asp:Label ID="lblNewPassword" runat="server" Text="New Password:"></asp:Label></td>
                <td><asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                     ControlToValidate="txtNewPassword" ErrorMessage="Can't be empty" 
                     Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                    ControlToValidate="txtNewPassword" ErrorMessage="Must be between 7 and 12 characters, and contains at least 1 special, 1 number, and 1 letter character"
                    ForeColor="DarkRed"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td><asp:Label ID="lblConfirmNewPassword" runat="server" Text="Confirm New Password:" ></asp:Label></td>
                <td><asp:TextBox ID="txtConfirmNewPassword" runat="server" TextMode="Password"></asp:TextBox></td>
                <td><asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ControlToCompare="txtNewPassword" ControlToValidate="txtConfirmNewPassword" 
                    ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator></td>
            </tr>
            <tr>
                <td><asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn btn-info"/></td>
                <td></td>
                <td><asp:Label ID="lblError" runat="server" ForeColor="DarkRed"></asp:Label></td>
            </tr>
        </table>
    </form>
</asp:Content>
