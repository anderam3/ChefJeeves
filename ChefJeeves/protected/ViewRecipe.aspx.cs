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
    protected void Page_Load(object sender, EventArgs e)
    {
            if (Session["username"] == null || Session["isSuccessful"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            else
            {
                
                String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
                MySqlConnection con = new MySqlConnection(con_string);
                MySqlCommand cmd = new MySqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "GetRecipeDetails";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("RecipeID", MySqlDbType.Int64, 11);
                cmd.Parameters["RecipeID"].Value = Session["recipeID"];
                cmd.Parameters["RecipeID"].Direction = ParameterDirection.Input;
                cmd.Parameters.Add("RecipeName", MySqlDbType.VarChar, 512);
                cmd.Parameters["RecipeName"].Direction = ParameterDirection.Output;
                cmd.Parameters.Add("Preparations", MySqlDbType.VarChar, 512);
                cmd.Parameters["Preparations"].Direction = ParameterDirection.Output;

                using (con)
                {
                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                        myheading.InnerHtml = cmd.Parameters["RecipeName"].Value.ToString();

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