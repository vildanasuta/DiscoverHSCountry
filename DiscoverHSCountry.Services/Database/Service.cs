using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class Service
{
    public int ServiceId { get; set; }

    public string ServiceName { get; set; } = null!;

    public string? ServiceDescription { get; set; }
    public decimal UnitPrice { get; set;}
    public int LocationId { get; set; }

    public virtual Location? Location { get; set; }

    public virtual ICollection<ReservationService> ReservationServices { get; set; } = new List<ReservationService>();

}
