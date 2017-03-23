using MySql.Data.MySqlClient;
using System;
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
            SqlDataSource.SelectCommand = "SELECT Ingredient_Name FROM AccountIngredient WHERE username ='" + Session["username"] + "'";
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetIngredient";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"].ToString();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Name", MySqlDbType.VarChar, 64);
            cmd.Parameters["Name"].Direction = ParameterDirection.Output;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteScalar();
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                }
            }
        }

        [WebMethod]
        public static void DeleteIngredient(string username, string ingredient_name)
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "DeleteIngredient";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = ingredient_name;
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Name", MySqlDbType.VarChar, 64);
            cmd.Parameters["Name"].Value = username;
            cmd.Parameters["Name"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteScalar();
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                }
            }
        }
    }
}