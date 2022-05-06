import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';
import '../services/users_service.dart';
import '../services/chat_service.dart';


class UsersView extends StatefulWidget {
  const UsersView({Key? key}) : super(key: key);

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final RefreshController ctrRefresh = RefreshController(initialRefresh: false);
  final userService = UsersService();
  List<UserModel> users = [];

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
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
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          }, 
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.onLine)
            ? const Icon(Icons.flash_on, color: Colors.green,)
            : const Icon(Icons.flash_off, color: Colors.red,),
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
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.destinatario = user;
          Navigator.pushNamed(context, 'chat');
        },
      );
  }

  _getUsers() async {
    users = await userService.getUsers();
    setState(() {});
    ctrRefresh.refreshCompleted();
  }
}