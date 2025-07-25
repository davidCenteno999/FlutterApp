﻿using FlutterAPI.Constants;

namespace FlutterAPI.Models
{
    public class RegisterDto
    {
        public string Username { get; set; } = string.Empty;

        public string Password { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string Role { get; set; } = UserRoles.User; // Default role is User
    }
}
