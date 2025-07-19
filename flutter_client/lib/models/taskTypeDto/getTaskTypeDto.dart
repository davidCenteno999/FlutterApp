
class Gettasktypedto {
  List<String> list_names;

  Gettasktypedto({
    required this.list_names,
  });

  factory Gettasktypedto.fromJson(List<dynamic> json) {
    return Gettasktypedto(
      list_names: List<String>.from(json.map((item) => item.toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list_names': list_names,
    };
  }


}
