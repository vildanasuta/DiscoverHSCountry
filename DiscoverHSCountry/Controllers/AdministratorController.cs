using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AdministratorController : BaseCRUDController<Model.Administrator, Model.SearchObjects.AdministratorSearchObject, Model.Requests.AdministratorCreateRequest, Model.Requests.AdministratorUpdateRequest>
    {
        private readonly IAdministratorService _administratorService;

        public AdministratorController(ILogger<BaseController<Administrator, AdministratorSearchObject>> logger,IAdministratorService service) : base(logger, service)
        {
            _administratorService = service;
        }

        [HttpPost("CreateAdministratorWithUserDetails")] // Specify the route path here
        public async Task<IActionResult> CreateAdministratorWithUserDetails([FromBody] AdministratorCreateRequest administratorCreateRequest)
        {
            try
            {
                var createdAdmin = await _administratorService.InsertAdministratorWithUserDetails(administratorCreateRequest);
                return Ok(createdAdmin);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while creating the tourist.");
            }
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<Administrator> Insert([FromBody] AdministratorCreateRequest insert)
        {
            return base.Insert(insert);
        }
    }
}
