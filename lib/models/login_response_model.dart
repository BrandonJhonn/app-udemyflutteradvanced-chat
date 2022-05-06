// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

import 'user_model.dart';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {

    bool ok;
    UserModel usuario;
    String token;
    
    LoginResponseModel({
        required this.ok,
        required this.usuario,
        required this.token,
    });

    factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        ok: json["ok"],
        usuario: UserModel.fromJson(json["usuario"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuario": usuario.toJson(),
        "token": token,
    };
}
