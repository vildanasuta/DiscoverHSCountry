using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Model
{
    public partial class VisitedLocation
    {
        public int VisitedLocationId { get; set; }

        public int? LocationId { get; set; }

        public int? TouristId { get; set; }

        public DateTime? VisitDate { get; set; }

        public string? Notes { get; set; }

        public virtual Location? Location { get; set; }

        public virtual Tourist? Tourist { get; set; }

        public virtual ICollection<VisitedLocationImage> VisitedLocationImages { get; set; } = new List<VisitedLocationImage>();
    }
}