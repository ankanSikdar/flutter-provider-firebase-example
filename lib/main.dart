import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_provider/auth_widget.dart';
import 'package:firebase_provider/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthService>(
      create: (BuildContext context) => FirebaseAuthService(),
      // ignore: prefer_const_constructors
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthWidget(),
      ),
    );
  }
}
