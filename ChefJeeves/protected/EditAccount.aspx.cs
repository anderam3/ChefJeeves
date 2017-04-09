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
            //Regex for email addresses
            RegularExpressionValidator2.ValidationExpression = @"(?i)^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|"
                            + @"([-a-z0-9!#$%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)"
                            + @"@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]$";
            //Regex for passwords
            RegularExpressionValidator3.ValidationExpression = @"^(?=.*[a-zA-Z])(?=.*\d)(?=.*(_|[^\w])).{7,12}$";
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            
        }

        protected void hasImage(object sender, ServerValidateEventArgs e)
        {
            e.IsValid = fileUpload.HasFile;
        }

        private void GetUserInfo()
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetAccountInfo";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();

                    txtUserName.Text = (string)(Session["username"]);
                    txtEmail.Text = (string)(Session["email"]);
                    txtName.Text = (string)(Session["name"]);
                    txtSecurityQuestion.Text = (string)(Session[" "]);
                    txtSecurityAnswer.Text = (string)(Session["username"]);
                    txtConfirmSecurityAnswer.Text = (string)(Session["username"]);
                    txtPassword.Text = (string)(Session["username"]);
                    txtConfirmPassword.Text = (string)(Session["username"]);

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

        protected void usernameExists(object sender, ServerValidateEventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "UsernameExists";
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = txtUserName.Text.Trim();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
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

        protected void emailExists(object sender, ServerValidateEventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "EmailExists";
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

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                cmd = new MySqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "InsertUser";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
                cmd.Parameters["User"].Value = txtUserName.Text.Trim();
                fileUpload.PostedFile.SaveAs(Server.MapPath("~/Images/Profiles/" + txtUserName.Text.Trim()) + ".jpg");
                cmd.Parameters.Add("Address", MySqlDbType.VarChar, 64);
                cmd.Parameters["Address"].Value = txtEmail.Text.Trim();
                cmd.Parameters.Add("FullName", MySqlDbType.VarChar, 64);
                cmd.Parameters["FullName"].Value = txtName.Text.Trim();
                cmd.Parameters.Add("Pass", MySqlDbType.VarChar, 512);
                cmd.Parameters["Pass"].Value = txtPassword.Text.Trim();
                cmd.Parameters.Add("Question", MySqlDbType.VarChar, 64);
                cmd.Parameters["Question"].Value = txtSecurityQuestion.Text.Trim();
                cmd.Parameters.Add("Answer", MySqlDbType.VarChar, 512);
                cmd.Parameters["Answer"].Value = txtSecurityAnswer.Text.Trim();
                using (con)
                {
                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        Session["username"] = txtUserName.Text.Trim();
                        Session["isSuccessful"] = true;
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

            Response.Redirect("~/protected/EditAccount.aspx");
            
        }
    }
}