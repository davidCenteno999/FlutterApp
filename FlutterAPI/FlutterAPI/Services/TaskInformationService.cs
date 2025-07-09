using FlutterAPI.Data;
using FlutterAPI.Entities;
using FlutterAPI.Models.TaskModel;

namespace FlutterAPI.Services
{
    public class TaskInformationService(AppDbContext context, IConfiguration configuration) : InterfaceTaskInformationService
    {
        public async  Task<TaskInformation>? CreateTaskInformationAsync(CreateTaskInformationDto taskInformationDto)
        {
            throw new NotImplementedException();
        }

        public Task<bool> DeleteTaskInformationAsync(Guid id)
        {
            throw new NotImplementedException();
        }

        public Task<List<GetTaskInformationDto>> GetAllTaskInformationAsync()
        {
            throw new NotImplementedException();
        }

        public Task<GetTaskInformationDto?> GetTaskInformationByIdAsync(Guid id)
        {
            throw new NotImplementedException();
        }

        public Task<List<GetTaskInformationDto>> GetTaskInformationByUserIdAsync(int userId)
        {
            throw new NotImplementedException();
        }

        public Task<bool> UpdateTaskInformationAsync(UpdateTaskInformationDto updateTaskInformationDto)
        {
            throw new NotImplementedException();
        }
    }
}
