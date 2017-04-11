<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AddNewIngredient.aspx.cs" Inherits="ChefJeeves.AddNewIngredient" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Add New Ingredient</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Add New Ingredient</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form runat="server"  >
        
        <asp:FileUpload ID="fileUpload" runat="server" />
        <asp:CustomValidator runat="server" ID="CustomValidator1" OnServerValidate="hasImage" ErrorMessage="The ingredient must have an image" ForeColor="DarkRed"></asp:CustomValidator>
        <asp:TextBox ID="txtAddIng" runat="server"   ></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="txtAddIng" ErrorMessage="Can't be empty" 
                    Display="Dynamic" ForeColor="DarkRed"></asp:RequiredFieldValidator>
        <asp:LinkButton ID="lnkSave" runat="server"  CssClass="glyphicon glyphicon-floppy-disk" OnClick="lnkSave_Click"/>
        <asp:LinkButton ID="lnkCancel" runat="server"  CssClass="glyphicon glyphicon-remove" OnClick="lnkCancel_Click" CausesValidation="false"/>
        <asp:Label runat="server" ID="lblFeedback" Text="Ingredient already exists in the database." SkinID="Feedback" Visible="false" ForeColor="#CC0000" />
    </form>
</asp:Content>
