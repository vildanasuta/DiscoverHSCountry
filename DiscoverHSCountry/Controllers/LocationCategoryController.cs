using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LocationCategoryController : BaseCRUDController<Model.LocationCategory, Model.SearchObjects.LocationCategorySearchObject, Model.Requests.LocationCategoryCreateRequest, Model.Requests.LocationCategoryUpdateRequest>
    {
        public LocationCategoryController(ILogger<BaseController<LocationCategory, LocationCategorySearchObject>> logger, ILocationCategoryService service) : base(logger, service)
        {
        }
    }
}
