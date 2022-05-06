import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';
import '../models/user_model.dart';
import '../models/messages_response_model.dart';
import 'auth_service.dart';

class ChatService with ChangeNotifier {
  late UserModel destinatario;

  Future<List<Mensaje>> getChat(String usuarioUid) async {

    final token = await AuthService.getToken();
    final res = await http.get(Uri.parse('${ Environment.apiUrl }/mensajes/$usuarioUid'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      }
    );

    final mensajesResponse = messagesResponseModelFromJson(res.body);
    return mensajesResponse.mensajes;
  }
}