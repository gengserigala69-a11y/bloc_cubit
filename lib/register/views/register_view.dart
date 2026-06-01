import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_cubit/register/bloc/register_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isObscure = true;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<RegisterBloc, RegisterState>(

      listener: (context, state) {

        // SUCCESS
        if (state is RegisterSuccess) {

          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(

              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,

              content: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {

            if (context.mounted) {

              Navigator.pushReplacementNamed(
                context,
                '/login',
              );

            }

          });
        }

        // FAILURE
        if (state is RegisterFailure) {

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

                    Text("Register Failed"),

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
        if (state is RegisterLoading) {

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

                    // ICON
                    Container(

                      width: 100,
                      height: 100,

                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.app_registration,
                        size: 50,
                        color: Colors.purple,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // TITLE
                    Text(

                      "Create Account",

                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 8),

                    Text(

                      "Register to continue",

                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Colors.grey,
                          ),
                    ),

                    const SizedBox(height: 40),

                    // EMAIL
                    TextField(

                      controller: _email,

                      keyboardType: TextInputType.emailAddress,

                      decoration: InputDecoration(

                        labelText: "Email",
                        hintText: "Input email",

                        prefixIcon: const Icon(
                          Icons.email,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // USERNAME
                    TextField(

                      controller: _username,

                      decoration: InputDecoration(

                        labelText: "Username",
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

                    // REGISTER BUTTON
                    SizedBox(

                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: () {

                          context.read<RegisterBloc>().add(

                            RegisterSubmitted(

                              email: _email.text.trim(),
                              username: _username.text.trim(),
                              password: _password.text.trim(),

                            ),
                          );
                        },

                        child: const Text(

                          "REGISTER",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LOGIN
                    Row(

                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        const Text(
                          "Already have an account?",
                        ),

                        TextButton(

                          onPressed: () {

                            Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            );

                          },

                          child: const Text(
                            "Login",
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