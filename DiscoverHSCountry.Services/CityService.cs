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
    public class CityService : BaseCRUDService<Model.City, Database.City, CitySearchObject, CityCreateRequest, CityUpdateRequest>, ICityService
    {
        public CityService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
