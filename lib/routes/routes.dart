import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../views/chat_view.dart';
import '../views/loading_view.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/users_view.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': (_) => const LoginView(),
  'register': (_) => const RegisterView(),
  'loading': (_) => const LoadingView(),
  'chat': (_) => const ChatView(),
  'users': (_) => const UsersView(),
};