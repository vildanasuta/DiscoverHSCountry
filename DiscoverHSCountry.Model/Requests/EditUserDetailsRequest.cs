using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class EditUserDetailsRequest
    { 
            public string Email { get; set; }

            public string FirstName { get; set; }

            public string LastName { get; set; }

            public string? ProfileImage { get; set; } 
        
    }
}
