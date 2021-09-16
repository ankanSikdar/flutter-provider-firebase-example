// ignore_for_file: unnecessary_const

import 'package:firebase_provider/screens/home/home_screen.dart';
import 'package:firebase_provider/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_provider/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    return StreamBuilder<User?>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user == null ? SignIn() : HomePage();
        } else {
          return const Scaffold(
            body: const Center(
              child: const CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
