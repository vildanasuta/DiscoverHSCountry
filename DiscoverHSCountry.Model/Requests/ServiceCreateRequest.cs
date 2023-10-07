using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model.Requests
{
    public class ServiceCreateRequest
    {
        public string ServiceName { get; set; } = null!;

        public string? ServiceDescription { get; set; }
        public decimal UnitPrice { get; set; }
        public int LocationId { get; set; }

        public virtual Location? Location { get; set; }

        public virtual ICollection<ReservationService> ReservationServices { get; set; } = new List<ReservationService>();
    }
}
