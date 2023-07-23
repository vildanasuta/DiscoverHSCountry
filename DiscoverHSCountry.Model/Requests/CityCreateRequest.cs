using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class CityCreateRequest
    {
        public string Name { get; set; } = null!;

        public string? CoverImage { get; set; }
    }
}
