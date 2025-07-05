using FlutterAPI.Entities;
using Microsoft.EntityFrameworkCore;

namespace FlutterAPI.Data
{
    public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
    {
        public DbSet<User> Users { get; set; }
   
    }
}
