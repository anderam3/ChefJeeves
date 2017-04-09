using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing.Imaging;

namespace ChefJeeves
{
    public partial class CaptchaPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CaptchaImage ci = new CaptchaImage(this.Session["CaptchaImageText"].ToString(), 200, 50, "Arial Black");

            // Change the response headers to output a JPEG image.
            this.Response.Clear();
            this.Response.ContentType = "image/jpeg";

            // Write the image to the response stream in JPEG format.
            ci.Image.Save(this.Response.OutputStream, ImageFormat.Jpeg);

            // Dispose of the CAPTCHA image object.
            ci.Dispose();

        }
    }
}