using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Util;

namespace DiscoverHSCountry.Services
{
    public interface IUserService: ICRUDService<Model.User, Model.SearchObjects.UserSearchObject, Model.Requests.UserCreateRequest, Model.Requests.UserUpdateRequest>
    {
        public Task<AuthenticationResponse> AuthenticateUser(string email, string password);
        public bool IsUserTouristAttractionOwner(int userId);
        public bool IsUserAdministrator(int userId);
        public bool IsUserTourist(int userId);
        Task<Database.User> UpdateUserDetails(int userId, EditUserDetailsRequest editedUser);
        Task<Database.User> UpdateOrAddProfilePhoto(int userId, string profileImage);
        Task<bool> UpdatePassword(int userId, string password, string oldPassword);
    }

}


