using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class LocationSubcategory
{
    public int LocationSubcategoryId { get; set; }

    public string Name { get; set; } = null!;

    public string? CoverImage { get; set; }

    public int? LocationCategoryId { get; set; }

    public virtual LocationCategory? LocationCategory { get; set; }

    public virtual ICollection<Location> Locations { get; set; } = new List<Location>();
}
