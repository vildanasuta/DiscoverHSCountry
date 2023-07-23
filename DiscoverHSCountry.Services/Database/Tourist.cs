using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class Tourist
{
    public int TouristId { get; set; }

    public DateTime? DateOfBirth { get; set; }

    public int? UserId { get; set; }

    public virtual ICollection<Reservation> Reservations { get; set; } = new List<Reservation>();

    public virtual ICollection<Review> Reviews { get; set; } = new List<Review>();

    public virtual ICollection<TechnicalIssueTourist> TechnicalIssueTourists { get; set; } = new List<TechnicalIssueTourist>();

    public virtual User? User { get; set; }

    public virtual ICollection<VisitedLocation> VisitedLocations { get; set; } = new List<VisitedLocation>();
}
