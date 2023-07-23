using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class LocationTouristAttractionOwnerUpdateRequest
    {
        public int? TouristAttractionOwnerId { get; set; }

        public int? LocationId { get; set; }
    }
}
