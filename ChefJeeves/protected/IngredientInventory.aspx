<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IngredientInventory.aspx.cs" Inherits="ChefJeeves.IngredientInventory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Ingredient Inventory</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Ingredient Inventory</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <asp:TextBox ID="txtSearch" runat="server" ></asp:TextBox>
    <asp:LinkButton ID="lnkSearch" runat="server"  CssClass="glyphicon glyphicon-search" OnClick="lnkSearch_Click" />
    <asp:LinkButton ID="lnkAdd" runat="server" CssClass="glyphicon glyphicon-plus-sign" />
    <asp:GridView ID="grd" runat="server">
        <Columns>  
            <asp:TemplateField HeaderText="IMAGE" ShowHeader="false">
                <ItemTemplate>
                    <asp:Image CssClass="round" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>  
        <EmptyDataTemplate>No Ingredients in Inventory</EmptyDataTemplate> 
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource" runat="server"></asp:SqlDataSource>
    </asp:Content>
