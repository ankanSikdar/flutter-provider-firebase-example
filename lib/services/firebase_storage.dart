import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_provider/services/firestore_path.dart';

class FirebaseStorageService {
  final String uid;

  FirebaseStorageService({
    required this.uid,
  });

  /// Upload an avatar from file
  Future<String> uploadAvatar({
    required File file,
  }) async =>
      await upload(
        file: file,
        path: FirestorePath.avatar(uid) + '/avatar.png',
        contentType: 'image/png',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    required File file,
    required String path,
    required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(
        file, SettableMetadata(contentType: contentType));

    final snapshot =
        await uploadTask.then((TaskSnapshot taskSnapshot) => taskSnapshot);

    if (snapshot.state == TaskState.error) {
      print('Upload Error ${snapshot.state.toString()}');
      throw Exception('Upload ERROR');
    }

    // Url used to download file/image
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }
}
