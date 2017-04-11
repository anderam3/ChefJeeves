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
	public partial class AddNewIngredient : System.Web.UI.Page
    {
        private MySqlConnection con;
        private MySqlCommand cmd;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null || Session["isSuccessful"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            con = new MySqlConnection(con_string);
            //cmd = new MySqlCommand();
        }

        protected void lnkSave_Click(object sender, EventArgs e)
        {
            
                cmd = new MySqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "CreateIngredient";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("IngredientName", MySqlDbType.VarChar, 64);
                cmd.Parameters["IngredientName"].Value = txtAddIng.Text.Trim();
                cmd.Parameters.Add("isSuccessful", MySqlDbType.Int64, 1);
                cmd.Parameters["isSuccessful"].Direction = ParameterDirection.Output;
                using (con)
                {
                    try
                    {
                        con.Open();
                        cmd.ExecuteScalar();
                        if ((Int64.Parse(cmd.Parameters["isSuccessful"].Value.ToString())) > 0)
                        {
                            fileUpload.PostedFile.SaveAs(Server.MapPath("~/Images/Ingredients/" + cmd.Parameters["isSuccessful"].Value.ToString()) + ".jpg");
                            con.Close();
                            Response.Redirect("~/protected/IngredientInventory.aspx");
                        }
                        else
                        {
                            con.Close();
                            lblFeedback.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                }
                }
            
        }

        protected void lnkCancel_Click(object sender, EventArgs e)
        {
            txtAddIng.Text = "";
            fileUpload = new FileUpload();
        }

        protected void hasImage(object sender, ServerValidateEventArgs e)
        {
            e.IsValid = fileUpload.HasFile;
        }
    }
}