using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ILocationSubcategoryService : ICRUDService<Model.LocationSubcategory, Model.SearchObjects.LocationSubcategorySearchObject, Model.Requests.LocationSubcategoryCreateRequest, Model.Requests.LocationSubcategoryUpdateRequest>
    {
    }
}
