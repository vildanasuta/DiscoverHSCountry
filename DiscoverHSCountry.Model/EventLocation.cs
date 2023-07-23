using System;
using System.Collections.Generic;
namespace DiscoverHSCountry.Model
{
    public partial class EventLocation
    {
        public int EventId { get; set; }

        public int? LocationId { get; set; }

        public virtual Event Event { get; set; } = null!;

        public virtual Location? Location { get; set; }
    }
}
