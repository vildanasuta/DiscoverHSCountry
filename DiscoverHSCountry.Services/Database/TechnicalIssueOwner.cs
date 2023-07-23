using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class TechnicalIssueOwner
{
    public int TehnicalIssueOwnerId { get; set; }

    public string Title { get; set; } = null!;

    public string Description { get; set; } = null!;

    public int? TouristAttractionOwnerId { get; set; }

    public virtual TouristAttractionOwner? TouristAttractionOwner { get; set; }
}
