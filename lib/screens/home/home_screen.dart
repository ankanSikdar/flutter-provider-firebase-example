import 'dart:async';
import 'dart:io';
import 'package:firebase_provider/global_widgets/avatar.dart';
import 'package:firebase_provider/models/avatar_reference.dart';
import 'package:firebase_provider/screens/about/about_screen.dart';
import 'package:firebase_provider/services/firebase_auth.dart';
import 'package:firebase_provider/services/firebase_storage.dart';
import 'package:firebase_provider/services/firestore_service.dart';
import 'package:firebase_provider/services/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    try {
      auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onAbout(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AboutPage(),
      ),
    );
  }

  Future<void> _chooseAvatar(BuildContext context) async {
    try {
      final imagePicker =
          Provider.of<ImagePickerService>(context, listen: false);
      final File? imageFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        final user = Provider.of<User>(context, listen: false);
        final downloadUrl =
            await storage.uploadAvatar(file: imageFile, uid: user.uid);
        final database = Provider.of<FirestoreService>(context, listen: false);
        await database.setAvatarReference(
          uid: user.uid,
          avatarReference: AvatarReference(downloadUrl),
        );
        await imageFile.delete();
      }

      // 4. (optional) delete local file as no longer needed
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: IconButton(
          icon: Icon(Icons.help),
          onPressed: () => _onAbout(context),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _signOut(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
          child: Column(
            children: <Widget>[
              _buildUserInfo(context: context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo({required BuildContext context}) {
    final database = Provider.of<FirestoreService>(context);
    final user = Provider.of<User>(context, listen: false);
    return StreamBuilder<AvatarReference>(
        stream: database.avatarReferenceStream(uid: user.uid),
        builder: (context, snapshot) {
          final avatarReference = snapshot.data;
          return Avatar(
            photoUrl: avatarReference?.downloadUrl ??
                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
            radius: 50,
            borderColor: Colors.black54,
            borderWidth: 2.0,
            onPressed: () => _chooseAvatar(context),
          );
        });
  }
}
