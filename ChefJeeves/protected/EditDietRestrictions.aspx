<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditDietRestrictions.aspx.cs" Inherits="ChefJeeves.EditDietRestrictions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Edit Diet Restrictions</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Edit Diet Restrictions</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form runat="server" class="dietTable">
        <asp:TextBox ID="txtSearch" runat="server" CausesValidation="false"></asp:TextBox>
        <asp:LinkButton ID="lnkClear" runat="server"  CssClass="glyphicon glyphicon-remove" OnClick="lnkClear_Click" />
        <asp:LinkButton ID="lnkSearch" runat="server"  CssClass="glyphicon glyphicon-search" OnClick="lnkSearch_Click" />
        <asp:LinkButton ID="lnkAdd" runat="server"  CssClass="glyphicon glyphicon-plus-sign" OnClick="lnkAdd_Click" />
        <br/>
        <asp:Image ID="imgAddDietRestriction" CssClass="round" runat="server" visible="false"/>
        <asp:TextBox ID="txtAddDietRestriction" runat="server" CausesValidation="false" visible="false"></asp:TextBox>
        <asp:LinkButton ID="lnkSaveDietRestriction" runat="server"  CssClass="glyphicon glyphicon-floppy-disk" OnClick="lnkSave_Click" visible="false"/>
        <asp:Label ID="lblError" Visible="false" runat="server" ForeColor="Red" Text="That diet restriction doesn't exist."></asp:Label>
        <asp:HiddenField ID="hfDietRestrictionID" runat="server" />
        <asp:GridView ID="grd" runat="server">
            <Columns>  
                <asp:TemplateField HeaderText="IMAGE" ShowHeader="false">
                    <ItemTemplate>
                        <asp:Image CssClass="roundDietRestriction" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>  
            <EmptyDataTemplate>No Diet Restrictions</EmptyDataTemplate> 
        </asp:GridView>
    </form>
 </asp:Content>
