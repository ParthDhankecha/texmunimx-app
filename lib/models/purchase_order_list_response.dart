// To parse this JSON data, do
//
//     final purchaseOrderListResponse = purchaseOrderListResponseFromMap(jsonString);

import 'dart:convert';

PurchaseOrderListResponse purchaseOrderListResponseFromMap(String str) =>
    PurchaseOrderListResponse.fromMap(json.decode(str));

String purchaseOrderListResponseToMap(PurchaseOrderListResponse data) =>
    json.encode(data.toMap());

class PurchaseOrderListResponse {
  String code;
  String message;
  PurchaseOrderListModel data;

  PurchaseOrderListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory PurchaseOrderListResponse.fromMap(Map<String, dynamic> json) =>
      PurchaseOrderListResponse(
        code: json["code"],
        message: json["message"],
        data: PurchaseOrderListModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class PurchaseOrderListModel {
  List<PurchaseOrderModel> list;
  int totalCount;

  PurchaseOrderListModel({required this.list, required this.totalCount});

  factory PurchaseOrderListModel.fromMap(Map<String, dynamic> json) =>
      PurchaseOrderListModel(
        list: List<PurchaseOrderModel>.from(
          json["list"].map((x) => PurchaseOrderModel.fromMap(x)),
        ),
        totalCount: json["totalCount"],
      );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
    "totalCount": totalCount,
  };
}

class PurchaseOrderModel {
  String id;
  double panna;
  String partyPoNumber;
  String poNumber;
  String process;
  List<DesignId> designId;
  List<PartyId> partyId;
  int quantity;
  double rate;
  int pending;
  bool isCompleted;
  dynamic completedAt;
  DateTime? deliveryDate;
  bool? isHighPriority;
  String createdBy;
  String workspaceId;
  DateTime createdAt;
  DateTime updatedAt;

  PurchaseOrderModel({
    required this.id,
    required this.panna,
    required this.partyPoNumber,
    required this.poNumber,
    required this.process,
    required this.designId,
    required this.partyId,
    required this.quantity,
    required this.rate,
    required this.pending,
    required this.isCompleted,
    required this.completedAt,
    required this.deliveryDate,
    required this.isHighPriority,
    required this.createdBy,
    required this.workspaceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PurchaseOrderModel.fromMap(Map<String, dynamic> json) =>
      PurchaseOrderModel(
        id: json["_id"],
        panna: double.parse(json["panna"].toString()),
        partyPoNumber: json["partyPoNumber"],
        poNumber: json["poNumber"],
        process: json["process"],
        designId: List<DesignId>.from(
          json["designId"].map((x) => DesignId.fromMap(x)),
        ),
        partyId: List<PartyId>.from(
          json["partyId"].map((x) => PartyId.fromMap(x)),
        ),
        quantity: json["quantity"],
        rate: double.parse(json["rate"].toString()),
        pending: json["pending"],
        isCompleted: json["isCompleted"],
        completedAt: json["completedAt"],
        deliveryDate: json["deliveryDate"] == null
            ? null
            : DateTime.parse(json["deliveryDate"]),
        isHighPriority: json["isHighPriority"],
        createdBy: json["createdBy"],
        workspaceId: json["workspaceId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "panna": panna,
    "partyPoNumber": partyPoNumber,
    "poNumber": poNumber,
    "process": process,
    "designId": List<dynamic>.from(designId.map((x) => x.toMap())),
    "partyId": List<dynamic>.from(partyId.map((x) => x.toMap())),
    "quantity": quantity,
    "rate": rate,
    "pending": pending,
    "isCompleted": isCompleted,
    "completedAt": completedAt,
    "deliveryDate": deliveryDate?.toIso8601String(),
    "isHighPriority": isHighPriority,
    "createdBy": createdBy,
    "workspaceId": workspaceId,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class DesignId {
  String id;
  String designName;
  String designNumber;
  String designImage;
  String workspaceId;

  DesignId({
    required this.id,
    required this.designName,
    required this.designNumber,
    required this.designImage,
    required this.workspaceId,
  });

  factory DesignId.fromMap(Map<String, dynamic> json) => DesignId(
    id: json["_id"],
    designName: json["designName"],
    designNumber: json["designNumber"],
    designImage: json["designImage"],
    workspaceId: json["workspaceId"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "designName": designName,
    "designNumber": designNumber,
    "designImage": designImage,
    "workspaceId": workspaceId,
  };
}

class PartyId {
  String id;
  String partyName;
  String partyNumber;

  PartyId({
    required this.id,
    required this.partyName,
    required this.partyNumber,
  });

  factory PartyId.fromMap(Map<String, dynamic> json) => PartyId(
    id: json["_id"],
    partyName: json["partyName"],
    partyNumber: json["partyNumber"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "partyName": partyName,
    "partyNumber": partyNumber,
  };
}
