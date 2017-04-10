<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IngredientInventory.aspx.cs" Inherits="ChefJeeves.IngredientInventory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Ingredient Inventory</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Ingredient Inventory</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
     
    <form runat="server">
    <asp:TextBox ID="txtSearch" runat="server" CausesValidation="false"></asp:TextBox>
    <asp:LinkButton ID="lnkClear" runat="server"  CssClass="glyphicon glyphicon-remove" OnClick="lnkClear_Click" />
    <asp:LinkButton ID="lnkSearch" runat="server"  CssClass="glyphicon glyphicon-search" OnClick="lnkSearch_Click" />
    <asp:LinkButton ID="lnkAdd" runat="server" CssClass="glyphicon glyphicon-plus-sign" OnClick="lnkAdd_Click"/>
    <br/>
    <asp:Image ID="imgAddIng" CssClass="round" runat="server" visible="false"/>
    <asp:TextBox ID="txtAddIng" runat="server" CausesValidation="false" visible="false" ></asp:TextBox>
    <asp:LinkButton ID="lnkSave" runat="server"  CssClass="glyphicon glyphicon-floppy-disk" OnClick="lnkSave_Click" visible="false"/>
    <asp:LinkButton ID="lnkCancel" runat="server"  CssClass="glyphicon glyphicon-remove" OnClick="lnkCancel_Click" visible="false"/>
    <asp:HiddenField ID="hfingredientId" runat="server" />
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
    </form>
   
 </asp:Content>
