using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class CityController : BaseCRUDController<Model.City, Model.SearchObjects.CitySearchObject, Model.Requests.CityCreateRequest, Model.Requests.CityUpdateRequest>
    {
        private readonly ICityService _cityService;

        public CityController(ILogger<BaseController<City, CitySearchObject>> logger, ICityService service) : base(logger, service)
        {
            _cityService = service;
        }
    }
}
