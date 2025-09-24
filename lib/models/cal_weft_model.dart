class CalWeftModel {
  int id;
  String feeder;
  String? quality;
  double? denier;
  double? pick;
  double? panno;
  double? rate;
  double? meter;

  CalWeftModel({
    required this.id,
    required this.feeder,
    this.quality,
    this.denier,
    this.pick,
    this.panno,
    this.rate,
    this.meter,
  });
}
