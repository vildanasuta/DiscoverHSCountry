using DiscoverHSCountry.API.Controllers;
using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class CountryController : BaseCRUDController<Model.Country, Model.SearchObjects.CountrySearchObject, Model.Requests.CountryCreateRequest, Model.Requests.CountryUpdateRequest>
    {
        private readonly ICountryService _countryService;

        public CountryController(ILogger<BaseController<Country, CountrySearchObject>> logger, ICountryService service) : base(logger, service)
        {
            _countryService = service;
        }
        [AllowAnonymous]
        [HttpGet("GetAllCountries")]
        public async Task<PagedResult<Country>> GetAllCountries()
        {
            var list = await _countryService.Get();
            return list;
        }
    }
}
