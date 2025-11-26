// To parse this JSON data, do
//
//     final sariColorModel = sariColorModelFromMap(jsonString);

import 'dart:convert';

SariColorModel sariColorModelFromMap(String str) =>
    SariColorModel.fromMap(json.decode(str));

String sariColorModelToMap(SariColorModel data) => json.encode(data.toMap());

class SariColorModel {
  String? color;
  int? quantity;
  int? pending;
  int? cid;
  String? id;

  SariColorModel({this.color, this.quantity, this.pending, this.cid, this.id});

  factory SariColorModel.fromMap(Map<String, dynamic> json) => SariColorModel(
    color: json["color"],
    quantity: json["quantity"],
    pending: json["pending"],
    cid: json["cid"],
    id: json["_id"],
  );

  Map<String, dynamic> toMap() => {
    "color": color,
    "quantity": quantity,
    "pending": pending,
    "cid": cid,
    "_id": id,
  };
}
