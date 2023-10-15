using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class ReviewCreateRequest
    {
        public string Title { get; set; } = null!;

        public string Description { get; set; } = null!;

        public double Rate { get; set; }

        public DateTime ReviewDate { get; set; }

        public int? TouristId { get; set; }

        public int? LocationId { get; set; }
    }
}
