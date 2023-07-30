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
    public class EventCategoryService : BaseCRUDService<Model.EventCategory, Database.EventCategory, EventCategorySearchObject, EventCategoryCreateRequest, EventCategoryUpdateRequest>, IEventCategoryService
    {
        public EventCategoryService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
