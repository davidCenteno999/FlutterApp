class Createtaskdto {
  final String title;
  final String description;
  final String imageId;
  final String imageUrl;
  final String userId;
  final List<String> taskType;

  Createtaskdto({
    required this.title,
    required this.description,
    required this.imageId,
    required this.imageUrl,
    required this.userId,
    required this.taskType,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageId': imageId,
      'imageUrl': imageUrl,
      'userId': userId,
      'taskType': taskType,
    };
  }
}
