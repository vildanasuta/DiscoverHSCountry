using DiscoverHSCountry.API.Controllers;
using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class PublicCityServiceController : BaseCRUDController<Model.PublicCityService, Model.SearchObjects.PublicCityServiceSearchObject, Model.Requests.PublicCityServiceCreateRequest, Model.Requests.PublicCityServiceUpdateRequest>
    {

        private readonly IPublicCityServiceService _publicCityServiceService;
        public PublicCityServiceController(ILogger<BaseController<PublicCityService, PublicCityServiceSearchObject>> logger, IPublicCityServiceService service) : base(logger, service)
        {
            _publicCityServiceService = service;
        }
    }
}
