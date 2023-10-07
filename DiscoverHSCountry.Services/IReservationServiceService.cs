using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IReservationServiceService : ICRUDService<Model.ReservationService, Model.SearchObjects.ReservationServiceSearchObject, Model.Requests.ReservationServiceCreateRequest, Model.Requests.ReservationServiceUpdateRequest>
    {
    }
}
