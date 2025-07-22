using FlutterAPI.Entities;
using FlutterAPI.Models.TaskModel;

namespace FlutterAPI.Services
{
    public interface InterfaceTaskInformationService
    {
        Task<TaskInformation?> CreateTaskInformationAsync(CreateTaskInformationDto taskInformationDto);

        Task<List<GetTaskInformationDto?>> GetAllTaskInformationAsync();

        Task<GetTaskInformationDto?> GetTaskInformationByIdAsync(Guid id);

        Task<List<GetTaskInformationDto?>> GetTaskInformationByUserIdAsync(Guid userId);

        Task<bool> UpdateTaskInformationAsync(Guid id,UpdateTaskInformationDto updateTaskInformationDto);

        Task<bool> DeleteTaskInformationAsync(Guid id);

    }
}
