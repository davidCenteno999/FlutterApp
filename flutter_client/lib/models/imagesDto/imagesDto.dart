class ImagesDto {
  final String id;
  final String url;

  ImagesDto({required this.id, required this.url});

  factory ImagesDto.fromJson(Map<String, dynamic> json) {
    return ImagesDto(
      id: json['public_id'],
      url: json['secure_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}