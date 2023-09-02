using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class LocationCreateRequest
    {
        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public string? CoverImage { get; set; }

        public string Address { get; set; } = null!;

        public int? CityId { get; set; }

        public int? LocationCategoryId { get; set; }

        public int? LocationSubcategoryId { get; set; }

        public int? TouristAttractionOwnerId { get; set; }

        public string? FacebookUrl { get; set; }

        public string? InstagramUrl { get; set; }

        public string? BookingUrl { get; set; }

        public bool IsApproved { get; set; }

    }
}
