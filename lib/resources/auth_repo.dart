
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:music_player/models/user_model.dart' as model;
import 'package:music_player/resources/storage_method.dart';
class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot? snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromsnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethod()
            .uploadProfileImage('profilePics', file);

        if (kDebugMode) {
          print(cred.user!.uid);
        }

        model.User user = model.User(
          userName: userName,
          uid: cred.user!.uid,
          email: email,
          photoUrl: photoUrl,
          favoritePlaylists: [],
          favoriteSongs: []
        );

        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> LoginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user_not_found') {
        res = "Enter correct email id";
      } else if (e.code == 'wrong_password') {
        res = "Please enter correct password";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
   Future<void> signOut() async {
    await _auth.signOut();
  }
}
