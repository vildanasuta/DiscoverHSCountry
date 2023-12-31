﻿using DiscoverHSCountry.Model;
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
    public class EventLocationController : BaseCRUDController<Model.EventLocation, Model.SearchObjects.EventLocationSearchObject, Model.Requests.EventLocationCreateRequest, Model.Requests.EventLocationUpdateRequest>
    {
        private readonly IEventLocationService _eventLocationService;
        public EventLocationController(ILogger<BaseController<EventLocation, EventLocationSearchObject>> logger, IEventLocationService service) : base(logger, service)
        {
            _eventLocationService = service;
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<EventLocation> Insert([FromBody] EventLocationCreateRequest insert)
        {
            return _eventLocationService.Insert(insert);
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<EventLocation> Update(int id, [FromBody] EventLocationUpdateRequest update)
        {
            return _eventLocationService.Update(id, update);
        }

    }
}
