using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RabbitMQ.Client;
using RabbitMQ.Service;

namespace DiscoverHSCountry.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class ReservationController : BaseCRUDController<Model.Reservation, Model.SearchObjects.ReservationSearchObject, Model.Requests.ReservationCreateRequest, Model.Requests.ReservationUpdateRequest>
    {
        private readonly IReservationService _reservationService;
        private readonly RabbitMQEmailProducer _rabbitMQEmailProducer;

        public ReservationController(
            ILogger<BaseController<Reservation, ReservationSearchObject>> logger,
            IReservationService service,
            RabbitMQEmailProducer rabbitMQEmailProducer) : base(logger, service)
        {
            _reservationService = service;
            _rabbitMQEmailProducer = rabbitMQEmailProducer;
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

        [HttpPost("SendConfirmationEmail")]
        public IActionResult SendConfirmationEmail([FromBody] EmailModel emailModel)
        {
            try
            {
                _rabbitMQEmailProducer.SendConfirmationEmail(emailModel);
                Thread.Sleep(TimeSpan.FromSeconds(15));
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }


    }
}
