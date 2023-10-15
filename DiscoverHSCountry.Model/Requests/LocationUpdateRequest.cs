﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class LocationUpdateRequest
    {
        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public string? CoverImage { get; set; }

        public string Address { get; set; } = null!;

        public string? FacebookUrl { get; set; }

        public string? InstagramUrl { get; set; }

        public string? BookingUrl { get; set; }
    }
}
