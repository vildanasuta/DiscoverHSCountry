using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class EventLocationUpdateRequest
    {
        public int EventId { get; set; }

        public int? LocationId { get; set; } 
    }
}
