namespace FlutterAPI.Entities
{
    public class TaskInformation
    {
        public Guid Id { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        public string ImageId { get; set; } = string.Empty;

        public string ImageUrl { get; set; } = string.Empty;

        public ICollection<TaskType> TaskTypes { get; set; } = new List<TaskType>();

        public Guid UserId { get; set; }

        public User? User { get; set; }

    }
}
