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

            CreateMap<Database.HistoricalEvent, Model.HistoricalEvent>();
            CreateMap<Model.Requests.HistoricalEventCreateRequest, Database.HistoricalEvent>();
            CreateMap<Model.Requests.HistoricalEventUpdateRequest, Database.HistoricalEvent>();

            CreateMap<Database.Location, Model.Location>();
            CreateMap<Model.Requests.LocationCreateRequest, Database.Location>();
            CreateMap<Model.Requests.LocationUpdateRequest, Database.Location>();

            CreateMap<Database.LocationTouristAttractionOwner, Model.LocationTouristAttractionOwner>();
            CreateMap<Model.Requests.LocationTouristAttractionOwnerCreateRequest, Database.LocationTouristAttractionOwner>();
            CreateMap<Model.Requests.LocationTouristAttractionOwnerUpdateRequest, Database.LocationTouristAttractionOwner>();

            CreateMap<Database.LocationCategory, Model.LocationCategory>();
            CreateMap<Model.Requests.LocationCategoryCreateRequest, Database.LocationCategory>();
            CreateMap<Model.Requests.LocationCategoryUpdateRequest, Database.LocationCategory>();

            CreateMap<Database.LocationImage, Model.LocationImage>();
            CreateMap<Model.Requests.LocationImageCreateRequest, Database.LocationImage>();
            CreateMap<Model.Requests.LocationImageUpdateRequest, Database.LocationImage>();

            CreateMap<Database.LocationSubcategory, Model.LocationSubcategory>();
            CreateMap<Model.Requests.LocationSubcategoryCreateRequest, Database.LocationSubcategory>();
            CreateMap<Model.Requests.LocationSubcategoryUpdateRequest, Database.LocationSubcategory>();

            CreateMap<Database.Reservation, Model.Reservation>();
            CreateMap<Model.Requests.ReservationCreateRequest, Database.Reservation>();
            CreateMap<Model.Requests.ReservationUpdateRequest, Database.Reservation>();

            CreateMap<Database.Review, Model.Review>();
            CreateMap<Model.Requests.ReviewCreateRequest, Database.Review>();
            CreateMap<Model.Requests.ReviewUpdateRequest, Database.Review>();

            CreateMap<Database.Service, Model.Service>();
            CreateMap<Model.Requests.ServiceCreateRequest, Database.Service>();
            CreateMap<Model.Requests.ServiceUpdateRequest, Database.Service>();

            CreateMap<Database.TechnicalIssueOwner, Model.TechnicalIssueOwner>();
            CreateMap<Model.Requests.TechnicalIssueOwnerCreateRequest, Database.TechnicalIssueOwner>();
            CreateMap<Model.Requests.TechnicalIssueOwnerUpdateRequest, Database.TechnicalIssueOwner>();

            CreateMap<Database.TechnicalIssueTourist, Model.TechnicalIssueTourist>();
            CreateMap<Model.Requests.TechnicalIssueTouristCreateRequest, Database.TechnicalIssueTourist>();
            CreateMap<Model.Requests.TechnicalIssueTouristUpdateRequest, Database.TechnicalIssueTourist>();

            CreateMap<Database.VisitedLocation, Model.VisitedLocation>();
            CreateMap<Model.Requests.VisitedLocationCreateRequest, Database.VisitedLocation>();
            CreateMap<Model.Requests.VisitedLocationUpdateRequest, Database.VisitedLocation>();

            CreateMap<Database.VisitedLocationImage, Model.VisitedLocationImage>();
            CreateMap<Model.Requests.VisitedLocationImageCreateRequest, Database.VisitedLocationImage>();
            CreateMap<Model.Requests.VisitedLocationImageUpdateRequest, Database.VisitedLocationImage>();

            CreateMap<Database.PublicCityService, Model.PublicCityService>();
            CreateMap<Model.Requests.PublicCityServiceCreateRequest, Database.PublicCityService>();
            CreateMap<Model.Requests.PublicCityServiceUpdateRequest, Database.PublicCityService>();
        }
    }
}
