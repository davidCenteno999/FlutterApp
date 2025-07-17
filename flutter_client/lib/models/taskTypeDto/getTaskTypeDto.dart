
class Gettasktypedto {
  List<String> list_names;

  Gettasktypedto({
    required this.list_names,
  });

  factory Gettasktypedto.fromJson(Map<String, dynamic> json) {
    return Gettasktypedto(
      list_names: List<String>.from(json['list_names']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list_names': list_names,
    };
  }


}
