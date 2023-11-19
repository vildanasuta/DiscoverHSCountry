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
    public class LocationTouristAttractionOwnerController : BaseCRUDController<Model.LocationTouristAttractionOwner, Model.SearchObjects.LocationTouristAttractionOwnerSearchObject, Model.Requests.LocationTouristAttractionOwnerCreateRequest, Model.Requests.LocationTouristAttractionOwnerUpdateRequest>
    {
        private readonly ILocationTouristAttractionOwnerService _locationTouristAttractionOwnerService;
        public LocationTouristAttractionOwnerController(ILogger<BaseController<LocationTouristAttractionOwner, LocationTouristAttractionOwnerSearchObject>> logger, ILocationTouristAttractionOwnerService service) : base(logger, service)
        {
            _locationTouristAttractionOwnerService = service;
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<LocationTouristAttractionOwner> Insert([FromBody] LocationTouristAttractionOwnerCreateRequest insert)
        {
            return base.Insert(insert);
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<LocationTouristAttractionOwner> Update(int id, [FromBody] LocationTouristAttractionOwnerUpdateRequest update)
        {
            return base.Update(id, update);
        }

        [HttpGet("GetLocationIdsByTouristAttractionOwnerId/{touristAttractionOwnerId}")]
        public async Task<IActionResult> GetLocationIdsByTouristAttractionOwnerId(int touristAttractionOwnerId)
        {
            try
            {
                var locationIds = await _locationTouristAttractionOwnerService.GetLocationIdsByTouristAttractionOwnerIdAsync(touristAttractionOwnerId);

                return Ok(locationIds);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, "Error retrieving location IDs");
            }
        }

    }
}
