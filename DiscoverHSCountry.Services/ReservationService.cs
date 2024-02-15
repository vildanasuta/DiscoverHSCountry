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

        public async Task<Model.Reservation> UpdateIsPaid(int id, bool isPaid)
        {
            var reservation = await base.GetById(id);

            if (reservation != null)
            {
                var updateRequest = new ReservationUpdateRequest
                {
                    TouristId = reservation.TouristId,
                    IsConfirmed = reservation.IsConfirmed,
                    IsPaid = isPaid,
                    Price = reservation.Price,
                    LocationId = reservation.LocationId,
                    PayPalPaymentId = reservation.PayPalPaymentId,
                };
                await base.Update(id, updateRequest);
            }
            return reservation;
        }

        public async Task<Model.Reservation> UpdateIsConfirmed(int id, bool isConfirmed)
        {
            var reservation = await base.GetById(id);

            if (reservation != null)
            {
                var updateRequest = new ReservationUpdateRequest
                {
                    TouristId = reservation.TouristId,
                    IsConfirmed = isConfirmed,
                    IsPaid = reservation.IsPaid,
                    Price = reservation.Price,
                    LocationId = reservation.LocationId,
                    PayPalPaymentId=reservation.PayPalPaymentId,
                };
                await base.Update(id, updateRequest);
            }
            return reservation;
        }

        public async Task<Model.Reservation> AddPayPalPaymentId(int id, string payPalPaymentId)
        {
            var reservation = await base.GetById(id);

            if (reservation != null)
            {
                var updateRequest = new ReservationUpdateRequest
                {
                    TouristId = reservation.TouristId,
                    IsConfirmed = reservation.IsConfirmed,
                    IsPaid = reservation.IsPaid,
                    Price = reservation.Price,
                    LocationId = reservation.LocationId,
                    PayPalPaymentId = payPalPaymentId,
                };
                await base.Update(id, updateRequest);
            }
            return reservation;
        }
    }
}
