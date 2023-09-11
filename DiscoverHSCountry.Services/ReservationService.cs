using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public class ReservationService : BaseCRUDService<Model.Reservation, Database.Reservation, ReservationSearchObject, ReservationCreateRequest, ReservationUpdateRequest>, IReservationService
    {
        public ReservationService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<List<Reservation>> GetReservationsByLocationIdAsync(int locationId)
        {
            return await _context.Reservations
                .Where(r => r.LocationId == locationId)
                .ToListAsync();
        }
    }
}
