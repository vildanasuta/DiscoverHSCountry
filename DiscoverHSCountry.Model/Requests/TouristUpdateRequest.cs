using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class TouristUpdateRequest
    {
        public DateTime? DateOfBirth { get; set; }

        public int? UserId { get; set; }
        public virtual User? User { get; set; }
        public int? CountryId { get; set; }

    }
}
