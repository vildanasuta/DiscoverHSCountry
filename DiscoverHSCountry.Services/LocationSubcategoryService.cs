using AutoMapper;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public class LocationSubcategoryService : BaseCRUDService<Model.LocationSubcategory, Database.LocationSubcategory, LocationSubcategorySearchObject, LocationSubcategoryCreateRequest, LocationSubcategoryUpdateRequest>, ILocationSubcategoryService
    {
        ILocationCategoryService _locationCategoryService;
        public LocationSubcategoryService(DiscoverHSCountryContext context, IMapper mapper, ILocationCategoryService locationCategoryService) : base(context, mapper)
        {
            _locationCategoryService = locationCategoryService;
        }
    }
}
