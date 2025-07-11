using FlutterAPI.Data;
using FlutterAPI.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Scalar.AspNetCore;
using System.Text;

DotNetEnv.Env.Load();

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Configuration.AddEnvironmentVariables();

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();


var connectionString = Environment.GetEnvironmentVariable("DB_CONNECTION_STRING")
    ?? throw new Exception("DB_CONNECTION_STRING no está definida");

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(connectionString));

var jwtToken = Environment.GetEnvironmentVariable("TOKEN")
    ?? throw new Exception("TOKEN no está definida");

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).
    AddJwtBearer(options =>
    {
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = builder.Configuration["AppSettings:Issuer"],
        ValidAudience = builder.Configuration["AppSettings:Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(jwtToken))
    };
});

builder.Services.AddScoped<InterfaceAuthService, AuthService>();
builder.Services.AddScoped<InterfaceTaskInformationService, TaskInformationService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
