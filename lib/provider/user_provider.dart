import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../resources/auth_repo.dart';

class UserProvider with ChangeNotifier {
  late User _user;
  final AuthRepo _authRepo = AuthRepo();

  User get getUser => _user;
  
  

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
