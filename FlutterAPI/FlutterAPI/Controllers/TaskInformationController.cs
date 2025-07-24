using FlutterAPI.Entities;
using FlutterAPI.Models.TaskModel;
using FlutterAPI.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace FlutterAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TaskInformationController(InterfaceTaskInformationService taskInformationService) : ControllerBase
    {
        [Authorize]
        [HttpPost]
        public async Task<ActionResult<TaskInformation?>> CreateTaskInformationAsync(CreateTaskInformationDto taskInformationDto)
        {
            var taskInformation = await taskInformationService.CreateTaskInformationAsync(taskInformationDto);
            if (taskInformation == null)
            {
                return BadRequest("Task with this title already exists for the user.");
            }
            return Ok(taskInformation);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<GetTaskInformationDto?>> GetTaskInformationByIdAsync(Guid id)
        {
            var taskInformation = await taskInformationService.GetTaskInformationByIdAsync(id);
            if (taskInformation == null)
            {
                return NotFound("Task not found.");
            }
            return Ok(taskInformation);
        }

        [HttpGet("taskUser/{userId}")]
        public async Task<ActionResult<List<GetTaskInformationDto?>>> GetTaskInformationByUserIdAsync(Guid userId)
        {
            var taskInformationList = await taskInformationService.GetTaskInformationByUserIdAsync(userId);
            if (taskInformationList == null || !taskInformationList.Any())
            {
                return NotFound("No tasks found for this user.");
            }
            return Ok(taskInformationList);
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

        [HttpPut("{id}")]
        public async Task<ActionResult<bool>> UpdateTaskInformation(Guid id, UpdateTaskInformationDto updateTaskInformationDto)
        {
            
            var result = await taskInformationService.UpdateTaskInformationAsync(id, updateTaskInformationDto);
            if (!result)
            {
                return NotFound("Task not found or update failed.");
            }
            return Ok(result);
        }

        

    }


}
