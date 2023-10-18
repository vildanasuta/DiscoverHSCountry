using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class RecommendationCreateRequest
    {
        public int TouristId { get; set; }
        public int LocationId { get; set; }
    }
}
