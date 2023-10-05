using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model
{
    public partial class PublicCityService
    {
        public int PublicCityServiceId { get; set; }
        public string Name { get; set; } = null!;
        public string Description { get; set; } = null!;

        public string? CoverImage { get; set; }

        public string Address { get; set; } = null!;
        public int? CityId { get; set; }

        public virtual City? City { get; set; }
    }
}
