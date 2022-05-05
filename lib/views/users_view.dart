import 'package:flutter/material.dart';
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
    User(uid: '1', name: 'Jose Madero', email: 'test1@test.com', onLine: true),
    User(uid: '2', name: 'Maria Fernanda', email: 'test2@test.com', onLine: false),
    User(uid: '3', name: 'Samuel Romero', email: 'test3@test.com', onLine: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi nombre',
        style: TextStyle(
            color: Colors.black87,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: () {}, 
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

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          child: Text(user.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.onLine
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