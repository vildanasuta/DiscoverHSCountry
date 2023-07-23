using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IEventService : ICRUDService<Model.Event, Model.SearchObjects.EventSearchObject, Model.Requests.EventCreateRequest, Model.Requests.EventUpdateRequest>
    {
    }
}
