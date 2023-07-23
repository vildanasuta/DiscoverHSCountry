using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class EventUpdateRequest
    {
        public string Title { get; set; } = null!;

        public string Description { get; set; } = null!;

        public DateTime Date { get; set; }

        public string StartTime { get; set; } = null!;

        public string? Address { get; set; }

        public decimal? TicketCost { get; set; }

        public int? CityId { get; set; }

        public int? EventCategoryId { get; set; }
        public int? LocationId { get; set; }

    }
}
