﻿using AutoMapper;
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
    public class AdministratorService : BaseCRUDService<Model.Administrator, Database.Administrator, AdministratorSearchObject, AdministratorCreateRequest, AdministratorUpdateRequest>, IAdministratorService
    {
        private readonly IUserService _userService; // Injects the user service to handle user creation
        public AdministratorService(DiscoverHSCountryContext context, IMapper mapper, IUserService userService) : base(context, mapper)
        {
            _userService = userService;
        }
        public async Task<Database.Administrator> InsertAdministratorWithUserDetails(AdministratorCreateRequest administratorCreateRequest)
        {
            Database.Administrator administrator;
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var user = new UserCreateRequest
                    {
                        Email = administratorCreateRequest.Email,
                        FirstName = administratorCreateRequest.FirstName,
                        LastName = administratorCreateRequest.LastName,
                        ProfileImage = administratorCreateRequest.ProfileImage,
                    };
                    // Hash the password using bcrypt
                    string hashedPassword = BCrypt.Net.BCrypt.HashPassword(administratorCreateRequest.Password);
                    user.Password = hashedPassword;
                    Model.User createdUser = await _userService.Insert(user);
                    await _context.SaveChangesAsync();

                    administrator = new Administrator
                    {
                        UserId = createdUser.UserId
                    };

                    _context.Administrators.Add(administrator);
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
            return administrator;
        }
        public async Task<int?> ReturnUserIdByAdministratorIdAsync(int id)
        {
            Model.Administrator administrator = await base.GetById(id);
            return administrator?.UserId;
        }


        public override async Task<Model.Administrator> Delete(int id)
        {
            int userId = (int)await ReturnUserIdByAdministratorIdAsync(id);

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

        public int GetAdministratorIdByUserId(int userId)
        {
            var admin = _context.Administrators.FirstOrDefault(t => t.UserId == userId);
            return admin.AdministratorId;
        }
        
    }
}
