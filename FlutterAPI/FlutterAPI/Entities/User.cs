﻿using FlutterAPI.Constants;

namespace FlutterAPI.Entities
{
    public class User
    {
        public Guid Id { get; set; } 
        public string Username { get; set; } = string.Empty;

        public string PasswordHash { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string Role { get; set; } = UserRoles.User; // Default role is User

        public string? RefreshToken { get; set; }

        public DateTime? RefreshTokenExpiryTime { get; set; }

        

    }
}
