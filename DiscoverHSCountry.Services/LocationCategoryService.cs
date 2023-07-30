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
    public class LocationCategoryService : BaseCRUDService<Model.LocationCategory, Database.LocationCategory, LocationCategorySearchObject, LocationCategoryCreateRequest, LocationCategoryUpdateRequest>, ILocationCategoryService
    {
        public LocationCategoryService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
