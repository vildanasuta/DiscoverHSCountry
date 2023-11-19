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
    public class RecommendationController : BaseCRUDController<Model.Recommendation, Model.SearchObjects.RecommendationSearchObject, Model.Requests.RecommendationCreateRequest, Model.Requests.RecommendationUpdateRequest>
    {
        private readonly IRecommendationService _recommendationService;

        public RecommendationController(ILogger<BaseController<Recommendation, RecommendationSearchObject>> logger, IRecommendationService service) : base(logger, service)
        {
            _recommendationService = service;
        }

        [HttpGet("Recommendations/{touristId}")]
        public async Task<ActionResult<IEnumerable<Recommendation>>> GetRecommendationsAsync(int touristId)
        {
            var recommendations = await _recommendationService.GenerateRecommendationsAsync(touristId);
            return Ok(recommendations);
        }

    }
}
