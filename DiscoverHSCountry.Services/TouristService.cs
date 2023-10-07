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
    public class TouristService : BaseCRUDService<Model.Tourist, Database.Tourist, TouristSearchObject, TouristCreateRequest, TouristUpdateRequest>, ITouristService
    {
        private readonly IUserService _userService; // Injects the user service to handle user creation
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
                        UserId = createdUser.UserId
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

    }
}
