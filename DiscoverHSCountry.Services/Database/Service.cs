using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class Service
{
    public int ServiceId { get; set; }

    public string ServiceName { get; set; } = null!;

    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();
}
