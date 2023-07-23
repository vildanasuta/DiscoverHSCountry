using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class SocialMedium
{
    public int SocialMediaId { get; set; }

    public string? FacebookUrl { get; set; }

    public string? InstagramUrl { get; set; }

    public string? BookingUrl { get; set; }

    public virtual ICollection<SocialMediaLocation> SocialMediaLocations { get; set; } = new List<SocialMediaLocation>();
}
