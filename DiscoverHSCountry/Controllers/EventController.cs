using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EventController : BaseCRUDController<Model.Event, Model.SearchObjects.EventSearchObject, Model.Requests.EventCreateRequest, Model.Requests.EventUpdateRequest>
    {
        private readonly IEventService _eventService;
        public EventController(ILogger<BaseController<Event, EventSearchObject>> logger, IEventService service) : base(logger, service)
        {
            _eventService=service;
        }
    }
}
