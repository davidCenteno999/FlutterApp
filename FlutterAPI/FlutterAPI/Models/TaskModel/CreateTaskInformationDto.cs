using FlutterAPI.Entities;

namespace FlutterAPI.Models.TaskModel
{
    public class CreateTaskInformationDto
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;

        public string ImageId { get; set; } = string.Empty;

        public string ImageUrl { get; set; } = string.Empty;
        public Guid UserId { get; set; }

        public List<string> TaskTypesName { get; set; } = new List<string>();
    }
}
