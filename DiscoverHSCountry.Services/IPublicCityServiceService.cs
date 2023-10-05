using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IPublicCityServiceService : ICRUDService<Model.PublicCityService, Model.SearchObjects.PublicCityServiceSearchObject, Model.Requests.PublicCityServiceCreateRequest, Model.Requests.PublicCityServiceUpdateRequest>
    {
    }
}
