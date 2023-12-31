﻿using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using DiscoverHSCountry.Services.RabbitMQ;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using RabbitMQ.Client;

namespace DiscoverHSCountry.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class ReservationController : BaseCRUDController<Model.Reservation, Model.SearchObjects.ReservationSearchObject, Model.Requests.ReservationCreateRequest, Model.Requests.ReservationUpdateRequest>
    {
        private readonly IReservationService _reservationService;
        private readonly IRabbitMQProducer _rabbitMQProducer;
        public ReservationController(
            ILogger<BaseController<Reservation, ReservationSearchObject>> logger,
            IReservationService service, IRabbitMQProducer rabitMQProducer
            ) : base(logger, service)
        {
            _reservationService = service;
            _rabbitMQProducer=rabitMQProducer;
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

        public class EmailModel
        {
            public string Sender { get; set; }
            public string Recipient { get; set; }
            public string Subject { get; set; }
            public string Content { get; set; }
        }

        [HttpPost("SendConfirmationEmail")]
        public IActionResult SendConfirmationEmail([FromBody] EmailModel emailModel)
        {
            try
            {
                _rabbitMQProducer.SendMessage(emailModel);
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
