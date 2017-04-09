using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChefJeeves
{
    public partial class ContactUs : System.Web.UI.Page
    {
        private Random random = new Random();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                // Create a random code and store it in the Session object.
                this.Session["CaptchaImageText"] = GenerateRandomCode();

            }
        }

        private string GenerateRandomCode()
        {
            string s = "";
            for (int i = 0; i < 6; i++)
                s = String.Concat(s, this.random.Next(10).ToString());
            return s;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            MailMessage Message = new MailMessage();
            //Sender e-mail address.
            Message.From = new MailAddress(txtEmail.Text);
            //Recipient e-mail address.
            Message.To.Add("chefjeeves@gmail.com");

            Message.Body = txtBody.Text;
            Message.Subject = "Contact Us";
            Message.IsBodyHtml = true;
            try
            {
                if (this.CodeNumberTextBox.Text == this.Session["CaptchaImageText"].ToString())
                {
                    this.MessageLabel.Text = "";
                    SmtpClient mailClient = new SmtpClient();
                    mailClient.Host = "smtp.gmail.com";
                    mailClient.Port = 25;
                    mailClient.Credentials = new System.Net.NetworkCredential("chefjeeves@gmail.com", "chefjeeves2017");
                    mailClient.EnableSsl = true;
                    mailClient.Send(Message);
                    lblFeedbackOK.Visible = true;

                }
                else
                {
                    // Display an error message.
                    this.MessageLabel.Text = "ERROR: Incorrect, try again.";
                    // Clear the input and create a new random code.
                    this.CodeNumberTextBox.Text = "";
                    lblFeedbackOK.Visible = false;
                    this.Session["CaptchaImageText"] = GenerateRandomCode();
                }

            }
            catch (Exception ex)
            {
                lblFeedbackKO.Visible = true;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            if (Session["username"] == null || Session["isSuccessful"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            else
            {
                Response.Redirect("~/protected/SuggestedRecipes.aspx");
            }
        }
    }
}