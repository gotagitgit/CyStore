using System;
using System.Collections.Generic;

namespace Store.Web.Models
{
    public class Cart
    {
        public Cart()
        {
        }

        public int Id { get; set; }
        public List<Product> Items { get; set; }
    }
}
