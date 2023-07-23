using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class VisitedLocationImage
{
    public int ImageId { get; set; }

    public int? VisitedLocationId { get; set; }

    public string? Image { get; set; }

    public virtual VisitedLocation? VisitedLocation { get; set; }
}
