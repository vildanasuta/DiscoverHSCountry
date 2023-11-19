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
    public class EventCategoryController : BaseCRUDController<Model.EventCategory, Model.SearchObjects.EventCategorySearchObject, Model.Requests.EventCategoryCreateRequest, Model.Requests.EventCategoryUpdateRequest>
    {
        private readonly IEventCategoryService _eventCategoryService;
        public EventCategoryController(ILogger<BaseController<EventCategory, EventCategorySearchObject>> logger, IEventCategoryService service) : base(logger, service)
        { 
            _eventCategoryService = service;
        }
    }
}
