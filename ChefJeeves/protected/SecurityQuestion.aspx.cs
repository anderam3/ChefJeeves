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
    public partial class SecurityQuestion : System.Web.UI.Page
    {
        private MySqlConnection con;
        private MySqlCommand cmd;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            lblSecurityQuestion.Text = "Security Question: " + Session["question"].ToString();
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "VerifySecurityAnswer";
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"].ToString();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Answer", MySqlDbType.VarChar, 512);
            cmd.Parameters["Answer"].Value = txtSecurityAnswer.Text.Trim();
            cmd.Parameters["Answer"].Direction = ParameterDirection.Input;
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
                        Session["isSuccessful"] = true;
                        con.Close();
                        Response.Redirect("~/protected/ChangePassword.aspx");
                    }
                    else
                    {
                        lblError.Text = "Your answer is incorrect or your account is deactivated";
                        con.Close();
                    }
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                }
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSecurityAnswer.Text = String.Empty;
            txtConfirmSecurityAnswer.Text = String.Empty;
        }
    }
}