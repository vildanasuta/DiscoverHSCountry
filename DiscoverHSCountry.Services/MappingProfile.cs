using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public class MappingProfile:Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.User, Model.User>();
            CreateMap<Model.Requests.UserCreateRequest, Database.User>();
            CreateMap<Model.Requests.UserUpdateRequest, Database.User>();

            CreateMap<Database.Tourist, Model.Tourist>();
            CreateMap<Model.Requests.TouristCreateRequest, Database.Tourist>();
            CreateMap<Model.Requests.TouristUpdateRequest, Database.Tourist>();

        }
    }
}
