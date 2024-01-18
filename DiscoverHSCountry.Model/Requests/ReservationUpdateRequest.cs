using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class ReservationUpdateRequest
    {
        public int? TouristId { get; set; }

        public int? LocationId { get; set; }

        public decimal Price { get; set; }
        public bool IsPaid { get; set; } = false;
        public bool IsConfirmed { get; set; } = false;
    }
}
