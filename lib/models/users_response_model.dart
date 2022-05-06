// To parse this JSON data, do
//
//     final usersResponseModel = usersResponseModelFromJson(jsonString);

import 'dart:convert';

import '../models/user_model.dart';

UsersResponseModel usersResponseModelFromJson(String str) => UsersResponseModel.fromJson(json.decode(str));

String usersResponseModelToJson(UsersResponseModel data) => json.encode(data.toJson());

class UsersResponseModel {
    UsersResponseModel({
      required this.ok,
      required this.usuarios,
    });

    bool ok;
    List<UserModel> usuarios;

    factory UsersResponseModel.fromJson(Map<String, dynamic> json) => UsersResponseModel(
        ok: json["ok"],
        usuarios: List<UserModel>.from(json["usuarios"].map((x) => UserModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}
