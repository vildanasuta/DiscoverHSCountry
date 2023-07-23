using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class LocationTouristAttractionOwner
{
    public int LocationTouristAttractionOwnerId { get; set; }

    public int? TouristAttractionOwnerId { get; set; }

    public int? LocationId { get; set; }

    public virtual Location? Location { get; set; }

    public virtual TouristAttractionOwner? TouristAttractionOwner { get; set; }
}
