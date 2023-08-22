using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class PasswordUpdateRequest
    {
        public String Password { get; set; }
        public String OldPassword { get; set; }
    }
}
