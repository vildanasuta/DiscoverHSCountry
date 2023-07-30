using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class ReservationCreateRequest
    {
        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public int NumberOfPeople { get; set; }

        public string? AdditionalDescription { get; set; }

        public int? TouristId { get; set; }

        public int? ServiceId { get; set; }

        public int? LocationId { get; set; }

        public decimal Price { get; set; }
    }
}
