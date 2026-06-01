import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc_cubit/register/model/register_models.dart';

class RegisterRepository {

  final http.Client httpClient;

  RegisterRepository({
    required this.httpClient,
  });

  Future<Registermodel> register({
    required String email,
    required String username,
    required String password,
  }) async {

    final response = await httpClient.post(
      Uri.parse(
        'https://api.ppb.widiarrohman.my.id/api/auth/local/register',
      ),

      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },

      body: {
        'email': email,
        'username': username,
        'password': password,
      },
    );

    // DEBUG
    print("STATUS CODE:");
    print(response.statusCode);

    print("RESPONSE BODY:");
    print(response.body);

    final responseBody = jsonDecode(response.body);

    if (response.statusCode != 201) {
      throw Exception(
        'Error: ${response.statusCode} - ${responseBody['message']}',
      );
    }

    return Registermodel.fromMap(responseBody);
  }
}