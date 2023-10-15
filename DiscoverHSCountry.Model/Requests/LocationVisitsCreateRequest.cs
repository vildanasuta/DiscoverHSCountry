using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class LocationVisitsCreateRequest
    {
        public int LocationId { get; set; }

        public int TouristId { get; set; }
        public int NumberOfVisits { get; set; } = 0;
    }
}
