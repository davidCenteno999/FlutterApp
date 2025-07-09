using FlutterAPI.Entities;

namespace FlutterAPI.Models.TaskModel
{
    public class CreateTaskInformationDto
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public Guid UserId { get; set; }

        public List<Guid>? TaskTypesIds { get; set; }
    }
}
