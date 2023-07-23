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

            CreateMap<Database.Administrator, Model.Administrator>();
            CreateMap<Model.Requests.AdministratorCreateRequest, Database.Administrator>();
            CreateMap<Model.Requests.AdministratorUpdateRequest, Database.Administrator>();

            CreateMap<Database.TouristAttractionOwner, Model.TouristAttractionOwner>();
            CreateMap<Model.Requests.TouristAttractionOwnerCreateRequest, Database.TouristAttractionOwner>();
            CreateMap<Model.Requests.TouristAttractionOwnerUpdateRequest, Database.TouristAttractionOwner>();

            CreateMap<Database.City, Model.City>();
            CreateMap<Model.Requests.CityCreateRequest, Database.City>();
            CreateMap<Model.Requests.CityUpdateRequest, Database.City>();

            CreateMap<Database.Event, Model.Event>();
            CreateMap<Model.Requests.EventCreateRequest, Database.Event>();
            CreateMap<Model.Requests.EventUpdateRequest, Database.Event>();

            CreateMap<Database.EventLocation, Model.EventLocation>();
            CreateMap<Model.Requests.EventLocationCreateRequest, Database.EventLocation>();
            CreateMap<Model.Requests.EventLocationUpdateRequest, Database.EventLocation>();

            CreateMap<Database.EventCategory, Model.EventCategory>();
            CreateMap<Model.Requests.EventCategoryCreateRequest, Database.EventCategory>();
            CreateMap<Model.Requests.EventCategoryUpdateRequest, Database.EventCategory>();

        }
    }
}
