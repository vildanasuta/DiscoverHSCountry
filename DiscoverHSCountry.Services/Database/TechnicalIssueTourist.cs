using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class TechnicalIssueTourist
{
    public int TehnicalIssueTouristId { get; set; }

    public string Title { get; set; } = null!;

    public string Description { get; set; } = null!;

    public int? TouristId { get; set; }

    public int? LocationId { get; set; }

    public virtual Location? Location { get; set; }

    public virtual Tourist? Tourist { get; set; }
}
