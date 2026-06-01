import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc_cubit/login/bloc/login_bloc.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
  });

  @override
  State<AppDrawer> createState() =>
      _AppDrawerState();
}

class _AppDrawerState
    extends State<AppDrawer> {

  File? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

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
  Widget build(
    BuildContext context,
  ) {

    return Drawer(
      child: Column(
        children: [

          // HEADER
          BlocBuilder<
              LoginBloc,
              LoginState>(
            builder:
                (
              context,
              loginState,
            ) {

              String username =
                  "Guest";

              if (loginState
                  is LoginSuccess) {

                username =
                    loginState
                        .login
                        .user
                        .username;
              }

              return UserAccountsDrawerHeader(

                currentAccountPicture:
                    CircleAvatar(

                  backgroundColor:
                      Colors.white,

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
                                fontSize:
                                    28,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Colors.blue,
                              ),
                            )
                          : null,
                ),

                accountName:
                    const Text(
                  "Bloc Cubit",
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize:
                        18,
                  ),
                ),

                accountEmail:
                    Text(
                  username,

                  maxLines: 1,

                  overflow:
                      TextOverflow
                          .ellipsis,

                  style:
                      const TextStyle(
                    fontSize:
                        15,
                    color:
                        Colors.white70,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                decoration:
                    const BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors
                          .lightBlueAccent,
                    ],
                  ),
                ),
              );
            },
          ),

          // MENU
          Expanded(
            child: ListView(
              padding:
                  EdgeInsets.zero,
              children: [

                ListTile(
                  leading:
                      const Icon(
                    Icons
                        .home_rounded,
                    color:
                        Colors.blue,
                  ),

                  title:
                      const Text(
                    "Home",
                  ),

                  trailing:
                      const Icon(
                    Icons
                        .arrow_forward_ios,
                    size: 16,
                  ),

                  onTap: () {

                    Navigator.pop(
                      context,
                    );

                    Navigator
                        .pushNamed(
                      context,
                      '/home',
                    );
                  },
                ),

                ListTile(
                  leading:
                      const Icon(
                    Icons
                        .countertops_rounded,
                    color:
                        Colors.orange,
                  ),

                  title:
                      const Text(
                    "Counter",
                  ),

                  trailing:
                      const Icon(
                    Icons
                        .arrow_forward_ios,
                    size: 16,
                  ),

                  onTap: () {

                    Navigator.pop(
                      context,
                    );

                    Navigator
                        .pushNamed(
                      context,
                      '/counter',
                    );
                  },
                ),

                ListTile(
                  leading:
                      const Icon(
                    Icons
                        .newspaper_rounded,
                    color:
                        Colors.green,
                  ),

                  title:
                      const Text(
                    "Post List",
                  ),

                  trailing:
                      const Icon(
                    Icons
                        .arrow_forward_ios,
                    size: 16,
                  ),

                  onTap: () {

                    Navigator.pop(
                      context,
                    );

                    Navigator
                        .pushNamed(
                      context,
                      '/posts',
                    );
                  },
                ),

                const Divider(),

                ListTile(
                  leading:
                      const Icon(
                    Icons.person,
                    color:
                        Colors.purple,
                  ),

                  title:
                      const Text(
                    "Profile",
                  ),

                  trailing:
                      const Icon(
                    Icons
                        .arrow_forward_ios,
                    size: 16,
                  ),

                  onTap: () {

                    Navigator.pop(
                      context,
                    );

                    Navigator
                        .pushNamed(
                      context,
                      '/profile',
                    );
                  },
                ),

                ListTile(
                  leading:
                      const Icon(
                    Icons
                        .logout_rounded,
                    color:
                        Colors.red,
                  ),

                  title:
                      const Text(
                    "Logout",
                  ),

                  trailing:
                      const Icon(
                    Icons
                        .arrow_forward_ios,
                    size: 16,
                  ),

                  onTap: () {

                    Navigator.pop(
                      context,
                    );

                    Navigator
                        .pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (
                        route,
                      ) =>
                          false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}