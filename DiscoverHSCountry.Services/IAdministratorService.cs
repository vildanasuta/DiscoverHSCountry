using DiscoverHSCountry.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public interface IAdministratorService: ICRUDService<Model.Administrator, Model.SearchObjects.AdministratorSearchObject, Model.Requests.AdministratorCreateRequest, Model.Requests.AdministratorUpdateRequest>
    {
        public Task<Database.Administrator> InsertAdministratorWithUserDetails(AdministratorCreateRequest administratorCreateRequest);
        public int GetAdministratorIdByUserId(int userId);
    }
}
