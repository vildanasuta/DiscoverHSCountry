using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Model
{
    public partial class Reservation
    {
        public int ReservationId { get; set; }

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public int NumberOfPeople { get; set; }

        public string? AdditionalDescription { get; set; }

        public int? TouristId { get; set; }

        public int? ServiceId { get; set; }

        public int? LocationId { get; set; }

        public decimal Price { get; set; }

        public virtual Location? Location { get; set; }

        public virtual Service? Service { get; set; }

        public virtual Tourist? Tourist { get; set; }
    }
}