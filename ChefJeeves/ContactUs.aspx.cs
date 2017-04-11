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
            RegularExpressionValidator2.ValidationExpression = @"(?i)^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|"
                            + @"([-a-z0-9!#$%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)"
                            + @"@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]$";
            if (!IsPostBack)
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
            if (Page.IsValid)
            {
                MailMessage Message = new MailMessage();
                //Sender e-mail address.
                Message.From = new MailAddress(txtEmail.Text);
                //Recipient e-mail address.
                Message.To.Add("chefjeeves@gmail.com");
                Message.Subject = "Auto: Chef Jeeves Contact";
                Message.Body = txtEmail.Text + " said:  " + txtBody.Text;
                Message.IsBodyHtml = true;
                try
                {
                    if (this.txtCodeNumber.Text == this.Session["CaptchaImageText"].ToString())
                    {
                        lblMessage.Text = String.Empty;
                        SmtpClient mailClient = new SmtpClient();
                        mailClient.Host = "smtp.gmail.com";
                        mailClient.Port = 587;
                        mailClient.Credentials = new System.Net.NetworkCredential("chefjeeves@gmail.com", "chefjeeves2017");
                        mailClient.EnableSsl = true;
                        mailClient.Send(Message);
                        txtEmail.Text = String.Empty;
                        txtBody.Text = String.Empty;
                        txtCodeNumber.Text = String.Empty;
                        lblFeedbackOK.Visible = true;

                    }
                    else
                    {
                        lblMessage.Text = "Incorrect. Please try again.";
                        txtCodeNumber.Text = String.Empty;
                        lblFeedbackOK.Visible = false;
                        this.Session["CaptchaImageText"] = GenerateRandomCode();
                    }

                }
                catch (Exception ex)
                {
                    lblFeedbackKO.Visible = true;
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Request.RawUrl);
        }
    }
}