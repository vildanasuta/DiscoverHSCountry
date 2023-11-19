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
    public class LocationController : BaseCRUDController<Model.Location, Model.SearchObjects.LocationSearchObject, Model.Requests.LocationCreateRequest, Model.Requests.LocationUpdateRequest>
    {
        ILocationService locationService;
        public LocationController(ILogger<BaseController<Location, LocationSearchObject>> logger, ILocationService service) : base(logger, service)
        {
            this.locationService = service;
        }

        [HttpPut("Approve/{locationId}")]
        public async Task<IActionResult> ApproveLocation(int locationId)
        {
            try
            {
                var result = await locationService.ApproveLocationAsync(locationId);

                if (result)
                {
                    return Ok("Location approved successfully.");
                }
                else
                {
                    return NotFound("Location not found or approval failed.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while processing the request.");
            }
        }

        [HttpDelete("DeleteById/{locationId}")]
        public async Task<IActionResult> DeleteLocationByIdAsync(int locationId)
        {
            try
            {
                var result = await locationService.DeleteLocationByIdAsync(locationId);

                if (result)
                {
                    return Ok("Location approved successfully.");
                }
                else
                {
                    return NotFound("Location not found or approval failed.");
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while processing the request.");
            }
        }

        [HttpGet("GetLocationsBySubcategoryId/{categoryId}/{subcategoryId}")]
        public IActionResult GetLocationsBySubcategoryId(int categoryId, int subcategoryId)
        {
            var locations = locationService.GetLocationsBySubcategoryId(categoryId, subcategoryId);

            if (locations == null || locations.Count == 0)
            {
                return NotFound(); // Return a 404 Not Found response if no locations are found
            }

            return Ok(locations); // Return the locations as JSON data
        }

    }
}
