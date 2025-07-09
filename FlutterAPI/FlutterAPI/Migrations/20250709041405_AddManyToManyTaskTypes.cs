using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FlutterAPI.Migrations
{
    /// <inheritdoc />
    public partial class AddManyToManyTaskTypes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "TaskInformationTaskType",
                columns: table => new
                {
                    TaskTypesId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    TasksId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TaskInformationTaskType", x => new { x.TaskTypesId, x.TasksId });
                    table.ForeignKey(
                        name: "FK_TaskInformationTaskType_TaskTypes_TaskTypesId",
                        column: x => x.TaskTypesId,
                        principalTable: "TaskTypes",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_TaskInformationTaskType_Tasks_TasksId",
                        column: x => x.TasksId,
                        principalTable: "Tasks",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_TaskInformationTaskType_TasksId",
                table: "TaskInformationTaskType",
                column: "TasksId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TaskInformationTaskType");
        }
    }
}
