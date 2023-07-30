using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IServiceService : ICRUDService<Model.Service, Model.SearchObjects.ServiceSearchObject, Model.Requests.ServiceCreateRequest, Model.Requests.ServiceUpdateRequest>
    {
    }
}
