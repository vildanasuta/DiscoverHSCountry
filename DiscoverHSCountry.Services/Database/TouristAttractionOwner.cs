using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class TouristAttractionOwner
{
    public int TouristAttractionOwnerId { get; set; }

    public int? UserId { get; set; }

    public virtual ICollection<LocationTouristAttractionOwner> LocationTouristAttractionOwners { get; set; } = new List<LocationTouristAttractionOwner>();

    public virtual ICollection<TechnicalIssueOwner> TechnicalIssueOwners { get; set; } = new List<TechnicalIssueOwner>();

    public virtual User? User { get; set; }
}
