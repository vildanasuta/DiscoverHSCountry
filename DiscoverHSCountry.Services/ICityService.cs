using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ICityService: ICRUDService<Model.City, Model.SearchObjects.CitySearchObject, Model.Requests.CityCreateRequest, Model.Requests.CityUpdateRequest>
    {
    }
}
