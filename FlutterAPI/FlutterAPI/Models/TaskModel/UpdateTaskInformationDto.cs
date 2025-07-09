namespace FlutterAPI.Models.TaskModel
{
    public class UpdateTaskInformationDto
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public List<string>? TaskTypes { get; set; }
    }
}
