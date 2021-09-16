import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

@immutable
class User {
  const User({required this.uid});
  final String uid;
}

class FirebaseAuthService {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  User? _userFromFirebase(firebase_auth.User? user) {
    // ignore: unnecessary_null_comparison
    if (user == null) {
      return null;
    } else {
      return User(uid: user.uid);
    }
  }

  Stream<User?> get onAuthStateChanged {
    return _firebaseAuth
        .authStateChanges()
        .map((firebase_auth.User? user) => _userFromFirebase(user));
  }

  Future<User?> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
