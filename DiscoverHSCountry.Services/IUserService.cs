using DiscoverHSCountry.Model;
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
    }

}
