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
    public class TouristService : BaseCRUDService<Model.Tourist, Database.Tourist, TouristSearchObject, TouristCreateRequest, TouristUpdateRequest>, ITouristService
    {
        private readonly IUserService _userService;
        public TouristService(DiscoverHSCountryContext context, IMapper mapper, IUserService userService) : base(context, mapper)
        {
            _userService = userService;
        }
        public async Task<Database.Tourist> InsertTouristWithUserDetails(TouristCreateRequest touristCreateRequest)
        {
            Tourist tourist;
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var user = new UserCreateRequest
                    {
                        Email = touristCreateRequest.Email,
                        FirstName = touristCreateRequest.FirstName,
                        LastName = touristCreateRequest.LastName,
                        ProfileImage = touristCreateRequest.ProfileImage,
                    };
                    // Hash the password using bcrypt
                    string hashedPassword = BCrypt.Net.BCrypt.HashPassword(touristCreateRequest.Password);
                    user.Password = hashedPassword;
                    Model.User createdUser = await _userService.Insert(user);
                    await _context.SaveChangesAsync();

                    tourist = new Tourist
                    {
                        DateOfBirth = touristCreateRequest.DateOfBirth,
                        UserId = createdUser.UserId,
                        CountryId = touristCreateRequest.CountryId
                    };

                    _context.Tourists.Add(tourist);
                    await _context.SaveChangesAsync();
                    transaction.Commit();


                }
                catch (Exception ex)
                {
                    // If an exception occurs, roll back the transaction
                    transaction.Rollback();
                    throw;
                }
            }
            return tourist;
        }

        public async Task<int> ReturnUserIdByTouristIdAsync(int id)
        {
            int userId;
            Model.Tourist tourist = await base.GetById(id);
            userId = (int)tourist.UserId;
            return userId;
        }

        public override async Task<Model.Tourist> Delete(int id)
        {
            int userId = await ReturnUserIdByTouristIdAsync(id);

            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var reservations = await _context.Reservations
                        .Where(r => r.TouristId == id)
                        .ToListAsync();
                    if (reservations.Count > 0)
                    {
                        foreach(var reservation in reservations)
                        {
                            _context.Reservations.Remove(reservation);
                        }
                    }

                    var technicalIssues = await _context.TechnicalIssueTourists
                        .Where(t => t.TouristId == id)
                        .ToListAsync();
                    if(technicalIssues.Count > 0)
                    {
                        foreach(var issue in technicalIssues)
                        {
                            _context.TechnicalIssueTourists.Remove(issue);
                        }
                    }

                    var visitedLocations = await _context.VisitedLocations
                        .Where(v => v.TouristId == id)
                        .ToListAsync();
                    if(visitedLocations.Count > 0)
                    {
                        foreach(var location in visitedLocations)
                        {
                            var visitedLocationImages = await _context.VisitedLocationImages
                                .Where(v=> v.VisitedLocationId==location.VisitedLocationId)
                                .ToListAsync();
                            if(visitedLocationImages.Count > 0)
                            {
                                foreach(var image in visitedLocationImages)
                                {
                                    _context.VisitedLocationImages.Remove(image);
                                }
                            }
                            _context.VisitedLocations.Remove(location);
                        }
                    }

                    var locationVisits = await _context.LocationVisits
                        .Where(v => v.TouristId == id)
                        .ToListAsync();
                    if(locationVisits.Count > 0)
                    {
                        foreach(var visit in locationVisits)
                        {
                            _context.LocationVisits.Remove(visit);
                        }
                    }

                    var recommendations = await _context.Recommendation
                        .Where(r => r.TouristId == id)
                        .ToListAsync();
                    if(recommendations.Count > 0)
                    {
                        foreach (var recommendation in recommendations)
                        {
                            _context.Recommendation.Remove(recommendation);
                        }
                    }

                    var reviews = await _context.Reviews
                        .Where(r => r.TouristId == id)
                        .ToListAsync();
                    if(reviews.Count > 0)
                    {
                        foreach (var review in reviews)
                        {
                            _context.Reviews.Remove(review);
                        }
                    }


                    var deletedTourist = await base.Delete(id);
                    await _userService.Delete(userId);
                    transaction.Commit();
                    return deletedTourist;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    throw ex;
                }
            }
        }
        public int GetTouristIdByUserId(int userId)
        {
            var tourist = _context.Tourists.FirstOrDefault(t => t.UserId == userId);
            return tourist.TouristId;
        }

        public async Task<Country> GetCountryByTouristId(int touristId)
        {
            var tourist = await _context.Tourists
                .Include(t => t.Country)
                .FirstOrDefaultAsync(t => t.TouristId == touristId);

            return tourist?.Country;
        }
    }
}
