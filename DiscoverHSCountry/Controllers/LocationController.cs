using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LocationController : BaseCRUDController<Model.Location, Model.SearchObjects.LocationSearchObject, Model.Requests.LocationCreateRequest, Model.Requests.LocationUpdateRequest>
    {
        public LocationController(ILogger<BaseController<Location, LocationSearchObject>> logger, ILocationService service) : base(logger, service)
        {
        }
    }
}
