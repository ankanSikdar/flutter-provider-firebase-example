import 'package:firebase_provider/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  Future<void> _signInAnonymously(BuildContext context) async {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);

    try {
      final user = await auth.signInAnonymously();
      print('User ID: ${user!.uid}');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in')),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign in anonymously'),
          onPressed: () => _signInAnonymously(context),
        ),
      ),
    );
  }
}
