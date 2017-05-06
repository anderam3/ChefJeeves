<%@ Page Title="" EnableEventValidation="False" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IngredientInventory.aspx.cs" Inherits="ChefJeeves.IngredientInventory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Ingredient Inventory</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Ingredient Inventory</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form runat="server" class="ingInvTable">
        <asp:TextBox ID="txtSearch" runat="server" CausesValidation="false"></asp:TextBox>
        <asp:LinkButton ID="lnkClear" runat="server"  CssClass="glyphicon glyphicon-remove" OnClick="lnkClear_Click" />
        <asp:LinkButton ID="lnkSearch" runat="server"  CssClass="glyphicon glyphicon-search" OnClick="lnkSearch_Click" />
        <asp:LinkButton ID="lnkAdd" runat="server"  CssClass="glyphicon glyphicon-plus-sign" OnClick="lnkAdd_Click" />
        <br/>
        <asp:Image ID="imgAddIngredient" CssClass="round" runat="server" visible="false"/>
        <asp:TextBox ID="txtAddIngredient" runat="server" CausesValidation="false" visible="false"></asp:TextBox>
        <asp:LinkButton ID="lnkSaveIngredient" runat="server"  CssClass="glyphicon glyphicon-floppy-disk" OnClick="lnkSave_Click" visible="false"/>
        <asp:Label ID="lblError" Visible="false" runat="server" ForeColor="Red" Text="That ingredient is not selected, is within your diet restriction category, or does not exist. You can expand our ingredient database by clicking ">
               <asp:HyperLink id="lnkAddNewIngredient"  NavigateUrl="AddNewIngredient.aspx" Text="here" runat="server"/>
        </asp:Label>
        <asp:HiddenField ID="hfIngredientID" runat="server" />
        <asp:GridView ID="grd" runat="server" OnRowDataBound="OnRowDataBound" OnSelectedIndexChanged="OnSelectedIndexChanged">
            <Columns>  
                <asp:TemplateField HeaderText="IMAGE" ShowHeader="false">
                    <ItemTemplate>
                        <asp:Image CssClass="roundIngInv" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>  
            <EmptyDataTemplate>No Ingredients in Inventory</EmptyDataTemplate> 
        </asp:GridView>
    </form>
 </asp:Content>
