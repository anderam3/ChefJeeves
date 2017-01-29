using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ChefJeeves.Models
{
    class MainPageViewModel
    {
        //this data is from a different table.
        //and goes on the left of the page
        public string Categories { get; set; }
        //this data is also from a different table.
        //and goes on the center of the page
        public List<Products> Products { get; set; }
    }
}