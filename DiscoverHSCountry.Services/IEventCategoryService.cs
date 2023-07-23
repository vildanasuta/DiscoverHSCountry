using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IEventCategoryService: ICRUDService<Model.EventCategory, Model.SearchObjects.EventCategorySearchObject, Model.Requests.EventCategoryCreateRequest, Model.Requests.EventCategoryUpdateRequest>
    {
    }
}
