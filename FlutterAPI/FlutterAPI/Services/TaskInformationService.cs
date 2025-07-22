using FlutterAPI.Data;
using FlutterAPI.Entities;
using FlutterAPI.Models.TaskModel;
using Microsoft.EntityFrameworkCore;

namespace FlutterAPI.Services
{
    public class TaskInformationService(AppDbContext context, IConfiguration configuration) : InterfaceTaskInformationService
    {
        public async  Task<TaskInformation?> CreateTaskInformationAsync(CreateTaskInformationDto taskInformationDto)
        {
            if (await context.Tasks.AnyAsync(t => t.Title == taskInformationDto.Title ))
            {
                return null; // Task with this title already exists for the user
            }

            List<TaskType> taskTypes = new List<TaskType>();
            foreach (var nameType in taskInformationDto.TaskTypesName)
            {
               
                var taskType = await context.TaskTypes.FirstOrDefaultAsync(t => t.Name == nameType);
                if (taskType != null)
                {
                    taskTypes.Add(taskType);
                }

            }
            
            var user = await context.Users.FindAsync(taskInformationDto.UserId);


            var taskInformation = new TaskInformation
            {
               
                Title = taskInformationDto.Title,
                Description = taskInformationDto.Description,
                ImageId = taskInformationDto.ImageId,
                ImageUrl = taskInformationDto.ImageUrl,
                TaskTypes = taskTypes,
                UserId = taskInformationDto.UserId,
                User = user
            };

            await context.Tasks.AddAsync(taskInformation);
            await context.SaveChangesAsync();

            return taskInformation;
        }

        public async Task<bool> DeleteTaskInformationAsync(Guid id)
        {
            var taskInformation = await context.FindAsync<TaskInformation>(id);

            if (taskInformation == null)
            {
                return false; // Task not found
            }

            context.Tasks.Remove(taskInformation);
            return await context.SaveChangesAsync() > 0; // Returns true if the task was successfully deleted


        }

        public async Task<List<GetTaskInformationDto?>> GetAllTaskInformationAsync()
        {
            List<GetTaskInformationDto?> taskInformationDtos = new List<GetTaskInformationDto?>();

            await context.Tasks
                .Include(t => t.User)
                .Include(t => t.TaskTypes)
                .ForEachAsync(task =>
                {
                    taskInformationDtos.Add(new GetTaskInformationDto
                    {
                        Id = task.Id,
                        Title = task.Title,
                        Description = task.Description,
                        ImageUrl = task.ImageUrl,
                        UserName = task.User != null ? task.User.Username : "",
                        ListTypeTask = task.TaskTypes.Select(tt => tt.Name).ToList()
                    })
                    ;
                });
            
            return taskInformationDtos;
        }

        public async Task<GetTaskInformationDto?> GetTaskInformationByIdAsync(Guid id)
        {
            TaskInformation? taskInformation = await context.Tasks
                .Include(t => t.User)
                .Include(t => t.TaskTypes)
                .FirstOrDefaultAsync(t => t.Id == id);

            if (taskInformation == null)
            {
                return null; // Task not found
            }

            return new GetTaskInformationDto
            {
                Id = taskInformation.Id,
                Title = taskInformation.Title,
                Description = taskInformation.Description,
                ImageUrl = taskInformation.ImageUrl,
                UserName = taskInformation.User != null ? taskInformation.User.Username : "",
                ListTypeTask = taskInformation.TaskTypes.Select(tt => tt.Name).ToList()
            };



        }

        public async Task<List<GetTaskInformationDto>> GetTaskInformationByUserIdAsync(Guid userId)
        {
            List<GetTaskInformationDto> taskInformationDtos = new List<GetTaskInformationDto>();

            await context.Tasks
                .Include(t => t.User)
                .Include(t => t.TaskTypes)
                .Where(t => t.UserId == userId )
                .ForEachAsync(task =>
                {
                    taskInformationDtos.Add(new GetTaskInformationDto
                    {
                        Id = task.Id,
                        Title = task.Title,
                        Description = task.Description,
                        ImageUrl = task.ImageUrl,
                        UserName = task.User != null ? task.User.Username : "",
                        ListTypeTask = task.TaskTypes.Select(tt => tt.Name).ToList()
                    });
                });

            return taskInformationDtos;
        }


        public async Task<bool> UpdateTaskInformationAsync(Guid id,UpdateTaskInformationDto updateTaskInformationDto)
        {
            var existingTask = await context.Tasks
                .Include(t=> t.TaskTypes)
                .FirstOrDefaultAsync(t => t.Id == id);
            if (existingTask == null){
                return false; // Task not found
            }

            if (updateTaskInformationDto == null)
            {
                return false;
            }
            if (updateTaskInformationDto.Title != "")
                existingTask.Title = updateTaskInformationDto.Title;
            if (updateTaskInformationDto.Description != "")
                existingTask.Description = updateTaskInformationDto.Description;
            if (updateTaskInformationDto.ImageUrl != "")
                existingTask.ImageUrl = updateTaskInformationDto.ImageUrl;
            
            if (updateTaskInformationDto.TaskTypes != null)
            {


                existingTask.TaskTypes.Clear();
                existingTask.TaskTypes = new List<TaskType>();
                foreach (var nameType in updateTaskInformationDto.TaskTypes)
                {
                    var taskType = await context.TaskTypes.FirstOrDefaultAsync(t => t.Name == nameType);
                    if (taskType != null)
                    {
                        existingTask.TaskTypes.Add(taskType);
                    }
                }
            }

            context.Tasks.Update(existingTask);
            return await context.SaveChangesAsync() > 0; // Returns true if the task was successfully updated

        }
    }
}
