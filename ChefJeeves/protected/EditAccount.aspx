<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditAccount.aspx.cs" Inherits="ChefJeeves.EditAccount" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Edit Account</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">
     <asp:Image ID="imgProfile" CssClass="round" runat="server" ImageUrl="../Images/Profiles/" />
     <asp:Label ID="lblUserName" runat="server" Text="Edit Account:"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form id="form1" runat="server">
        <table id="editAccount">
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
                    <asp:Label ID="lblCurrentSecurityAnswer" runat="server" Text="Current Security Answer:" TextMode="Password"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtCurrentSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox>
                </td>
                <td>
                    <asp:CustomValidator runat="server" ID="CustomValidator2" 
                        OnServerValidate="verifySecurityAnswer"
                        ErrorMessage="Security answer incorrect." ForeColor="DarkRed"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblNewSecurityAnswer" runat="server" Text="New Security Answer:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtNewSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                        ControlToValidate="txtNewSecurityAnswer" ErrorMessage="Can't be empty" 
                        Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
                </td>
            </tr>        
            <tr>
                <td>
                    <asp:Label ID="lblConfirmNewSecurityAnswer" runat="server" Text="Confirm New Security Answer:" ></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtConfirmNewSecurityAnswer" runat="server" TextMode="Password"></asp:TextBox>
                </td>
                <td>
                    <asp:CompareValidator ID="CompareValidator1" runat="server" 
                        ControlToCompare="txtNewSecurityAnswer" ControlToValidate="txtConfirmNewSecurityAnswer" 
                        ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
                </td>
            </tr>        
            <tr>
                <td>
                    <asp:Label ID="lblCurrentPassword" runat="server" Text="Current Password:" TextMode="Password"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password"></asp:TextBox>
                </td>
                <td>
                    <asp:CustomValidator runat="server" ID="CustomValidator1" 
                        OnServerValidate="verifyPassword"
                        ErrorMessage="Password incorrect." ForeColor="DarkRed"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblNewPassword" runat="server" Text="New Password:" TextMode="Password"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"></asp:TextBox>
                </td>
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="txtNewPassword" ErrorMessage="Can't be empty" 
                        Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                        ControlToValidate="txtNewPassword" ErrorMessage="Must be between 7 and 12 characters, and contains at least 1 special, 1 number, and 1 letter character"
                        ForeColor="DarkRed"></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblConfirmNewPassword" runat="server" Text="Confirm New Password:" ></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtConfirmNewPassword" runat="server" TextMode="Password"></asp:TextBox>
                </td>
                <td>
                    <asp:CompareValidator ID="CompareValidator2" runat="server" 
                        ControlToCompare="txtNewPassword" ControlToValidate="txtConfirmNewPassword" 
                        ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
                </td>
            </tr>        
            <tr>
                <td>
                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn btn-default"/>
                </td>
                <td>
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="btn btn-default"/>
                </td>
            </tr>   
        </table>
    </form>
</asp:Content>