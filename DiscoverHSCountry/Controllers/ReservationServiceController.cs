using DiscoverHSCountry.API.Controllers;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace DiscoverHSCountry.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class ReservationServiceController: BaseCRUDController<Model.ReservationService, Model.SearchObjects.ReservationServiceSearchObject, Model.Requests.ReservationServiceCreateRequest, Model.Requests.ReservationServiceUpdateRequest>
    {
        private readonly IReservationServiceService _reservationService;

        public ReservationServiceController(ILogger<BaseController<Model.ReservationService, ReservationServiceSearchObject>> logger, IReservationServiceService service) : base(logger, service)
        {
            _reservationService = service;
        }
    }
}
