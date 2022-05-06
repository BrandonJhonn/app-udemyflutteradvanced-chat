import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global/environment.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  late UserModel usuario;
  bool _procesando = false;
  String _sms = '';
  final _storage = const FlutterSecureStorage();

  bool get procesando => _procesando;
  set procesando(bool valor) {
    _procesando = valor;
    notifyListeners();
  }

  String get sms => _sms;
  set sms(String valor) {
    _sms = valor;
    notifyListeners();
  }

  //  Getters del token de forma estatica
  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {

    procesando = true;

    final data = {
      'email': email,
      'password': password
    };

    final res = await http.post(Uri.parse('${ Environment.apiUrl }/login'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    procesando = false;
    if (res.statusCode == 200) {
      final loginResponse = loginResponseModelFromJson(res.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      sms = jsonDecode(res.body)['msg'];
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    procesando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final res = await http.post(Uri.parse('${ Environment.apiUrl }/login/new'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    procesando = false;
    if (res.statusCode == 200) {
      final loginResponse = loginResponseModelFromJson(res.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      sms = jsonDecode(res.body)['msg'];
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    
    final res = await http.get(Uri.parse('${ Environment.apiUrl }/login/renew'),
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString()
      }
    );

    if (res.statusCode == 200) {
      final loginResponse = loginResponseModelFromJson(res.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}