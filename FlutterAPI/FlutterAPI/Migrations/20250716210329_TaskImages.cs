using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FlutterAPI.Migrations
{
    /// <inheritdoc />
    public partial class TaskImages : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ImageId",
                table: "Tasks",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ImageUrl",
                table: "Tasks",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ImageId",
                table: "Tasks");

            migrationBuilder.DropColumn(
                name: "ImageUrl",
                table: "Tasks");
        }
    }
}
