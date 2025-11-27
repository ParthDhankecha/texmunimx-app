import 'package:texmunimx/models/sari_color_model.dart';

class SariMatchingModel {
  String? id;
  int? mId;
  String? matching;
  String? color1;
  String? color2;
  String? color3;
  String? color4;
  double? rate;
  int? color1Quantity;
  int? color2Quantity;
  int? color3Quantity;
  int? color4Quantity;
  double? meter;
  int? quantity;
  bool? isLocked;
  List<SariColorModel> colors;

  SariMatchingModel({
    this.id,
    this.mId,
    this.matching,
    this.color1,
    this.color2,
    this.color3,
    this.color4,
    this.color1Quantity,
    this.color2Quantity,
    this.color3Quantity,
    this.color4Quantity,
    this.rate,
    this.meter,
    this.quantity,
    this.isLocked,
    this.colors = const [],
  });
}
