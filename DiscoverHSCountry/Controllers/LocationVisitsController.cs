using DiscoverHSCountry.API.Controllers;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class LocationVisitsController : BaseCRUDController<Model.LocationVisits, Model.SearchObjects.LocationVisitsSearchObject, Model.Requests.LocationVisitsCreateRequest, Model.Requests.LocationVisitsUpdateRequest>
    {
        private readonly ILocationVisitsService _locationVisitsService;

        public LocationVisitsController(ILogger<BaseController<Model.LocationVisits, LocationVisitsSearchObject>> logger, ILocationVisitsService service) : base(logger, service)
        {
            _locationVisitsService = service;
        }
    }
}
