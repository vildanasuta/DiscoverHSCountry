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
using System.Web.Http.Description;

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
                        InstagramUrl=locationCreateRequest.InstagramUrl,
                        IsApproved=locationCreateRequest.IsApproved
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

                // Remove related records in the LocationTouristAttractionOwners table
                var jointRecords = _context.LocationTouristAttractionOwners
                    .Where(ltao => ltao.LocationId == locationId);

                _context.LocationTouristAttractionOwners.RemoveRange(jointRecords);

                // Remove related records in the VisitedLocation table
                var visitedLocations = _context.VisitedLocations
                    .Where(vl => vl.LocationId == locationId);

                // Remove related records in the VisitedLocationImage table
                foreach (var visitedLocation in visitedLocations)
                {
                    var visitedLocationImages = _context.VisitedLocationImages
                        .Where(vli => vli.VisitedLocationId == visitedLocation.VisitedLocationId);

                    _context.VisitedLocationImages.RemoveRange(visitedLocationImages);
                }

                _context.VisitedLocations.RemoveRange(visitedLocations);

                // Remove related records in the Review table
                var reviews = _context.Reviews
                    .Where(r => r.LocationId == locationId);

                _context.Reviews.RemoveRange(reviews);

                // Remove related records in the Reservation table
                var reservations = _context.Reservations
                    .Where(r => r.LocationId == locationId);

                _context.Reservations.RemoveRange(reservations);

                // Remove related records in the Service table
                var services = _context.Services
                    .Where(s => s.LocationId == locationId);

                _context.Services.RemoveRange(services);

                // Remove related records in the TechnicalIssueTourist table
                var technicalIssues = _context.TechnicalIssueTourists
                    .Where(t => t.LocationId == locationId);

                _context.TechnicalIssueTourists.RemoveRange(technicalIssues);

                // Remove related records in the LocationVisits table
                var locationVisits = _context.LocationVisits
                    .Where(lv => lv.LocationId == locationId);

                _context.LocationVisits.RemoveRange(locationVisits);

                // Remove related records in the Recommendation table
                var recommendations = _context.Recommendation
                    .Where(r => r.LocationId == locationId);

                _context.Recommendation.RemoveRange(recommendations);

                // Remove related records in the EventLocation table
                var eventLocations = _context.EventLocations
                    .Where(lv => lv.LocationId == locationId);

                _context.EventLocations.RemoveRange(eventLocations);


                _context.Locations.Remove(location);

                await _context.SaveChangesAsync();

                return true;
            }
            catch (Exception ex)
            {
                return false; 
            }
        }

        

        public List<Database.Location> GetLocationsBySubcategoryId(int categoryId, int subcategoryId)
        {
                return _context.Locations
                    .Where(location => location.LocationCategoryId==categoryId && location.LocationSubcategoryId == subcategoryId)
                    .ToList();
        }


    }
}
