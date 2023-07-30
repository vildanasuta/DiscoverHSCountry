using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ServiceController : BaseCRUDController<Model.Service, Model.SearchObjects.ServiceSearchObject, Model.Requests.ServiceCreateRequest, Model.Requests.ServiceUpdateRequest>
    {
        public ServiceController(ILogger<BaseController<Service, ServiceSearchObject>> logger, IServiceService service) : base(logger, service)
        {
        }
    }
}
