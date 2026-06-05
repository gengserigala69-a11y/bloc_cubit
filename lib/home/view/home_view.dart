import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc_cubit/core/theme/theme_cubit.dart';
import 'package:bloc_cubit/core/widgets/app_drawer.dart';

import 'package:bloc_cubit/counter/cubit/counter_cubit.dart';
import 'package:bloc_cubit/counter/cubit/counter_state.dart';

import 'package:bloc_cubit/login/bloc/login_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() =>
      _HomeViewState();
}

class _HomeViewState
    extends State<HomeView> {

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

    return Scaffold(

      drawer:
          const AppDrawer(),

      appBar: AppBar(

        elevation: 0,

        title:
            const Text(
          "Home",
        ),

        actions: [

          IconButton(

            onPressed: () {

              context
                  .read<
                      ThemeCubit>()
                  .toggleTheme();
            },

            icon:
                const Icon(
              Icons.dark_mode,
            ),
          ),
        ],
      ),

      body: SafeArea(

        child:
            SingleChildScrollView(

          padding:
              const EdgeInsets.all(
            20,
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [

              // USER CARD
              BlocBuilder<
                  LoginBloc,
                  LoginState>(
                builder:
                    (
                  context,
                  loginState,
                ) {

                  if (loginState
                      is LoginSuccess) {

                    final user =
                        loginState
                            .login
                            .user;

                    return Container(

                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      decoration:
                          BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),

                        gradient:
                            LinearGradient(

                          colors: [

                            Colors.blue
                                .shade600,

                            Colors
                                .lightBlueAccent,
                          ],
                        ),

                        boxShadow: [

                          BoxShadow(

                            color: Colors
                                .blue
                                .withOpacity(
                              0.2,
                            ),

                            blurRadius:
                                10,

                            offset:
                                const Offset(
                              0,
                              5,
                            ),
                          ),
                        ],
                      ),

                      child: Row(

                        children: [

                          // PROFILE IMAGE
                          CircleAvatar(

                            radius:
                                35,

                            backgroundColor:
                                Colors
                                    .white,

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

                                        user.username
                                                .isNotEmpty
                                            ? user
                                                .username[
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

                          const SizedBox(
                            width: 16,
                          ),

                          // USER INFO
                          Expanded(

                            child:
                                Column(

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                const Text(

                                  "Welcome Back",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white70,
                                    fontSize:
                                        14,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      4,
                                ),

                                Text(

                                  user
                                      .username,

                                  maxLines:
                                      1,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      const TextStyle(

                                    color:
                                        Colors.white,

                                    fontSize:
                                        22,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height:
                                      4,
                                ),

                                Text(

                                  user.email,

                                  maxLines:
                                      1,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // GUEST
                  return Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    decoration:
                        BoxDecoration(

                      color: Colors
                          .grey
                          .shade200,

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),
                    ),

                    child:
                        const Row(

                      children: [

                        CircleAvatar(
                          radius:
                              30,
                          child: Icon(
                            Icons.person,
                          ),
                        ),

                        SizedBox(
                          width: 16,
                        ),

                        Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            Text(

                              "Welcome Guest",

                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize:
                                    18,
                              ),
                            ),

                            SizedBox(
                              height:
                                  4,
                            ),

                            Text(
                              "Please login first",
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 30,
              ),

              // TITLE
              Text(

                "Counter Statistics",

                style: Theme.of(
                        context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
              ),

              const SizedBox(
                height: 20,
              ),

              // COUNTER CARD
              BlocBuilder<
                  CounterCubit,
                  CounterState>(
                builder:
                    (
                  context,
                  state,
                ) {

                  return Container(

                    width:
                        double.infinity,

                    padding:
                        const EdgeInsets.all(
                      24,
                    ),

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(
                        24,
                      ),

                      color:
                          Theme.of(
                                  context)
                              .cardColor,

                      boxShadow: [

                        BoxShadow(

                          color: Colors
                              .black
                              .withOpacity(
                            0.05,
                          ),

                          blurRadius:
                              10,

                          offset:
                              const Offset(
                            0,
                            5,
                          ),
                        ),
                      ],
                    ),

                    child:
                        Column(

                      children: [

                        const Icon(
                          Icons
                              .countertops,
                          size:
                              60,
                          color:
                              Colors.orange,
                        ),

                        const SizedBox(
                          height:
                              16,
                        ),

                        Text(

                          "${state.counter}",

                          style:
                              const TextStyle(
                            fontSize:
                                48,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}