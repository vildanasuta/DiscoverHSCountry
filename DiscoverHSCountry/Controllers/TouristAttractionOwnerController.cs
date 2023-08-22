using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TouristAttractionOwnerController : BaseCRUDController<Model.TouristAttractionOwner, Model.SearchObjects.TouristAttractionOwnerSearchObject, Model.Requests.TouristAttractionOwnerCreateRequest, Model.Requests.TouristAttractionOwnerUpdateRequest>
    {
        private readonly ITouristAttractionOwnerService _touristAttractionOwnerService;
        public TouristAttractionOwnerController(ILogger<BaseController<TouristAttractionOwner, TouristAttractionOwnerSearchObject>> logger, ITouristAttractionOwnerService service) : base(logger, service)
        {
            _touristAttractionOwnerService = service;
        }

        [HttpPost("CreateTouristAttractionOwnerWithUserDetails")] // Specify the route path here
        public async Task<IActionResult> CreateTouristAttractionOwnerWithUserDetails([FromBody] TouristAttractionOwnerCreateRequest touristAttractionOwnerCreateRequest)
        {
            try
            {
                var createdTouristAttractionOwner = await _touristAttractionOwnerService.InsertTouristAttractionOwnerWithUserDetails(touristAttractionOwnerCreateRequest);
                return Ok(createdTouristAttractionOwner);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while creating the tourist.");
            }
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<TouristAttractionOwner> Insert([FromBody] TouristAttractionOwnerCreateRequest insert)
        {
            return base.Insert(insert);
        }

        [HttpGet("GetTouristAttractionOwnerIdByUserId/{userId}")]
        public IActionResult GetTouristAttractionOwnerIdByUserId(int userId)
        {
            int taoId = _touristAttractionOwnerService.GetTouristAttractionOwnerIdByUserId(userId);

            if (taoId != 0) // Check if a valid result was returned from the service
            {
                return Ok(taoId);
            }
            else
            {
                return NotFound();
            }
        }
    }
}
