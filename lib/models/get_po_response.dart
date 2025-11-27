// To parse this JSON data, do
//
//     final getPoResponse = getPoResponseFromMap(jsonString);

import 'dart:convert';

import 'package:texmunimx/models/sari_color_model.dart';

GetPoResponse getPoResponseFromMap(String str) =>
    GetPoResponse.fromMap(json.decode(str));

String getPoResponseToMap(GetPoResponse data) => json.encode(data.toMap());

class GetPoResponse {
  String code;
  String message;
  POModel data;

  GetPoResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory GetPoResponse.fromMap(Map<String, dynamic> json) => GetPoResponse(
    code: json["code"],
    message: json["message"],
    data: POModel.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class POModel {
  String id;
  int panna;
  String partyPoNumber;
  String poNumber;
  String process;
  String designId;
  String partyId;
  String note;
  bool isCompleted;
  dynamic completedAt;
  List<Matching2> matchings;
  String orderType;
  bool isJobPo;
  List<JobUser> jobUser;
  dynamic deliveryDate;
  bool isHighPriority;
  String createdBy;
  String workspaceId;
  DateTime createdAt;
  DateTime updatedAt;
  bool? isLocked;

  POModel({
    required this.id,
    required this.panna,
    required this.partyPoNumber,
    required this.poNumber,
    required this.process,
    required this.designId,
    required this.partyId,
    required this.note,
    required this.isCompleted,
    required this.completedAt,
    required this.matchings,
    required this.orderType,
    required this.isJobPo,
    required this.jobUser,
    required this.deliveryDate,
    required this.isHighPriority,
    required this.createdBy,
    required this.workspaceId,
    required this.createdAt,
    required this.updatedAt,
    this.isLocked,
  });

  factory POModel.fromMap(Map<String, dynamic> json) => POModel(
    id: json["_id"],
    panna: json["panna"],
    partyPoNumber: json["partyPoNumber"],
    poNumber: json["poNumber"],
    process: json["process"],
    designId: json["designId"],
    partyId: json["partyId"],
    note: json["note"],
    isCompleted: json["isCompleted"],
    completedAt: json["completedAt"],
    matchings: List<Matching2>.from(
      json["matchings"].map((x) => Matching2.fromMap(x)),
    ),
    orderType: json["orderType"],
    isJobPo: json["isJobPo"],
    jobUser: List<JobUser>.from(json["jobUser"].map((x) => JobUser.fromMap(x))),
    deliveryDate: json["deliveryDate"],
    isHighPriority: json["isHighPriority"],
    createdBy: json["createdBy"],
    workspaceId: json["workspaceId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    isLocked: json["isLocked"] ?? false,
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "panna": panna,
    "partyPoNumber": partyPoNumber,
    "poNumber": poNumber,
    "process": process,
    "designId": designId,
    "partyId": partyId,
    "note": note,
    "isCompleted": isCompleted,
    "completedAt": completedAt,
    "matchings": List<dynamic>.from(matchings.map((x) => x.toMap())),
    "orderType": orderType,
    "isJobPo": isJobPo,
    "jobUser": List<dynamic>.from(jobUser.map((x) => x.toMap())),
    "deliveryDate": deliveryDate,
    "isHighPriority": isHighPriority,
    "createdBy": createdBy,
    "workspaceId": workspaceId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class JobUser {
  String userId;
  String firmId;
  int quantity;
  int pending;
  String remarks;
  int matchingNo;
  String id;
  bool isLocked;
  int? colorNo;

  JobUser({
    required this.userId,
    required this.firmId,
    required this.quantity,
    required this.pending,
    required this.remarks,
    required this.matchingNo,
    required this.id,
    required this.isLocked,
    this.colorNo,
  });

  factory JobUser.fromMap(Map<String, dynamic> json) => JobUser(
    userId: json["userId"],
    firmId: json["firmId"],
    quantity: json["quantity"],
    pending: json["pending"],
    remarks: json["remarks"],
    matchingNo: json["matchingNo"],
    id: json["_id"],
    isLocked: json["isLocked"],
    colorNo: json["colorNo"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "firmId": firmId,
    "quantity": quantity,
    "pending": pending,
    "remarks": remarks,
    "matchingNo": matchingNo,
    "_id": id,
    "isLocked": isLocked,
    "colorNo": colorNo,
  };
}

class Matching2 {
  List<SariColorModel>? colors;
  double rate;
  int quantity;
  int pending;
  int mid;
  String mLabel;
  String id;
  bool? isLocked;

  Matching2({
    required this.colors,
    required this.rate,
    required this.quantity,
    required this.pending,
    required this.mid,
    required this.mLabel,
    required this.id,
    this.isLocked,
  });

  factory Matching2.fromMap(Map<String, dynamic> json) => Matching2(
    colors: json["colors"] != null
        ? List<SariColorModel>.from(
            json["colors"].map((x) => SariColorModel.fromMap(x)),
          )
        : null,
    rate: (json["rate"] as num).toDouble(),
    quantity: json["quantity"],
    pending: json["pending"],
    mid: json["mid"],
    mLabel: json["mLabel"],
    id: json["_id"],
    isLocked: json["isLocked"],
  );

  Map<String, dynamic> toMap() => {
    "colors": List<dynamic>.from(colors?.map((x) => x.toMap()) ?? []),
    "rate": rate,
    "quantity": quantity,
    "pending": pending,
    "mid": mid,
    "mLabel": mLabel,
    "_id": id,
  };
}
