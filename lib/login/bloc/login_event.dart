part of 'login_bloc.dart';

sealed class LoginEvent
    extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginSubmitted
    extends LoginEvent {

  final String username;
  final String password;

  const LoginSubmitted({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [
        username,
        password,
      ];
}

// UPDATE USER PROFILE
final class UpdateUserProfile
    extends LoginEvent {

  final UserModel user;

  const UpdateUserProfile({
    required this.user,
  });

  @override
  List<Object> get props => [user];
}