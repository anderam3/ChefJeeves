<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SecurityQuestion.aspx.cs" Inherits="ChefJeeves.SecurityQuestion" %>
<asp:Content ID="Content4" ContentPlaceHolderID="title" runat="server">Security Question</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="heading" runat="server">Answer Security Question</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="content" runat="server">
    <form runat="server">
        <table>
            <tr>
                <td>Security Question: </td>
                <td><asp:Label ID="lblSecurityQuestion" runat="server" Text=""></asp:Label></td>
                <td></td>
            </tr>
            <tr>
                <td><asp:Label ID="lblSecurityAnswer" runat="server" Text="Security Answer:"></asp:Label></td>
                <td><asp:TextBox ID="txtSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox></td>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                    ControlToValidate="txtSecurityAnswer" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td><asp:Label ID="lblConfirmSecurityAnswer" runat="server" Text="Confirm Security Answer:"></asp:Label></td>
                <td><asp:TextBox ID="txtConfirmSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox></td>
                <td><asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ControlToCompare="txtSecurityAnswer" ControlToValidate="txtConfirmSecurityAnswer" 
                    ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
                </td>
            </tr>
            <tr>
                <td><asp:Button ID="btnSubmit" runat="server" Text="Submit" OnClick="btnSubmit_Click" CssClass="btn btn-info"/></td>
                <td></td>
                <td><asp:Label ID="lblError" runat="server" ForeColor="DarkRed"></asp:Label></td> 
            </tr>
        </table>
    </form>
</asp:Content>