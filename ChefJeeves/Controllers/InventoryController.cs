using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Security;

namespace ChefJeeves.Controllers
{
    public class InventoryController: Controller
    {
        private MySqlConnection con;
        private MySqlCommand cmd;

        public ActionResult Index()
        {
            return View();
        }
          
    }
}