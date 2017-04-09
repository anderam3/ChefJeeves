﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditAccount.aspx.cs" Inherits="ChefJeeves.EditAccount" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Edit Account</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Edit Account</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">


    <form id="form1" runat="server">
    <!--
        <asp:FileUpload ID="fileUpload" runat="server" />
        
        <asp:CustomValidator runat="server" ID="CustomValidator1" 
            OnServerValidate="hasImage"
            ErrorMessage="The profile must have an image" ForeColor="DarkRed"></asp:CustomValidator>
        -->
        <table id="editAccount">
            <tr>
                <td>
                    <asp:Label ID="lblUserName" runat="server" Text="Username:"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtUserName" runat="server" ></asp:TextBox>
                </td>            
                <td>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                        ControlToValidate="txtUserName" ErrorMessage="Can't be empty" 
                        Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>

                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" 
                        ControlToValidate="txtUserName" ErrorMessage="Must be less than 65 alphanumeric characters" 
                        ValidationExpression="^\w{1,64}$" ForeColor="DarkRed"></asp:RegularExpressionValidator>

                    <asp:CustomValidator runat="server" ID="CustomValidator4" OnServerValidate="usernameExists"
                        ErrorMessage="Username already exists. Choose another one." ForeColor="DarkRed"></asp:CustomValidator>


                 <!--   <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="txtUserName" ErrorMessage="Can't be empty" 
                        Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>

                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                        ControlToValidate="txtUserName" ErrorMessage="Must be less than 65 alphanumeric characters" 
                        ValidationExpression="^\w{1,64}$" ForeColor="DarkRed"></asp:RegularExpressionValidator>

                    <asp:CustomValidator runat="server" ID="CustomValidator2" 
                        OnServerValidate="usernameExists"
                        ErrorMessage="Username already exists. Choose another one." ForeColor="DarkRed"></asp:CustomValidator>-->
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
                        ControlToCompare="txtConfirmPassword" ControlToValidate="txtPassword" 
                        ErrorMessage="Must be the same as above" ForeColor="DarkRed"></asp:CompareValidator>
                </td>
            </tr>        
            <tr>
                <td>
                    <asp:Button ID="btnCreate" runat="server" Text="Save Changes" OnClick="btnCreate_Click" CssClass="btn btn-default"/>
                </td>
                <td>
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="btn btn-default"/>
                </td>
            </tr>   
        </table>
    </form>








</asp:Content>