using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HistoricalEventController : BaseCRUDController<Model.HistoricalEvent, Model.SearchObjects.HistoricalEventSearchObject, Model.Requests.HistoricalEventCreateRequest, Model.Requests.HistoricalEventUpdateRequest>
    {
        private readonly IHistoricalEventService _eventService;
        public HistoricalEventController(ILogger<BaseController<HistoricalEvent, HistoricalEventSearchObject>> logger, IHistoricalEventService service) : base(logger, service)
        {
            _eventService = service;
        }
    }
}
