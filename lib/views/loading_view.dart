import 'package:app_workspace_chat/services/auth_service.dart';
import 'package:app_workspace_chat/views/login_view.dart';
import 'package:app_workspace_chat/views/users_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Cargando...'),
          );
        },
      ),
   );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    
    if (autenticado) {
      //  TODO: Conectar al socket
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UsersView(),
          transitionDuration: const Duration(milliseconds: 1)
        ),
      );
    } else {
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginView(),
          transitionDuration: const Duration(milliseconds: 1)
        ),
      );
    }
  }
}