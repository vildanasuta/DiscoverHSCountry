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
    public class ReviewController : BaseCRUDController<Model.Review, Model.SearchObjects.ReviewSearchObject, Model.Requests.ReviewCreateRequest, Model.Requests.ReviewUpdateRequest>
    {
        public ReviewController(ILogger<BaseController<Review, ReviewSearchObject>> logger, IReviewService service) : base(logger, service)
        {
        }
    }
}
