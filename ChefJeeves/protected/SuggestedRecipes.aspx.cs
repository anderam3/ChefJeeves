﻿using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChefJeeves
{
    public partial class SuggestedRecipes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null || Session["isSuccessful"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetRecipes";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Recipe", MySqlDbType.VarChar, 64);
            cmd.Parameters["Recipe"].Value = txtSearch.Text.Trim();
            cmd.Parameters["Recipe"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    grd.EmptyDataText = "You cannot make any Recipes based off your current Ingredient Inventory";
                    grd.DataSource = cmd.ExecuteReader();
                    grd.DataBind();
                    Image img = new Image();
                    foreach (GridViewRow row in grd.Rows)
                    {
                        img = (Image)row.Cells[0].Controls[1];
                        img.ImageUrl = "../Images/Recipes/" + row.Cells[2].Text + ".jpg";
                        row.Cells[2].Visible = false;
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["style"] = "cursor:pointer;";
                e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink(grd, "Select$" + e.Row.RowIndex);
                e.Row.ToolTip = "Click to view this recipe.";
            }
        }

        protected void OnSelectedIndexChanged(object sender, EventArgs e)
        {
            foreach (GridViewRow row in grd.Rows)
            {
                if (row.RowIndex == grd.SelectedIndex)
                {
                    Session["recipeID"] = row.Cells[2].Text;
                    Response.Redirect("~/protected/ViewRecipe.aspx");
                }
            }
        }

        protected void lnkClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = String.Empty;
        }

        protected void lnkSearch_Click(object sender, EventArgs e)
        {
            txtSearch.AutoPostBack = true;
            txtSearch.AutoPostBack = false;
        }
    }
}