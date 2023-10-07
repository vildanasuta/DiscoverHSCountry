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
    public class ServiceService : BaseCRUDService<Model.Service, Database.Service, ServiceSearchObject, ServiceCreateRequest, ServiceUpdateRequest>, IServiceService
    {
        public ServiceService(DiscoverHSCountryContext context, IMapper mapper) : base(context, mapper)
        {
        }
        public async Task<List<Database.Service>> GetServicesByLocationId(int locationId)
        {
            var services = await _context.Services
                .Where(s => s.LocationId == locationId)
                .ToListAsync();

            return services;
        }
    }
}
