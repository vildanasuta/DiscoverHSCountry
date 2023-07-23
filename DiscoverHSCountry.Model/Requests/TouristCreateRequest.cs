using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class TouristCreateRequest
    {
        public string Email { get; set; }

        public string Password { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string? ProfileImage { get; set; } // ProfileImage is nullable
        public DateTime? DateOfBirth { get; set; }
        [JsonIgnore]
        public int? UserId { get; set; }

    }
}
