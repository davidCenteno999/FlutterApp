using FlutterAPI.Data;
using FlutterAPI.Entities;
using FlutterAPI.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace FlutterAPI.Services
{
    public class AuthService(AppDbContext context, IConfiguration configuration) : InterfaceAuthService
    {
        public string GenerateToken(User user)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email)
            };

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(configuration.GetValue<string>("AppSettings:Token")!));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512);

            var tokenDescriptor = new JwtSecurityToken(
                issuer: configuration.GetValue<string>("AppSettings: Issuer"),
                audience: configuration.GetValue<string>("AppSettings: Audience"),
                claims: claims,
                expires: DateTime.UtcNow.AddDays(1),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(tokenDescriptor);
        }

        public async Task<string?> LoginAsync(UserDto userDto)
        {
            if (userDto == null || string.IsNullOrEmpty(userDto.Email) || string.IsNullOrEmpty(userDto.Password))
            {
                return null; // Invalid input
            }

            var user = await context.Users
                .FirstOrDefaultAsync(u => u.Email == userDto.Email);
            if (user == null)
            {
                return null; // User not found
            }


            // Simulate checking the user credentials
            if (user.Email == userDto.Email && new PasswordHasher<User>().VerifyHashedPassword(user, user.PasswordHash, userDto.Password) == PasswordVerificationResult.Success)
            {
                return GenerateToken(user);
                
            }
            else
            {
                return null; // Invalid credentials
            }
        }

        public async Task<User?> RegisterAsync(UserDto userDto)
        {
            if (await context.Users.AnyAsync(u => u.Email == userDto.Email))
            {
               return null; // User with this email already exists
            }

            var user = new User();

            var hashedPassword = new PasswordHasher<User>().HashPassword(user, userDto.Password);

            user.Username = userDto.Username;
            user.PasswordHash = hashedPassword;
            user.Email = userDto.Email;
            
            context.Users.Add(user);

            await context.SaveChangesAsync();

            return user;


        }
    }
}
