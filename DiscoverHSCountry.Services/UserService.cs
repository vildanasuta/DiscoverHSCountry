using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.Description;

namespace DiscoverHSCountry.Services
{

    public class UserService : BaseCRUDService<Model.User, Database.User, UserSearchObject, UserCreateRequest, UserUpdateRequest>, IUserService
    {
        public UserService(DiscoverHSCountryContext dbContext, IMapper mapper) : base(dbContext, mapper)
        {
        }

    }

}
