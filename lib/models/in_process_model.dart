class Delivered {
  int quantity;
  String firmId;
  String userId;
  String movedBy;
  String machineNo;
  String remarks;

  Delivered({
    required this.quantity,
    required this.firmId,
    required this.userId,
    required this.movedBy,
    required this.machineNo,
    required this.remarks,
  });

  factory Delivered.fromMap(Map<String, dynamic> json) => Delivered(
    quantity: json["quantity"],
    firmId: json["firmId"] ?? '',
    userId: json["userId"] ?? '',
    movedBy: json["movedBy"] ?? '',
    machineNo: json["machineNo"] ?? '',
    remarks: json["remarks"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "quantity": quantity,
    "firmId": firmId,
    "userId": userId,
    "movedBy": movedBy,
    "machineNo": machineNo,
    "remarks": remarks,
  };
}

class ReadyToDispatch {
  String id;
  int quantity;
  String? firmId;
  String? userId;
  String? movedBy;
  String machineNo;
  String remarks;

  ReadyToDispatch({
    required this.id,
    required this.quantity,
    required this.firmId,
    required this.userId,
    required this.movedBy,
    required this.machineNo,
    required this.remarks,
  });

  factory ReadyToDispatch.fromMap(Map<String, dynamic> json) => ReadyToDispatch(
    id: json["_id"] ?? '',
    quantity: json["quantity"],
    firmId: json["firmId"] ?? '',
    userId: json["userId"] ?? '',
    movedBy: json["movedBy"] ?? '',
    machineNo: json["machineNo"] ?? '',
    remarks: json["remarks"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "quantity": quantity,
    "firmId": firmId,
    "userId": userId,
    "movedBy": movedBy,
    "machineNo": machineNo,
    "remarks": remarks,
  };
}

class InProcess {
  String id;
  int quantity;
  String firmId;
  String userId;
  String movedBy;
  String machineNo;
  String remarks;

  InProcess({
    required this.id,
    required this.quantity,
    required this.firmId,
    required this.userId,
    required this.movedBy,
    required this.machineNo,
    required this.remarks,
  });

  factory InProcess.fromMap(Map<String, dynamic> json) => InProcess(
    id: json["_id"] ?? '',
    quantity: json["quantity"],
    firmId: json["firmId"] ?? '',
    userId: json["userId"] ?? '',
    movedBy: json["movedBy"] ?? '',
    machineNo: json["machineNo"] ?? '',
    remarks: json["remarks"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "quantity": quantity,
    "firmId": firmId,
    "userId": userId,
    "movedBy": movedBy,
    "machineNo": machineNo,
    "remarks": remarks,
  };
}

class FirmId {
  String id;
  String firmName;
  String? workspaceId;

  FirmId({required this.id, required this.firmName, this.workspaceId});

  factory FirmId.fromMap(Map<String, dynamic> json) => FirmId(
    id: json["_id"],
    firmName: json["firmName"],
    workspaceId: json["workspaceId"] ?? '',
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "firmName": firmName,
    "workspaceId": workspaceId ?? '',
  };
}

class MovedBy {
  String id;
  String fullname;

  MovedBy({required this.id, required this.fullname});

  factory MovedBy.fromMap(Map<String, dynamic> json) =>
      MovedBy(id: json["_id"], fullname: json["fullname"]);

  Map<String, dynamic> toMap() => {"_id": id, "fullname": fullname};
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
