using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.Description;
using Util;

namespace DiscoverHSCountry.Services
{

    public class UserService : BaseCRUDService<Model.User, Database.User, UserSearchObject, UserCreateRequest, UserUpdateRequest>, IUserService
    {
        public UserService(DiscoverHSCountryContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }
        public async Task<AuthenticationResponse> AuthenticateUser(string email, string password)
        {
            var user = _context.Users.FirstOrDefault(u => u.Email == email);

            if (user == null)
            {
                return new AuthenticationResponse { Result = Util.AuthenticationResult.UserNotFound };
            }

            if (!BCrypt.Net.BCrypt.Verify(password, user.Password))
            {
                return new AuthenticationResponse { Result = Util.AuthenticationResult.InvalidPassword };
            }

            return new AuthenticationResponse { Result = Util.AuthenticationResult.Success, UserId = user.UserId };
        }

    }

}
