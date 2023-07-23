using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class City
{
    public int CityId { get; set; }

    public string Name { get; set; } = null!;

    public string? CoverImage { get; set; }

    public virtual ICollection<Event> Events { get; set; } = new List<Event>();

    public virtual ICollection<HistoricalEvent> HistoricalEvents { get; set; } = new List<HistoricalEvent>();

    public virtual ICollection<Location> Locations { get; set; } = new List<Location>();
}
