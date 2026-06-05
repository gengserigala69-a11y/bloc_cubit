import 'dart:convert';

import 'package:http/http.dart'
    as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/delete_account_model.dart';

class DeleteAccountRepository {
  final http.Client
      httpClient;

  DeleteAccountRepository({
    required this.httpClient,
  });

  Future<
      DeleteAccountModel>
      deleteAccount({

    required String password,

  }) async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final token =
        prefs.getString(
      'token',
    );

    // DEBUG TOKEN
    print(
      'TOKEN DARI STORAGE = $token',
    );

    print(
      'HEADER AUTH = Bearer $token',
    );

    final response =
        await http.delete(

      Uri.parse(
        'https://api.ppb.widiarrohman.my.id/api/users/delete',
      ),

      headers: {

        'Authorization':
            'Bearer $token',

        'Content-Type':
            'application/json',
      },

      body: jsonEncode({

        'password':
            password,
      }),
    );

    print(
      'STATUS CODE = ${response.statusCode}',
    );

    print(
      'RESPONSE BODY = ${response.body}',
    );

    final data =
        jsonDecode(
      response.body,
    );

    if (response.statusCode ==
            200 ||
        response.statusCode ==
            201) {

      return DeleteAccountModel
          .fromMap(
        data,
      );
    }

    throw Exception(
      data['message'] ??
          'Failed to delete account',
    );
  }
}