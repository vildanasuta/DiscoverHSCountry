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
    public class LocationVisitsService: BaseCRUDService<Model.LocationVisits, Database.LocationVisits, LocationVisitsSearchObject, LocationVisitsCreateRequest, LocationVisitsUpdateRequest>, ILocationVisitsService
    {
       public LocationVisitsService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
       {
       }
    }
}
