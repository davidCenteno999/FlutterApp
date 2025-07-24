class GetTask {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String userName;
  final List<String> listTypeTask;

  GetTask({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.userName,
    required this.listTypeTask,
  });

  factory GetTask.fromJson(Map<String, dynamic> json) {
    return GetTask(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      userName: json['userName'] ?? '',
      listTypeTask: List<String>.from(json['listTypeTask'] ?? []),
    );
  }
  
  
}