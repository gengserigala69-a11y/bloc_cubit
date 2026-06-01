import 'package:bloc_cubit/login/models/user_model.dart';

class LoginModel {
  final String jwt;
  final UserModel user;

  LoginModel({
    required this.jwt,
    required this.user,
  });

  factory LoginModel.fromMap(Map<String, dynamic> map) {

    final data = map['data'] ?? {};

    return LoginModel(
      jwt: data['jwt'] ?? '',
      user: UserModel.fromMap(data['user'] ?? {}),
    );
  }

  LoginModel copyWith({
    String? jwt,
    UserModel? user,
  }) =>
      LoginModel(
        jwt: jwt ?? this.jwt,
        user: user ?? this.user,
      );
}