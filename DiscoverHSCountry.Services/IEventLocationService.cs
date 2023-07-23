using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IEventLocationService : ICRUDService<Model.EventLocation, Model.SearchObjects.EventLocationSearchObject, Model.Requests.EventLocationCreateRequest, Model.Requests.EventLocationUpdateRequest>
    {

    }
}
