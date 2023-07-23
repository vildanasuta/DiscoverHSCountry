using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class User
{
    public int UserId { get; set; }

    public string Email { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? ProfileImage { get; set; }

    public virtual ICollection<Administrator> Administrators { get; set; } = new List<Administrator>();

    public virtual ICollection<TouristAttractionOwner> TouristAttractionOwners { get; set; } = new List<TouristAttractionOwner>();

    public virtual ICollection<Tourist> Tourists { get; set; } = new List<Tourist>();
}
