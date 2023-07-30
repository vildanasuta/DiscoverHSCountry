using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ILocationCategoryService : ICRUDService<Model.LocationCategory, Model.SearchObjects.LocationCategorySearchObject, Model.Requests.LocationCategoryCreateRequest, Model.Requests.LocationCategoryUpdateRequest>
    {
    }
}
