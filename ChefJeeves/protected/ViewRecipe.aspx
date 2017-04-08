<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewRecipe.aspx.cs" Inherits="ChefJeeves.ViewRecipe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">
    <asp:Literal runat="server" ID="ltlTitle"></asp:Literal>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">
    <asp:Image ID="imgRecipe" CssClass="round" runat="server" ImageUrl="../Images/Recipes/" />
    <asp:Label runat="server" ID="lblHeading"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <style>th {display:initial}</style>
    <form id="frm" runat="server">
    <asp:GridView ID="grd" runat="server" DataSourceID="SqlDataSource"></asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:cnn %>" ProviderName="<%$ ConnectionStrings:cnn.ProviderName %>" SelectCommand="GetRecipeDetails" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:SessionParameter Name="ID" SessionField="recipeID" Type="Int64" />
            </SelectParameters>
        </asp:SqlDataSource>
    <h3>Directions:</h3>
    <asp:Literal runat="server" ID="ltlDirections"></asp:Literal>
    <h3>Submitted by user: <asp:Label ID="lblUser" runat="server"></asp:Label></h3>
    </form>
</asp:Content>
