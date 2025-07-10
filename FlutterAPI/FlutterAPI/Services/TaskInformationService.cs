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
                        UserName = task.User != null ? task.User.Username : "",
                        ListTypeTask = task.TaskTypes.Select(tt => tt.Name).ToList()
                    })
                    ;
                });
            
            return taskInformationDtos;
        }

        public Task<GetTaskInformationDto?> GetTaskInformationByIdAsync(Guid id)
        {
            throw new NotImplementedException();
        }

        public Task<List<GetTaskInformationDto>> GetTaskInformationByUserIdAsync(Guid userId)
        {
            throw new NotImplementedException();
        }

        public Task<bool> UpdateTaskInformationAsync(UpdateTaskInformationDto updateTaskInformationDto)
        {
            throw new NotImplementedException();
        }
    }
}
