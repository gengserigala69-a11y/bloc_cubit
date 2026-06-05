import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_cubit/login/bloc/login_bloc.dart';
import 'package:bloc_cubit/profile/repository/profile_repository.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({
    super.key,
  });

  @override
  State<ProfileEdit> createState() =>
      _ProfileEditState();
}

class _ProfileEditState
    extends State<ProfileEdit> {

  final _formKey =
      GlobalKey<FormState>();

  late TextEditingController
      usernameController;

  late TextEditingController
      emailController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final loginState =
        context
            .read<LoginBloc>()
            .state;

    if (loginState
        is LoginSuccess) {

      usernameController =
          TextEditingController(
        text: loginState
            .login
            .user
            .username,
      );

      emailController =
          TextEditingController(
        text: loginState
            .login
            .user
            .email,
      );
    } else {

      usernameController =
          TextEditingController();

      emailController =
          TextEditingController();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void>
      updateProfile() async {

    if (!_formKey
        .currentState!
        .validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final loginState =
          context
                  .read<LoginBloc>()
                  .state
              as LoginSuccess;

      final token =
          loginState
              .login
              .jwt;

      final updatedUser =
          await context
              .read<
                  ProfileRepository>()
              .updateProfile(
        token: token,
        username:
            usernameController
                .text
                .trim(),
        email:
            emailController
                .text
                .trim(),
      );

      context
          .read<LoginBloc>()
          .add(
            UpdateUserProfile(
              user:
                  updatedUser,
            ),
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
              context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Profile berhasil diperbarui',
          ),
        ),
      );

      Navigator.pop(
        context,
      );

    } catch (e) {

      ScaffoldMessenger.of(
              context)
          .showSnackBar(
        SnackBar(
          content:
              Text(
            e.toString(),
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          "Edit Profile",
        ),
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Form(

          key: _formKey,

          child: Column(
            children: [

              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              TextFormField(
                controller:
                    usernameController,

                decoration:
                    InputDecoration(
                  labelText:
                      "Username",

                  prefixIcon:
                      const Icon(
                    Icons.person,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                validator:
                    (value) {

                  if (value ==
                          null ||
                      value
                          .trim()
                          .isEmpty) {

                    return
                        "Username wajib diisi";
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 16,
              ),

              TextFormField(
                controller:
                    emailController,

                keyboardType:
                    TextInputType
                        .emailAddress,

                decoration:
                    InputDecoration(
                  labelText:
                      "Email",

                  prefixIcon:
                      const Icon(
                    Icons.email,
                  ),

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),

                validator:
                    (value) {

                  if (value ==
                          null ||
                      value
                          .trim()
                          .isEmpty) {

                    return
                        "Email wajib diisi";
                  }

                  if (!value.contains('@')) {
                    return
                        "Format email tidak valid";
                  }

                  return null;
                },
              ),

              const SizedBox(
                height: 24,
              ),

              SizedBox(
                width:
                    double.infinity,

                height:
                    50,

                child:
                    ElevatedButton.icon(

                  icon:
                      isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(),
                            )
                          : const Icon(
                              Icons.save,
                            ),

                  label: Text(
                    isLoading
                        ? "Saving..."
                        : "Save Changes",
                  ),

                  onPressed:
                      isLoading
                          ? null
                          : updateProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}