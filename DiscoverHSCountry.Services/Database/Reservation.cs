using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class Reservation
{
    public int ReservationId { get; set; }

    public int? TouristId { get; set; }

    public int? LocationId { get; set; }

    public decimal Price { get; set; }
    public bool IsPaid { get; set; } = false;
    public bool IsConfirmed { get; set; } = false;
    public string? PayPalPaymentId { get; set; }


    public virtual Location? Location { get; set; }

    public virtual Tourist? Tourist { get; set; }
    public virtual ICollection<ReservationService> ReservationServices { get; set; } = new List<ReservationService>();

}
