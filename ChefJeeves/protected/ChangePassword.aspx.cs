using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;
using System.Web.Configuration;

namespace ChefJeeves
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        private MySqlConnection con;
        private MySqlCommand cmd;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "UpdatePassword";
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"].ToString();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Pass", MySqlDbType.VarChar, 512);
            cmd.Parameters["Pass"].Value = txtNewPassword.Text.Trim();
            cmd.Parameters["Pass"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Redirect("~/Login.aspx");
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                }
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtNewPassword.Text = String.Empty;
            txtConfirmNewPassword.Text = String.Empty;
        }
    }
}