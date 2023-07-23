using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Model
{
    public partial class Administrator
    {
        public int AdministratorId { get; set; }

        public int? UserId { get; set; }

        public virtual User? User { get; set; }
    }
}
