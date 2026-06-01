import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc_cubit/login/models/login_model.dart';
import 'package:bloc_cubit/login/models/user_model.dart';
import 'package:bloc_cubit/login/repository/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final LoginRepository loginRepository;

  LoginBloc({
    required this.loginRepository,
  }) : super(LoginInitial()) {

    on<LoginSubmitted>(_onLoginSubmitted);
    on<UpdateUserProfile>(
  _onUpdateUserProfile,
);}

void _onUpdateUserProfile(

  UpdateUserProfile event,
  Emitter<LoginState> emit,

) {

  if (state is LoginSuccess) {

    final currentState =
        state as LoginSuccess;

    final updatedLogin =
        currentState.login.copyWith(
      user: event.user,
    );

    emit(
      LoginSuccess(
        login: updatedLogin,
      ),
    );
  }
}

  Future<void> _onLoginSubmitted(

    LoginSubmitted event,
    Emitter<LoginState> emit,

  ) async {

    // AMBIL VALUE
    final username = event.username.trim();
    final password = event.password.trim();

    // VALIDASI KOSONG
    if (username.isEmpty || password.isEmpty) {

      emit(
        const LoginFailure(
          message: 'Username dan password wajib diisi',
        ),
      );

      return;
    }

    // VALIDASI PASSWORD
    if (password.length < 8) {

      emit(
        const LoginFailure(
          message: 'Password minimal 8 karakter',
        ),
      );

      return;
    }

    emit(LoginLoading());

    // AKUN DUMMY
    if (username == 'admin' && password == 'admin123') {

      await Future.delayed(
        const Duration(seconds: 1),
      );

      final dummyUser = UserModel(
        id: 99,
        documentId: 'dummy-document-id-123',
        username: 'admin',
        email: 'admin@dummymail.com',
      );

      final dummyLogin = LoginModel(
        jwt: 'dummy_token_jwt_xyz123',
        user: dummyUser,
      );

      emit(
        LoginSuccess(
          login: dummyLogin,
        ),
      );

      return;
    }

    // LOGIN API
    try {

      final LoginModel login =
          await loginRepository.login(
        identifier: username,
        password: password,
      );

      emit(
        LoginSuccess(
          login: login,
        ),
      );

    } catch (e) {

      emit(
        LoginFailure(
          message: e.toString(),
        ),
      );
    }
  }
}