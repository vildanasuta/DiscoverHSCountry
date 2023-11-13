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
    public class LocationSubcategoryController : BaseCRUDController<Model.LocationSubcategory, Model.SearchObjects.LocationSubcategorySearchObject, Model.Requests.LocationSubcategoryCreateRequest, Model.Requests.LocationSubcategoryUpdateRequest>
    {
        private readonly ILocationSubcategoryService _subcategoryService;

        public LocationSubcategoryController(ILogger<BaseController<LocationSubcategory, LocationSubcategorySearchObject>> logger, ILocationSubcategoryService service, ILocationSubcategoryService subcategoryService) : base(logger, service)
        {
            _subcategoryService = subcategoryService;
        }

        [HttpGet("GetSubcategoriesByCategory/{categoryId}")]
        public async Task<ActionResult<List<LocationSubcategory>>> GetSubcategoriesByCategoryIdAsync(int categoryId)
        {
            var subcategories = await _subcategoryService.GetSubcategoriesByCategoryIdAsync(categoryId);
            return Ok(subcategories);
        }
    }
}
