import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/delete_account_bloc.dart';
import '../bloc/delete_account_event.dart';
import '../bloc/delete_account_state.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() =>
      _DeleteAccountViewState();
}

class _DeleteAccountViewState
    extends State<DeleteAccountView> {
  final TextEditingController
      passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool isChecked = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Delete Account",
          ),
          content: const Text(
            "This action cannot be undone. Are you sure you want to permanently delete your account?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);

                context
                    .read<
                        DeleteAccountBloc>()
                    .add(
                      DeleteAccountRequested(
                        password:
                            passwordController
                                .text,
                      ),
                    );
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  color:
                      Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocListener<
        DeleteAccountBloc,
        DeleteAccountState>(
      listener: (
        context,
        state,
      ) async {
        if (state
            is DeleteAccountLoading) {
          showDialog(
            context: context,
            barrierDismissible:
                false,
            builder: (_) =>
                const Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        if (state
            is DeleteAccountSuccess) {
          Navigator.pop(context);

          final prefs =
              await SharedPreferences
                  .getInstance();

          await prefs.clear();

          if (!context.mounted) {
            return;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                state
                    .deleteAccountModel
                    .message,
              ),
            ),
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }

        if (state
            is DeleteAccountFailure) {
          Navigator.pop(context);

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Delete Account',
          ),
        ),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const SizedBox(
                height: 20,
              ),

              const Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color:
                      Colors.red,
                  size: 90,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              const Center(
                child: Text(
                  'Delete Your Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Center(
                child: Text(
                  'Deleting your account is permanent and cannot be removed.',
                  textAlign:
                      TextAlign
                          .center,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Container(
                padding:
                    const EdgeInsets
                        .all(16),
                decoration:
                    BoxDecoration(
                  border: Border.all(
                    color: Colors.red
                        .shade200,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    12,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      'What will happen?',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize:
                            18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '• You will no longer be able to login',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '• Your account will be marked as deleted',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '• Your personal information will be inaccessible',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '• This action cannot be undone',
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              TextField(
                controller:
                    passwordController,
                obscureText:
                    obscurePassword,
                decoration:
                    InputDecoration(
                  labelText:
                      'Confirm Password',
                  prefixIcon:
                      const Icon(
                    Icons.lock,
                  ),
                  suffixIcon:
                      IconButton(
                    onPressed:
                        () {
                      setState(
                        () {
                          obscurePassword =
                              !obscurePassword;
                        },
                      );
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons
                              .visibility
                          : Icons
                              .visibility_off,
                    ),
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: [
                  Checkbox(
                    value:
                        isChecked,
                    onChanged:
                        (
                      value,
                    ) {
                      setState(
                        () {
                          isChecked =
                              value ??
                                  false;
                        },
                      );
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I understand that this action cannot be undone.',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width: double.infinity,
                height: 55,
                child:
                    ElevatedButton
                        .icon(
                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        Colors.red,
                  ),
                  onPressed:
                      () {
                    if (passwordController
                        .text
                        .trim()
                        .isEmpty) {
                      ScaffoldMessenger
                              .of(
                            context,
                          )
                          .showSnackBar(
                        const SnackBar(
                          content:
                              Text(
                            'Please enter password',
                          ),
                        ),
                      );
                      return;
                    }

                    if (!isChecked) {
                      ScaffoldMessenger
                              .of(
                            context,
                          )
                          .showSnackBar(
                        const SnackBar(
                          content:
                              Text(
                            'Please confirm the checkbox',
                          ),
                        ),
                      );
                      return;
                    }

                    _showDeleteConfirmation();
                  },
                  icon: const Icon(
                    Icons
                        .delete_forever,
                    color:
                        Colors.white,
                  ),
                  label:
                      const Text(
                    'Delete Account',
                    style:
                        TextStyle(
                      color: Colors
                          .white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}