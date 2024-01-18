using DiscoverHSCountry.Model;
using DiscoverHSCountry.Model.Requests;
using DiscoverHSCountry.Model.SearchObjects;
using DiscoverHSCountry.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Data;

namespace DiscoverHSCountry.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class UserController : BaseCRUDController<Model.User, Model.SearchObjects.UserSearchObject, Model.Requests.UserCreateRequest, Model.Requests.UserUpdateRequest>
    {
        private readonly IUserService _userService;
        private readonly ITouristAttractionOwnerService _touristAttractionOwnerService;
        private readonly IAdministratorService _administratorService;
        private readonly ITouristService _touristService;
        public UserController(ILogger<BaseController<User, UserSearchObject>> logger, IUserService service, ITouristAttractionOwnerService touristAttractionOwnerService, ITouristService touristService, IAdministratorService administratorService) : base(logger, service)
        {
            _userService = service;
            _touristAttractionOwnerService = touristAttractionOwnerService;
            _administratorService = administratorService;
            _touristService = touristService;
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
        [AllowAnonymous]
        public async Task<IActionResult> Login(LoginRequest request)
        {
            var authenticationResponse = await _userService.AuthenticateUser(request.Email, request.Password);
            String? userType;
            switch (authenticationResponse.Result)
            {
                case Util.AuthenticationResult.Success:
                    var userId = authenticationResponse.UserId;
                    if(_userService.IsUserTouristAttractionOwner((int)userId))
                    {
                        userType = "touristattractionowner";
                    }
                    else if(_userService.IsUserAdministrator((int)userId)) {
                        userType = "administrator";
                    }
                    else if(_userService.IsUserTourist((int)userId))
                    {
                        userType = "tourist";
                    }
                    else
                    {
                        userType = null;
                    }
                    if (userType != null) {
                        // Check if the user is a tourist and trying to access the desktop app
                        if (userType== "tourist" && request.DeviceType == "desktop")
                        {
                            return BadRequest("Tourists cannot use the desktop app.");
                        }
                        // Check if the user is a tourist attraction owner or administrator and trying to access the mobile app
                        if ((userType == "touristattractionowner" || userType == "administrator") && request.DeviceType == "mobile")
                        {
                            return BadRequest("Tourist Attraction Owners or Administrators cannot use the mobile app.");
                        } 
                    }
                    return Ok(new { UserId = authenticationResponse.UserId, UserType = userType, Token = authenticationResponse.Token });
                case Util.AuthenticationResult.UserNotFound:
                    return BadRequest("User not found.");
                case Util.AuthenticationResult.InvalidPassword:
                    return BadRequest("Invalid password.");
                default:
                    return StatusCode(500, "An error occurred during authentication.");
            }
        }
        [HttpPut("UpdateDetails/{userId}")]
        public async Task<IActionResult> UpdateUserDetails(int userId, [FromBody] EditUserDetailsRequest editedUser)
        {
            try
            {
                var updatedUser = await _userService.UpdateUserDetails(userId,editedUser);
                return Ok(updatedUser);
            }
            catch (Exception)
            {
                return StatusCode(500, "An error occurred while updating user details.");
            }
        }
        [HttpPut("UpdateProfilePhoto/{userId}")]
        public async Task<IActionResult> UpdateOrAddProfilePhoto(int userId)
        {
            try
            {
                var file = Request.Form.Files["profileImage"];
                if (file != null && file.Length > 0)
                {
                    using (var stream = new MemoryStream())
                    {
                        await file.CopyToAsync(stream);
                        var base64Image = Convert.ToBase64String(stream.ToArray());

                        await _userService.UpdateOrAddProfilePhoto(userId, base64Image);

                        return Ok("Profile image saved successfully.");
                    }
                }
                else
                {
                    return BadRequest("Profile image not found in the request.");
                }
            }
            catch (Exception)
            {
                return StatusCode(500, "An error occurred while updating profile photo.");
            }
        }


        [HttpPut("UpdatePassword/{userId}")]
        public async Task<IActionResult> UpdatePassword(int userId, [FromBody] PasswordUpdateRequest passwordUpdateRequest)
        {
            try
            {
                var success = await _userService.UpdatePassword(userId, passwordUpdateRequest.Password, passwordUpdateRequest.OldPassword);
                if (success)
                {
                    return Ok("Password updated successfully.");
                }
                return BadRequest("Password update failed.");
            }
            catch (Exception)
            {
                return StatusCode(500, "An error occurred while updating password.");
            }
        }

        [AllowAnonymous]
        [HttpGet("GetAllUsers")]
        public async Task<PagedResult<User>> GetAllUsers()
        {
            var list = await _userService.Get();
            return list;
        }

    }
}
