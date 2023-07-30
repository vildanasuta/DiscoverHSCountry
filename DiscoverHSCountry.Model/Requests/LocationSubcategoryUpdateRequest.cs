using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class LocationSubcategoryUpdateRequest
    {
        public string Name { get; set; } = null!;

        public string? CoverImage { get; set; }

        public int? LocationCategoryId { get; set; }
    }
}
