using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model
{
    public partial class TechnicalIssueOwner
    {
        public int TehnicalIssueOwnerId { get; set; }

        public string Title { get; set; } = null!;

        public string Description { get; set; } = null!;

        public int? TouristAttractionOwnerId { get; set; }

        public virtual TouristAttractionOwner? TouristAttractionOwner { get; set; }
    }
}
