using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class Event
{
    public int EventId { get; set; }

    public string Title { get; set; } = null!;

    public string Description { get; set; } = null!;

    public DateTime Date { get; set; }

    public string StartTime { get; set; } = null!;

    public string? Address { get; set; }

    public decimal? TicketCost { get; set; }

    public int? CityId { get; set; }

    public int? EventCategoryId { get; set; }

    public virtual City? City { get; set; }

    public virtual EventCategory? EventCategory { get; set; }

    public virtual EventLocation? EventLocation { get; set; }
}
