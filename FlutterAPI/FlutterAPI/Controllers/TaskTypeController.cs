using FlutterAPI.Data;
using FlutterAPI.Models.TaskTypeModel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace FlutterAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TaskTypeController(AppDbContext context) : ControllerBase
    {
       
        [HttpGet]
        public async Task<ActionResult<string>> GetAll()
        {
            var taskTypeNames = await context.TaskTypes
            .Select(t => t.Name)
            .ToListAsync();
            if (taskTypeNames == null || !taskTypeNames.Any())
            {
                return NotFound("No task types found.");
            }
            return Ok(taskTypeNames);


        }

        // POST api/<TaskTypeController>
        [HttpPost]
        public async Task<ActionResult> CreateTaskType(TaskTypeDto value)
        {
            if (value == null || string.IsNullOrEmpty(value.Name))
            {
                return BadRequest("Invalid task type data.");
            }
            var taskType = new Entities.TaskType
            {
               
                Name = value.Name
            };

            await context.AddAsync(taskType);
            await context.SaveChangesAsync();
            return Ok(taskType);
        }

        
    }
}
