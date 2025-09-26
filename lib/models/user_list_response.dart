// To parse this JSON data, do
//
//     final userListResponse = userListResponseFromMap(jsonString);

import 'dart:convert';

UserListResponse userListResponseFromMap(String str) =>
    UserListResponse.fromMap(json.decode(str));

String userListResponseToMap(UserListResponse data) =>
    json.encode(data.toMap());

class UserListResponse {
  String code;
  String message;
  UserListModel data;

  UserListResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory UserListResponse.fromMap(Map<String, dynamic> json) =>
      UserListResponse(
        code: json["code"],
        message: json["message"],
        data: UserListModel.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class UserListModel {
  List<UserModel> list;
  int totalCount;

  UserListModel({required this.list, required this.totalCount});

  factory UserListModel.fromMap(Map<String, dynamic> json) => UserListModel(
    list: List<UserModel>.from(json["list"].map((x) => UserModel.fromMap(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toMap() => {
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
    "totalCount": totalCount,
  };
}

class UserModel {
  String id;
  String fullname;
  String workspaceId;
  String mobile;
  String email;
  int userType;
  bool isActive;

  UserModel({
    required this.id,
    required this.fullname,
    required this.workspaceId,
    required this.mobile,
    required this.email,
    required this.userType,
    required this.isActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    fullname: json["fullname"],
    workspaceId: json["workspaceId"],
    mobile: json["mobile"],
    email: json["email"],
    userType: json["userType"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toMap() => {
    "_id": id,
    "fullname": fullname,
    "workspaceId": workspaceId,
    "mobile": mobile,
    "email": email,
    "userType": userType,
    "isActive": isActive,
  };
}
