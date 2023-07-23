using System;
using System.Collections.Generic;
namespace DiscoverHSCountry.Model
{
    public partial class EventCategory
    {
        public int EventCategoryId { get; set; }

        public string CategoryName { get; set; } = null!;

        public virtual ICollection<Event> Events { get; set; } = new List<Event>();
    }
}