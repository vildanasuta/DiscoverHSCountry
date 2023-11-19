using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using Microsoft.Extensions.Configuration;
using Microsoft.Identity.Client;
using Microsoft.IdentityModel.Tokens;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.Description;
using Util;

namespace DiscoverHSCountry.Services
{

    public class UserService : BaseCRUDService<Model.User, Database.User, UserSearchObject, UserCreateRequest, UserUpdateRequest>, IUserService
    {
        private readonly IConfiguration _configuration;
        public UserService(DiscoverHSCountryContext dbContext, IMapper mapper, IConfiguration configuration) : base(dbContext, mapper)
        {
            _configuration = configuration;
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

            var token = CreateToken(user);

            return new AuthenticationResponse { Result = Util.AuthenticationResult.Success, UserId = user.UserId, Token = token };
        }

        private string CreateToken(User user)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.Email, user.Email),
            };
            var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(_configuration.GetSection("AppSettings:Token").Value));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
            var token = new JwtSecurityToken(
                claims: claims, 
                expires: DateTime.Now.AddDays(1),
                signingCredentials: creds
                );

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        

        public bool IsUserTouristAttractionOwner(int userId)
        {
            var userExists = _context.TouristAttractionOwners
                                  .Any(owner => owner.UserId == userId);

            return userExists;
        }


        public bool IsUserAdministrator(int userId)
        {
            var userExists = _context.Administrators
                .Any(admin => admin.UserId == userId);

            return userExists;
        }

        public bool IsUserTourist(int userId)
        {
            var userExists = _context.Tourists
                .Any(tourist => tourist.UserId == userId);

            return userExists;
        }
         public async Task<User> UpdateOrAddProfilePhoto(int userId, string profileImage)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                throw new Exception("User not found");
            }

            user.ProfileImage = profileImage;

            await _context.SaveChangesAsync();

            return _mapper.Map<User>(user);
        }

        public async Task<bool> UpdatePassword(int userId, string newPassword, string oldPassword)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                throw new Exception("User not found");
            }
            if (BCrypt.Net.BCrypt.Verify(oldPassword,user.Password))
            {
                user.Password = BCrypt.Net.BCrypt.HashPassword(newPassword);

                await _context.SaveChangesAsync();

                return true;
            }
            else
            {
                return false;
            }
        }

        public async Task<User> UpdateUserDetails(int userId, EditUserDetailsRequest editedUser)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                throw new Exception("User not found");
            }

            user.Email = editedUser.Email;
            user.FirstName = editedUser.FirstName;
            user.LastName = editedUser.LastName;
            user.ProfileImage = editedUser.ProfileImage;

            await _context.SaveChangesAsync();

            return _mapper.Map<User>(user);
        }

    }

}
