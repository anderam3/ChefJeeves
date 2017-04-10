using MySql.Data.MySqlClient;
using System;
using System.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChefJeeves
{
	public partial class IngredientInventory : System.Web.UI.Page
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
            cmd.CommandText = "GetAccountIngredients";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Ingredient", MySqlDbType.VarChar, 64);
            cmd.Parameters["Ingredient"].Value = txtSearch.Text.Trim();
            cmd.Parameters["Ingredient"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    grd.EmptyDataText = "No Ingredients in Inventory";
                    grd.DataSource = cmd.ExecuteReader();
                    grd.DataBind();
                    BoundField colDelete = new BoundField();
                    grd.Columns.Add(colDelete);
                    Image img = new Image();
                    LinkButton trash = new LinkButton();
                    foreach (GridViewRow row in grd.Rows)
                    {
                        img = (Image)row.Cells[0].Controls[1];
                        img.ImageUrl = "../Images/Ingredients/" + row.Cells[2].Text + ".jpg";
                        trash = new LinkButton();
                        trash.ID = row.Cells[2].Text;
                        trash.CssClass = "glyphicon glyphicon-trash";
                        trash.Command += DeleteIngredient;
                        row.Cells[2].Controls.Add(trash);
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void DeleteIngredient(object sender, CommandEventArgs e)
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "DeleteIngredient";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("ID", MySqlDbType.Int64, 11);
            cmd.Parameters["ID"].Value = (sender as LinkButton).ID;
            cmd.Parameters["ID"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteScalar();
                    con.Close();
                    Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
                    con.Close();
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