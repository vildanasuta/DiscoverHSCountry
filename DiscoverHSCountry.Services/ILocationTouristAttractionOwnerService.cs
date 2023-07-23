using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ILocationTouristAttractionOwnerService: ICRUDService<Model.LocationTouristAttractionOwner, Model.SearchObjects.LocationTouristAttractionOwnerSearchObject, Model.Requests.LocationTouristAttractionOwnerCreateRequest, Model.Requests.LocationTouristAttractionOwnerUpdateRequest>
    {
    }
}
