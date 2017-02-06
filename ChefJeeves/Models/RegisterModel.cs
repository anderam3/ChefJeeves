using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Configuration;
using System.Web.Http;

namespace ChefJeeves.Models
{
    public class RegisterModel
    {
        [Required]
        [Display(Name = "First Name")]
        public string FirstName { get; set; }

        [Required]
        [Display(Name = "Last Name")]
        public string LastName { get; set; }

        [Required]
        [Display(Name = "Email Address")]
        public string Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Password")]
        public string Passcode { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [Display(Name = "Retype Password")]
        public string PasscodeRetype { get; set; }

        [Display(Name = "Remember on this computer")]
        public bool RememberMe { get; set; }

        private MySqlConnection con;
        private MySqlCommand cmd;

        public bool IsRegistered(string firstname, string lastname, string email, string password)
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            cmd = new MySqlCommand("INSERT INTO account VALUES('"+ email +"','" + firstname + "','" + lastname + "','" + password + "')", con);
            bool flag = false;
            using (con)
            {
                try
                {
                    con.Open();
                    int rows = cmd.ExecuteNonQuery();
                    int row = rows;
                    if (rows == 1 )
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

