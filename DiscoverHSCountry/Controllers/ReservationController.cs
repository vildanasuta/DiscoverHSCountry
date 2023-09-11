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
        private readonly IReservationService _reservationService;
        public ReservationController(ILogger<BaseController<Reservation, ReservationSearchObject>> logger, IReservationService service) : base(logger, service)
        {
            _reservationService = service;
        }

        [HttpGet("GetReservationByLocationId/{locationId}")]
        public async Task<IActionResult> GetReservationsByLocationAsync(int locationId)
        {
            var reservations = await _reservationService.GetReservationsByLocationIdAsync(locationId);

            if (reservations == null || reservations.Count== 0)
            {
                return Ok(new List<Reservation>());
            }

            return Ok(reservations);
        }
    }
}
