using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TouristController : BaseCRUDController<Model.Tourist, Model.SearchObjects.TouristSearchObject, Model.Requests.TouristCreateRequest, Model.Requests.TouristUpdateRequest>
    {
        private readonly ITouristService _touristService;

        public TouristController(ILogger<BaseController<Tourist, TouristSearchObject>> logger, ITouristService service) : base(logger, service)
        {
            _touristService = service;

        }

        [HttpPost("CreateTouristWithUserDetails")] 
        public async Task<IActionResult> CreateTouristWithUserDetails([FromBody] TouristCreateRequest touristCreateRequest)
        {
            try
            {
                var createdTourist = await _touristService.InsertTouristWithUserDetails(touristCreateRequest);
                return Ok(createdTourist);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while creating the tourist.");
            }
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<Tourist> Insert([FromBody] TouristCreateRequest insert)
        {
            return base.Insert(insert);
        }

        [Authorize]
        [HttpGet("GetTouristIdByUserId/{userId}")]
        public IActionResult GetTouristIdByUserId(int userId)
        {
            int touristId = _touristService.GetTouristIdByUserId(userId);

            if (touristId != 0)
            {
                return Ok(touristId);
            }
            else
            {
                return NotFound();
            }
        }
    }
}
