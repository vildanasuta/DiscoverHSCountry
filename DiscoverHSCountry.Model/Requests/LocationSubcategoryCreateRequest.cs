using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class LocationSubcategoryCreateRequest
    {
        public string Name { get; set; } = null!;

        public string? CoverImage { get; set; }

        public int? LocationCategoryId { get; set; }

    }
}
