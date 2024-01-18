using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface ICountryService : ICRUDService<Model.Country, Model.SearchObjects.CountrySearchObject, Model.Requests.CountryCreateRequest, Model.Requests.CountryUpdateRequest>
    {
    }
}
