<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewRecipe.aspx.cs" Inherits="ChefJeeves.ViewRecipe" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">
    <asp:Literal runat="server" ID="ltlTitle"></asp:Literal>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">
    <asp:Label runat="server" ID="lblHeading"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <div style="clear:both;">
        <div id="recipeLeft">
            <div class="hex1">
                <div class="hex2">
                    <div class="hex3">
                        <asp:Panel ID="panel" runat="server" />
                        <!--<asp:Image ID="Image1" runat="server" ImageUrl="../Images/Recipes/" />-->
                    </div>
                </div>
            </div>
            
        </div>
        <div id="recipeRight">
            <div>
                <h2>
                    <asp:Label runat="server" ID="Label1"></asp:Label>
                </h2>
            </div>
            <div>
                <h3>Ingredients</h3>
            </div>
            <form id="frm" class="viewRecipeTable" runat="server">
            <asp:GridView ID="grd" runat="server" DataSourceID="SqlDataSource"></asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:cnn %>" ProviderName="<%$ ConnectionStrings:cnn.ProviderName %>" SelectCommand="GetRecipeDetails" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:SessionParameter Name="ID" SessionField="recipeID" Type="Int64" />
                    </SelectParameters>
                </asp:SqlDataSource>

            <h3>Directions:</h3>
            <div>
                <asp:Literal runat="server" ID="ltlDirections"></asp:Literal>
            </div>
             </form>
        </div>
        
    </div>
    

</asp:Content>
