using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IVisitedLocationService : ICRUDService<Model.VisitedLocation, Model.SearchObjects.VisitedLocationSearchObject, Model.Requests.VisitedLocationCreateRequest, Model.Requests.VisitedLocationUpdateRequest>
    {
    }
}
