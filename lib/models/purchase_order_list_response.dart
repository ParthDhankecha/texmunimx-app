// To parse this JSON data, do
//
//     final purchaseOrderListResponse = purchaseOrderListResponseFromMap(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:texmunimx/models/in_process_model.dart';

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
        totalCount: json["totalCount"] ?? 0,
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
  String designId;
  String partyId;
  int quantity;
  double rate;
  int pending;
  bool isCompleted;
  dynamic completedAt;
  DateTime? deliveryDate;
  bool? isHighPriority;
  String? note;

  //in process
  InProcess? inProcess;
  //ready to dispatch
  ReadyToDispatch? readyToDispatch;

  //delivered
  Delivered? delivered;
  String createdBy;
  String workspaceId;
  DateTime createdAt;
  DateTime updatedAt;

  String orderType;
  bool isJobPo;
  JobUserClass? jobUser;
  Matching? matching;
  bool? isLocked;

  bool isMasterEntry;
  bool hideUposBtns;

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
    this.inProcess,
    this.readyToDispatch,
    this.delivered,

    this.orderType = '',
    this.isJobPo = false,
    this.jobUser,
    this.matching,
    this.note,
    this.isLocked,
    this.isMasterEntry = false,
    this.hideUposBtns = false,
  });

  factory PurchaseOrderModel.fromMap(Map<String, dynamic> json) {
    log('Parsing PurchaseOrderModel: ${json["_id"]}');
    log('hideUposBtns: ${json["hideUposBtns"]}');
    log('isMasterEntry: ${json["isMasterEntry"]}');
    log('-----------');
    return PurchaseOrderModel(
      id: json["_id"],
      panna: double.parse(json["panna"].toString()),
      partyPoNumber: json["partyPoNumber"],
      poNumber: json["poNumber"],
      process: json["process"],
      designId: json["designId"],
      partyId: json["partyId"],
      quantity: json["quantity"] ?? 0,
      rate: double.parse(json["rate"] ?? '0'),
      pending: json["pending"] ?? 0,
      isCompleted: json["isCompleted"],
      completedAt: json["completedAt"],
      deliveryDate: json["deliveryDate"] == null
          ? null
          : DateTime.parse(json["deliveryDate"]).toLocal(),
      isHighPriority: json["isHighPriority"],
      createdBy: json["createdBy"],
      workspaceId: json["workspaceId"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      inProcess: json["inProcess"] == null
          ? null
          : InProcess.fromMap(json["inProcess"]),
      readyToDispatch: json["readyToDispatch"] == null
          ? null
          : ReadyToDispatch.fromMap(json["readyToDispatch"]),

      delivered: json["delivered"] == null
          ? null
          : Delivered.fromMap(json["delivered"]),

      jobUser: json['jobUser'] == null
          ? null
          : json["jobUser"] is List
          ? null
          : JobUserClass.fromMap(json["jobUser"]),
      orderType: json["orderType"] ?? '',
      isJobPo: json["isJobPo"] ?? false,
      matching: json["matching"] == null
          ? null
          : Matching.fromMap(json["matching"]),
      note: json["note"] ?? '',
      isLocked: json["isLocked"] ?? false,
      isMasterEntry: json["isMasterEntry"] ?? false,
      hideUposBtns: json["hideUposBtns"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    "_id": id,
    "panna": panna,
    "partyPoNumber": partyPoNumber,
    "poNumber": poNumber,
    "process": process,
    "designId": designId,
    "partyId": partyId,
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
    "inProcess": inProcess?.toMap(),
    "readyToDispatch": readyToDispatch?.toMap(),
    "delivered": delivered?.toMap(),
    "orderType": orderType,
    "isJobPo": isJobPo,
    "jobUser": jobUser,
    "matching": matching?.toMap(),

    "isMasterEntry": isMasterEntry,
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
    workspaceId: json["workspaceId"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "designName": designName,
    "designNumber": designNumber,
    "designImage": designImage,
    "workspaceId": workspaceId,
  };
}

class JobUserClass {
  String userId;
  String firmId;
  int quantity;
  int pending;
  String remarks;
  int matchingNo;
  String id;

  JobUserClass({
    required this.userId,
    required this.firmId,
    required this.quantity,
    required this.pending,
    required this.remarks,
    required this.matchingNo,
    required this.id,
  });

  factory JobUserClass.fromMap(Map<String, dynamic> json) => JobUserClass(
    userId: json["userId"],
    firmId: json["firmId"],
    quantity: json["quantity"],
    pending: json["pending"],
    remarks: json["remarks"],
    matchingNo: json["matchingNo"],
    id: json["_id"],
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "firmId": firmId,
    "quantity": quantity,
    "pending": pending,
    "remarks": remarks,
    "matchingNo": matchingNo,
    "_id": id,
  };
}

class Matching {
  String id;
  int mid;
  String mLabel;
  int quantity;
  int pending;
  double? rate;

  Matching({
    required this.id,
    required this.mid,
    required this.mLabel,
    required this.quantity,
    required this.pending,
    this.rate,
  });

  factory Matching.fromMap(Map<String, dynamic> json) => Matching(
    id: json["_id"],
    mid: json["mid"],
    mLabel: json["mLabel"],
    quantity: json["quantity"],
    pending: json["pending"],
    rate: json["rate"] != null ? double.parse(json["rate"].toString()) : null,
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "mid": mid,
    "mLabel": mLabel,
    "quantity": quantity,
    "pending": pending,
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
