import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

import 'package:music_player/helper/snackbar.dart';




class AppState extends ChangeNotifier {
  String? _userEmail;
  bool _isAuthenticated = false;
    

  String? get userEmail => _userEmail;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> signup(
      String email, String password, BuildContext context) async {
    String res = '';
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = 'success';
      _userEmail = userCredential.user?.email;
      _isAuthenticated = true;
      if (context.mounted) {
        SnackBarHelper.showSuccess(res, context);
      }
    } catch (e) {
      res = 'Signup error: ${e.toString()}';
      SnackBarHelper.showError(res, context);
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    String res = '';
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        res = 'success';
        _userEmail = userCredential.user?.email;
        _isAuthenticated = true;
        if (context.mounted) {
          SnackBarHelper.showSuccess(res, context);
        }
      } else {
        res = 'No email or password exist';
        _userEmail = null;
        _isAuthenticated = false;
        if (context.mounted) {
          SnackBarHelper.showError(res, context);
        }
      }
    } catch (e) {
      res = 'Login error: ${e.toString()}';
      _userEmail = null;
      _isAuthenticated = false;
      SnackBarHelper.showError(res, context);
    }
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      _userEmail = null;
      _isAuthenticated = false;
      if (context.mounted) {
        SnackBarHelper.showSuccess('Success', context);
      }
      notifyListeners();
    } catch (e) {
      SnackBarHelper.showError(e.toString(), context);
    }
  }

  
}
