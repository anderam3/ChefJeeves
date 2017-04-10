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

        protected void lnkAdd_Click(object sender, EventArgs e)
        {
            if (imgAddIng.Visible == false)
            {
                imgAddIng.Visible = true;
                txtAddIng.Visible = true;
                lnkSave.Visible = true;
                lnkCancel.Visible = true;
                lnkAdd.CssClass = "glyphicon glyphicon-minus-sign";
            }
            else
            {
                imgAddIng.Visible = false;
                txtAddIng.Visible = false;
                lnkSave.Visible = false;
                lnkCancel.Visible = false;
                lnkAdd.CssClass = "glyphicon glyphicon-plus-sign";
            }
            
        }

        protected void lnkCancel_Click(object sender, EventArgs e)
        {
            txtAddIng.Text = String.Empty;
        }

        protected void lnkSave_Click(object sender, EventArgs e)
        {
            //string customerName = Request.Form[txtSearch.UniqueID];
            string ingredientId = Request.Form[hfingredientId.UniqueID];
            //ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Name: " + customerName + "\\nID: " + customerId + "');", true);
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
            cmd.Parameters["ID"].Value = Convert.ToInt64(ingredientId); ;
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

        [WebMethod]
        public static string[] GetIngredients(string prefix)
        {
            prefix = prefix + '%';
            List<string> ingredients = new List<string>();
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection conn = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = conn;
            cmd.CommandText = "select ingredient_name, ingredient_id from ingredient where ingredient_name like @SearchText";
            cmd.Parameters.AddWithValue("@SearchText", prefix);
            using (conn)
            {
                try
                {
                    conn.Open();
                    MySqlDataReader sdr = cmd.ExecuteReader();
                    while (sdr.Read())
                    {
                        ingredients.Add(string.Format("{0}-{1}", sdr["ingredient_name"], sdr["ingredient_id"]));
                    }
                    conn.Close();
                   // Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
                    conn.Close();
                    //return ex.Message();
                }
              
            }
            return ingredients.ToArray();
        }
    }
}