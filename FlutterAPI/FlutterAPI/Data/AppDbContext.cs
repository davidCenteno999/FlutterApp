using FlutterAPI.Entities;
using Microsoft.EntityFrameworkCore;

namespace FlutterAPI.Data
{
    public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
    {
        //This line of code defines a DbSet for the User entity, allowing Entity Framework Core to manage the User table in the database.
        public DbSet<User> Users { get; set; }
   
    }
}
