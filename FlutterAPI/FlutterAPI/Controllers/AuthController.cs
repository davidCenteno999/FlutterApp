using FlutterAPI.Entities;
using FlutterAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace FlutterAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {

        public static User user = new();

        [HttpPost("register")]
        public ActionResult<User> Register(UserDto userDto)
        {
            if (userDto == null || string.IsNullOrEmpty(userDto.Username) || string.IsNullOrEmpty(userDto.Password) || string.IsNullOrEmpty(userDto.Email))
            {
                return BadRequest("Invalid user data.");
            }
            
            var hashedPassword = new PasswordHasher<User>().HashPassword(user, userDto.Password);

            user.Username = userDto.Username;
            user.PasswordHash = hashedPassword;
            user.Email = userDto.Email;
            // Simulate saving to a database
            // In a real application, you would use a service to handle database operations.
            return Ok(user);
        }

        [HttpPost("login")]
        public ActionResult<string> Login(UserDto userDto)
        {
            if (userDto == null || string.IsNullOrEmpty(userDto.Email) || string.IsNullOrEmpty(userDto.Password))
            {
                return BadRequest("Invalid login data.");
            }

            


            // Simulate checking the user credentials
            if (user.Email == userDto.Email && new PasswordHasher<User>().VerifyHashedPassword(user, user.PasswordHash, userDto.Password) == PasswordVerificationResult.Success)
            {
                return Ok("Login successful");
            }
            else
            {
                return BadRequest("Invalid email or password.");
            }
        }
    }
}
