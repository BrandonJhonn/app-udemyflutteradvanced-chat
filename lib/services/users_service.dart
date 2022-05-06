import 'package:app_workspace_chat/global/environment.dart';
import 'package:app_workspace_chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../models/users_response_model.dart';

class UsersService {

  Future<List<UserModel>> getUsers() async {

    try {

      final token = await AuthService.getToken();
      final res = await http.get(Uri.parse('${ Environment.apiUrl }/usuarios'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        }
      );

      final usuariosResponse = usersResponseModelFromJson(res.body);
      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }

  }
}