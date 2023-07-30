using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LocationImageController : BaseCRUDController<Model.LocationImage, Model.SearchObjects.LocationImageSearchObject, Model.Requests.LocationImageCreateRequest, Model.Requests.LocationImageUpdateRequest>
    {
        public LocationImageController(ILogger<BaseController<LocationImage, LocationImageSearchObject>> logger, ILocationImageService service) : base(logger, service)
        {
        }
    }
}
