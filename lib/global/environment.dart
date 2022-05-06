

import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid ? 'https://app-chat-srv.herokuapp.com/api' : 'https://app-chat-srv.herokuapp.com/api';
  static String socketUrl = Platform.isAndroid ? 'https://app-chat-srv.herokuapp.com/' : 'https://app-chat-srv.herokuapp.com/';
}