import 'package:app_workspace_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user_model.dart';


class UsersView extends StatefulWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final RefreshController ctrRefresh = RefreshController(initialRefresh: false);
  final users = [
    UserModel(uid: '1', nombre: 'Jose Madero', email: 'test1@test.com', online: true),
    UserModel(uid: '2', nombre: 'Maria Fernanda', email: 'test2@test.com', online: false),
    UserModel(uid: '3', nombre: 'Samuel Romero', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre,
        style: const TextStyle(
            color: Colors.black87,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {
            //  TODO: Desconectar del socket
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          }, 
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            //child: const Icon(Icons.flash_on, color: Colors.green,),
            child: const Icon(Icons.flash_off, color: Colors.red,),
          )
        ]
      ),
      body: SmartRefresher(
        controller: ctrRefresh,
        enablePullDown: true,
        onRefresh: _getUsers,
        header: WaterDropHeader(
          complete: Icon(Icons.check_outlined, color: Colors.green[400],),
          waterDropColor: Colors.green[400]!,
        ),
        child: _userListView(),
      ),
   );
  }

  ListView _userListView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]), 
      separatorBuilder: (_, i) => const Divider(), 
      itemCount: users.length
    );
  }

  ListTile _userListTile(UserModel user) {
    return ListTile(
        title: Text(user.nombre),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online
            ? Colors.green[300]
            : Colors.red,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );
  }

  _getUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    ctrRefresh.refreshCompleted();
  }
}