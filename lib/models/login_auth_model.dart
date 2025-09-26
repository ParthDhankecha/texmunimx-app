// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromMap(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromMap(String str) =>
    LoginResponse.fromMap(json.decode(str));

String loginResponseToMap(LoginResponse data) => json.encode(data.toMap());

class LoginResponse {
  String code;
  String message;
  LoginModel data;

  LoginResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    code: json["code"],
    message: json["message"],
    data: LoginModel.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "message": message,
    "data": data.toMap(),
  };
}

class LoginModel {
  Token token;
  User user;

  LoginModel({required this.token, required this.user});

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
    token: Token.fromMap(json["token"]),
    user: User.fromMap(json["user"]),
  );

  Map<String, dynamic> toMap() => {
    "token": token.toMap(),
    "user": user.toMap(),
  };
}

class Token {
  int expiresIn;
  String accessToken;

  Token({required this.expiresIn, required this.accessToken});

  factory Token.fromMap(Map<String, dynamic> json) =>
      Token(expiresIn: json["expiresIn"], accessToken: json["accessToken"]);

  Map<String, dynamic> toMap() => {
    "expiresIn": expiresIn,
    "accessToken": accessToken,
  };
}

class User {
  String id;
  int type;
  String email;

  User({required this.id, required this.type, required this.email});

  factory User.fromMap(Map<String, dynamic> json) =>
      User(id: json["_id"], type: json["type"], email: json["email"]);

  Map<String, dynamic> toMap() => {"_id": id, "type": type, "email": email};
}
