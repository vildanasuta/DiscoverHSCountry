using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ServiceController : BaseCRUDController<Model.Service, Model.SearchObjects.ServiceSearchObject, Model.Requests.ServiceCreateRequest, Model.Requests.ServiceUpdateRequest>
    {
        private readonly IServiceService service;

        public ServiceController(ILogger<BaseController<Model.Service, Model.SearchObjects.ServiceSearchObject>> logger, IServiceService service) : base(logger, service)
        {
            this.service = service;
        }

        [HttpGet("GetServicesByLocationId/{locationId}")]
        public async Task<ActionResult<List<Model.Service>>> GetServicesByLocationId(int locationId)
        {
            try
            {
                var services = await service.GetServicesByLocationId(locationId);
                return Ok(services);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing your request.");
            }
        }

    }
}
