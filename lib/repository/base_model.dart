// To parse this JSON data, do
//
//     final baseModel = baseModelFromMap(jsonString);

import 'dart:convert';

BaseModel baseModelFromMap(String str) => BaseModel.fromMap(json.decode(str));

String baseModelToMap(BaseModel data) => json.encode(data.toMap());

class BaseModel {
  String code;
  String message;
  Data data;

  BaseModel({required this.code, required this.message, required this.data});

  factory BaseModel.fromMap(Map<String, dynamic> json) => BaseModel(
    code: json["code"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class Data {
  Data();

  factory Data.fromMap(Map<String, dynamic> json) => Data();

  Map<String, dynamic> toMap() => {};
}
