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
    public class VisitedLocationService : BaseCRUDService<Model.VisitedLocation, Database.VisitedLocation, VisitedLocationSearchObject, VisitedLocationCreateRequest, VisitedLocationUpdateRequest>, IVisitedLocationService
    {
        public VisitedLocationService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
