// To parse this JSON data, do
//
//     final firmListResponse = firmListResponseFromMap(jsonString);

import 'dart:convert';

FirmListResponse firmListResponseFromMap(String str) =>
    FirmListResponse.fromMap(json.decode(str));

String firmListResponseToMap(FirmListResponse data) =>
    json.encode(data.toMap());

class FirmListResponse {
  String code;
  String message;
  List<FirmModel> data;

  FirmListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory FirmListResponse.fromMap(Map<String, dynamic> json) =>
      FirmListResponse(
        code: json["code"],
        message: json["message"],
        data: List<FirmModel>.from(
          json["data"].map((x) => FirmModel.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class FirmModel {
  String id;
  String firmName;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  FirmModel({
    required this.id,
    required this.firmName,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FirmModel.fromMap(Map<String, dynamic> json) => FirmModel(
    id: json["_id"],
    firmName: json["firmName"],
    createdBy: CreatedBy.fromMap(json["createdBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "firmName": firmName,
    "createdBy": createdBy.toMap(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class CreatedBy {
  String id;
  String fullname;

  CreatedBy({required this.id, required this.fullname});

  factory CreatedBy.fromMap(Map<String, dynamic> json) =>
      CreatedBy(id: json["_id"], fullname: json["fullname"]);

  Map<String, dynamic> toMap() => {"_id": id, "fullname": fullname};
}
