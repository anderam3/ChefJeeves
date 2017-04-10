﻿<%@ Page Title="" EnableEventValidation="False" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SuggestedRecipes.aspx.cs" Inherits="ChefJeeves.SuggestedRecipes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="title" runat="server">Suggested Recipes</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="heading" runat="server">Suggested Recipes</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="content" runat="server">
    <form runat="server" class="suggestedRecipeTable">
    <asp:TextBox ID="txtSearch" runat="server" CausesValidation="false"></asp:TextBox>
    <asp:LinkButton ID="lnkClear" runat="server"  CssClass="glyphicon glyphicon-remove" OnClick="lnkClear_Click" />
    <asp:LinkButton ID="lnkSearch" runat="server"  CssClass="glyphicon glyphicon-search" OnClick="lnkSearch_Click" />
    <asp:GridView ID="grd" runat="server" OnRowDataBound="OnRowDataBound" OnSelectedIndexChanged="OnSelectedIndexChanged">
        <Columns>  
            <asp:TemplateField HeaderText="IMAGE" ShowHeader="false">
                <ItemTemplate>
                    <asp:Image CssClass="round" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>  
        <EmptyDataTemplate>You cannot make any Recipes based off your current Ingredient Inventory</EmptyDataTemplate> 
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource" runat="server"></asp:SqlDataSource>
    </form>
 </asp:Content>
