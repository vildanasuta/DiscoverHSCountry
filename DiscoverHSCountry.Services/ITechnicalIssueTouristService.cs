using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ITechnicalIssueTouristService : ICRUDService<Model.TechnicalIssueTourist, Model.SearchObjects.TechnicalIssueTouristSearchObject, Model.Requests.TechnicalIssueTouristCreateRequest, Model.Requests.TechnicalIssueTouristUpdateRequest>
    {
    }
}
