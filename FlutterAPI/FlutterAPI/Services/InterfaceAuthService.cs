using FlutterAPI.Entities;
using FlutterAPI.Models;

namespace FlutterAPI.Services
{
    public interface InterfaceAuthService
    {
        Task<User?> RegisterAsync(RegisterDto userDto);
        Task<TokenResponseDto?> LoginAsync(LogInDto userDto);
        Task<TokenResponseDto?> RefreshTokenAsync(RefreshTokenRequestDto userDto);
    }
}
