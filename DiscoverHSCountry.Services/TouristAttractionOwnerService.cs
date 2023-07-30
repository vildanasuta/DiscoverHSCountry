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
    public class TouristAttractionOwnerService: BaseCRUDService<Model.TouristAttractionOwner, Database.TouristAttractionOwner, TouristAttractionOwnerSearchObject, TouristAttractionOwnerCreateRequest, TouristAttractionOwnerUpdateRequest>, ITouristAttractionOwnerService
    {
        private readonly IUserService _userService; // Injects the user service to handle user creation

        public TouristAttractionOwnerService(DiscoverHSCountryContext context, IMapper mapper, IUserService userService) : base(context, mapper)
        {
            _userService = userService;
        }

        public async Task<TouristAttractionOwner> InsertTouristAttractionOwnerWithUserDetails(TouristAttractionOwnerCreateRequest touristAttractionOwnerCreateRequest)
        {
            TouristAttractionOwner touristAttractionOwner;
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var user = new UserCreateRequest
                    {
                        Email = touristAttractionOwnerCreateRequest.Email,
                        FirstName = touristAttractionOwnerCreateRequest.FirstName,
                        LastName = touristAttractionOwnerCreateRequest.LastName,
                        Password = touristAttractionOwnerCreateRequest.Password,
                        ProfileImage = touristAttractionOwnerCreateRequest.ProfileImage,
                    };
                    Model.User createdUser = await _userService.Insert(user);
                    await _context.SaveChangesAsync();

                    touristAttractionOwner = new TouristAttractionOwner
                    {
                        UserId = createdUser.UserId
                    };

                    _context.TouristAttractionOwners.Add(touristAttractionOwner);
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
            return touristAttractionOwner;
        }

        public async Task<int> ReturnUserIdByTouristAOIdAsync(int id)
        {
            int userId;
            Model.TouristAttractionOwner touristAttractionOwner = await base.GetById(id);
            userId = (int)touristAttractionOwner.UserId;
            return userId;
        }

        public override async Task<Model.TouristAttractionOwner> Delete(int id)
        {
            int userId = await ReturnUserIdByTouristAOIdAsync(id);

            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var deletedTouristAO = await base.Delete(id);
                    await _userService.Delete(userId);
                    transaction.Commit();
                    return deletedTouristAO;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    throw ex;
                }
            }
        }
    }
}
