using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class TechnicalIssueTouristController : BaseCRUDController<Model.TechnicalIssueTourist, Model.SearchObjects.TechnicalIssueTouristSearchObject, Model.Requests.TechnicalIssueTouristCreateRequest, Model.Requests.TechnicalIssueTouristUpdateRequest>
    {
        public TechnicalIssueTouristController(ILogger<BaseController<TechnicalIssueTourist, TechnicalIssueTouristSearchObject>> logger, ITechnicalIssueTouristService service) : base(logger, service)
        {
        }
    }
}
