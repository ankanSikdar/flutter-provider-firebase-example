import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_provider/models/avatar_reference.dart';
import 'package:firebase_provider/services/firestore_path.dart';

class FirestoreService {
  // Sets the avatar download url
  Future<void> setAvatarReference(
      {required String uid, required AvatarReference avatarReference}) async {
    final path = FirestorePath.avatar(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(avatarReference.toMap());
  }

  // Reads the current avatar download url
  Stream<AvatarReference> avatarReferenceStream({required String uid}) {
    final path = FirestorePath.avatar(uid);
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots
        .map((snapshot) => AvatarReference.fromMap(snapshot.data()));
  }
}
