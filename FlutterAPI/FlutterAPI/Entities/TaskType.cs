namespace FlutterAPI.Entities
{
    public class TaskType
    {
        public Guid Id { get; set; }
        public required string Name { get; set; }

        public ICollection<TaskInformation> Tasks { get; set; } = new List<TaskInformation>();
    }
}
