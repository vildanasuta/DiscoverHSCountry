using AutoMapper;
using DiscoverHSCountry.Model;
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
    public class LocationService : BaseCRUDService<Model.Location, Database.Location, LocationSearchObject, LocationCreateRequest, LocationUpdateRequest>, ILocationService
    {
        ILocationTouristAttractionOwnerService _locationTouristAttractionOwnerService;
        public LocationService(DiscoverHSCountryContext context, IMapper mapper, ILocationTouristAttractionOwnerService locationTouristAttractionOwnerService) : base(context, mapper)
        {
            _locationTouristAttractionOwnerService = locationTouristAttractionOwnerService;
        }

        public override async Task<Model.Location> Insert(LocationCreateRequest locationCreateRequest)
        {
            Model.Location createdLocation;
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    LocationCreateRequest newLocation = new LocationCreateRequest
                    {
                        Name = locationCreateRequest.Name,
                        Address = locationCreateRequest.Address,
                        Description = locationCreateRequest.Description,
                        CoverImage = locationCreateRequest.CoverImage,
                        CityId = locationCreateRequest.CityId,
                        LocationCategoryId = locationCreateRequest.LocationCategoryId,
                        LocationSubcategoryId = locationCreateRequest.LocationSubcategoryId,
                        BookingUrl=locationCreateRequest.BookingUrl,
                        FacebookUrl=locationCreateRequest.FacebookUrl,
                        InstagramUrl=locationCreateRequest.InstagramUrl
                    };

                    createdLocation = await base.Insert(newLocation);
                    await _context.SaveChangesAsync();
                    if (locationCreateRequest.TouristAttractionOwnerId != null)
                    {
                        LocationTouristAttractionOwnerCreateRequest locationTouristAttractionOwnerCreateRequest = new LocationTouristAttractionOwnerCreateRequest
                        {
                            LocationId = createdLocation.LocationId,
                            TouristAttractionOwnerId = locationCreateRequest.TouristAttractionOwnerId
                        };
                        await _locationTouristAttractionOwnerService.Insert(locationTouristAttractionOwnerCreateRequest);
                        await _context.SaveChangesAsync();
                    }
                    transaction.Commit();

                }
                catch (Exception ex)
                {
                    // If an exception occurs, roll back the transaction
                    transaction.Rollback();
                    throw;
                }
            }
            return createdLocation;
        }

        public async Task<bool> ApproveLocationAsync(int locationId)
        {
            try
            {   
                var location = await _context.Locations.FindAsync(locationId);

                if (location != null)
                {
                    location.IsApproved = true;
                    await _context.SaveChangesAsync();
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public async Task<bool> DeleteLocationByIdAsync(int locationId)
        {
            try
            {
                var location = await _context.Locations.FindAsync(locationId);

                if (location == null)
                {
                    return false; 
                }

                var jointRecords = _context.LocationTouristAttractionOwners
                    .Where(ltao => ltao.LocationId == locationId);

                _context.LocationTouristAttractionOwners.RemoveRange(jointRecords);

                _context.Locations.Remove(location);

                await _context.SaveChangesAsync();

                return true;
            }
            catch (Exception ex)
            {
                return false; 
            }
        }

    }
}
