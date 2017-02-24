using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace ChefJeeves.Models
{
    public class InventoryModel
    { 
        private MySqlConnection con;
        private MySqlCommand cmd;
        private MySqlDataReader rdr;

        public void Delete(string email, string ingredientName)
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            cmd = new MySqlCommand("DELETE from `useringredient` a WHERE a.email ='" + email + "' and a.ingredient_name = '" + ingredientName + "'", con);
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                }
            }
        }

        public void Refresh()
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            cmd = new MySqlCommand("SELECT ingredient_name from `ingredient`", con);
            using (con)
            {
                try
                {
                    con.Open();
                    rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        rdr["INGREDIENT_NAME"].ToString();
                    }
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