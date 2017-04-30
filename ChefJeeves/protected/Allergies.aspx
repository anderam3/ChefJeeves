<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Allergies.aspx.cs" Inherits="ChefJeeves.Allergies" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Allergies</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Allergies</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form runat="server" class="ingInvTable">
        <asp:TextBox ID="txtSearch" runat="server" CausesValidation="false"></asp:TextBox>
        <asp:LinkButton ID="lnkClear" runat="server"  CssClass="glyphicon glyphicon-remove" OnClick="lnkClear_Click" />
        <asp:LinkButton ID="lnkSearch" runat="server"  CssClass="glyphicon glyphicon-search" OnClick="lnkSearch_Click" />
        <asp:LinkButton ID="lnkAdd" runat="server"  CssClass="glyphicon glyphicon-plus-sign" OnClick="lnkAdd_Click" />
        <br/>
        <asp:Image ID="imgAddAllergen" CssClass="round" runat="server" visible="false"/>
        <asp:TextBox ID="txtAddAllergen" runat="server" CausesValidation="false" visible="false"></asp:TextBox>
        <asp:LinkButton ID="lnkSaveAllergen" runat="server"  CssClass="glyphicon glyphicon-floppy-disk" OnClick="lnkSave_Click" visible="false"/>
        <asp:Label ID="lblError" Visible="false" runat="server" ForeColor="Red" Text="That allergen doesn't exist. Expand our ingredient database by clicking ">
               <asp:HyperLink id="lnkAddNewAllergen"  NavigateUrl="AddNewIngredient.aspx" Text="here" runat="server"/>
        </asp:Label><asp:HiddenField ID="hfAllergenID" runat="server" />
        <asp:GridView ID="grd" runat="server">
            <Columns>  
                <asp:TemplateField HeaderText="IMAGE" ShowHeader="false">
                    <ItemTemplate>
                        <asp:Image CssClass="roundIngInv" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>  
            <EmptyDataTemplate>No Ingredients in Inventory</EmptyDataTemplate></asp:GridView><asp:SqlDataSource ID="SqlDataSource" runat="server"></asp:SqlDataSource>
    </form>
 </asp:Content>
