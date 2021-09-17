// ignore_for_file: unnecessary_const

import 'package:firebase_provider/screens/home/home_screen.dart';
import 'package:firebase_provider/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_provider/services/firebase_auth.dart';
import 'package:firebase_provider/services/firebase_storage.dart';
import 'package:firebase_provider/services/firestore_service.dart';
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
          if (user != null) {
            return MultiProvider(
              providers: [
                Provider.value(
                  value: user,
                ),
                Provider<FirestoreService>(
                  create: (context) => FirestoreService(uid: user.uid),
                ),
                Provider<FirebaseStorageService>(
                  create: (context) => FirebaseStorageService(uid: user.uid),
                ),
              ],
              child: HomePage(),
            );
          } else {
            return SignIn();
          }
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
