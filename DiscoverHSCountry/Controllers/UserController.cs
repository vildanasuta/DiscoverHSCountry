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
        private readonly IUserService _userService;

        public UserController(ILogger<BaseController<User, UserSearchObject>> logger, IUserService service) : base(logger, service)
        {
            _userService = service;
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<Model.User> Insert(UserCreateRequest insert)
        {
            return _userService.Insert(insert);
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<User> Delete(int id)
        {
            return _userService.Delete(id);
        }

        [ApiExplorerSettings(IgnoreApi = true)]
        public override Task<User> Update(int id, [FromBody] UserUpdateRequest update)
        {
            return _userService.Update(id, update);
        }
    }
}
