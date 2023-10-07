using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class ReservationCreateRequest
    {
        public int? TouristId { get; set; }

        public int? LocationId { get; set; }

        public decimal Price { get; set; }
    }
}
