using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public class EventService : BaseCRUDService<Model.Event, Database.Event, EventSearchObject, EventCreateRequest, EventUpdateRequest>, IEventService
    {
        IEventLocationService _eventLocationService;
        public EventService(DiscoverHSCountryContext context, IMapper mapper, IEventLocationService eventLocationService) : base(context, mapper)
        {
            _eventLocationService = eventLocationService;
        }

        public override async Task<Model.Event> Insert(EventCreateRequest eventCreateRequest)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var newEvent = new EventCreateRequest
                    {
                        Title = eventCreateRequest.Title,
                        Description = eventCreateRequest.Description,
                        Date = eventCreateRequest.Date,
                        StartTime = eventCreateRequest.StartTime,
                        Address = eventCreateRequest.Address,
                        TicketCost = eventCreateRequest.TicketCost,
                        CityId = eventCreateRequest.CityId,
                        EventCategoryId = eventCreateRequest.EventCategoryId
                    };

                    // Add the new event to the context and save changes
                    var createdEvent=await base.Insert(newEvent);
                    await _context.SaveChangesAsync();

                    if (eventCreateRequest.LocationId != null)
                    {
                        var eventLocation = new EventLocationCreateRequest
                        {
                            EventId = createdEvent.EventId,
                            LocationId=eventCreateRequest.LocationId
                        };
                        await _eventLocationService.Insert(eventLocation);
                        await _context.SaveChangesAsync();
                    }
                    transaction.Commit();

                    return createdEvent; 
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    throw;
                }
            }
        }

       




    }
}

