using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class TechnicalIssueOwnerUpdateRequest
    {
        public string Title { get; set; } = null!;

        public string Description { get; set; } = null!;

        public int? TouristAttractionOwnerId { get; set; }
    }
}
