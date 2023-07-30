using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TechnicalIssueOwnerController : BaseCRUDController<Model.TechnicalIssueOwner, Model.SearchObjects.TechnicalIssueOwnerSearchObject, Model.Requests.TechnicalIssueOwnerCreateRequest, Model.Requests.TechnicalIssueOwnerUpdateRequest>
    {
        public TechnicalIssueOwnerController(ILogger<BaseController<TechnicalIssueOwner, TechnicalIssueOwnerSearchObject>> logger, ITechnicalIssueOwnerService service) : base(logger, service)
        {
        }
    }
}
