using System;
using System.Collections.Generic;

namespace DiscoverHSCountry.Model
{
    public partial class LocationImage
    {
        public int ImageId { get; set; }

        public int? LocationId { get; set; }

        public string? Image { get; set; }

        public virtual Location? Location { get; set; }
    }
}