class GetTask {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String username;
  final List<String> taskType;

  GetTask({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.username,
    required this.taskType,
  });

  factory GetTask.fromJson(Map<String, dynamic> json) {
    return GetTask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      username: json['username'],
      taskType: List<String>.from(json['taskType']),
    );
  }
  
  
}