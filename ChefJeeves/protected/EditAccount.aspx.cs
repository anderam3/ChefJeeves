using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace ChefJeeves
{
	public partial class EditAccount : System.Web.UI.Page
    {
        private MySqlConnection con;
        private MySqlCommand cmd;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null || Session["isSuccessful"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            imgProfile.ImageUrl = "../Images/Profiles/" + Session["username"] + ".jpg";
            //Regex for email addresses
            RegularExpressionValidator2.ValidationExpression = @"(?i)^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|"
                            + @"([-a-z0-9!#$%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)"
                            + @"@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]$";
            //Regex for passwords
            RegularExpressionValidator3.ValidationExpression = @"^(?=.*[a-zA-Z])(?=.*\d)(?=.*(_|[^\w])).{7,12}$";
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            cmd = new MySqlCommand();
            if (!IsPostBack)
            {
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "GetAccount";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
                cmd.Parameters["User"].Value = Session["username"];
                cmd.Parameters["User"].Direction = ParameterDirection.Input;
                cmd.Parameters.Add("Name", MySqlDbType.VarChar, 64);
                cmd.Parameters["Name"].Direction = ParameterDirection.Output;
                cmd.Parameters.Add("Address", MySqlDbType.VarChar, 64);
                cmd.Parameters["Address"].Direction = ParameterDirection.Output;
                cmd.Parameters.Add("Question", MySqlDbType.VarChar, 64);
                cmd.Parameters["Question"].Direction = ParameterDirection.Output;
                using (con)
                {
                    try
                    {
                        con.Open();
                        cmd.ExecuteReader();
                        lblUserName.Text = "Edit Account: " + Session["username"].ToString();
                        txtEmail.Text = cmd.Parameters["Address"].Value.ToString();
                        txtName.Text = cmd.Parameters["Name"].Value.ToString();
                        txtSecurityQuestion.Text = cmd.Parameters["Question"].Value.ToString();
                        con.Close();
                    }
                    catch (Exception ex)
                    {
                    }
                }
            }
        }

        protected void emailExists(object sender, ServerValidateEventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "EmailExists";
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"].ToString();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Address", MySqlDbType.VarChar, 64);
            cmd.Parameters["Address"].Value = txtEmail.Text.Trim();
            cmd.Parameters["Address"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Result", MySqlDbType.Int64, 1);
            cmd.Parameters["Result"].Direction = ParameterDirection.Output;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteScalar();
                    if (Int64.Parse(cmd.Parameters["Result"].Value.ToString()) == 1)
                    {
                        e.IsValid = false;
                    }
                    else
                    {
                        e.IsValid = true;
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void verifySecurityAnswer(object sender, ServerValidateEventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "VerifySecurityAnswer";
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"].ToString();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Answer", MySqlDbType.VarChar, 512);
            cmd.Parameters["Answer"].Value = txtCurrentSecurityAnswer.Text;
            cmd.Parameters["Answer"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("IsSuccessful", MySqlDbType.Int64, 1);
            cmd.Parameters["IsSuccessful"].Direction = ParameterDirection.Output;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteScalar();
                    if (Int64.Parse(cmd.Parameters["IsSuccessful"].Value.ToString()) == 1)
                    {
                        e.IsValid = true;
                    }
                    else
                    {
                        e.IsValid = false;
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void verifyPassword(object sender, ServerValidateEventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "VerifyPassword";
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"].ToString();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Pass", MySqlDbType.VarChar, 512);
            cmd.Parameters["Pass"].Value = txtCurrentPassword.Text;
            cmd.Parameters["Pass"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("IsSuccessful", MySqlDbType.Int64, 1);
            cmd.Parameters["IsSuccessful"].Direction = ParameterDirection.Output;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteScalar();
                    if (Int64.Parse(cmd.Parameters["IsSuccessful"].Value.ToString()) == 1)
                    {
                        e.IsValid = true;
                    }
                    else
                    {
                        e.IsValid = false;
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                cmd = new MySqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "UpdateAccount";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
                cmd.Parameters["User"].Value = Session["username"].ToString();
                cmd.Parameters.Add("Name", MySqlDbType.VarChar, 64);
                cmd.Parameters["Name"].Value = txtName.Text.Trim();
                cmd.Parameters.Add("Address", MySqlDbType.VarChar, 64);
                cmd.Parameters["Address"].Value = txtEmail.Text.Trim();
                cmd.Parameters.Add("Question", MySqlDbType.VarChar, 64);
                cmd.Parameters["Question"].Value = txtSecurityQuestion.Text.Trim();
                cmd.Parameters.Add("Answer", MySqlDbType.VarChar, 512);
                cmd.Parameters["Answer"].Value = txtNewSecurityAnswer.Text.Trim();
                cmd.Parameters.Add("Pass", MySqlDbType.VarChar, 512);
                cmd.Parameters["Pass"].Value = txtNewPassword.Text.Trim();
                using (con)
                {
                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        Response.Redirect("~/protected/SuggestedRecipes.aspx");
                    }
                    catch (Exception ex)
                    {
                    }
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.RawUrl);
        }
    }
}