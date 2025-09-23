// To parse this JSON data, do
//
//     final purchaseOrderOptionsResponse = purchaseOrderOptionsResponseFromMap(jsonString);

import 'dart:convert';

import 'package:textile_po/models/in_process_model.dart';

PurchaseOrderOptionsResponse purchaseOrderOptionsResponseFromMap(String str) =>
    PurchaseOrderOptionsResponse.fromMap(json.decode(str));

String purchaseOrderOptionsResponseToMap(PurchaseOrderOptionsResponse data) =>
    json.encode(data.toMap());

class PurchaseOrderOptionsResponse {
  String code;
  String message;
  PurchaseOptionsModel data;

  PurchaseOrderOptionsResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory PurchaseOrderOptionsResponse.fromMap(Map<String, dynamic> json) =>
      PurchaseOrderOptionsResponse(
        code: json["code"],
        message: json["message"],
        data: PurchaseOptionsModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class PurchaseOptionsModel {
  List<Design> designs;
  List<Party> parties;
  List<FirmId> firms;
  List<MovedBy> users;

  PurchaseOptionsModel({
    required this.designs,
    required this.parties,
    required this.firms,
    required this.users,
  });

  factory PurchaseOptionsModel.fromMap(Map<String, dynamic> json) =>
      PurchaseOptionsModel(
        designs: List<Design>.from(
          json["designs"].map((x) => Design.fromMap(x)),
        ),
        parties: List<Party>.from(json["parties"].map((x) => Party.fromMap(x))),
        firms: List<FirmId>.from(json["firms"].map((x) => FirmId.fromMap(x))),
        users: List<MovedBy>.from(json["users"].map((x) => MovedBy.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
    "designs": List<dynamic>.from(designs.map((x) => x.toMap())),
    "parties": List<dynamic>.from(parties.map((x) => x.toMap())),
    "firms": List<dynamic>.from(firms.map((x) => x.toMap())),
    "users": List<dynamic>.from(users.map((x) => x.toMap())),
  };
}

class Design {
  String id;
  String designName;
  String designNumber;
  String designImage;

  Design({
    required this.id,
    required this.designName,
    required this.designNumber,
    required this.designImage,
  });

  factory Design.fromMap(Map<String, dynamic> json) => Design(
    id: json["_id"],
    designName: json["designName"],
    designNumber: json["designNumber"],
    designImage: json["designImage"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "designName": designName,
    "designNumber": designNumber,
    "designImage": designImage,
  };
}

class Party {
  String id;
  String partyName;
  String partyNumber;
  String? mobile;

  Party({
    required this.id,
    required this.partyName,
    required this.partyNumber,
    required this.mobile,
  });

  factory Party.fromMap(Map<String, dynamic> json) => Party(
    id: json["_id"],
    partyName: json["partyName"],
    partyNumber: json["partyNumber"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "partyName": partyName,
    "partyNumber": partyNumber,
    "mobile": mobile,
  };
}
