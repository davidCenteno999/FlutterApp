using FlutterAPI.Entities;
using FlutterAPI.Models;

namespace FlutterAPI.Services
{
    public interface InterfaceAuthService
    {
        Task<User?> RegisterAsync(UserDto userDto);
        Task<string?> LoginAsync(UserDto userDto);
       
    }
}
