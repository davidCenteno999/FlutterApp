using FlutterAPI.Models.TaskTypeModel;

namespace FlutterAPI.Models.TaskModel
{
    public class GetTaskInformationDto
    {
        public Guid Id { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public string ImageUrl { get; set; } = string.Empty;

        public string UserName { get; set; } = string.Empty;

        // Puedes incluir solo los nombres de los tipos o el ID + nombre

        public List<string>? ListTypeTask { get; set; }

    }
}
