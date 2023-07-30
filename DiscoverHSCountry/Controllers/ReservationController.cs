using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ReservationController : BaseCRUDController<Model.Reservation, Model.SearchObjects.ReservationSearchObject, Model.Requests.ReservationCreateRequest, Model.Requests.ReservationUpdateRequest>
    {
        public ReservationController(ILogger<BaseController<Reservation, ReservationSearchObject>> logger, IReservationService service) : base(logger, service)
        {
        }
    }
}
