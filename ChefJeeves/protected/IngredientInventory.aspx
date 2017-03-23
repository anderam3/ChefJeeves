<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IngredientInventory.aspx.cs" Inherits="ChefJeeves.IngredientInventory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Ingredeint Inventory</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Ingredient Inventory</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <span id="username" runat="server" style='display:none;'><%: Session["username"] %></span>
    <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
    <asp:GridView ID="grid" runat="server" DataSourceID="SqlDataSource" AutoGenerateColumns="False" ShowHeaderWhenEmpty="True" DataKeyNames="ID">  
        <Columns>
            <asp:TemplateField HeaderText="ADD" ShowHeader="false">
                <HeaderStyle HorizontalAlign="Right" /><HeaderTemplate>
                <asp:Button ID="btnAdd" runat="server" CssClass="glyphicon glyphicon-plus" />
            </HeaderTemplate>   
            </asp:TemplateField>
            <asp:TemplateField HeaderText="IMAGE" ShowHeader="false">
                <ItemTemplate>
                    <asp:ImageButton CssClass="round" runat="server" ImageUrl="../Images/Ingredients/" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="NAME" HeaderText="NAME" SortExpression="NAME" ShowHeader="false"/>  
            <asp:TemplateField HeaderText="TRASH" ShowHeader="false">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CssClass="glyphicon glyphicon-trash"></asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>  
        <EmptyDataTemplate>No Record Available</EmptyDataTemplate>  
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:cnn %>" ProviderName="<%$ ConnectionStrings:cnn.ProviderName %>" ></asp:SqlDataSource>
</asp:Content>
