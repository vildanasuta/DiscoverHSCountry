using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class Review
{
    public int ReviewId { get; set; }

    public string Title { get; set; } = null!;

    public string Description { get; set; } = null!;

    public double Rate { get; set; }

    public DateTime ReviewDate { get; set; }

    public int? TouristId { get; set; }

    public int? LocationId { get; set; }

    public virtual Location? Location { get; set; }

    public virtual Tourist? Tourist { get; set; }
}
