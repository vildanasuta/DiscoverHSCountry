using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class LocationCategory
{
    public int LocationCategoryId { get; set; }

    public string Name { get; set; } = null!;

    public string? CoverImage { get; set; }

    public virtual ICollection<LocationSubcategory> LocationSubcategories { get; set; } = new List<LocationSubcategory>();

    public virtual ICollection<Location> Locations { get; set; } = new List<Location>();
}
