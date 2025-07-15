using FlutterAPI.Data;
using FlutterAPI.Entities;
using FlutterAPI.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace FlutterAPI.Services
{
    public class AuthService(AppDbContext context, IConfiguration configuration) : InterfaceAuthService
    {

        public async Task<TokenResponseDto?> LoginAsync(LogInDto userDto)
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
                return await CreateTokenResponseAsync(user);

            }
            else
            {
                return null; // Invalid credentials
            }
        }

        private async Task<TokenResponseDto?> CreateTokenResponseAsync(User user)
        {
            return new TokenResponseDto
            {
                AccessToken = GenerateToken(user),
                RefreshToken = await GenerateAndSaveRefreshToken(user)
            };
            // Return the token response
        }

        public async Task<User?> RegisterAsync(RegisterDto userDto)
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
            user.Role = userDto.Role;
            
            context.Users.Add(user);

            await context.SaveChangesAsync();

            return user;


        }

        public async Task<TokenResponseDto?> RefreshTokenAsync(RefreshTokenRequestDto userDto)
        {
            var user = await ValidateRefreshTokenAsync(userDto);
            if (user == null)
            {
                return null; // Invalid refresh token
            }

            return await CreateTokenResponseAsync(user);

        }

        private async Task<User?> ValidateRefreshTokenAsync(RefreshTokenRequestDto userDto)
        {
            var user = await context.Users.FindAsync(userDto.UserId);
            if (user == null || user.RefreshToken != userDto.RefreshToken || user.RefreshTokenExpiryTime < DateTime.UtcNow)
            {
                return null; // Invalid refresh token
            }

            return user; // Valid user with valid refresh token
        }

        private string GenerateRefreshToken()
        {
            var randomNumber = new byte[32];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(randomNumber);
            }
            return Convert.ToBase64String(randomNumber);
        }

        private async Task<string>  GenerateAndSaveRefreshToken(User user)
        {
            var refreshToken = GenerateRefreshToken();
            user.RefreshToken = refreshToken;
            user.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7); // Set expiry time for the refresh token
            context.Users.Update(user);
            await context.SaveChangesAsync();
            return refreshToken;
        }


        private string GenerateToken(User user)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role)
            };

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("TOKEN")!));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512);

            var tokenDescriptor = new JwtSecurityToken(
                issuer: configuration.GetValue<string>("AppSettings:Issuer"),
                audience: configuration.GetValue<string>("AppSettings:Audience"),
                claims: claims,
                expires: DateTime.UtcNow.AddDays(1),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(tokenDescriptor);
        }

        public async Task<UserDto?> GetUserDataAsync(Guid userId)
        {
            var user = await context.Users.FindAsync(userId);
            if (user == null)
            {
                return null; // User not found
            }
            return new UserDto
            {
                Username = user.Username,
                Email = user.Email,
                Role = user.Role
            };
        }

       
    }
}
