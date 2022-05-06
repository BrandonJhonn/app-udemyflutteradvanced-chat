// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        required this.nombre,
        required this.email,
        required this.online,
        required this.uid,
    });

    String nombre;
    String email;
    bool online;
    String uid;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
    };
}
