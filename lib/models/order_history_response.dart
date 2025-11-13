// To parse this JSON data, do
//
//     final orderHistoryResponse = orderHistoryResponseFromMap(jsonString);

import 'dart:convert';
import 'dart:developer';

OrderHistoryResponse orderHistoryResponseFromMap(String str) =>
    OrderHistoryResponse.fromMap(json.decode(str));

String orderHistoryResponseToMap(OrderHistoryResponse data) =>
    json.encode(data.toMap());

class OrderHistoryResponse {
  String code;
  String message;
  OrderHistoryListModel data;

  OrderHistoryResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory OrderHistoryResponse.fromMap(Map<String, dynamic> json) =>
      OrderHistoryResponse(
        code: json["code"],
        message: json["message"],
        data: OrderHistoryListModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class OrderHistoryListModel {
  List<OrderHistory> orderHistory;

  OrderHistoryListModel({required this.orderHistory});

  factory OrderHistoryListModel.fromMap(Map<String, dynamic> json) =>
      OrderHistoryListModel(
        orderHistory: List<OrderHistory>.from(
          json["orderHistory"].map((x) => OrderHistory.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
    "orderHistory": List<dynamic>.from(orderHistory.map((x) => x.toMap())),
  };
}

class OrderHistory {
  int quantity;
  String firmId;
  String userId;
  String movedBy;
  String machineNo;
  dynamic remarks;
  String status;
  DateTime eventDate;
  String id;

  OrderHistory({
    required this.quantity,
    required this.firmId,
    required this.userId,
    required this.movedBy,
    required this.machineNo,
    required this.remarks,
    required this.status,
    required this.eventDate,
    required this.id,
  });

  factory OrderHistory.fromMap(Map<String, dynamic> json) => OrderHistory(
    quantity: json["quantity"],
    firmId: json["firmId"],
    userId: json["userId"],
    movedBy: json["movedBy"],
    machineNo: json["machineNo"],
    remarks: json["remarks"],
    status: json["status"],
    eventDate: DateTime.parse(json["eventDate"]),
    id: json["_id"],
  );

  Map<String, dynamic> toMap() => {
    "quantity": quantity,
    "firmId": firmId,
    "userId": userId,
    "movedBy": movedBy,
    "machineNo": machineNo,
    "remarks": remarks,
    "status": status,
    "eventDate": eventDate.toIso8601String(),
    "_id": id,
  };

  RemarksClass? get remarksDetails {
    if (remarks is Map<String, dynamic>) {
      try {
        return RemarksClass.fromMap(remarks as Map<String, dynamic>);
      } catch (e) {
        log('Error parsing remarks into RemarksClass: $e');
        return null;
      }
    }
    return null;
  }
}

class RemarksClass {
  int? panna;
  String? partyPoNumber;
  String? process;
  String? designId;
  String? partyId;
  bool? isHighPriority;
  String? orderType;
  DateTime? deliveryDate;
  String? createdBy;
  String? workspaceId;
  bool? isJobPo;
  String? poNumber;
  List<Matching>? matchings;
  List<HistoryJobUserModel>? jobUser;

  RemarksClass({
    this.panna,
    this.partyPoNumber,
    this.process,
    this.designId,
    this.partyId,
    this.isHighPriority,
    this.orderType,
    this.deliveryDate,
    this.createdBy,
    this.workspaceId,
    this.isJobPo,
    this.poNumber,
    this.matchings,
    this.jobUser,
  });

  factory RemarksClass.fromMap(Map<String, dynamic> json) {
    log('Order Remarks Details Map: $json');
    return RemarksClass(
      panna: json["panna"],
      partyPoNumber: json["partyPoNumber"],
      process: json["process"],
      designId: json["designId"],
      partyId: json["partyId"],
      isHighPriority: json["isHighPriority"],
      orderType: json["orderType"],
      deliveryDate: DateTime.parse(
        json["deliveryDate"] ?? DateTime.now().toIso8601String(),
      ),
      createdBy: json["createdBy"],
      workspaceId: json["workspaceId"],
      isJobPo: json["isJobPo"],
      poNumber: json["poNumber"],
      matchings: List<Matching>.from(
        json["matchings"].map((x) => Matching.fromMap(x)),
      ),
      jobUser: json["jobUser"] == null
          ? []
          : List<HistoryJobUserModel>.from(
              json["jobUser"]!.map((x) => HistoryJobUserModel.fromMap(x)),
            ),
    );
  }

  Map<String, dynamic> toMap() => {
    "panna": panna,
    "partyPoNumber": partyPoNumber,
    "process": process,
    "designId": designId,
    "partyId": partyId,
    "isHighPriority": isHighPriority,
    "orderType": orderType,
    "deliveryDate": "",
    "createdBy": createdBy,
    "workspaceId": workspaceId,
    "isJobPo": isJobPo,
    "poNumber": poNumber,
    "matchings": matchings == null
        ? []
        : List<dynamic>.from(matchings!.map((x) => x.toMap())),
    "jobUser": jobUser == null
        ? []
        : List<dynamic>.from(jobUser!.map((x) => x)),
  };
}

class Matching {
  int quantity;
  int pending;
  int rate;
  List<dynamic>? colors;
  int? mid;
  String? id;
  List<Delivered>? inProcess;
  List<Delivered>? readyToDispatch;
  List<Delivered>? delivered;
  String? mLabel;

  Matching({
    required this.quantity,
    required this.pending,
    required this.rate,
    this.colors,
    this.mid,
    this.id,
    this.inProcess,
    this.readyToDispatch,
    this.delivered,
    this.mLabel,
  });

  factory Matching.fromMap(Map<String, dynamic> json) => Matching(
    quantity: json["quantity"],
    pending: json["pending"],
    rate: json["rate"],
    colors: json["colors"] == null
        ? []
        : List<dynamic>.from(json["colors"]!.map((x) => x)),
    mid: json["mid"],
    id: json["_id"],
    inProcess: json["inProcess"] == null
        ? []
        : List<Delivered>.from(
            json["inProcess"]!.map((x) => Delivered.fromMap(x)),
          ),
    readyToDispatch: json["readyToDispatch"] == null
        ? []
        : List<Delivered>.from(
            json["readyToDispatch"]!.map((x) => Delivered.fromMap(x)),
          ),
    delivered: json["delivered"] == null
        ? []
        : List<Delivered>.from(
            json["delivered"]!.map((x) => Delivered.fromMap(x)),
          ),
    mLabel: json["mLabel"],
  );

  Map<String, dynamic> toMap() => {
    "quantity": quantity,
    "pending": pending,
    "rate": rate,
    "colors": colors == null ? [] : List<dynamic>.from(colors!.map((x) => x)),
    "mid": mid,
    "_id": id,
    "inProcess": inProcess == null
        ? []
        : List<dynamic>.from(inProcess!.map((x) => x.toMap())),
    "readyToDispatch": readyToDispatch == null
        ? []
        : List<dynamic>.from(readyToDispatch!.map((x) => x.toMap())),
    "delivered": delivered == null
        ? []
        : List<dynamic>.from(delivered!.map((x) => x.toMap())),
    "mLabel": mLabel,
  };
}

class Delivered {
  int quantity;
  String firmId;
  String userId;
  String movedBy;
  String machineNo;
  String remarks;
  String refId;
  String id;
  DateTime movedOn;

  Delivered({
    required this.quantity,
    required this.firmId,
    required this.userId,
    required this.movedBy,
    required this.machineNo,
    required this.remarks,
    required this.refId,
    required this.id,
    required this.movedOn,
  });

  factory Delivered.fromMap(Map<String, dynamic> json) => Delivered(
    quantity: json["quantity"],
    firmId: json["firmId"],
    userId: json["userId"],
    movedBy: json["movedBy"],
    machineNo: json["machineNo"],
    remarks: json["remarks"],
    refId: json["refId"],
    id: json["_id"],
    movedOn: DateTime.parse(json["movedOn"]),
  );

  Map<String, dynamic> toMap() => {
    "quantity": quantity,
    "firmId": firmId,
    "userId": userId,
    "movedBy": movedBy,
    "machineNo": machineNo,
    "remarks": remarks,
    "refId": refId,
    "_id": id,
    "movedOn": movedOn.toIso8601String(),
  };
}

class HistoryJobUserModel {
  String userId;
  String firmId;
  int quantity;
  int pending;
  String remarks;
  String matchingNo;
  String id;
  String uid;

  HistoryJobUserModel({
    required this.userId,
    required this.firmId,
    required this.quantity,
    required this.pending,
    required this.remarks,
    required this.matchingNo,
    required this.id,
    required this.uid,
  });

  factory HistoryJobUserModel.fromMap(Map<String, dynamic> json) {
    log('Order Remarks Details: $json');
    return HistoryJobUserModel(
      userId: json["userId"] ?? '',
      firmId: json["firmId"] ?? '',
      quantity: json["quantity"] ?? 0,
      pending: json["pending"] ?? 0,
      remarks: json["remarks"] ?? '',
      matchingNo: json["matchingNo"] ?? '',
      id: json["_id"] ?? '',
      uid: json["uid"] ?? '',
    );
  }
}
