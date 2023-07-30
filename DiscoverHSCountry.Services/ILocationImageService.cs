using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ILocationImageService : ICRUDService<Model.LocationImage, Model.SearchObjects.LocationImageSearchObject, Model.Requests.LocationImageCreateRequest, Model.Requests.LocationImageUpdateRequest>
    {
    }
}
