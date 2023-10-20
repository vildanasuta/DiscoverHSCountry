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
        private readonly RabbitMQEmailProducer _rabbitMQEmailProducer;
        private readonly EmailService _emailService;
        public ReservationController(ILogger<BaseController<Reservation, ReservationSearchObject>> logger, IReservationService service, RabbitMQEmailProducer rabbitMQEmailProducer, EmailService emailService) : base(logger, service)
        {
            _reservationService = service;
            _rabbitMQEmailProducer = rabbitMQEmailProducer;

            _emailService = emailService;
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
                _emailService.StartListening();
                return Ok();
            }
            catch (Exception ex)
            {

                return StatusCode(500, ex.Message);
            }
        }

    }
}
