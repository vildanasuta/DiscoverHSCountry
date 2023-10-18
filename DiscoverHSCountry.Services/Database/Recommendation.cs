using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services.Database
{
    public partial class Recommendation
    {
        public int RecommendationId { get; set; }
        public int TouristId { get; set; }
        public int LocationId { get; set; }
        public virtual Tourist? Tourist { get; set; }
        public virtual Location? Location { get; set; }
    }
}
