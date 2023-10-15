using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ILocationVisitsService : ICRUDService<Model.LocationVisits, Model.SearchObjects.LocationVisitsSearchObject, Model.Requests.LocationVisitsCreateRequest, Model.Requests.LocationVisitsUpdateRequest>
    {
    }
}
