import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc_cubit/login/bloc/login_bloc.dart';
import 'package:bloc_cubit/profile/repository/profile_repository.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  State<ProfileView> createState() =>
      _ProfileViewState();
}

class _ProfileViewState
    extends State<ProfileView> {

  File? profileImage;

  late TextEditingController
      usernameController;

  late TextEditingController
      emailController;

  @override
  void initState() {
    super.initState();

    loadProfileImage();

    final loginState =
        context.read<LoginBloc>().state;

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

  // PICK IMAGE
  Future<void> pickImage() async {

    final picker =
        ImagePicker();

    final image =
        await picker.pickImage(
      source:
          ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setString(
      'profile_image',
      image.path,
    );

    setState(() {

      profileImage =
          File(image.path);
    });
  }

  // LOAD IMAGE
  Future<void>
      loadProfileImage() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    final path =
        prefs.getString(
      'profile_image',
    );

    if (path != null) {

      setState(() {

        profileImage =
            File(path);
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    final loginState =
        context
            .read<LoginBloc>()
            .state;

    String username =
        "Guest";

    String email = "";

    if (loginState
        is LoginSuccess) {

      username =
          loginState
              .login
              .user
              .username;

      email =
          loginState
              .login
              .user
              .email;
    }

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
          'Profile Page',
        ),
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(
          children: [

            const SizedBox(
              height: 20,
            ),

            // PROFILE IMAGE
            GestureDetector(

              onTap:
                  pickImage,

              child: Stack(

                alignment:
                    Alignment
                        .bottomRight,

                children: [

                  CircleAvatar(
                    radius: 60,

                    backgroundColor:
                        const Color.fromARGB(255, 255, 255, 255),

                    backgroundImage:
                        profileImage !=
                                null
                            ? FileImage(
                                profileImage!,
                              )
                            : null,

                    child:
                        profileImage ==
                                null
                            ? Text(
                                username
                                        .isNotEmpty
                                    ? username[
                                            0]
                                        .toUpperCase()
                                    : "U",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize:
                                      40,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              )
                            : null,
                  ),

                  Container(
                    padding:
                        const EdgeInsets.all(
                      8,
                    ),

                    decoration:
                        const BoxDecoration(
                      color:
                          Colors.blue,
                      shape:
                          BoxShape.circle,
                    ),

                    child:
                        const Icon(
                      Icons
                          .camera_alt,
                      color:
                          Colors.white,
                      size:
                          18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Text(
              username,
              style:
                  const TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              email,
              style:
                  const TextStyle(
                color:
                    Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // USERNAME
            TextField(
              controller:
                  usernameController,

              decoration:
                  InputDecoration(
                labelText:
                    "Username",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                prefixIcon:
                    const Icon(
                  Icons.person,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // EMAIL
            TextField(
              controller:
                  emailController,

              decoration:
                  InputDecoration(
                labelText:
                    "Email",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                ),

                prefixIcon:
                    const Icon(
                  Icons.email,
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            // UPDATE BUTTON
            SizedBox(
              width:
                  double.infinity,
              height: 60,

              child:
                  ElevatedButton
                      .icon(

                style:
                    ElevatedButton
                        .styleFrom(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                  ),
                ),

                onPressed:
                    () async {

                  try {

                    final loginState =
                        context
                                .read<
                                    LoginBloc>()
                                .state
                            as LoginSuccess;

                    final token =
                        loginState
                            .login
                            .jwt;

                    // UPDATE API
                    final updatedUser =
                        await context
                            .read<
                                ProfileRepository>()
                            .updateProfile(

                      token:
                          token,

                      username:
                          usernameController
                              .text
                              .trim(),

                      email:
                          emailController
                              .text
                              .trim(),
                    );

                    // UPDATE LOGIN BLOC
                    context
                        .read<
                            LoginBloc>()
                        .add(
                          UpdateUserProfile(
                            user:
                                updatedUser,
                          ),
                        );

                    if (!mounted)
                      return;

                    ScaffoldMessenger
                            .of(
                                context)
                        .showSnackBar(

                      const SnackBar(
                        content:
                            Text(
                          'Profile berhasil diperbarui',
                        ),
                      ),
                    );

                    setState(
                        () {});
                  } catch (e) {

                    if (!mounted)
                      return;

                    ScaffoldMessenger
                            .of(
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
                },

                icon:
                    const Icon(
                  Icons.save,
                ),

                label:
                    const Text(
                  "Update Profile",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}