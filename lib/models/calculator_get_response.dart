// To parse this JSON data, do
//
//     final calculatorGetResponse = calculatorGetResponseFromMap(jsonString);

import 'dart:convert';

CalculatorGetResponse calculatorGetResponseFromMap(String str) =>
    CalculatorGetResponse.fromMap(json.decode(str));

String calculatorGetResponseToMap(CalculatorGetResponse data) =>
    json.encode(data.toMap());

class CalculatorGetResponse {
  String code;
  String message;
  CalculatorModel data;

  CalculatorGetResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CalculatorGetResponse.fromMap(Map<String, dynamic> json) =>
      CalculatorGetResponse(
        code: json["code"],
        message: json["message"],
        data: CalculatorModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class CalculatorModel {
  String id;
  String designId;
  Warp warp;
  List<Weft> weft;
  Labour? labour;
  DateTime createdAt;
  DateTime updatedAt;

  CalculatorModel({
    required this.id,
    required this.designId,
    required this.warp,
    required this.weft,
    required this.labour,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalculatorModel.fromMap(Map<String, dynamic> json) => CalculatorModel(
    id: json["_id"],
    designId: json["designId"],
    warp: json["warp"] != null
        ? Warp.fromMap(json["warp"])
        : Warp(
            quality: '',
            denier: 0.0,
            tar: 0.0,
            meter: 0.0,
            ratePerKg: 0.0,
            id: '',
          ),
    weft: json["weft"] != null
        ? List<Weft>.from(json["weft"].map((x) => Weft.fromMap(x)))
        : [],
    labour: json["labour"] != null ? Labour.fromMap(json["labour"]) : null,
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "designId": designId,
    "warp": warp.toMap(),
    "weft": List<dynamic>.from(weft.map((x) => x.toMap())),
    "labour": labour?.toMap(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Labour {
  int designCard;
  String id;

  Labour({required this.designCard, required this.id});

  factory Labour.fromMap(Map<String, dynamic> json) =>
      Labour(designCard: json["designCard"], id: json["_id"]);

  Map<String, dynamic> toMap() => {"designCard": designCard, "_id": id};
}

class Warp {
  String quality;
  double denier;
  double tar;
  double meter;
  double ratePerKg;
  String id;

  Warp({
    required this.quality,
    required this.denier,
    required this.tar,
    required this.meter,
    required this.ratePerKg,
    required this.id,
  });

  factory Warp.fromMap(Map<String, dynamic> json) => Warp(
    quality: json["quality"],
    denier: double.tryParse(json["denier"].toString()) ?? 0.0,
    tar: double.tryParse(json["tar"].toString()) ?? 0.0,
    meter: double.tryParse(json["meter"].toString()) ?? 0.0,
    ratePerKg: double.tryParse(json["ratePerKg"].toString()) ?? 0.0,
    id: json["_id"],
  );

  Map<String, dynamic> toMap() => {
    "quality": quality,
    "denier": denier,
    "tar": tar,
    "meter": meter,
    "ratePerKg": ratePerKg,
    "_id": id,
  };
}

class Weft {
  String quality;
  double denier;
  double pick;
  double panno;
  double rate;
  double meter;
  String id;

  Weft({
    required this.quality,
    required this.denier,
    required this.pick,
    required this.panno,
    required this.rate,
    required this.meter,
    required this.id,
  });

  factory Weft.fromMap(Map<String, dynamic> json) => Weft(
    quality: json["quality"],
    denier: double.tryParse(json["denier"].toString()) ?? 0.0,
    pick: double.tryParse(json["pick"].toString()) ?? 0.0,
    panno: double.tryParse(json["panno"].toString()) ?? 0.0,
    rate: double.tryParse(json["rate"].toString()) ?? 0.0,
    meter: double.tryParse(json["meter"].toString()) ?? 0.0,
    id: json["_id"],
  );

  Map<String, dynamic> toMap() => {
    "quality": quality,
    "denier": denier,
    "pick": pick,
    "panno": panno,
    "rate": rate,
    "meter": meter,
    "_id": id,
  };
}
