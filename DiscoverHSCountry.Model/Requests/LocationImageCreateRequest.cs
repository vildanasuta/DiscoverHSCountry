using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class LocationImageCreateRequest
    {
        public int? LocationId { get; set; }

        public string? Image { get; set; }
    }
}
