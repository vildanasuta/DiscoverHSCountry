using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class SocialMediaLocation
{
    public int SocialMediaLocation1 { get; set; }

    public int? SocialMediaId { get; set; }

    public int? LocationId { get; set; }

    public virtual Location? Location { get; set; }

    public virtual SocialMedium? SocialMedia { get; set; }
}
