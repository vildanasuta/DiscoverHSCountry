using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IHistoricalEventService : ICRUDService<Model.HistoricalEvent, Model.SearchObjects.HistoricalEventSearchObject, Model.Requests.HistoricalEventCreateRequest, Model.Requests.HistoricalEventUpdateRequest>
    {
    }
}
