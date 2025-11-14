// To parse this JSON data, do
//
//     final partyListResponse = partyListResponseFromMap(jsonString);

import 'dart:convert';

PartyListResponse partyListResponseFromMap(String str) =>
    PartyListResponse.fromMap(json.decode(str));

String partyListResponseToMap(PartyListResponse data) =>
    json.encode(data.toMap());

class PartyListResponse {
  String code;
  String message;
  PartyListModel data;

  PartyListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory PartyListResponse.fromMap(Map<String, dynamic> json) =>
      PartyListResponse(
        code: json["code"],
        message: json["message"],
        data: PartyListModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class PartyListModel {
  List<PartyModel> list;
  int totalCount;

  PartyListModel({required this.list, required this.totalCount});

  factory PartyListModel.fromMap(Map<String, dynamic> json) => PartyListModel(
    list: List<PartyModel>.from(json["list"].map((x) => PartyModel.fromMap(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
    "totalCount": totalCount,
  };
}

class PartyModel {
  String? mobile;
  String? email;
  String id;
  String partyName;
  String partyNumber;
  String? gstNo;
  String? address;
  String? contactDetails;
  String? brokerName;
  CreatedBy? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  PartyModel({
    required this.mobile,
    required this.email,
    required this.id,
    required this.partyName,
    required this.partyNumber,
    required this.gstNo,
    required this.address,
    required this.contactDetails,
    required this.brokerName,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PartyModel.fromMap(Map<String, dynamic> json) => PartyModel(
    mobile: json["mobile"],
    email: json["email"],
    id: json["_id"],
    partyName: json["partyName"],
    partyNumber: json["customerName"],
    gstNo: json["GSTNo"],
    address: json["address"],
    contactDetails: json["contactDetails"],
    brokerName: json["brokerName"],
    createdBy: CreatedBy.fromMap(json["createdBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "mobile": mobile,
    "email": email,
    "_id": id,
    "partyName": partyName,
    "partyNumber": partyNumber,
    "GSTNo": gstNo,
    "address": address,
    "contactDetails": contactDetails,
    "brokerName": brokerName,
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
