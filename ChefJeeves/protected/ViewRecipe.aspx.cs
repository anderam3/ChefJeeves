using MySql.Data.MySqlClient;
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
	public partial class ViewRecipe : System.Web.UI.Page
    {
        private MySqlConnection con;
        private MySqlCommand cmd;

        protected void Page_Load(object sender, EventArgs e)
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            cmd = new MySqlCommand();
            if (Session["username"] == null || Session["isSuccessful"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            else if (Session["recipeID"] == null)
            {
                Response.Redirect("~/protected/SuggestedRecipes.aspx");
            }
            else
            {
                imgRecipe.ImageUrl = "../Images/Recipes/" + Session["recipeID"] + ".jpg";
                Image1.ImageUrl = "../Images/Recipes/" + Session["recipeID"] + ".jpg";
                foreach (GridViewRow row in grd.Rows)
                {
                    
                        
                   /* row.Cells[0].Controls.Add(new Image {
                            ImageUrl = "../Images/Ingredients/" + row.Cells[0].Text + ".jpg",
                            CssClass = "round"
                        }
                    );*/
                    row.Cells[3].ToolTip = row.Cells[4].Text;
                    
                    row.Cells[4].Visible = false;
                }

                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "GetRecipe";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("ID", MySqlDbType.Int64, 11);
                cmd.Parameters["ID"].Value = Session["recipeID"];
                cmd.Parameters["ID"].Direction = ParameterDirection.Input;
                cmd.Parameters.Add("Name", MySqlDbType.VarChar, 64);
                cmd.Parameters["Name"].Direction = ParameterDirection.Output;
                cmd.Parameters.Add("Prep", MySqlDbType.Text);
                cmd.Parameters["Prep"].Direction = ParameterDirection.Output;
                using (con)
                {
                    try
                    {
                        con.Open();
                        cmd.ExecuteScalar();
                        ltlTitle.Text = cmd.Parameters["Name"].Value.ToString();
                        lblHeading.Text = cmd.Parameters["Name"].Value.ToString();
                        ltlDirections.Text = cmd.Parameters["Prep"].Value.ToString();
                        con.Close();
                        con.Dispose();
                    }
                    catch (Exception ex)
                    {
                        con.Close();
                        con.Dispose();
                    }
                }
            }
        }
    }
}