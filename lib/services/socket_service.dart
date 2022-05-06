
import 'package:app_workspace_chat/global/environment.dart';
import 'package:app_workspace_chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  onLine,
  offLine,
  connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  void connect() async {

    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(Environment.socketUrl, 
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .enableForceNew()
        .setExtraHeaders({
          'x-token': token
        })
        .build()
    );
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.onLine;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offLine;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}