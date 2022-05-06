// To parse this JSON data, do
//
//     final messagesResponseModel = messagesResponseModelFromJson(jsonString);

import 'dart:convert';

MessagesResponseModel messagesResponseModelFromJson(String str) => MessagesResponseModel.fromJson(json.decode(str));

String messagesResponseModelToJson(MessagesResponseModel data) => json.encode(data.toJson());

class MessagesResponseModel {
    MessagesResponseModel({
        required this.ok,
        required this.mensajes,
    });

    bool ok;
    List<Mensaje> mensajes;

    factory MessagesResponseModel.fromJson(Map<String, dynamic> json) => MessagesResponseModel(
        ok: json["ok"],
        mensajes: List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
    };
}

class Mensaje {
    Mensaje({
      required this.de,
      required this.para,
      required this.mensaje,
      required this.createdAt,
      required this.updatedAt,
    });

    String de;
    String para;
    String mensaje;
    DateTime createdAt;
    DateTime updatedAt;

    factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        de: json["de"],
        para: json["para"],
        mensaje: json["mensaje"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "mensaje": mensaje,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
