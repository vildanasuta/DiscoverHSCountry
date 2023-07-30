using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public class EventLocationService : BaseCRUDService<Model.EventLocation, Database.EventLocation, EventLocationSearchObject, EventLocationCreateRequest, EventLocationUpdateRequest>, IEventLocationService
    {
        public EventLocationService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }

    }
}
