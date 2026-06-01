import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc_cubit/login/models/user_model.dart';
import 'package:bloc_cubit/profile/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc
    extends Bloc<
        ProfileEvent,
        ProfileState> {

  final ProfileRepository
      profileRepository;

  ProfileBloc({
    required this.profileRepository,
  }) : super(
          ProfileInitial(),
        ) {

    on<
        UpdateProfileSubmitted>(
      _onUpdateProfile,
    );
  }

  Future<void>
      _onUpdateProfile(

    UpdateProfileSubmitted
        event,

    Emitter<ProfileState>
        emit,

  ) async {

    emit(
      ProfileLoading(),
    );

    try {

      final user =
          await profileRepository
              .updateProfile(

        token:
            event.token,

        username:
            event.username,

        email:
            event.email,
      );

      emit(
        ProfileSuccess(
          user: user,
        ),
      );

    } catch (e) {

      emit(
        ProfileFailure(
          message:
              e.toString(),
        ),
      );
    }
  }
}