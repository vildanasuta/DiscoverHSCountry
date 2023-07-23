using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model
{
    public partial class TouristAttractionOwner
    {
        public int TouristAttractionOwnerId { get; set; }

        public int? UserId { get; set; }

        public virtual ICollection<LocationTouristAttractionOwner> LocationTouristAttractionOwners { get; set; } = new List<LocationTouristAttractionOwner>();

        public virtual ICollection<TechnicalIssueOwner> TechnicalIssueOwners { get; set; } = new List<TechnicalIssueOwner>();

        public virtual User? User { get; set; }
    }
}
