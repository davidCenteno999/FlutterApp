using FlutterAPI.Entities;
using FlutterAPI.Models;
using FlutterAPI.Services;
using Microsoft.AspNetCore.Authorization;
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
        public async Task<ActionResult<User>> Register(RegisterDto userDto)
        {
            var user = await authService.RegisterAsync(userDto);
            if (user == null)
            {
                return BadRequest("User registration failed.");
            }
            return Ok(user);

        }

        [HttpPost("login")]
        public async Task<ActionResult<TokenResponseDto>> Login(LogInDto userDto)
        {
            var response = await authService.LoginAsync(userDto);
            if (response == null)
            {
                return Unauthorized("Invalid credentials.");
            }
            return Ok(response);
        }


        [HttpPost("refresh-token")]
        public async Task<ActionResult<TokenResponseDto>> RefreshToken(RefreshTokenRequestDto userDto)
        {
            var response = await authService.RefreshTokenAsync(userDto);
            if (response == null || response.RefreshToken == null || response.AccessToken == null)
            {
                return Unauthorized("Invalid refresh token.");
            }
            return Ok(response);
        }

        [Authorize]
        [HttpGet]
        public IActionResult AuthenticatedOnlyEndpoint()
        {
            return Ok("You are authenticated!");
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("admin")]
        public IActionResult AdminOnlyEndpoint()
        {
            return Ok("You are an admin!");

        }
    }
}
