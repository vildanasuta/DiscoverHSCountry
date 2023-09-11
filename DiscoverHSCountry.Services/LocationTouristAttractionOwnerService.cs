using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using Microsoft.EntityFrameworkCore;
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
        public async Task<List<int>> GetLocationIdsByTouristAttractionOwnerIdAsync(int touristAttractionOwnerId)
        {
            var locationIds = await _context.LocationTouristAttractionOwners
                .Where(ltoa => ltoa.TouristAttractionOwnerId == touristAttractionOwnerId && ltoa.LocationId != null)
                .Select(ltoa => ltoa.LocationId!.Value)
                .ToListAsync();

            return locationIds;
        }


    }
}
