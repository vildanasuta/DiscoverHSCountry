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
    public class LocationSubcategoryService : BaseCRUDService<Model.LocationSubcategory, Database.LocationSubcategory, LocationSubcategorySearchObject, LocationSubcategoryCreateRequest, LocationSubcategoryUpdateRequest>, ILocationSubcategoryService
    {
        ILocationCategoryService _locationCategoryService;
        public LocationSubcategoryService(DiscoverHSCountryContext context, IMapper mapper, ILocationCategoryService locationCategoryService) : base(context, mapper)
        {
            _locationCategoryService = locationCategoryService;
        }

        public async Task<List<Model.LocationSubcategory>> GetSubcategoriesByCategoryIdAsync(int categoryId)
        {
            var category = await _locationCategoryService.GetById(categoryId);

            if (category == null)
            {
                // Category not found, return an empty list
                return new List<Model.LocationSubcategory>();
            }

            var subcategories = await _context.LocationSubcategories
                .Where(subcategory => subcategory.LocationCategoryId == categoryId)
                .Select(subcategory => _mapper.Map<Model.LocationSubcategory>(subcategory))
                .ToListAsync();

            return subcategories;
        }
    }  
}
