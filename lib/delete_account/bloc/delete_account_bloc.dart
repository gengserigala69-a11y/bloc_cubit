import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/delete_account_repository.dart';

import 'delete_account_event.dart';
import 'delete_account_state.dart';

class DeleteAccountBloc
    extends Bloc<
        DeleteAccountEvent,
        DeleteAccountState> {
  final DeleteAccountRepository
      deleteAccountRepository;

  DeleteAccountBloc({
    required this.deleteAccountRepository,
  }) : super(
          DeleteAccountInitial(),
        ) {
    on<DeleteAccountRequested>(
      _onDeleteAccountRequested,
    );
  }

  Future<void>
      _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<DeleteAccountState> emit,
  ) async {
    emit(
      DeleteAccountLoading(),
    );

    try {
      final result =
          await deleteAccountRepository
              .deleteAccount(
        password: event.password,
      );

      emit(
        DeleteAccountSuccess(
          deleteAccountModel:
              result,
        ),
      );
    } catch (e) {
      emit(
        DeleteAccountFailure(
          error: e.toString(),
        ),
      );
    }
  }
}