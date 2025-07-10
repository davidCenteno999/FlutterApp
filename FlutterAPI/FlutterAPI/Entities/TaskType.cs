using System.Text.Json.Serialization;

namespace FlutterAPI.Entities
{
    public class TaskType
    {
        public Guid Id { get; set; }
        public required string Name { get; set; }
        [JsonIgnore]
        public ICollection<TaskInformation> Tasks { get; set; } = new List<TaskInformation>();
    }
}
