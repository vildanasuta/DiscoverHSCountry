using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Services.Database;

public partial class Administrator
{
    public int AdministratorId { get; set; }

    public int? UserId { get; set; }

    public virtual User? User { get; set; }
}
