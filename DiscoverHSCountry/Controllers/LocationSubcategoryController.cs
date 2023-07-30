using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LocationSubcategoryController : BaseCRUDController<Model.LocationSubcategory, Model.SearchObjects.LocationSubcategorySearchObject, Model.Requests.LocationSubcategoryCreateRequest, Model.Requests.LocationSubcategoryUpdateRequest>
    {
        public LocationSubcategoryController(ILogger<BaseController<LocationSubcategory, LocationSubcategorySearchObject>> logger, ILocationSubcategoryService service) : base(logger, service)
        {
        }
    }
}
