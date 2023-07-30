using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IReservationService : ICRUDService<Model.Reservation, Model.SearchObjects.ReservationSearchObject, Model.Requests.ReservationCreateRequest, Model.Requests.ReservationUpdateRequest>
    {
    }
}
