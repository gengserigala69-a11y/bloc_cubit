part of 'profile_bloc.dart';

sealed class ProfileEvent
    extends Equatable {

  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class UpdateProfileSubmitted
    extends ProfileEvent {

  final String token;
  final String username;
  final String email;

  const UpdateProfileSubmitted({
    required this.token,
    required this.username,
    required this.email,
  });

  @override
  List<Object> get props => [
        token,
        username,
        email,
      ];
}