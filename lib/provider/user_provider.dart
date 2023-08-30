import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../resources/auth_repo.dart';

class UserProvider with ChangeNotifier {
  late User _user;
  bool _isAuthenticated = false; // New property
  final AuthRepo _authRepo = AuthRepo();

  User get getUser => _user;
  bool get isAuthenticated => _isAuthenticated; // Getter for isAuthenticated

  // Call this method when the user logs in
  void setUserAuthenticated() {
    _isAuthenticated = true;
    notifyListeners();
  }

  // Call this method when the user logs out
  void setUserUnauthenticated() {
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    try {
      User user = await _authRepo.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}
