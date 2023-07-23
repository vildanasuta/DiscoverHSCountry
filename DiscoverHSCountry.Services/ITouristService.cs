using DiscoverHSCountry.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ITouristService: ICRUDService<Model.Tourist, Model.SearchObjects.TouristSearchObject, Model.Requests.TouristCreateRequest, Model.Requests.TouristUpdateRequest>
    {
        public Task<Database.Tourist> InsertTouristWithUserDetails(TouristCreateRequest touristCreateRequest);

    }
}
