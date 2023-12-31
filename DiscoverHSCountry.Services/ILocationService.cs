﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ILocationService : ICRUDService<Model.Location, Model.SearchObjects.LocationSearchObject, Model.Requests.LocationCreateRequest, Model.Requests.LocationUpdateRequest>
    {
        public Task<bool> ApproveLocationAsync(int locationId);
        public Task<bool> DeleteLocationByIdAsync(int locationId);
        public List<Database.Location> GetLocationsBySubcategoryId(int categoryId, int subcategoryId);


    }
}
