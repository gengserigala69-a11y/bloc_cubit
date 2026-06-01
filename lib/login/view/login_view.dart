// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_cubit/login/bloc/login_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isObscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<LoginBloc, LoginState>(

      listener: (context, state) {

        // SUCCESS
        if (state is LoginSuccess) {

          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,

              content: const Text(
                "Login successful",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {

            if (context.mounted) {

              Navigator.pushReplacementNamed(
                context,
                '/home',
              );

            }

          });
        }

        // FAILURE
        if (state is LoginFailure) {

          showDialog(

            context: context,

            builder: (context) {

              return AlertDialog(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                title: const Row(
                  children: [

                    Icon(
                      Icons.error,
                      color: Colors.red,
                    ),

                    SizedBox(width: 8),

                    Text("Login Failed"),

                  ],
                ),

                content: Text(
                  state.message,
                ),

                actions: [

                  TextButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("OK"),
                  ),

                ],
              );
            },
          );
        }
      },

      builder: (context, state) {

        // LOADING
        if (state is LoginLoading) {

          return const Scaffold(

            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(

          body: SafeArea(

            child: Center(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                    // LOGO
                    Container(

                      width: 100,
                      height: 100,

                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.lock_person,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TITLE
                    Text(

                      "Welcome Back",

                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 8),

                    Text(

                      "Login to continue",

                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Colors.grey,
                          ),
                    ),

                    const SizedBox(height: 40),

                    // USERNAME
                    TextField(

                      controller: _username,

                      decoration: InputDecoration(

                        labelText: "Username / Email",
                        hintText: "Input username",

                        prefixIcon: const Icon(
                          Icons.person,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PASSWORD
                    TextField(

                      controller: _password,
                      obscureText: isObscure,

                      decoration: InputDecoration(

                        labelText: "Password",
                        hintText: "Input password",

                        prefixIcon: const Icon(
                          Icons.lock,
                        ),

                        suffixIcon: IconButton(

                          onPressed: () {

                            setState(() {
                              isObscure = !isObscure;
                            });

                          },

                          icon: Icon(

                            isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // LOGIN BUTTON
                    SizedBox(

                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: () {

                          print("login pressed");

                          context.read<LoginBloc>().add(

                            LoginSubmitted(

                              username: _username.text.trim(),
                              password: _password.text.trim(),

                            ),
                          );
                        },

                        child: const Text(

                          "LOGIN",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // REGISTER
                    Row(

                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        const Text(
                          "Don't have an account?",
                        ),

                        TextButton(

                          onPressed: () {

                            Navigator.pushNamed(
                              context,
                              '/register',
                            );

                          },

                          child: const Text(
                            "Register",
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}