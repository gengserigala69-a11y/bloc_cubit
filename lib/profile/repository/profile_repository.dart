import 'dart:convert';

import 'package:http/http.dart'
    as http;

import 'package:bloc_cubit/login/models/user_model.dart';

class ProfileRepository {

  Future<UserModel> updateProfile({

    required String token,
    required String username,
    required String email,

  }) async {

    final response =
        await http.put(

      Uri.parse(
        'https://api.ppb.widiarrohman.my.id/api/users/update',
      ),

      headers: {
        'Authorization':
            'Bearer $token',

        'content-type':
            'application/json',
      },

      body: jsonEncode({
        "username": username,
        "email": email,
        "confirmed": true,
        "blocked": false,
      }),
    );

    final body =
        jsonDecode(response.body);

    if (response.statusCode == 200) {

      final data =
          body['data'];

      return UserModel(
        id: data['id'],
        documentId: '',
        username:
            data['username'],
        email:
            data['email'],
      );
    }

    throw Exception(
      body['message'] ??
      'Gagal update profile',
    );
  }
}