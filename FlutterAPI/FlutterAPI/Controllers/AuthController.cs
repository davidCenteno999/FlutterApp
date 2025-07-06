using FlutterAPI.Entities;
using FlutterAPI.Models;
using FlutterAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace FlutterAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController(InterfaceAuthService authService) : ControllerBase
    {

        

        [HttpPost("register")]
        public async Task<ActionResult<User>> Register(UserDto userDto)
        {
            var user = await authService.RegisterAsync(userDto);
            if (user == null)
            {
                return BadRequest("User registration failed.");
            }
            return Ok(user);

        }

        [HttpPost("login")]
        public async Task<ActionResult<string>> Login(UserDto userDto)
        {
            var token  = await authService.LoginAsync(userDto);
            if (string.IsNullOrEmpty(token))
            {
                return Unauthorized("Invalid credentials.");
            }
            return Ok(token);

        }

      
    }
}
