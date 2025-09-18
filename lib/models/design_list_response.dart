// To parse this JSON DesignListModel, do
//
//     final designListResponse = designListResponseFromMap(jsonString);

import 'dart:convert';

DesignListResponse designListResponseFromMap(String str) =>
    DesignListResponse.fromMap(json.decode(str));

String designListResponseToMap(DesignListResponse designListModel) =>
    json.encode(designListModel.toMap());

class DesignListResponse {
  String code;
  String message;
  DesignListModel designListModel;

  DesignListResponse({
    required this.code,
    required this.message,
    required this.designListModel,
  });

  factory DesignListResponse.fromMap(Map<String, dynamic> json) =>
      DesignListResponse(
        code: json["code"],
        message: json["message"],
        designListModel: DesignListModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": designListModel.toMap(),
  };
}

class DesignListModel {
  List<DesignModel> list;
  int totalCount;
  String imgBaseUrl;

  DesignListModel({
    required this.list,
    required this.totalCount,
    required this.imgBaseUrl,
  });

  factory DesignListModel.fromMap(Map<String, dynamic> json) => DesignListModel(
    list: List<DesignModel>.from(
      json["list"].map((x) => DesignModel.fromMap(x)),
    ),
    totalCount: json["totalCount"],
    imgBaseUrl: json["imgBaseUrl"],
  );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
    "totalCount": totalCount,
    "imgBaseUrl": imgBaseUrl,
  };
}

class DesignModel {
  String id;
  String designName;
  String designNumber;
  String designImage;
  DateTime createdAt;
  DateTime updatedAt;

  DesignModel({
    required this.id,
    required this.designName,
    required this.designNumber,
    required this.designImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DesignModel.fromMap(Map<String, dynamic> json) => DesignModel(
    id: json["_id"],
    designName: json["designName"],
    designNumber: json["designNumber"],
    designImage: json["designImage"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "designName": designName,
    "designNumber": designNumber,
    "designImage": designImage,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
