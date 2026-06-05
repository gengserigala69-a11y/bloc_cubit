import 'package:equatable/equatable.dart';

import '../models/delete_account_model.dart';

abstract class DeleteAccountState extends Equatable {
  const DeleteAccountState();

  @override
  List<Object> get props => [];
}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {
  final DeleteAccountModel deleteAccountModel;

  const DeleteAccountSuccess({
    required this.deleteAccountModel,
  });

  @override
  List<Object> get props => [
        deleteAccountModel,
      ];
}

class DeleteAccountFailure extends DeleteAccountState {
  final String error;

  const DeleteAccountFailure({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}