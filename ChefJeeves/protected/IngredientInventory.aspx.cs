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
                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
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

        protected void lnkAdd_Click(object sender, EventArgs e)
        {
            imgAddIngredient.ImageUrl = String.Empty;
            txtAddIngredient.Text = String.Empty;
            if (imgAddIngredient.Visible == false)
            {
                imgAddIngredient.Visible = true;
                txtAddIngredient.Visible = true;
                lnkSaveIngredient.Visible = true;
                lnkAdd.CssClass = "glyphicon glyphicon-minus-sign";
            }
            else
            {
                imgAddIngredient.Visible = false;
                txtAddIngredient.Visible = false;
                lnkSaveIngredient.Visible = false;
                lnkAdd.CssClass = "glyphicon glyphicon-plus-sign";
            }
            
        }

        protected void lnkSave_Click(object sender, EventArgs e)
        {
            string ingredientId = Request.Form[hfIngredientID.UniqueID];
            int parsedID = 0;
            if (Int32.TryParse(ingredientId, out parsedID))
            {
                String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
                MySqlConnection con = new MySqlConnection(con_string);
                MySqlCommand cmd = new MySqlCommand();
                cmd = new MySqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "AddIngredient";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
                cmd.Parameters["User"].Value = Session["username"];
                cmd.Parameters["User"].Direction = ParameterDirection.Input;
                cmd.Parameters.Add("ID", MySqlDbType.Int64, 11);
                cmd.Parameters["ID"].Value = parsedID;
                cmd.Parameters["ID"].Direction = ParameterDirection.Input;
                cmd.Parameters.Add("isSuccessful", MySqlDbType.Int64, 1);
                cmd.Parameters["isSuccessful"].Direction = ParameterDirection.Output;
                using (con)
                {
                    try
                    {
                        con.Open();
                        cmd.ExecuteScalar();
                        if (Int64.Parse(cmd.Parameters["isSuccessful"].Value.ToString()) == 1)
                        {
                            lblError.Visible = false;
                            Response.Redirect(Request.RawUrl);
                        }
                        else
                        {
                            lblError.Visible = true;
                            con.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                    }
                }
            }
            else{
                lblError.Visible = true;
            }
        }

        [WebMethod]
        public static string[] GetIngredients(string ingredient)
        {
            List<string> ingredients = new List<string>();
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetNonAccountIngredients";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = HttpContext.Current.Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Ingredient", MySqlDbType.VarChar, 64);
            cmd.Parameters["Ingredient"].Value = ingredient;
            cmd.Parameters["Ingredient"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    MySqlDataReader rd = cmd.ExecuteReader();
                    while (rd.Read())
                    {
                        ingredients.Add(string.Format("{0}-{1}", rd["Name"], rd["ID"]));
                    }
                    con.Close();
                }
                catch (Exception ex)
                { 
                }
              
            }
            return ingredients.ToArray();
        }
    }
}