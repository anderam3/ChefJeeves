using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.Configuration;
using System.Web.UI.WebControls;

namespace ChefJeeves
{
    public partial class Login : System.Web.UI.Page
    {
        private MySqlConnection con;
        private MySqlCommand cmd;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Abandon();
            }
            SetFocus(lgn.FindControl("UserName"));
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
        }

        protected void lgn_Authenticate(object sender, AuthenticateEventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "VerifyPassword";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = lgn.UserName.Trim();
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Pass", MySqlDbType.VarChar, 512);
            cmd.Parameters["Pass"].Value = lgn.Password.Trim();
            cmd.Parameters["Pass"].Direction = ParameterDirection.Input;
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
                        Session["username"] = lgn.UserName.Trim();
                        con.Close();
                        Response.Redirect("~/protected/SuggestedRecipes.aspx");
                    }
                    else
                    {
                        con.Close();
                    }
                }
                catch (Exception ex)
                {
                    con.Close();
                }
            }
        }

        protected void lgn_LoggedIn(object sender, EventArgs e)
        {
            Response.Redirect("~/protected/SuggestedRecipes.aspx");
        }

        protected void btnCreateAccount_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/CreateAccount.aspx");
        }

        protected void btnForgotPassword_Click(object sender, EventArgs e)
        {
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "UsernameExists";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = lgn.UserName.Trim();
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
                        cmd.CommandText = "GetSecurityQuestion";
                        cmd.Parameters.Clear();
                        cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
                        cmd.Parameters["User"].Value = lgn.UserName.ToString().Trim();
                        cmd.Parameters["User"].Direction = ParameterDirection.Input;
                        cmd.Parameters.Add("Question", MySqlDbType.VarChar, 512);
                        cmd.Parameters["Question"].Direction = ParameterDirection.Output;
                        cmd.ExecuteScalar();

                        Session["username"] = cmd.Parameters["User"].Value.ToString();
                        Session["question"] = cmd.Parameters["Question"].Value.ToString();
                        con.Close();
                        Response.Redirect("~/SecurityQuestion.aspx");
                    }
                    else
                    {
                        lblError.Text = "User does not exist";
                        con.Close();
                    }
                }
                catch (Exception ex)
                {
                    lblError.Text = ex.Message;
                    con.Close();
                }
            }
        }
    }
}
