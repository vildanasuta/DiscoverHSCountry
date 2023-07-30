using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class VisitedLocationController : BaseCRUDController<Model.VisitedLocation, Model.SearchObjects.VisitedLocationSearchObject, Model.Requests.VisitedLocationCreateRequest, Model.Requests.VisitedLocationUpdateRequest>
    {
        public VisitedLocationController(ILogger<BaseController<VisitedLocation, VisitedLocationSearchObject>> logger, IVisitedLocationService service) : base(logger, service)
        {
        }
    }
}
