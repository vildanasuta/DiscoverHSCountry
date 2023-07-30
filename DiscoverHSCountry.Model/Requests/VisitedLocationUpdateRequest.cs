using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class VisitedLocationUpdateRequest
    {
        public int? LocationId { get; set; }

        public int? TouristId { get; set; }

        public DateTime? VisitDate { get; set; }

        public string? Notes { get; set; }
    }
}
