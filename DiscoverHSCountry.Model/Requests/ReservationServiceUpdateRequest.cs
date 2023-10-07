using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class ReservationServiceUpdateRequest
    {
        public int ReservationServiceId { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public int NumberOfPeople { get; set; }

        public string? AdditionalDescription { get; set; }

        public int ReservationId { get; set; }

        public int ServiceId { get; set; }

    }
}
