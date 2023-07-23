using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : BaseCRUDController<Model.User, Model.SearchObjects.UserSearchObject, Model.Requests.UserCreateRequest, Model.Requests.UserUpdateRequest>
    {
        public UserController(ILogger<BaseController<User, UserSearchObject>> logger, IUserService service) : base(logger, service)
        {
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<Model.User> Insert(UserCreateRequest insert)
        {
            return base.Insert(insert);
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<User> Delete(int id)
        {
            return base.Delete(id);
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<User> Update(int id, [FromBody] UserUpdateRequest update)
        {
            return base.Update(id, update);
        }
    }
}
