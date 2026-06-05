import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc_cubit/login/bloc/login_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', image.path);

    setState(() {
      profileImage = File(image.path);
    });
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image');
    if (path != null) {
      setState(() {
        profileImage = File(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        String username = "Guest";
        String email = "";

        if (loginState is LoginSuccess) {
          username = loginState.login.user.username;
          email = loginState.login.user.email;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile Page'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        backgroundImage:
                            profileImage != null ? FileImage(profileImage!) : null,
                        child: profileImage == null
                            ? Text(
                                username.isNotEmpty
                                    ? username[0].toUpperCase()
                                    : "U",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(username,
                    style:
                        const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(email,
                    style: const TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/update-profile');
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Update Profile"),
                  ),
                ),
                const SizedBox(height: 24),
                buildDangerZone(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDangerZone(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Danger Zone",
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "These actions may affect your account permanently.",
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              icon: const Icon(Icons.delete_forever),
              label: const Text("Delete Account"),
              onPressed: () {
                Navigator.pushNamed(context, '/delete-account');
              },
            ),
          ),
        ],
      ),
    );
  }
}