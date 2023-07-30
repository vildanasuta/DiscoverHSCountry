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
    public class LocationTouristAttractionOwnerService : BaseCRUDService<Model.LocationTouristAttractionOwner, Database.LocationTouristAttractionOwner, LocationTouristAttractionOwnerSearchObject, LocationTouristAttractionOwnerCreateRequest, LocationTouristAttractionOwnerUpdateRequest>, ILocationTouristAttractionOwnerService
    {
        public LocationTouristAttractionOwnerService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
