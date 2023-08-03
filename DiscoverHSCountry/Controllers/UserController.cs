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

        // POST: api/users/login
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginRequest request)
        {
            var authenticationResponse = await _userService.AuthenticateUser(request.Email, request.Password);

            switch (authenticationResponse.Result)
            {
                case Util.AuthenticationResult.Success:
                    return Ok(new { UserId = authenticationResponse.UserId });
                case Util.AuthenticationResult.UserNotFound:
                    return BadRequest("User not found.");
                case Util.AuthenticationResult.InvalidPassword:
                    return BadRequest("Invalid password.");
                default:
                    return StatusCode(500, "An error occurred during authentication.");
            }
        }

    }
}
