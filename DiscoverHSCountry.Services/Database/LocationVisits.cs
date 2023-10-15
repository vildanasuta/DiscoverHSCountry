using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services.Database
{
    public partial class LocationVisits
    {
        public int LocationVisitsId { get; set; }
        public int LocationId { get; set; }

        public int TouristId { get; set; }
        public int NumberOfVisits { get; set; } = 0;
        public virtual Location Location { get; set; } = null!;

        public virtual Tourist Tourist { get; set; } = null!;

    }
}
