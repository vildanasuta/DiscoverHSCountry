using DiscoverHSCountry.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ITouristAttractionOwnerService : ICRUDService<Model.TouristAttractionOwner, Model.SearchObjects.TouristAttractionOwnerSearchObject, Model.Requests.TouristAttractionOwnerCreateRequest, Model.Requests.TouristAttractionOwnerUpdateRequest>
    {
        public Task<Database.TouristAttractionOwner> InsertTouristAttractionOwnerWithUserDetails(TouristAttractionOwnerCreateRequest touristAttractionOwnerCreateRequest);
        public int GetTouristAttractionOwnerIdByUserId(int userId);
    }
}
