using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VisitedLocationImageController : BaseCRUDController<Model.VisitedLocationImage, Model.SearchObjects.VisitedLocationImageSearchObject, Model.Requests.VisitedLocationImageCreateRequest, Model.Requests.VisitedLocationImageUpdateRequest>
    {
        public VisitedLocationImageController(ILogger<BaseController<VisitedLocationImage, VisitedLocationImageSearchObject>> logger, IVisitedLocationImageService service) : base(logger, service)
        {
        }
    }
}
