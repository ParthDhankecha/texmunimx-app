class RolesModel {
  int id;
  String type;

  RolesModel({required this.id, required this.type});

  factory RolesModel.fromMap(Map<String, dynamic> json) =>
      RolesModel(id: json["id"], type: json["type"]);

  Map<String, dynamic> toMap() => {"id": id, "type": type};
}
