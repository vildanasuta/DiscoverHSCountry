using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class HistoricalEvent
{
    public int HistoricalEventId { get; set; }

    public string Title { get; set; } = null!;

    public string Description { get; set; } = null!;

    public string CoverImage { get; set; } = null!;

    public int? CityId { get; set; }

    public virtual City? City { get; set; }
}
