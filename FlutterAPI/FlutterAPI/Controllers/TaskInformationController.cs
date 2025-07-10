using FlutterAPI.Entities;
using FlutterAPI.Models.TaskModel;
using FlutterAPI.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace FlutterAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TaskInformationController(InterfaceTaskInformationService taskInformationService) : ControllerBase
    {
        [HttpPost("create")]
        public async Task<ActionResult<TaskInformation?>> CreateTaskInformationAsync(CreateTaskInformationDto taskInformationDto)
        {
            var taskInformation = await taskInformationService.CreateTaskInformationAsync(taskInformationDto);
            if (taskInformation == null)
            {
                return BadRequest("Task with this title already exists for the user.");
            }
            return Ok(taskInformation);
        }

        [HttpGet("all")]
        public async Task<ActionResult<List<GetTaskInformationDto?>>> GetAllTaskInformationAsync()
        {
            var taskInformationList = await taskInformationService.GetAllTaskInformationAsync();
            if (taskInformationList == null || !taskInformationList.Any())
            {
                return NotFound("No tasks found.");
            }
            return Ok(taskInformationList);
        }

    }


}
