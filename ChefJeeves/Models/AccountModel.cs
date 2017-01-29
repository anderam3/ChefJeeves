using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace ChefJeeves.Models
{
    public class AccountModel
    {
        [Required]
        [Display(Name = "Email Address")]
        public string Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Passcode { get; set; }

        [Display(Name = "Remember on this computer")]
        public bool RememberMe { get; set; }

        private MySqlConnection con;
        private MySqlCommand cmd;
        private MySqlDataReader rdr;

        public bool IsAuthenicated(string email, string password)
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            cmd = new MySqlCommand("SELECT a.email, a.passcode from `account` a WHERE a.email ='" + email + "' and a.passcode = '" + password + "'", con);
            bool flag = false;
            using (con)
            {
                try
                {
                    con.Open();
                    rdr = cmd.ExecuteReader();
                    while (rdr.Read())
                    {
                        flag = true;
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                    con.Close();
                }
            }
            return flag;
        }
    }
}