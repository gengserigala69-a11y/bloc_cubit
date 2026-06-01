part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginModel login;
  const LoginSuccess({required this.login});

  @override
  List<Object> get props => [login];
}

final class LoginFailure extends LoginState {
  final String message;
  const LoginFailure({required this.message});

  @override
  List<Object> get props => [message];
} 