import 'dart:convert';

import 'package:http/http.dart'
    as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc_cubit/login/models/login_model.dart';

class LoginRepository {

  final http.Client
      httpClient;

  LoginRepository({
    required this.httpClient,
  });

  Future<LoginModel> login({

    required String identifier,
    required String password,

  }) async {

    final response =
        await httpClient.post(

      Uri.parse(
        'https://api.ppb.widiarrohman.my.id/api/auth/local',
      ),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'identifier':
            identifier,

        'password':
            password,
      }),
    );

    print(
      'LOGIN RESPONSE = ${response.body}',
    );

    if (response.statusCode !=
        200) {

      throw Exception(
        'Login gagal',
      );
    }

    final json =
        jsonDecode(
      response.body,
    );

    final loginModel =
        LoginModel.fromMap(
      json,
    );

    // SIMPAN TOKEN JWT
    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      'token',
      loginModel.jwt,
    );

    print(
      'TOKEN TERSIMPAN = ${loginModel.jwt}',
    );

    return loginModel;
  }
}