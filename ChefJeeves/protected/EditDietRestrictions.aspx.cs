using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI.WebControls;

namespace ChefJeeves
{
    public partial class EditDietRestrictions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null || Session["isSuccessful"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetDietRestrictions";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Restriction", MySqlDbType.VarChar, 64);
            cmd.Parameters["Restriction"].Value = txtSearch.Text.Trim();
            cmd.Parameters["Restriction"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    grd.EmptyDataText = "No Diet Restrictions";
                    grd.DataSource = cmd.ExecuteReader();
                    grd.DataBind();
                    BoundField colDelete = new BoundField();
                    grd.Columns.Add(colDelete);
                    Image img = new Image();
                    LinkButton trash = new LinkButton();
                    LinkButton searchable = new LinkButton();
                    foreach (GridViewRow row in grd.Rows)
                    {
                        img = (Image)row.Cells[0].Controls[1];
                        img.ImageUrl = "../Images/DietRestrictions/" + row.Cells[2].Text + ".jpg";
                        trash = new LinkButton();
                        trash.ID = row.Cells[2].Text;
                        trash.CssClass = "glyphicon glyphicon-trash";
                        trash.Command += DeleteDietRestriction;
                        row.Cells[2].Controls.Add(trash);
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void DeleteDietRestriction(object sender, CommandEventArgs e)
        {
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "DeleteDietRestriction";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("ID", MySqlDbType.Int64, 11);
            cmd.Parameters["ID"].Value = (sender as LinkButton).ID;
            cmd.Parameters["ID"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Redirect(Request.RawUrl);
                }
                catch (Exception ex)
                {
                }
            }
        }

        protected void lnkClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = String.Empty;
        }

        protected void lnkSearch_Click(object sender, EventArgs e)
        {
            txtSearch.AutoPostBack = true;
            txtSearch.AutoPostBack = false;
        }

        protected void lnkAdd_Click(object sender, EventArgs e)
        {
            imgAddDietRestriction.ImageUrl = String.Empty;
            txtAddDietRestriction.Text = String.Empty;
            if (imgAddDietRestriction.Visible == false)
            {
                imgAddDietRestriction.Visible = true;
                txtAddDietRestriction.Visible = true;
                lnkSaveDietRestriction.Visible = true;
                lnkAdd.CssClass = "glyphicon glyphicon-minus-sign";
            }
            else
            {
                imgAddDietRestriction.Visible = false;
                txtAddDietRestriction.Visible = false;
                lnkSaveDietRestriction.Visible = false;
                lnkAdd.CssClass = "glyphicon glyphicon-plus-sign";
            }

        }

        protected void lnkSave_Click(object sender, EventArgs e)
        {
            string dietRestrictionId = Request.Form[hfDietRestrictionID.UniqueID];
            int parsedID = 0;
            if (Int32.TryParse(dietRestrictionId, out parsedID))
            {
                String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
                MySqlConnection con = new MySqlConnection(con_string);
                MySqlCommand cmd = new MySqlCommand();
                cmd = new MySqlCommand();
                cmd.Connection = con;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "AddDietRestriction";
                cmd.Parameters.Clear();
                cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
                cmd.Parameters["User"].Value = Session["username"];
                cmd.Parameters["User"].Direction = ParameterDirection.Input;
                cmd.Parameters.Add("ID", MySqlDbType.Int64, 11);
                cmd.Parameters["ID"].Value = parsedID;
                cmd.Parameters["ID"].Direction = ParameterDirection.Input;
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
                            lblError.Visible = false;
                            Response.Redirect(Request.RawUrl);
                        }
                        else
                        {
                            lblError.Visible = true;
                            con.Close();
                        }
                    }
                    catch (Exception ex)
                    {
                    }
                }
            }
            else
            {
                lblError.Visible = true;
            }
        }

        [WebMethod]
        public static string[] GetDietRestrictions(string restriction)
        {
            List<string> restrictions = new List<string>();
            String con_string = WebConfigurationManager.ConnectionStrings["cnn"].ConnectionString;
            MySqlConnection con = new MySqlConnection(con_string);
            MySqlCommand cmd = new MySqlCommand();
            cmd.Connection = con;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = "GetNonDietRestrictions";
            cmd.Parameters.Clear();
            cmd.Parameters.Add("User", MySqlDbType.VarChar, 64);
            cmd.Parameters["User"].Value = HttpContext.Current.Session["username"];
            cmd.Parameters["User"].Direction = ParameterDirection.Input;
            cmd.Parameters.Add("Restriction", MySqlDbType.VarChar, 64);
            cmd.Parameters["Restriction"].Value = restriction;
            cmd.Parameters["Restriction"].Direction = ParameterDirection.Input;
            using (con)
            {
                try
                {
                    con.Open();
                    MySqlDataReader rd = cmd.ExecuteReader();
                    while (rd.Read())
                    {
                        restrictions.Add(string.Format("{0}-{1}", rd["Name"], rd["ID"]));
                    }
                    con.Close();
                }
                catch (Exception ex)
                {
                }

            }
            return restrictions.ToArray();
        }
    }
}